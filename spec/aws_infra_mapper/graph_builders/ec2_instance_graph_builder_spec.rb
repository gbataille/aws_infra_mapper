# frozen_string_literal: true

RSpec.describe AwsInfraMapper::GraphBuilders::EC2InstanceGraphBuilder do
  describe '#index_instances_by_sg' do
    let(:aws_ec2_instance1) { build(:aws_ec2_instance) }
    let(:aws_ec2_instance2) do
      build(:aws_ec2_instance, security_groups: aws_ec2_instance1.security_groups)
    end

    it 'should return an index of the instance' do
      expected = {}
      aws_ec2_instance1.security_groups.each do |sg|
        expected.merge!(sg.group_id => [aws_ec2_instance1])
      end
      expect(subject.send(:index_instances_by_sg, [aws_ec2_instance1])).to eq(expected)
    end

    it 'should aggregate instances when they belong to the same sg' do
      expected = {}
      aws_ec2_instance1.security_groups.each do |sg|
        expected.merge!(sg.group_id => [aws_ec2_instance1, aws_ec2_instance2])
      end
      expect(
        subject.send(:index_instances_by_sg, [aws_ec2_instance1, aws_ec2_instance2])
      ).to eq(expected)
    end

    it 'should return a hash with default []' do
      expect(subject.send(:index_instances_by_sg, [])[Faker::Lorem.word]).to eq([])
    end
  end

  describe '#sg_to_sg_map' do
    let(:source_sg) { build(:aws_security_group, ip_permissions: [], ip_permissions_egress: []) }
    let(:user_group_id_pair) do
      build(
        :aws_user_id_group_pair,
        group_id: source_sg.group_id,
        group_name: source_sg.group_name
      )
    end
    let(:ip_perm) { build(:aws_ip_permission, user_id_group_pairs: [user_group_id_pair]) }
    let(:dest_sg1) { build(:aws_security_group, ip_permissions: [ip_perm]) }
    let(:dest_sg2) { build(:aws_security_group, ip_permissions: [ip_perm]) }

    it 'should map source to destination' do
      expect(
        subject.send(:sg_to_sg_map, [source_sg, dest_sg1, dest_sg2])
      ).to eq(
        [
          { from: source_sg.group_id, to: dest_sg1.group_id },
          { from: source_sg.group_id, to: dest_sg2.group_id }
        ]
      )
    end
  end

  describe '#build_edges' do
    let(:sg_src) { build(:aws_security_group) }
    let(:src_instance) { build(:aws_ec2_instance, security_groups: [sg_src]) }
    let(:user_id_group_pair) do
      build(:aws_user_id_group_pair, group_id: sg_src.group_id, group_name: sg_src.group_name)
    end
    let(:ip_perm) { build(:aws_ip_permission, user_id_group_pairs: [user_id_group_pair]) }
    let(:sg_to) { build(:aws_security_group, ip_permissions: [ip_perm]) }

    let(:dest_instance_1) { build(:aws_ec2_instance, security_groups: [sg_to]) }
    let(:dest_instance_2) { build(:aws_ec2_instance, security_groups: [sg_to]) }

    it 'should map instances properly' do
      expect(
        subject.build_edges([src_instance, dest_instance_1, dest_instance_2], [sg_src, sg_to])
      ).to eq(
        [
          {
            NODE_KEY_SOURCE => src_instance.instance_id,
            NODE_KEY_TARGET => dest_instance_1.instance_id,
            NODE_KEY_DATA => nil
          },
          {
            NODE_KEY_SOURCE => src_instance.instance_id,
            NODE_KEY_TARGET => dest_instance_2.instance_id,
            NODE_KEY_DATA => nil
          }
        ]
      )
    end
  end

  describe '#deduped_instaces' do
    it 'should use the instance_label to collapse similar instances' do
      exporter = AwsInfraMapper::Exporters::EC2InstanceExporter.new
      label_tmpl = '{{image_id}}-foo-{{key_name}}'
      aws_ec2_instance1 = build(:aws_ec2_instance)
      aws_ec2_instance1bis = build(:aws_ec2_instance,
                                   image_id: aws_ec2_instance1.image_id,
                                   key_name: aws_ec2_instance1.key_name)
      aws_ec2_instance1ter = build(:aws_ec2_instance,
                                   image_id: aws_ec2_instance1.image_id,
                                   key_name: aws_ec2_instance1.key_name)
      aws_ec2_instance2 = build(:aws_ec2_instance)

      result = subject.send(
        :deduped_instances,
        [aws_ec2_instance1, aws_ec2_instance1bis, aws_ec2_instance1ter, aws_ec2_instance2],
        label_tmpl
      )
      expect(result.length).to eq(2)
      expect(result).to eq(
        [
          exporter.as_node(aws_ec2_instance1, label_tmpl, NODE_TYPE_EC2_INSTANCES_CLUSTER),
          exporter.as_node(aws_ec2_instance2, label_tmpl)
        ]
      )
    end
  end
end
