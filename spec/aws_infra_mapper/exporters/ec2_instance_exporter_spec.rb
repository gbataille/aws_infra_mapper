# frozen_string_literal: true

RSpec.describe AwsInfraMapper::Exporters::EC2InstanceExporter do
  describe '#as_node' do
    context 'with the default config' do
      let(:aws_instance) { build(:aws_ec2_instance) }

      it 'should have the correct node type' do
        expect(subject.as_node(aws_instance, '')[NODE_KEY_TYPE]).to eq(NODE_TYPE_EC2_INSTANCE)
      end
    end

    context 'with a custom configuration' do
      let(:label_pattern) { '{{instance_type}}-{{tag_Name}}' }
      let(:tag) { build(:tag, key: 'Name') }
      let(:aws_instance) { build(:aws_ec2_instance, tags: [tag]) }

      it 'should have the rendered template as a label' do
        expect(
          subject.as_node(aws_instance, label_pattern)[NODE_KEY_LABEL]
        ).to eq("#{aws_instance.instance_type}-#{tag.value}")
      end
    end
  end
end
