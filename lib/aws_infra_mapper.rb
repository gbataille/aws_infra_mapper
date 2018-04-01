# frozen_string_literal: true

require 'optparse'

require 'aws_infra_mapper/version'
require 'aws_infra_mapper/aws_constants'

module AwsInfraMapper
  autoload :AwsProxy, 'aws_infra_mapper/aws_proxy'
  autoload :Models, 'aws_infra_mapper/models'
  autoload :Services, 'aws_infra_mapper/services'

  def self.help
    <<~HEREDOC
      Usage: aws_infra_mapper [options]
    HEREDOC
  end

  def self.main
    'foo'
  end
end
