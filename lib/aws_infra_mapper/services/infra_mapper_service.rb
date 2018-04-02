# frozen_string_literal: true

require 'pathname'

module AwsInfraMapper
  module Services
    class InfraMapperService
      def self.export(work_dir = nil, filename = nil)
        work_dir ||= DEFAULT_EXPORT_DIR
        filename ||= DEFAULT_EXPORT_FILENAME
        filepath = Pathname.new(work_dir).join(filename)
        File.open(filepath, 'w') do |f|
          f.write('{}')
        end
      end
    end
  end
end
