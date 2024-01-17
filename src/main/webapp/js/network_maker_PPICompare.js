import {styleSheet} from '../resources/PPICompare/graph_properties.js';
import {styleSheetLegend} from '../resources/PPICompare/graph_properties.js';

// colorOpts is defined in functionality_PPICompare.js
export function makePlot(fetchedData, graphLayoutOptions, legendLayoutOptions){
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

        elements: fetch('./resources/PPICompare/legend.json')
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
