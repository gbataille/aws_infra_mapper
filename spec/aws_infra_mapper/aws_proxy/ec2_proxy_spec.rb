# frozen_string_literal: true

require 'spec_helper'

require_relative 'aws_proxy_factories'

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

    it 'should return all the instances' do
      expect(
        ec2.instances.to_a.length
      ).to eq(
        @infra.reduce(0) { |acc, vpc| acc + vpc[:instances].length }
      )
    end

    it 'should filter on vpc ID' do
      chosen_vpc_config = @infra[0]

      ec2.add_vpc_filter([chosen_vpc_config[:vpc].id])
      expect(ec2.instances.to_a.length).to eq(chosen_vpc_config[:instances].length)
    end

    it 'should filter on any attribute' do
      chosen_instance = @infra[0][:instances][0]

      expected_instances = @infra.reduce([]) do |acc, vpc|
        acc + vpc[:instances].keep_if { |elem| elem.image_id == chosen_instance.image_id }
      end

      filter = {
        name: 'image-id',
        values: [chosen_instance.image_id]
      }
      ec2.add_raw_filter(filter)

      expect(ec2.instances.to_a.length).to eq(expected_instances.length)
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

    it 'should filter on vpc ID' do
      chosen_vpc_config = @infra[0]

      ec2.add_vpc_filter([chosen_vpc_config[:vpc].id])
      expect(
        ec2.security_groups.reject { |sg| sg.group_name == 'default' }.map(&:group_id)
      ).to eq(
        chosen_vpc_config[:sgs].map(&:id)
      )
    end

    it 'should filter on any attribute' do
      chosen_sg = @infra[0][:sgs][0]

      expected_sgs = @infra.reduce([]) do |acc, vpc|
        acc + vpc[:sgs].keep_if { |elem| elem.group_name == chosen_sg.group_name }
      end

      filter = {
        name: 'group-name',
        values: [chosen_sg.group_name]
      }
      ec2.add_raw_filter(filter)

      expect(ec2.security_groups.to_a.length).to eq(expected_sgs.length)
    end
  end
end
