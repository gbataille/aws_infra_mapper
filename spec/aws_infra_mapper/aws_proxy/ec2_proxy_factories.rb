# frozen_string_literal: true

SECURITY_GROUP_TAGS = (1..5).map { { key: Faker::StarWars.specie, value: Faker::StarWars.planet } }

MOCK_SECURITY_GROUPS = (1..5).map do
  {
    description: Faker::DrWho.quote,
    group_id: "sg-#{Faker::DrWho.specie}",
    group_name: Faker::DrWho.villian,
    # ip_permissions:,
    # ip_permissions_egress:,
    owner_id: Faker::Crypto.md5,
    tags: [random_elem(SECURITY_GROUP_TAGS)],
    vpc_id: Faker::Crypto.md5
  }
end

INSTANCE_STATES = [
  { code: 0, name: 'pending' },
  { code: 16, name: 'running' },
  { code: 32, name: 'shutting-down' },
  { code: 48, name: 'terminated' },
  { code: 64, name: 'stopping' },
  { code: 80, name: 'stopped' }
].freeze

INSTANCE_PROFILES = (1..5).map do |i|
  {
    arn: "arn:aws:iam::#{Faker::Number.number(10)}:instance-profile/profile_#{i}",
    id: Faker::Crypto.md5
  }
end

INSTANCE_SECURITY_GROUPS = (1..5).map do |i|
  {
    group_id: "sg-#{Faker::Crypto.md5}",
    group_name: "sg_#{i}"
  }
end

INSTANCE_TAGS = (1..5).map { { key: Faker::StarWars.specie, value: Faker::StarWars.planet } }

MOCK_INSTANCES = (1..5).map do
  sg = random_elem(MOCK_SECURITY_GROUPS)
  {
    iam_instance_profile: random_elem(INSTANCE_PROFILES),
    image_id: Faker::Crypto.md5,
    instance_id: Faker::Crypto.md5,
    instance_type: random_elem(INSTANCE_TYPES),
    key_name: "private_ssh_key_#{Faker::Number.digit}",
    private_ip_address: Faker::Internet.private_ip_v4_address,
    public_ip_address: Faker::Internet.public_ip_v4_address,
    security_groups: [sg.select { |key, _value| %w[group_id group_name].include? key }],
    state: random_elem(INSTANCE_STATES),
    subnet_id: Faker::Crypto.md5,
    tags: [
      random_elem(INSTANCE_TAGS)
    ],
    vpc_id: sg[:vpc_id]
  }
end

STUB_DESCRIBE_INSTANCES = {
  reservations: [
    {
      instances: MOCK_INSTANCES
    }
  ]
}.freeze

STUB_DESCRIBE_SECURITY_GROUPS = {
  security_groups: MOCK_SECURITY_GROUPS
}.freeze
