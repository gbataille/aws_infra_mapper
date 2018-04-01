# frozen_string_literal: true

module AwsInfraMapper
  module Services
    class EC2InstanceService
      def initialize
        @ec2_proxy = AwsInfraMapper::AwsProxy::EC2Proxy.new
      end

      def list_instances
        @ec2_proxy.instances.map { |i| AwsInfraMapper::Models::EC2Instance.new(i) }
      end
    end
  end
end
