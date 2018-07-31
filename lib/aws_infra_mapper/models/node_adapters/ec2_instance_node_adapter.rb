# frozen_string_literal: true

module AwsInfraMapper
  module Models
    module NodeAdapters
      class EC2InstanceNodeAdapter < GraphNode
        ## Takes an Aws::EC2::Types::Instance and presents it as a graph node
        attr_accessor :node_type
        attr_writer :node_label

        def initialize(ec2_instance, label_tmpl, node_type = NODE_TYPE_EC2_INSTANCE)
          @ec2_instance = ec2_instance
          @label_tmpl = label_tmpl
          @node_type = node_type
        end

        def node_id
          @ec2_instance.instance_id
        end

        def node_public_ips
          [@ec2_instance.public_ip_address]
        end

        def node_private_ips
          [@ec2_instance.private_ip_address]
        end

        def node_data
          deep_hash(@ec2_instance)
        end

        def node_label
          # TODO: gbataille - test
          @node_label || Mustache.render(
            @label_tmpl, Services::Aws::BaseService.object_meta_dict(@ec2_instance)
          )
        end

        def add_instance_to_cluster_node
          if @node_type == NODE_TYPE_EC2_INSTANCE
            @node_type = NODE_TYPE_EC2_INSTANCES_CLUSTER
            # Need to use the accessor as the first time, @node_label is empty
            @node_label = node_label + ' (2)'
          else
            @node_label.sub!(/(.*)\s\((\d+)\)/) do
              "#{Regexp.last_match(1)} (#{Regexp.last_match(2).to_i + 1})"
            end
          end
        end
      end
    end
  end
end
