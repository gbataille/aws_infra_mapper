# frozen_string_literal: true

require 'spec_helper'
require 'aws-sdk-core'

require_relative 'ec2_proxy_factories'

RSpec.describe AwsInfraMapper::AwsProxy::EC2Proxy do
  describe '#instances' do
    before(:all) do
      Aws.config[:ec2] = {
        stub_responses: {
          describe_instances: STUB_DESCRIBE_INSTANCES
        }
      }
    end

    subject(:ec2) { AwsInfraMapper::AwsProxy::EC2Proxy.new }

    it 'should return all the instances' do
      expect(ec2.instances.map(&:instance_id)).to eq(MOCK_INSTANCES.map { |x| x[:instance_id] })
    end
  end

  describe '#security_groups' do
    before(:all) do
      Aws.config[:ec2] = {
        stub_responses: {
          describe_security_groups: STUB_DESCRIBE_SECURITY_GROUPS
        }
      }
    end

    subject(:ec2) { AwsInfraMapper::AwsProxy::EC2Proxy.new }

    it 'should return all the SGs' do
      expect(
        ec2.security_groups.map(&:group_id)
      ).to eq(
        MOCK_SECURITY_GROUPS.map { |x| x[:group_id] }
      )
    end
  end
end
