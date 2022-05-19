/*
var ProteinColor = "deeppink"
var PPIColor = "#a4268f"
var DomainColor = "#68d3aa"
var DDIColor = "#1f9b71"
var parentNodeBackgroundColor = "lightgray"
var nodeSize = 15

let colorOpts = {
    'ProteinColor': ProteinColor,
    'PPIColor': PPIColor,
    'DomainColor': DomainColor,
    'DDIColor': DDIColor,
    'parentNodeBackgroundColor': parentNodeBackgroundColor,
    'nodeSize': nodeSize
}
*/

export function makePlot(fetchedData, colorOpts){
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
                        const api = this.expandCollapse({
                            layoutBy: {
                                name: "cose-bilkent",
                                animate: true,
                                randomize: false,
                                fit: true
                            },
                            fisheye: true,
                            animate: true,
                            undoable: false
                        });
                        api.collapseAll();
                    },

                    style: [
                        {
                            selector: 'node',
                            style: {
                                'label': 'data(label)', //Show gene id
                                'color': colorOpts.ProteinColor,
                                'text-valign': 'bottom',
                                'background-color': colorOpts.ProteinColor,
                                'text-margin-y': 5,
                                'padding': 10,
                                'line-color': colorOpts.PPIColor,
                                'line-height': 2,
                                'height': colorOpts.nodeSize,
                                'width': colorOpts.nodeSize,
                                'opacity': colorOpts.opacity
                            }
                        },
                        { // Node properties for both protein ad domain node when dragged
                            selector: ".Node_active",
                            style: {
                                'font-weight': 'bold'
                            }
                        },
                        { // Node properties for domain node
                            selector: ".Domain_Node",
                            style: {
                                'color': colorOpts.DDIColor,
                                'background-color': colorOpts.DomainColor
                            }
                        },
                        { // Node properties for parents (compound nodes)
                            selector: ':parent',
                            style: {
                                'background-opacity': 0.4,
                                'background-color': colorOpts.parentNodeBackgroundColor,
                                'text-margin-y': 5,
                                'border-width': 0,
                                'shape' : 'round-rectangle',
                            }
                        },
                        { // Collapsed nodes properties
                            selector: "node.cy-expand-collapse-collapsed-node",
                            style: {
                                "background-color": colorOpts.ProteinColor,
                                "shape": "round-triangle"
                            }
                        },
                        { // Default edge properties for PPI
                            selector: ".PPI_Edge",
                            style: {
                                'label': '',
                                'curve-style': 'straight',
                                'width': "mapData(weight, 0, 5, 1, 10)",
                                'opacity': 0.4,
                                'line-color': colorOpts.PPIColor
                            }
                        },
                        { // Default edge properties for DDI
                            selector: ".DDI_Edge",
                            style: {
                                'line-color': colorOpts.DDIColor
                            }
                        },
                        {  // Edge properties for DDI in expand mode
                            selector: ".DDI_Edge_active",
                            style: {
                                'opacity': 0.4
                            }
                        },
                        { // Edge properties for DDI in collapse mode
                            selector: ".DDI_Edge_inactive",
                            style: {
                                'opacity': 0 // Do not show DDI edge in the default collapsed mode
                            }
                        },
                        { // Edge properties for PPI in expand mode
                            selector: ".PPI_Edge_inactive",
                            style: {
                                'line-style': 'dashed'
                            }
                        },
                        { // Edge properties for both PPI and DDI while a connected node is selected
                            selector: ".Edge_highlight",
                            style: {
                                'opacity': 1
                            }
                        }
                    ]
                })
        )
    return graph;
}

jQuery(document).ready(function(){
})
