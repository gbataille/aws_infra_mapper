# frozen_string_literal: true

require 'logger'
require 'optparse'

require 'aws_infra_mapper/version'
require 'aws_infra_mapper/aws_constants'
require 'aws_infra_mapper/defaults'
require 'aws_infra_mapper/graph_constants'

$LOGGER = Logger.new STDOUT

module AwsInfraMapper
  autoload :Exporters, 'aws_infra_mapper/exporters'
  autoload :Services, 'aws_infra_mapper/services'

  def self.help
    <<~HEREDOC
      Usage: aws_infra_mapper [options]
    HEREDOC
  end

  def self.main
    Services::InfraMapperService.new.export
    Services::ViewerService.new.serve
  end
end
