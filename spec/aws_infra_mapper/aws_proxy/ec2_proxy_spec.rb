# frozen_string_literal: true

require 'spec_helper'

require_relative 'aws_proxy_factories'
require_relative 'ec2_proxy_factories'

RSpec.describe AwsInfraMapper::AwsProxy::EC2Proxy do
  before(:all) do
    # Start a MOTO server
    # See https://github.com/spulec/moto
    skip 'Skipping aws API tests: moto_server not found' unless start_moto('ec2')

    @infra = setup_infrastructure
  end

  after(:all) do
    stop_moto('ec2')
  end

  describe '#instances' do
    subject(:ec2) { AwsInfraMapper::AwsProxy::EC2Proxy.new }

    xit 'should return all the instances' do
      expect(ec2.instances.map(&:instance_id)).to eq(MOCK_INSTANCES.map { |x| x[:instance_id] })
    end
  end

  describe '#security_groups' do
    subject(:ec2) { AwsInfraMapper::AwsProxy::EC2Proxy.new }

    it 'should return all the SGs' do
      expect(
        ec2.security_groups.reject { |sg| sg.group_name == 'default' }.map(&:group_id)
      ).to eq(
        @infra.reduce([]) { |acc, vpc| acc + vpc[:sgs].map(&:id) }
      )
    end
  end
end
