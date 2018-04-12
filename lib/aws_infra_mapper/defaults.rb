# frozen_string_literal: true

require 'pathname'

def root_dir
  Pathname.new(__dir__).dirname.dirname
end

ROOT_DIR = root_dir.to_s
DEFAULT_EXPORT_DIR = VIEWER_DIR = root_dir.join('utils', 'network_graph_viewer').to_s
DEFAULT_EXPORT_FILENAME = 'data.json'
DEFAULT_CONFIG_FILE_PATH = root_dir.join('aws_infra_mapperrc.default')
