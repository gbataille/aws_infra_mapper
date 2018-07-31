# frozen_string_literal: true

FactoryBot.define do
  factory :ec2_instance_node_adapter,
          class: AwsInfraMapper::Models::NodeAdapters::EC2InstanceNodeAdapter do
    association :ec2_instance, factory: :aws_ec2_instance, strategy: :build
    label_tmpl '{{ id }}'
    node_type NODE_TYPE_EC2_INSTANCE
    initialize_with { new(ec2_instance, label_tmpl, node_type) }
  end
end
