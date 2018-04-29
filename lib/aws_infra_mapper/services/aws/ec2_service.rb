# frozen_string_literal: true

require 'aws-sdk-ec2'

module AwsInfraMapper
  module Services
    module Aws
      class EC2Service < BaseService
        def initialize
          super
          @ec2_client = ::Aws::EC2::Client.new
        end

        def instances
          resp = @ec2_client.describe_instances(generic_client_args)
          resp.reservations.reduce([]) { |acc, res| acc + res.instances }
        end

        def security_groups
          resp = @ec2_client.describe_security_groups(generic_client_args)
          resp.security_groups
        end
      end
    end
  end
end
