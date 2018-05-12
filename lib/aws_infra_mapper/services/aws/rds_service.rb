# frozen_string_literal: true

require 'aws-sdk-rds'

module AwsInfraMapper
  module Services
    module Aws
      class RDSService < BaseService
        def initialize
          super
          @rds_client = ::Aws::RDS::Client.new
        end

        def db_instances
          resp = @rds_client.describe_db_instances(generic_client_args)
          resp.db_instances
        end
      end
    end
  end
end
