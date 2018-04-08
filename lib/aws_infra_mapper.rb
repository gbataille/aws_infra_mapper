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
  autoload :GraphBuilders, 'aws_infra_mapper/graph_builders'
  autoload :Services, 'aws_infra_mapper/services'

  def self.main
    mapper = AwsInfraMapper.new
    mapper.main
  end

  class AwsInfraMapper
    def help
      <<~HEREDOC
        Usage: aws_infra_mapper [options]
      HEREDOC
    end

    def configure
    end

    def main
      configure
      graph
    end

    def graph
      Services::InfraMapperService.new.export
      Services::ViewerService.new.serve
    end
  end
end
