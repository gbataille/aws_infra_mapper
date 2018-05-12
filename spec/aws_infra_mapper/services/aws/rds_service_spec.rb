# frozen_string_literal: true

RSpec.describe AwsInfraMapper::Services::Aws::RDSService do
  before(:all) do
    # Start a MOTO server
    # See https://github.com/spulec/moto
    skip 'Skipping aws API tests: moto_server not found' unless start_moto('rds')
    skip 'Skipping aws API tests: moto_server not found' unless start_moto('ec2')

    ec2_vpcs = setup_ec2_infrastructure
    @infra = setup_rds_infrastructure ec2_vpcs
  end

  after(:all) do
    stop_moto('ec2')
    stop_moto('rds')
  end

  describe '#instances' do
    it 'should return all the instances' do
      expect(
        subject.db_instances.to_a.length
      ).to eq(
        @infra.length
      )
    end

    # it 'should filter on vpc ID' do
    #   chosen_vpc_config = @infra[0]
    #
    #   ec2.add_vpc_filter([chosen_vpc_config[:vpc].id])
    #   expect(ec2.instances.to_a.length).to eq(chosen_vpc_config[:instances].length)
    # end
    #
    # it 'should filter on any attribute' do
    #   chosen_instance = @infra[0][:instances][0]
    #
    #   expected_instances = @infra.reduce([]) do |acc, vpc|
    #     acc + vpc[:instances].keep_if { |elem| elem.image_id == chosen_instance.image_id }
    #   end
    #
    #   filter = {
    #     name: 'image-id',
    #     values: [chosen_instance.image_id]
    #   }
    #   ec2.add_raw_filter(filter)
    #
    #   expect(ec2.instances.to_a.length).to eq(expected_instances.length)
    # end
  end
end
