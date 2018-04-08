# frozen_string_literal: true

module AwsInfraMapper
  module Exporters
    autoload :AwsRouteExporter, 'aws_infra_mapper/exporters/aws_route_exporter'
    autoload :EC2InstanceExporter, 'aws_infra_mapper/exporters/ec2_instance_exporter'
  end
end
