# frozen_string_literal: true

module AwsInfraMapper
  module Exporters
    class EC2InstanceExporter
      def as_node(ec2_instance, label_tmpl, node_type = NODE_TYPE_EC2_INSTANCE)
        ## Takes an Aws::EC2::Types::Instance and turn it into a generic graph node
        {
          NODE_KEY_ID => ec2_instance.instance_id,
          NODE_KEY_TYPE => node_type,
          NODE_KEY_LABEL => node_label(ec2_instance, label_tmpl),
          NODE_KEY_PUBLIC_IP => ec2_instance.public_ip_address,
          NODE_KEY_PRIVATE_IP => ec2_instance.private_ip_address,
          NODE_KEY_DATA => deep_hash(ec2_instance)
        }
      end

      def node_label(ec2_instance, label_tmpl)
        Mustache.render(label_tmpl, Services::Aws::EC2Service.instance_meta_dict(ec2_instance))
      end

      private

      def deep_hash(h)
        h.to_h.transform_values! do |v|
          return deep_hash v if v.is_a? Struct
          v
        end
      end
    end
  end
end
