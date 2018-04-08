# frozen_string_literal: true

def mock_dict(faker_class)
  (1..Faker::Number.non_zero_digit.to_i).map { { faker_class.planet => faker_class.character } }
end

RSpec.describe AwsInfraMapper::GraphBuilders::BaseGraphBuilder do
  describe '#build' do
    let(:mock_arg1) { 'foo' }
    let(:mock_arg2) { 'bar' }
    let(:mock_graph_nodes) { mock_dict(Faker::Stargate) }
    let(:mock_graph_edges) { mock_dict(Faker::StarWars) }
    let(:graph) do
      { GRAPH_DATA_NODES_KEY => mock_graph_nodes, GRAPH_DATA_EDGES_KEY => mock_graph_edges }
    end
    let(:mock_nodes_return) { mock_dict(Faker::Dune) }
    let(:mock_edges_return) { mock_dict(Faker::HitchhikersGuideToTheGalaxy) }

    context 'with nodes and edges returning proper hashes' do
      before(:each) do
        allow(subject).to receive(:build_nodes).and_return(mock_nodes_return)
        allow(subject).to receive(:build_edges).and_return(mock_edges_return)
      end

      it 'should pass proper arguments to #build_nodes' do
        subject.build({}, mock_arg1, mock_arg2)

        expect(subject).to have_received(:build_nodes).with(mock_arg1, mock_arg2)
      end

      it 'should pass proper arguments to #build_edges' do
        subject.build({}, mock_arg1, mock_arg2)

        expect(subject).to have_received(:build_edges).with(mock_arg1, mock_arg2)
      end

      it 'should merge #build_nodes nodes with original data' do
        subject.build(graph)

        expect(graph[GRAPH_DATA_NODES_KEY]).to eq(mock_graph_nodes + mock_nodes_return)
      end

      it 'should merge #build_edges nodes with original data' do
        subject.build(graph)

        expect(graph[GRAPH_DATA_EDGES_KEY]).to eq(mock_graph_edges + mock_edges_return)
      end
    end

    context 'with nodes and edges returning null' do
      before(:each) do
        allow(subject).to receive(:build_nodes)
        allow(subject).to receive(:build_edges)
      end

      it 'should succeed even if #build_nodes returns nothing' do
        subject.build(graph)

        expect(graph[GRAPH_DATA_NODES_KEY]).to eq(mock_graph_nodes)
      end

      it 'should succeed even if #build_edges returns nothing' do
        subject.build(graph)

        expect(graph[GRAPH_DATA_EDGES_KEY]).to eq(mock_graph_edges)
      end
    end
  end
end
