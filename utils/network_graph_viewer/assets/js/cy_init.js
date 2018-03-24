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

// Call to function with anonymous callback
loadJSON(function(response) {
  // Do Something with the response e.g.
  json_graph = JSON.parse(response);

  var cy = cytoscape({
    container: document.getElementById('cy'),
    elements: [
      {
        data: json_graph.nodes[0],
        classes: 'ec2_instance',
      },
      {
        data: json_graph.nodes[1],
        classes: 'ec2_instance',
      },
      {
        data: json_graph.edges[0],
      }
    ],
    layout: {
      name: 'grid',
      rows: 1
    },
    style: cytoscape.stylesheet()
      .selector('node')
        .css({
          "shape": "rectangle",
          "background-fit": "contain",
          "background-repeat": "no-repeat",
          "background-color": "white"
        })
      .selector('.ec2_instance')
        .css({
          "background-image": "url('/assets/icons/aws/EC2_instance.png')",
        })
  });

});
