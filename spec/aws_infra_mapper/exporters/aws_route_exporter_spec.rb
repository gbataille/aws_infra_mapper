# frozen_string_literal: true

RSpec.describe AwsInfraMapper::Exporters::AwsRouteExporter do
  describe '#as_edge' do
    let(:route) { { source: 'a', target: 'b', data: { a: 1 } } }

    it 'should export in the proper route format' do
      expect(AwsInfraMapper::Exporters::AwsRouteExporter.as_edge(route)).to eq(
        NODE_KEY_DATA => route[:data],
        NODE_KEY_SOURCE => route[:source],
        NODE_KEY_TARGET => route[:target]
      )
    end
  end
end
