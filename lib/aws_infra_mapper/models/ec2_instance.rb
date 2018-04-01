# frozen_string_literal: true

module AwsInfraMapper
  module Models
    class EC2Instance
      def initialize(aws_instance)
        unless aws_instance.instance_of? Aws::EC2::Types::Instance
          raise ArgumentError, 'Aws::EC2::Types::Instance expected'
        end

        @aws_instance = aws_instance
      end

      def ==(other)
        return false unless other.instance_of? EC2Instance

        @aws_instance.instance_id == other.instance_id
      end

      alias eql? :==

      def hash
        @aws_instance.instance_id.hash
      end

      def method_missing(method_name, *args, &block)
        if @aws_instance.respond_to? method_name
          @aws_instance.public_send method_name
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        @aws_instance.respond_to?(method_name) || super
      end
    end
  end
end
