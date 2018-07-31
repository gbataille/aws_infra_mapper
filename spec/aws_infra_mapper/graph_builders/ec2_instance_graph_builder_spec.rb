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
        subject.build_edges(
          [src_instance, dest_instance_1, dest_instance_2],
          [sg_src, sg_to],
          [src_instance.instance_id, dest_instance_1.instance_id, dest_instance_2.instance_id]
        )
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

    it 'should take the node filter into account' do
      expect(
        subject.build_edges(
          [src_instance, dest_instance_1, dest_instance_2],
          [sg_src, sg_to],
          [src_instance.instance_id, dest_instance_1.instance_id]
        )
      ).to eq(
        [
          {
            NODE_KEY_SOURCE => src_instance.instance_id,
            NODE_KEY_TARGET => dest_instance_1.instance_id,
            NODE_KEY_DATA => nil
          }
        ]
      )
    end
  end

  describe '#dedup_nodes' do
    let(:label_tmpl) { '{{image_id}}-foo-{{key_name}}' }
    let(:instance_node1) { build(:ec2_instance_node_adapter, label_tmpl: label_tmpl) }
    let(:aws_ec2_instance1bis) do
      build(:aws_ec2_instance,
            image_id: instance_node1.node_data[:image_id],
            key_name: instance_node1.node_data[:key_name])
    end
    let(:aws_ec2_instance1ter) do
      build(:aws_ec2_instance,
            image_id: instance_node1.node_data[:image_id],
            key_name: instance_node1.node_data[:key_name])
    end
    let(:instance_node1bis) do
      build(:ec2_instance_node_adapter,
            ec2_instance: aws_ec2_instance1bis, label_tmpl: label_tmpl)
    end
    let(:instance_node1ter) do
      build(:ec2_instance_node_adapter,
            ec2_instance: aws_ec2_instance1ter, label_tmpl: label_tmpl)
    end
    let(:instance_node2) { build(:ec2_instance_node_adapter, label_tmpl: label_tmpl) }

    it 'should use the node_label to collapse similar nodes' do
      result = subject.send(
        :dedup_nodes,
        [instance_node1, instance_node1bis, instance_node1ter, instance_node2]
      )
      puts result
      expect(result.length).to eq(2)
    end

    it 'should indicate the number of instances in the cluster in the label' do
      result = subject.send(
        :dedup_nodes,
        [instance_node1, instance_node1bis, instance_node1ter, instance_node2]
      )
      puts result
      expect(result[0].node_label).to include('(3)')
      expect(result[0].node_label).not_to include('(2)')
    end
  end
end
