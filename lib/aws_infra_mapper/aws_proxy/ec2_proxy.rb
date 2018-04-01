# frozen_string_literal: true

require 'aws-sdk-ec2'

module AwsInfraMapper
  module AwsProxy
    class EC2Proxy
      def initialize
        @ec2_client = ::Aws::EC2::Client.new
        @filters = []
      end

      def instances
        resp = @ec2_client.describe_instances(filters: @filters)
        resp.reservations.reduce([]) { |acc, res| acc + res.instances }
      end

      def security_groups
        resp = @ec2_client.describe_security_groups(filters: @filters)
        resp.security_groups
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
