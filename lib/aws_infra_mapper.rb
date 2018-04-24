# frozen_string_literal: true

require 'logger'
require 'mustache'
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
  autoload :Models, 'aws_infra_mapper/models'
  autoload :Services, 'aws_infra_mapper/services'

  def self.main
    banner
    $LOGGER.info "Launching AwsInfraMapper version #{VERSION}"
    mapper = AwsInfraMapper.new
    mapper.main
  end

  def self.banner
    # rubocop:disable Layout/IndentHeredoc
    puts <<~'HEREDOC'

         ########################################################################################
        #   ___                ____      ____           __  ___                                #
       #   /   |_      _______/  _/___  / __/________ _/  |/  /___ _____  ____  ___  _____    #
      #   / /| | | /| / / ___// // __ \/ /_/ ___/ __ `/ /|_/ / __ `/ __ \/ __ \/ _ \/ ___/   #
     #   / ___ | |/ |/ (__  )/ // / / / __/ /  / /_/ / /  / / /_/ / /_/ / /_/ /  __/ /      #
    #   /_/  |_|__/|__/____/___/_/ /_/_/ /_/   \__,_/_/  /_/\__,_/ .___/ .___/\___/_/      #
   #                                                            /_/   /_/                 #
  ########################################################################################


    HEREDOC
    # rubocop:enable Layout/IndentHeredoc
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

        opts.on_head('-c', '--config-file=FILE_PATH', 'Path to the configuration file') do |c|
          @options[OPTION_CONFIG_FILE] = c
        end

        opts.on(
          '--vpc=VPC_IDS', 'Create the graph only for those VPCs (comma separated list)'
        ) do |vpcs|
          @options[OPTION_VPC_FILTER] = vpcs.split(',')
        end

        opts.on_tail('-h', '--help', 'Print this documentation') do
          display_help_and_exit opts
        end
      end.parse!

      @conf = Models::Config.new @options[OPTION_CONFIG_FILE]
    end

    def graph
      Services::InfraMapperService.new(@conf, vpc_filter: @options[OPTION_VPC_FILTER]).export
      Services::ViewerService.new.serve
    end
  end
end
