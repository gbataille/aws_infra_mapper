# frozen_string_literal: true

require 'aws-sdk-ec2'

module AwsInfraMapper
  module Services
    module Aws
      class EC2Service
        def initialize
          @ec2_client = ::Aws::EC2::Client.new
          @filters = []
        end

        def instances
          resp = @ec2_client.describe_instances(generic_client_args)
          resp.reservations.reduce([]) { |acc, res| acc + res.instances }
        end

        def security_groups
          resp = @ec2_client.describe_security_groups(generic_client_args)
          resp.security_groups
        end

        def add_vpc_filter(vpc_ids)
          add_filter_with_name('vpc-id', vpc_ids)
        end

        def add_raw_filter(filter)
          @filters << filter
        end

        def generic_client_args
          args = {}
          args[:filters] = @filters unless @filters.empty?

          args
        end

        def self.instance_meta_dict(ec2_instance)
          ec2_instance.to_h.merge!(EC2Service.tag_for_rendering(ec2_instance))
        end

        private

        def add_filter_with_name(name, filter_values)
          @filters << {
            name: name,
            values: filter_values
          }
        end

        def self.tag_for_rendering(ec2_instance)
          ec2_instance.tags.each_with_object({}) do |tag, h|
            h.store("tag_#{tag.key}", tag.value)
            h
          end
        end
      end
    end
  end
end
