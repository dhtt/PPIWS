import {styleSheet} from '../resources/PPIXpress/graph_properties.js';
import {styleSheetLegend} from '../resources/PPIXpress/graph_properties.js';

// colorOpts is defined in functionality.js
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
                        const api = this.expandCollapse({
                            layoutBy: {
                                name: "cose-bilkent",
                                animate: false,
                                randomize: false,
                                fit: true,
                                animationDuration: 200,
                            },
                            fisheye: true,
                            animate: false,
                            undoable: false
                        });
                        api.collapseAll();
                    },

                    style: styleSheet
                })
        )

    
    // Make legend for plot
    var NVContent_Legend_cy = window.NVContent_Legend = cytoscape({
        container: $('#NVContent_Legend'),

        elements: fetch('./resources/PPIXpress/legend.json')
            .then(res => res.json())
            .then(res => res.filter((node) => node.data.type === "default")),

        layout: legendLayoutOptions,

        style: styleSheetLegend
    })

    NVContent_Legend_cy.on('layoutstop', function(data){
        let cy = data.cy;
        var PPI_node_1 = cy.$('#PPI_node_1')
        var PPI_node_2 = cy.$('#PPI_node_2')
        var DDI_node_1 = cy.$('#DDI_node_1')
        var DDI_node_2 = cy.$('#DDI_node_2')

        //The initial layout draws 4 nodes PPI_node_1, PPI_node_2, DDI_node_1, DDI_node_2 in such order

        DDI_node_1.position({
            x: DDI_node_1.position().x - 50,
            y: PPI_node_2.position().y // Move to the 4th node which is DDI_node_2
        })
        DDI_node_2.position({
            x: DDI_node_1.position().x + 50,
            y: PPI_node_2.position().y // Move to the 4th node which is DDI_node_2
        })


        PPI_node_2.position({
            x: PPI_node_1.position().x,
            y: PPI_node_1.position().y // Move to the 3rd node which is DDI_node_1
        })
        PPI_node_1.position({
            x: PPI_node_1.position().x - 50,
            y: PPI_node_1.position().y // Move to the 3rd node which is DDI_node_1
        })
    })

    return graph;
}

jQuery(document).ready(function(){
})
