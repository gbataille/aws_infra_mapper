# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'pathname'
require 'tmpdir'

require 'spec_helper'

RSpec.describe AwsInfraMapper::Services::InfraMapperService do
  before(:each) do
    # Use mock AWS data throughout the tests
    stub_describe_instances([])
  end

  describe '#export' do
    before(:each) do
      @tmp_dir = Dir.mktmpdir
    end

    after(:each) do
      FileUtils.remove_dir @tmp_dir
    end

    let(:filepath) { Pathname.new(@tmp_dir).join(DEFAULT_EXPORT_FILENAME) }

    before(:each) do
      AwsInfraMapper::Services::InfraMapperService.new.export(@tmp_dir)
    end

    context 'always (incl. without any data)' do
      it 'should create a JSON file in the right place' do
        expect(filepath).to exist
      end

      it 'should create a file that is valid JSON' do
        File.open(filepath, 'r') do |f|
          content = f.read
          expect { JSON.parse(content) }.not_to raise_error
        end
      end

      it 'should contain nodes and edges' do
        File.open(filepath, 'r') do |f|
          content = f.read
          data = JSON.parse(content)

          expect(data).to have_key('nodes')
          expect(data).to have_key('edges')
        end
      end
    end

    context 'with data' do
      pending 'should contain all the instances as nodes'
      pending 'should create a file that is valid JSON'
    end
  end

  describe '#infra_data' do
    subject { AwsInfraMapper::Services::InfraMapperService.new.infra_data }

    context 'always (incl. without any data)' do
      it 'should contain nodes and edges' do
        expect(subject).to have_key(GRAPH_DATA_NODES_KEY)
        expect(subject).to have_key(GRAPH_DATA_EDGES_KEY)
      end
    end

    context 'with data' do
      let(:instances) { (1..Faker::Number.non_zero_digit.to_i).map { build(:aws_ec2_instance) } }

      before(:each) do
        stub_describe_instances(instances)
      end

      it 'should contain all the instances as nodes' do
        ec2_instance_nodes = subject[GRAPH_DATA_NODES_KEY].keep_if do |elem|
          elem[NODE_KEY_TYPE] == NODE_TYPE_EC2_INSTANCE
        end
        expect(ec2_instance_nodes.length).to eq(instances.length)
      end
    end
  end
end
