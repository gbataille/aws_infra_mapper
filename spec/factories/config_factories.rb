# frozen_string_literal: true

FactoryBot.define do
  factory :config, class: AwsInfraMapper::Models::Config do

    # Handling post init attributes
    ignore do
      ec2_instance_label '{{instance_id}}'
    end

    after(:build) do |model, evaluator|
      model.instance_variable_set(:@ec2_instance_label, evaluator.ec2_instance_label)
    end
  end
end
