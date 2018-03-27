# frozen_string_literal: true

require 'aws-sdk-ec2'

module AwsInfraMapper
  module AwsProxy
    class EC2Proxy
      def initialize
        @ec2_resource = ::Aws::EC2::Resource.new
        @filters = []
      end

      def instances
        @ec2_resource.instances(filters: @filters)
      end

      def security_groups
        @ec2_resource.security_groups(filters: @filters)
      end

      def add_vpc_filter(vpc_ids)
        add_filter_with_name('vpc-id', vpc_ids)
      end

      def add_raw_filter(filter)
        @filters << filter
      end

      private

      def add_filter_with_name(name, filter_values)
        @filters << {
          name: name,
          values: filter_values
        }
      end
    end
  end
end
