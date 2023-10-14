import {makePlot} from './network_maker_PPICompare.js'


const CSS_Style = {};
$("[name='CSS_Style']").map(function(){
    const col = window.getComputedStyle(this, null).getPropertyValue("color"); // Get CS value of variable
    this.value = col // Set value of style to value of CSS variable
    CSS_Style[this.id] = col; // Return an JSON entry for variable with value as item
}).get()
let colorOpts = {
    'ProteinColor': CSS_Style['--deeppink'],
    'DomainColor': CSS_Style['--intensemint'],
    'PPIColor': CSS_Style['--darkdeeppink'],
    'DDIColor': CSS_Style['--darkintensemint'],
    'nodeSize': 15,
    'opacity': 1
}

$('#ShowSubnetwork').on("click", function (){
    const resultFileType = "graph"
    const downloadData = new FormData();
    downloadData.append("resultFileType", resultFileType)

    let fetchData = fetch("DownloadServlet", {
            method: 'POST',
            body: downloadData
        })
        
    // Output log file
    fetchData.then(function(result) {
            console.log(result)
        })

    let ProteinNetwork = null;
    if (resultFileType === "graph"){
        ProteinNetwork = makePlot(fetchData, colorOpts);
        ProteinNetwork
            .then(cy => {
                WarningMessage.css({'display': 'none'});
                return cy
            })
    }
    activateNetwork(ProteinNetwork, WarningMessage)
})


function activateNetwork(graph, warning){
    graph
        .then(cy => {
            cy.unbind("grab"); // unbind event to prevent possible mishaps with firing too many events
            cy.$('node').bind('grab', function(node) { // bind with .bind() (synonym to .on() but more intuitive
                const ele = node.target;
                ele.addClass('Node_active');
                ele.connectedEdges().addClass('Edge_highlight');
            });

            cy.$('node').bind('free', function(node) { // bind with .bind() (synonym to .on() but more intuitive
                const ele = node.target;
                ele.removeClass('Node_active');
                ele.connectedEdges().removeClass('Edge_highlight')
            });

            cy.unbind("tap"); // unbind event to prevent possible mishaps with firing too many events
            cy.$('node').bind('tap', function(node) { // bind with .bind() (synonym to .on() but more intuitive
                const ele = node.target;
            })
            return cy
        })
}