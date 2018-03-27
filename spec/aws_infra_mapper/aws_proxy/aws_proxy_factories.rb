# frozen_string_literal: true

require 'aws-sdk-ec2'

VPCS = (1..2).map do
  {
    cidr: Faker::Internet.ip_v4_cidr,
    security_groups: (1..2).map do
      {
        description: Faker::DrWho.quote,
        group_name: Faker::Lorem.characters(10)
      }
    end
  }
end

def setup_infrastructure
  @ec2 = ::Aws::EC2::Resource.new

  vpcs = []
  VPCS.each { |vpc| vpcs << create_vpc(vpc) }

  vpcs
end

def create_vpc(vpc_hash)
  vpc = @ec2.create_vpc(cidr_block: vpc_hash[:cidr])

  sgs = []
  vpc_hash[:security_groups].each { |sg| sgs << create_sg(vpc.id, sg) }

  { vpc: vpc, sgs: sgs }
end

def create_sg(vpc_id, sg_hash)
  @ec2.create_security_group(
    description: sg_hash[:description],
    group_name: sg_hash[:group_name],
    vpc_id: vpc_id
  )
end
