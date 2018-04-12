# frozen_string_literal: true

module AwsInfraMapper
  module Exporters
    class EC2InstanceExporter
      def as_node(ec2_instance, conf, *)
        ## Takes an Aws::EC2::Types::Instance and turn it into a generic graph node
        {
          NODE_KEY_ID => ec2_instance.instance_id,
          NODE_KEY_TYPE => NODE_TYPE_EC2_INSTANCE,
          NODE_KEY_LABEL => node_label(ec2_instance, conf)
        }
      end

      private

      def node_label(ec2_instance, conf)
        instance_attributes = ec2_instance.to_h.merge!(tag_for_rendering(ec2_instance))
        Mustache.render(conf.ec2_instance_label, instance_attributes)
      end

      def tag_for_rendering(ec2_instance)
        ec2_instance.tags.each_with_object({}) do |tag, h|
          h.store("tag_#{tag.key}", tag.value)
          h
        end
      end
    end
  end
end
