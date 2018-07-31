# frozen_string_literal: true

module AwsInfraMapper
  module Models
    class GraphNode
      def node_id
        raise NotImplementedError
      end

      def node_type
        raise NotImplementedError
      end

      def node_public_ips
        raise NotImplementedError
      end

      def node_private_ips
        raise NotImplementedError
      end

      def node_data
        raise NotImplementedError
      end

      def node_label
        raise NotImplementedError
      end

      def to_h
        {
          NODE_KEY_ID => node_id,
          NODE_KEY_TYPE => node_type,
          NODE_KEY_LABEL => node_label,
          NODE_KEY_PUBLIC_IP => node_public_ips,
          NODE_KEY_PRIVATE_IP => node_private_ips,
          NODE_KEY_DATA => node_data
        }
      end

      private

      def deep_hash(my_hash)
        my_hash.to_h.transform_values! do |v|
          return deep_hash v if v.is_a? Struct
          v
        end
      end
    end
  end
end
