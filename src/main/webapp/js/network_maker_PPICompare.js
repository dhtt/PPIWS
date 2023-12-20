// colorOpts is defined in functionality_PPICompare.js

export function makePlot(fetchedData, colorOpts, graphLayoutOptions, legendLayoutOptions){
    let lineColor = 'mapData(weight, 0, 1, ' + colorOpts.LostEdgeColor + ', ' + colorOpts.GainedEdgeColor + ')'
    let shapeMappingFunction = function(ele){ 
        return ele.data('transcriptomicAlteration') === 'gain' ? 'rectangle' : 
        (ele.data('transcriptomicAlteration') === 'loss' ? 'triangle' : 'ellipse'); 
    }
    const styleSheet = [
        { // Standard style for nodes
            selector: 'node',
            style: {
                'display': 'element',
                'label': 'data(id)', 
                'color': colorOpts.ProteinColor,
                'text-valign': 'bottom',
                'text-opacity': 1,
                'background-color': colorOpts.ProteinColor,
                'text-margin-y': 5,
                'padding': 15,
                'height': colorOpts.nodeSize,
                'width': colorOpts.nodeSize,
                'opacity': colorOpts.nodeOpacity,
                'shape': 'ellipse',
                'border-width': 0,
                'border-color': colorOpts.ProteinColor,
                'font-size': 15
            }
        },
        { // Node properties for both protein ad domain node when dragged
            selector: ".Node_active",
            style: {
                'font-weight': 'bold'
            }
        },
        { // Node properties for both protein ad domain node when dragged
            selector: ".Node_highlight",
            style: {
                'background-color': colorOpts.HighlightedProteinColor,
                'color': colorOpts.HighlightedProteinColor,
                'border-color': colorOpts.HighlightedProteinColor,
                'font-weight': 'bold'
            }
        },
        { // Node properties for both protein ad domain node when dragged
            selector: ".Node_hidden",
            style: {
                'display': 'none'
            }
        },
        { 
            selector: ".Node_transcriptomicAlteration",
            style: {
                'shape': shapeMappingFunction
            }
        },
        { 
            selector: ".Node_partOfMinReasons",
            style: {
                'border-width': 5,
                'border-color': 'red',
                'font-weight': 'bold'
            }
        },
        { // Default edge properties for PPI
            selector: ".PPI_Edge",
            style: {
                'display': 'element',
                'label': '',
                'curve-style': 'straight',
                'width': 4,
                'opacity': 0.8,
                'line-color': lineColor,
                'visibility': 'visible'
            }
        }
    ]
    
    let styleSheetLegendChange = [
        {
            'selector': 'node',
            'label': 'data(label)', 
            'color': 'black',
            'text-valign': 'center',
            'text-halign': 'right',
            'text-margin-x': '1em',
        },
        { // Default edge properties for PPI
            'selector': ".PPI_Edge",
            'display': 'element',
            'width': 5
        },
        {
            'selector': ".Node_transcriptomicAlteration",
            'shape': shapeMappingFunction
        }
    ]

    let styleSheetLegend = []
    styleSheet.forEach(function(item){
        styleSheetLegend.push(JSON.parse(JSON.stringify(item)))
    })
    styleSheetLegendChange.forEach(function(item) {
        for (var i = 0; i < styleSheetLegend.length; i++) {
            if (styleSheetLegend[i]['selector'] === item['selector']){
                for (var attr in item) {
                    if (attr !== 'selector') styleSheetLegend[i]['style'][attr] = item[attr]
                }
            }
        }
    });


    // Make plot
    var graph = fetchedData
        .then(res => res.json())
        .then(
            data => window.NVContent_Graph = cytoscape({
                    container: $('#NVContent_Graph'),
                    elements: data,
                    boxSelectionEnabled: false,
                    autounselectify: true,

                    ready: function () {
                        this.layout(graphLayoutOptions).run();
                    },

                    style: styleSheet
                })
        )

    // Make legend for plot
    var NVContent_Legend_cy = window.NVContent_Legend = cytoscape({
        container: $('#NVContent_Legend'),

        elements: fetch('./resources/legend.json')
            .then(res => res.json())
            .then(res => res.filter((node) => node.data.type === "default")),

        layout: legendLayoutOptions,

        style: styleSheetLegend
    })

    NVContent_Legend_cy.on('layoutstop', function(data){
        let cy = data.cy;
        var gained_edge_1 = cy.$('#gained_edge_1')
        var gained_edge_2 = cy.$('#gained_edge_2')
        var lost_edge_1 = cy.$('#lost_edge_1')
        var lost_edge_2 = cy.$('#lost_edge_2')

        //The initial layout draws 4 nodes gained_edge_1, gained_edge_2, lost_edge_1, lost_edge_2 in such order
        gained_edge_1.position({
            x: gained_edge_1.position().x - 50,
            y: lost_edge_1.position().y // Move to the 3rd node which is lost_edge_1
        })
        gained_edge_2.position({
            x: gained_edge_1.position().x + 50,
            y: lost_edge_1.position().y // Move to the 3rd node which is lost_edge_1
        })

        lost_edge_1.position({
            x: lost_edge_1.position().x - 50,
            y: lost_edge_2.position().y // Move to the 4th node which is lost_edge_2
        })
        lost_edge_2.position({
            x: lost_edge_1.position().x + 50,
            y: lost_edge_2.position().y // Move to the 4th node which is lost_edge_2
        })
    })

    // Return graph for other usage in functionality_PPICompare
    return graph;
}

jQuery(document).ready(function(){
})
