# frozen_string_literal: true

require 'aws-sdk-ec2'

FactoryBot.define do
  factory :aws_vpc, class: Aws::EC2::Types::Vpc do
    cidr_block { random_elem(VPC_CIDRS) }
    vpc_id { Faker::Crypto.md5 }
  end

  factory :aws_sg_identifier, class: Aws::EC2::Types::GroupIdentifier do
    group_id { 'sg-' + Faker::Crypto.md5 }
    group_name { Faker::Simpsons.character }
  end

  factory :aws_ec2_instance, class: Aws::EC2::Types::Instance do
    image_id { Faker::Crypto.md5 }
    instance_id { Faker::Crypto.md5 }
    instance_type { random_elem(INSTANCE_TYPES) }
    key_name { Faker::HarryPotter.house }
    private_ip_address { Faker::Internet.private_ip_v4_address }
    security_groups { build(:aws_sg_identifier) }
    state { random_elem(INSTANCE_STATES) }
    subnet_id { Faker::Crypto.md5 }
    vpc_id { Faker::Crypto.md5 }
  end
end
