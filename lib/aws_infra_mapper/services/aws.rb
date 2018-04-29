# frozen_string_literal: true

module AwsInfraMapper
  module Services
    module Aws
      autoload :BaseService, 'aws_infra_mapper/services/aws/base_service'
      autoload :EC2Service, 'aws_infra_mapper/services/aws/ec2_service'
    end
  end
end
