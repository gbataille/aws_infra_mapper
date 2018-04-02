# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'pathname'
require 'tmpdir'

require 'spec_helper'

RSpec.describe AwsInfraMapper::Services::InfraMapperService do
  before(:each) do
    @tmp_dir = Dir.mktmpdir
  end
  after(:each) do
    FileUtils.remove_dir @tmp_dir
  end

  describe '#export_infra' do
    let(:filepath) { Pathname.new(@tmp_dir).join(DEFAULT_EXPORT_FILENAME) }

    before(:each) do
      AwsInfraMapper::Services::InfraMapperService.export(@tmp_dir)
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

      pending 'should contain nodes and edges'
    end

    context 'with data' do
      pending 'should contain all the instances as nodes'
      pending 'should create a file that is valid JSON'
    end
  end
end
