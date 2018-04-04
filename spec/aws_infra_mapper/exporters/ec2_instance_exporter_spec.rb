# frozen_string_literal: true

require 'spec_helper'

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
end
