# frozen_string_literal: true

RSpec.describe AwsInfraMapper::Services::Aws::BaseService do
  context 'class methods' do
    subject { AwsInfraMapper::Services::Aws::BaseService }

    let(:instance) { double }

    describe '#tag_for_rendering' do
      it 'should return the tags if the instance is taggable' do
        tag1 = build(:tag)
        tag2 = build(:tag)
        allow(instance).to receive(:tags).and_return([tag1, tag2])

        expect(subject.tag_for_rendering(instance)).to have_key("tag_#{tag1.key}")
        expect(subject.tag_for_rendering(instance)["tag_#{tag1.key}"]).to eq(tag1.value)
        expect(subject.tag_for_rendering(instance)).to have_key("tag_#{tag2.key}")
        expect(subject.tag_for_rendering(instance)["tag_#{tag2.key}"]).to eq(tag2.value)
      end
    end
  end

  context 'instance methods' do
    describe '#generic_client_args' do
      it 'should return an empty hash when no filters' do
        expect(subject.generic_client_args).to eq({})
      end

      it 'should return a hash with the filters' do
        vpc1 = 'vpc-abc1'
        vpc2 = 'vpc-def2'
        filter1 = { name: 'foo', values: 'bar' }
        filter2 = { name: 'abc', values: 'def' }
        subject.add_raw_filter(filter1)
        subject.add_raw_filter(filter2)
        subject.add_vpc_filter([vpc1, vpc2])

        expected = [
          filter1,
          filter2,
          { name: 'vpc-id', values: [vpc1, vpc2] }
        ]

        expect(subject.generic_client_args).to eq(filters: expected)
      end
    end
  end
end
