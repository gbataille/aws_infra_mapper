# frozen_string_literal: true

RSpec.describe AwsInfraMapper::Services::EC2InstanceService do
  subject(:ec2_service) { AwsInfraMapper::Services::EC2InstanceService.new }

  describe '#list_instances' do
    before(:each) do
      instances = (1..5).map { build(:aws_ec2_instance) }
      stub_describe_instances(instances)
    end

    it 'should return a list of AwsInfraMapper::Models::EC2Instance' do
      expect(ec2_service.list_instances[0]).to be_instance_of(AwsInfraMapper::Models::EC2Instance)
    end
  end
end
