# frozen_string_literal: true

require 'colorize'
require 'webrick'

module AwsInfraMapper
  module Services
    class ViewerService
      def serve
        msg = <<~HEREDOC
          Serving the data:

          Starting webserver to view the JSON output on port 9090.
          Use Ctrl+C to interrupt it

        HEREDOC
        $LOGGER.info msg.blue

        start_server
      end

      private

      def start_server
        dev_null = WEBrick::Log.new('/dev/null', 7)
        s = WEBrick::HTTPServer.new(
          Port: 9090, Logger: dev_null, AccessLog: dev_null, DocumentRoot: VIEWER_DIR
        )

        begin
          s.start
        rescue StandardError, SignalException
          $LOGGER.info 'Stopping the HTTP server.'
          s.shutdown
          $LOGGER.info 'HTTP Server stopped. Exiting the program'
        end
      end
    end
  end
end
