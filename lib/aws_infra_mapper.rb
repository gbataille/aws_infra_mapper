# frozen_string_literal: true

require 'logger'
require 'optparse'

require 'aws_infra_mapper/version'
require 'aws_infra_mapper/aws_constants'
require 'aws_infra_mapper/config_constants'
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
    def main
      @options = {}

      set_defaults
      configure
      graph
    end

    private

    def help
      <<~HEREDOC
        Usage: aws_infra_mapper [options]
      HEREDOC
    end

    def display_help_and_exit(opts)
      puts opts
      exit
    end

    def set_defaults
      @options = {
        OPTION_CONFIG_FILE => "#{ENV['HOME']}/.aws_infra_mapperrc"
      }
    end

    def configure
      OptionParser.new do |opts|
        opts.banner = help

        opts.on_head('-c', '--config-file', 'Path to the configuration file') do |c|
          @options[OPTION_CONFIG_FILE] = c
        end

        opts.on_tail('-h', '--help', 'Print this documentation') do
          display_help_and_exit opts
        end
      end.parse!
    end

    def graph
      Services::InfraMapperService.new.export
      Services::ViewerService.new.serve
    end
  end
end
