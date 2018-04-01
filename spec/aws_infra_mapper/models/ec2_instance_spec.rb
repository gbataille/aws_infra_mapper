# frozen_string_literal: true

RSpec.describe AwsInfraMapper::Models::EC2Instance do
  subject(:ec2_instance_class) { AwsInfraMapper::Models::EC2Instance }

  describe '#new' do
    context 'with a proper AWS::EC2::Types::Instance' do
      let(:aws_instance) { build(:aws_ec2_instance) }

      it 'should not throw on initialization' do
        expect { ec2_instance_class.new(aws_instance) }.not_to raise_error
      end
    end

    context 'without a proper AWS::EC2::Types::Instance' do
      it 'should throw on initialization' do
        expect { ec2_instance_class.new({}) }.to raise_error(ArgumentError)
      end
    end
  end

  context 'equality test' do
    let(:aws_instance) { build(:aws_ec2_instance) }
    let(:aws_same_instance) { build(:aws_ec2_instance, instance_id: aws_instance.instance_id) }
    let(:aws_other_instance) { build(:aws_ec2_instance) }

    describe '#==' do
      it 'should equal another object with same instance id' do
        expect(
          ec2_instance_class.new(aws_instance)
        ).not_to equal(ec2_instance_class.new(aws_instance))
        expect(ec2_instance_class.new(aws_instance)).to eq(ec2_instance_class.new(aws_instance))

        expect(
          ec2_instance_class.new(aws_instance)
        ).not_to equal(ec2_instance_class.new(aws_same_instance))
        expect(
          ec2_instance_class.new(aws_instance)
        ).to eq(ec2_instance_class.new(aws_same_instance))

        expect(
          ec2_instance_class.new(aws_instance)
        ).not_to equal(ec2_instance_class.new(aws_other_instance))
        expect(
          ec2_instance_class.new(aws_instance)
        ).not_to eq(ec2_instance_class.new(aws_other_instance))
      end
    end

    describe '#eql?' do
      it 'should equal another object with same instance id' do
        expect(
          ec2_instance_class.new(aws_instance)
        ).not_to equal(ec2_instance_class.new(aws_instance))
        expect(ec2_instance_class.new(aws_instance)).to eql(ec2_instance_class.new(aws_instance))

        expect(
          ec2_instance_class.new(aws_instance)
        ).not_to equal(ec2_instance_class.new(aws_same_instance))
        expect(
          ec2_instance_class.new(aws_instance)
        ).to eql(ec2_instance_class.new(aws_same_instance))

        expect(
          ec2_instance_class.new(aws_instance)
        ).not_to equal(ec2_instance_class.new(aws_other_instance))
        expect(
          ec2_instance_class.new(aws_instance)
        ).not_to eql(ec2_instance_class.new(aws_other_instance))
      end
    end

    describe '#hash' do
      it 'should have the same hash as another object with same instance id' do
        expect(
          ec2_instance_class.new(aws_instance).hash
        ).to eql(ec2_instance_class.new(aws_instance).hash)

        expect(
          ec2_instance_class.new(aws_instance).hash
        ).to eql(ec2_instance_class.new(aws_same_instance).hash)

        expect(
          ec2_instance_class.new(aws_instance).hash
        ).not_to eql(ec2_instance_class.new(aws_other_instance).hash)
      end
    end
  end

  describe '#method_missing (proxy on AWS::EC2::Types::Instance)' do
    let(:aws_instance) { build(:aws_ec2_instance) }
    let(:instance) { ec2_instance_class.new aws_instance }

    it 'should respond to any existing attributes on the AWS instance' do
      expect(instance.respond_to?(:image_id)).to be true
      expect(instance.respond_to?(:instance_type)).to be true
      expect(instance.respond_to?(:state)).to be true
      expect(instance.respond_to?(:subnet_id)).to be true
    end

    it 'should not respond to any unknown attributes on the AWS instance' do
      expect(instance.respond_to?(:foobar)).to be false
    end

    it 'should proxy the call to any existing attributes on the AWS instance' do
      expect(instance.image_id).to eq(aws_instance.image_id)
      expect(instance.instance_type).to eq(aws_instance.instance_type)
      expect(instance.state).to eq(aws_instance.state)
      expect(instance.subnet_id).to eq(aws_instance.subnet_id)
    end

    it 'should raise for any unknown attributes' do
      expect { instance.foobar }.to raise_error(NoMethodError)
    end
  end
end
