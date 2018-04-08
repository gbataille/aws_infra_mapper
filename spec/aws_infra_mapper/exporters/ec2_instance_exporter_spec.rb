# frozen_string_literal: true

RSpec.describe AwsInfraMapper::Exporters::EC2InstanceExporter do
  describe '#as_node' do
    let(:aws_instance) { build(:aws_ec2_instance) }

    subject(:node) { AwsInfraMapper::Exporters::EC2InstanceExporter.as_node(aws_instance) }

    it 'should have the correct node type' do
      expect(subject[NODE_KEY_TYPE]).to eq(NODE_TYPE_EC2_INSTANCE)
    end

    it 'should have the instance_id as a label' do
      expect(subject[NODE_KEY_LABEL]).to eq(aws_instance.instance_id)
    end
  end

  describe '#as_edges' do
    let(:src_instance) { build(:aws_ec2_instance) }
    let(:user_id_group_pair) do
      src_sg = src_instance.security_groups[0]
      build(:aws_user_id_group_pair, group_id: src_sg.group_id, group_name: src_sg.group_name)
    end
    let(:ip_perm) { build(:aws_ip_permission, user_id_group_pairs: [user_group_id_pair]) }
    let(:sg_to) { build(:aws_security_group, ip_permissions: [ip_perm]) }

    let(:dest_instance_1) { build(:aws_ec2_instance, security_groups: [sg_to]) }
    let(:dest_instance_2) { build(:aws_ec2_instance, security_groups: [sg_to]) }

    it 'should link instances properly' do
    end
  end
end
