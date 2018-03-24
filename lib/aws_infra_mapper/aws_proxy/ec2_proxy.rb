# frozen_string_literal: true

require 'aws-sdk-ec2'

module AwsInfraMapper
  module AwsProxy
    # Proxy access to the AWS SDK
    class EC2Proxy
      def initialize
        @ec2_resource = ::Aws::EC2::Resource.new
        @filters = {}
      end

      def instances
        @ec2_resource.instances(filters: @filters)
      end

      def security_groups
        @ec2_resource.security_groups(filters: @filters)
      end
    end
  end
end
