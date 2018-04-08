# frozen_string_literal: true

RSpec.describe AwsInfraMapper::AwsInfraMapper do
  describe '#set_defaults' do
    it 'should set the config file to the default path in the user home' do
      subject.send(:set_defaults)

      expect(
        subject.instance_variable_get(:@options)[OPTION_CONFIG_FILE]
      ).to eq("#{ENV['HOME']}/.aws_infra_mapperrc")
    end
  end

  describe '#main' do
    before(:each) do
      allow(subject).to receive(:graph).and_return(nil)
    end

    context 'when asking for the help' do
      context 'with shorthand config' do
        before(:each) do
          # rubocop: disable Style/MutableConstant
          ARGV.replace ['-h']
          # rubocop: enable Style/MutableConstant
        end

        it 'should display the help' do
          allow(subject).to receive(:display_help_and_exit).and_return(nil)
          subject.main

          expect(subject).to have_received(:display_help_and_exit)
        end
      end

      context 'with longhand config' do
        before(:each) do
          ARGV.replace ['--help']
        end

        it 'should display the help' do
          allow(subject).to receive(:display_help_and_exit).and_return(nil)
          subject.main

          expect(subject).to have_received(:display_help_and_exit)
        end
      end
    end
  end
end
