# frozen_string_literal: true

RSpec.describe AwsInfraMapper::Exporters::EC2InstanceExporter do
  describe '#as_node' do
    context 'with the default config' do
      let(:conf) { AwsInfraMapper::Models::Config.new('') }
      let(:aws_instance) { build(:aws_ec2_instance) }

      subject(:node) do
        AwsInfraMapper::Exporters::EC2InstanceExporter.new.as_node(aws_instance, conf)
      end

      it 'should have the correct node type' do
        expect(subject[NODE_KEY_TYPE]).to eq(NODE_TYPE_EC2_INSTANCE)
      end

      it 'should have the instance_id as the default label' do
        expect(subject[NODE_KEY_LABEL]).to eq(aws_instance.instance_id)
      end
    end

    context 'with a custom configuration' do
      let(:label_pattern) { '{{instance_type}}-{{tag_Name}}' }
      let(:conf) { build(:config, ec2_instance_label: label_pattern) }
      let(:tag) { build(:tag, key: 'Name') }
      let(:aws_instance) { build(:aws_ec2_instance, tags: [tag]) }

      subject(:node) do
        AwsInfraMapper::Exporters::EC2InstanceExporter.new.as_node(aws_instance, conf)
      end

      it 'should have the rendered template as a label' do
        expect(subject[NODE_KEY_LABEL]).to eq("#{aws_instance.instance_type}-#{tag.value}")
      end
    end
  end
end
