# frozen_string_literal: true

module AwsInfraMapper
  module Services
    autoload :Aws, 'aws_infra_mapper/services/aws'
    autoload :InfraMapperService, 'aws_infra_mapper/services/infra_mapper_service'
    autoload :ViewerService, 'aws_infra_mapper/services/viewer_service'
  end
end
