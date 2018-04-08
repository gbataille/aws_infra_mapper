function loadJSON(callback) {

  var xobj = new XMLHttpRequest();
  xobj.overrideMimeType("application/json");
  xobj.open('GET', 'data.json', true);
  xobj.onreadystatechange = function() {
    if (xobj.readyState == 4 && xobj.status == 200) {
      // .open will NOT return a value but simply returns undefined in async mode so use a callback
      callback(xobj.responseText);
    }
  }
  xobj.send(null);
}

function get_node_classes(type) {
  if (type === 'ec2_instance') {
    return 'ec2_instance'
  } else {
    return 'default'
  }
}

function prepare_node(node_data) {
  return {
    group: 'nodes',
    data: {
      id: node_data.label,
      label: node_data.label,
      raw: node_data
    },
    classes: get_node_classes(node_data.type)
  }
}

function prepare_edge(edge_data) {
  return {
    group: 'edges',
    data: {
      source: edge_data.source,
      target: edge_data.target,
      raw: edge_data.data
    }
  }
}

// Call to function with anonymous callback
loadJSON(function(response) {
  // Do Something with the response e.g.
  json_graph = JSON.parse(response);

  nodes = json_graph.nodes.map(prepare_node);
  edges = json_graph.edges.map(prepare_edge);

  var cy = cytoscape({
    container: document.getElementById('cy'),
    elements: nodes.concat(edges),
    layout: {
      name: 'breadthfirst'
    },
    style: cytoscape.stylesheet()
      .selector('node')
        .css({
          "content": 'data(label)',
          "text-valign": 'bottom',
          "shape": "rectangle",
          "background-fit": "contain",
          "background-repeat": "no-repeat",
          "background-color": "white"
        })
      .selector('.default')
        .css({
          "background-color": "blue",
        })
      .selector('.ec2_instance')
        .css({
          "background-image": "url('/assets/icons/aws/EC2_instance.png')",
        })
  });

});
