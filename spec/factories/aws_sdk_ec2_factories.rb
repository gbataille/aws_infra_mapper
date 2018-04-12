# frozen_string_literal: true

require 'aws-sdk-ec2'

FactoryBot.define do
  factory :aws_vpc, class: Aws::EC2::Types::Vpc do
    cidr_block { random_elem(VPC_CIDRS) }
    vpc_id { Faker::Crypto.md5 }
  end

  factory :aws_sg_identifier, class: Aws::EC2::Types::GroupIdentifier do
    group_id { "sg-#{Faker::Crypto.md5}" }
    group_name { Faker::Simpsons.character }
  end

  factory :aws_ec2_instance, class: Aws::EC2::Types::Instance do
    image_id { Faker::Crypto.md5 }
    instance_id { Faker::Crypto.md5 }
    instance_type { random_elem(INSTANCE_TYPES) }
    key_name { Faker::HarryPotter.house }
    private_ip_address { Faker::Internet.private_ip_v4_address }
    security_groups { (1..Faker::Number.non_zero_digit.to_i).map { build(:aws_sg_identifier) } }
    state { random_elem(INSTANCE_STATES) }
    subnet_id { Faker::Crypto.md5 }
    tags []
    vpc_id { Faker::Crypto.md5 }
  end

  factory(
    :aws_user_id_group_pair, parent: :aws_sg_identifier, class: Aws::EC2::Types::UserIdGroupPair
  ) do
    description { Faker::Lorem.sentence }
    vpc_id { Faker::Crypto.md5 }
  end

  factory :aws_ip_permission, class: Aws::EC2::Types::IpPermission do
    from_port { Faker::Number.between(22, 4_000).to_i }
    to_port { from_port + Faker::Number.between(1, 10_000).to_i }
    ip_protocol { random_elem(%w[UDP TCP]) }
    ip_ranges []
    ipv_6_ranges []
    prefix_list_ids []
    user_id_group_pairs { random_sized_list { build(:aws_user_id_group_pair) } }
  end

  factory :aws_security_group, class: Aws::EC2::Types::SecurityGroup, parent: :aws_sg_identifier do
    description { Faker::Lorem.sentence }
    vpc_id { Faker::Crypto.md5 }
    ip_permissions { random_sized_list { build(:aws_ip_permission) } }
    # ip_permissions_egress { random_sized_list { build(:aws_ip_permission) } }
  end

  factory :tag, class: Aws::EC2::Types::Tag do
    key { Faker::HowIMetYourMother.character }
    value { Faker::HowIMetYourMother.high_five }
  end
end
