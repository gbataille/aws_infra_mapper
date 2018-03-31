# frozen_string_literal: true

require 'aws-sdk-core'

def set_aws_endpoint_for(aws_service, server, port)
  set_aws_config_option_for(aws_service, :endpoint, "http://#{server}:#{port}")
end

def set_aws_credentials_for(aws_service, key, secret)
  set_aws_config_option_for(aws_service, :credentials, Aws::Credentials.new(key, secret))
end

private

def set_aws_config_option_for(aws_service, config_key, config_value)
  conf = Aws.config[aws_service.to_sym] ||= {}
  conf[config_key] = config_value
end
