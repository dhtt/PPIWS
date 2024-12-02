import {styleSheet} from '../resources/PPIXpress/graph_properties.js';
import {styleSheetLegend} from '../resources/PPIXpress/graph_properties.js';
import {showWarningMessage} from './functionality_helper_functions.js'

export function get_graph_type(fetchedData){

}
// colorOpts is defined in functionality.js
export function makePlot(fetchedData, graphLayoutOptions, legendLayoutOptions){
    // Make plot
    let WarningMessage = $('#WarningMessage')

    var graph = fetchedData
        .then(res => res.json())
        .then(
            data => {
                let graph_type = data[0].graph_type
                data.shift() // Remove the first element of the array which is the graph_type
                let n_nodes = data.filter((node) => node.group === "nodes").length
                if (n_nodes >= 10000){
                    showWarningMessage(WarningMessage,
                        "⚠️ This network contains more than 10000 nodes and will take a long time to render. Please use Cytoscape desktop to view the network.",
                        null)
                    return null
                } else {                
                    if (graph_type === "none"){
                        showWarningMessage(WarningMessage,
                            "⚠️ This protein is not a part of this condition-specific network or a reference network. Please select a different protein, " +
                            "or run the analysis again with the option 'Output reference network' (Step 3. Adjust Run Options) " +
                            "if you wish to inspect this protein in the reference network.",
                            null)
                    }
                    else if (graph_type === "reference_network"){
                        showWarningMessage(WarningMessage,
                            "⚠️ This protein is not a part of the condition-specific network for this expression data, " + 
                            "but is found in the reference network. Here, the subgraph from the reference network is shown.",
                            null)
                    }
    
                    window.NVContent_Graph = cytoscape({
                        container: $('#NVContent_Graph'),
                        elements: data,
                        boxSelectionEnabled: false,
                        autounselectify: true,
                        minZoom: 0.1,
    
                        ready: function () {
                            this.layout(graphLayoutOptions).run();
                            this.expandCollapse({
                                layoutBy: {
                                    name: "cose-bilkent",
                                    animate: false,
                                    randomize: false,
                                    fit: true,
                                    animationDuration: 50,
                                },
                                fisheye: true,
                                animate: false,
                                undoable: false
                            });
                        },
                        
                        style: styleSheet
                    })
            
                    window.NVContent_Graph.on('layoutstop', function(data){
                        if (graph_type === "condition_specific_network"){
                            WarningMessage.hide();
                        }
                    })
                    return window.NVContent_Graph;
                }
            })

    
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
