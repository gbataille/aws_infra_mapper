# frozen_string_literal: true

# TODO: gbataille - cleanup
require 'aws-sdk-ec2'
require 'aws-sdk-rds'

VPCS = (1..2).map do
  {
    cidr: random_elem(VPC_CIDRS),
    security_groups: (1..2).map do
      {
        description: Faker::DrWho.quote,
        group_name: Faker::Lorem.characters(10)
      }
    end,
    instances: (1..5).map do
      {
        image_id: Faker::Crypto.md5,
        instance_type: random_elem(INSTANCE_TYPES),
        key_name: Faker::Lorem.word,
        count: Faker::Number.non_zero_digit.to_i
      }
    end
  }
end

def setup_ec2_infrastructure
  @ec2 = ::Aws::EC2::Resource.new

  vpcs = []
  VPCS.each { |vpc| vpcs << create_vpc(vpc) }
  vpcs
end

def setup_rds_infrastructure(vpcs)
  @rds = ::Aws::RDS::Resource.new

  create_rds_instances(vpcs)
end

# rubocop:disable Metrics/AbcSize
def create_rds_instances(vpcs)
  (1..Faker::Number.non_zero_digit.to_i).each_with_object([]) do |_, instances|
    vpc = random_elem(vpcs)

    instances << @rds.create_db_instance(
      db_name: Faker::Lorem.word,
      db_instance_identifier: Faker::Crypto.sha1,
      db_instance_class: 'db.m5.large',
      engine: random_elem(%w[postgres mysql]),
      master_username: Faker::Lorem.word,
      master_user_password: Faker::Lorem.word,
      db_security_groups: [],
      vpc_security_group_ids: [vpc[:sgs][0].group_id],
      availability_zone: random_elem(%w[a b c])
    )
  end
end
# rubocop:enable Metrics/AbcSize

def create_vpc(vpc_hash)
  vpc = @ec2.create_vpc(cidr_block: vpc_hash[:cidr])

  sgs = []
  vpc_hash[:security_groups].each { |sg| sgs << create_sg(vpc.id, sg) }

  subnet = create_subnet(vpc)

  instances = []
  vpc_hash[:instances].each do |instance_hash|
    instances_collection = create_instance(random_elem(sgs), subnet, instance_hash)
    instances += instances_collection.to_a
  end

  { vpc: vpc, sgs: sgs, instances: instances }
end

def create_sg(vpc_id, sg_hash)
  @ec2.create_security_group(
    description: sg_hash[:description],
    group_name: sg_hash[:group_name],
    vpc_id: vpc_id
  )
end

def sub_subnet(cidr)
  bitmask_length = cidr.slice(cidr.rindex('/') + 1, 1000).to_i
  cidr.slice(0, cidr.rindex('/') + 1) + [++bitmask_length, 16].max.to_s
end

def create_subnet(vpc)
  vpc.create_subnet(
    cidr_block: sub_subnet(vpc.cidr_block)
  )
end

def create_instance(security_group, subnet, instance_hash)
  subnet.create_instances(
    image_id: instance_hash[:image_id],
    instance_type: instance_hash[:instance_type],
    key_name: instance_hash[:key_name],
    max_count: instance_hash[:count],
    min_count: instance_hash[:count],
    security_group_ids: [security_group.id]
  )
end
