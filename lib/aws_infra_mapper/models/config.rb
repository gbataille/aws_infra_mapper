# frozen_string_literal: true

require 'yaml'

module AwsInfraMapper
  module Models
    class Config
      attr_reader :ec2_instance_label

      def initialize(file_path = nil)
        if file_path.nil? || !File.exist?(file_path)
          $LOGGER.warn "Configuration file #{file_path} does not exists. Using defaults."
          file_path = DEFAULT_CONFIG_FILE_PATH
        end

        conf = {}
        begin
          File.open(file_path, 'r') do |f|
            conf = YAML.safe_load(f.read)
          end
        rescue StandardError
          # Do nothing. Keep conf empty
          conf = {}
        end

        parse_config conf
      end

      def parse_config(conf)
        @ec2_instance_label = conf.dig(CONF_EC2_INSTANCE, CONF_EC2_INSTANCE_LABEL)
      end
    end
  end
end
