# frozen_string_literal: true

module AwsInfraMapper
  module AwsProxy
    autoload :Base, 'aws_infra_mapper/aws_proxy/base'
    autoload :EC2Proxy, 'aws_infra_mapper/aws_proxy/ec2_proxy'
  end
end
