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
end
