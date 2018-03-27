# frozen_string_literal: true

require 'spec_helper'
require 'aws-sdk-core'

require_relative 'aws_proxy_factories'
require_relative 'ec2_proxy_factories'

RSpec.describe AwsInfraMapper::AwsProxy::EC2Proxy do
  before(:all) do
    # Start a MOTO server
    # See https://github.com/spulec/moto
    if `which moto_server` == ''
      skip 'Skipping aws API tests: moto_server not found'
    else
      moto_server = 'localhost'
      moto_port = 3333
      @moto_pid = spawn("moto_server ec2 -H #{moto_server} -p #{moto_port}")
      ::Aws.config[:ec2] = {
        endpoint: "http://#{moto_server}:#{moto_port}",
        credentials: Aws::Credentials.new('dummy_access_key_id', 'dummy_secret_access_key')
      }

      @infra = setup_infrastructure
    end
  end

  after(:all) do
    Process.kill('TERM', @moto_pid) if defined? @moto_pid
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
