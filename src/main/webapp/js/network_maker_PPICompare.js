// colorOpts is defined in functionality_PPICompare.js

export function makePlot(fetchedData, colorOpts){
    let line_color = 'mapData(weight, 0, 1, ' + colorOpts.LostEdgeColor + ', ' + colorOpts.GainedEdgeColor + ')'
    var graph = fetchedData
        .then(res => res.json())
        .then(
            data => window.NVContent_Graph = cytoscape({
                    container: $('#NVContent_Graph'),
                    elements: data,
                    boxSelectionEnabled: false,
                    autounselectify: true,

                    ready: function () {
                        this.layout({
                            name: 'cose-bilkent',
                            randomize: true,
                            fit: true,
                            animate: false
                        }).run();
                    },

                    style: [
                        {
                            selector: 'node',
                            style: {
                                'label': 'data(id)', 
                                'color': colorOpts.ProteinColor,
                                'text-valign': 'bottom',
                                'text-opacity': 1,
                                'background-color': colorOpts.ProteinColor,
                                'text-margin-y': 5,
                                'padding': 15,
                                'height': colorOpts.nodeSize,
                                'width': colorOpts.nodeSize,
                                'opacity': colorOpts.nodeOpacity
                            }
                        },
                        { // Node properties for both protein ad domain node when dragged
                            selector: ".Node_active",
                            style: {
                                'font-weight': 'bold'
                            }
                        },
                        { // Default edge properties for PPI
                            selector: ".PPI_Edge",
                            style: {
                                'label': '',
                                'curve-style': 'straight',
                                'width': 4,
                                'opacity': 0.8,
                                'line-color': line_color
                            }
                        }
                    ]
                })
        )
    return graph;
}

jQuery(document).ready(function(){
})
