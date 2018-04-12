# frozen_string_literal: true

RSpec.describe AwsInfraMapper::Models::Config do
  before(:all) do
    # Mock a global variable and must make sure to restore it afterwards
    @logger = $LOGGER
    $LOGGER = double
  end

  after(:all) do
    $LOGGER = @logger
  end

  describe '#initialize' do
    it 'should warn if the file passed does not exist' do
      allow($LOGGER).to receive(:warn)

      AwsInfraMapper::Models::Config.new Faker::File.file_name

      expect($LOGGER).to have_received(:warn)
    end
  end
end
