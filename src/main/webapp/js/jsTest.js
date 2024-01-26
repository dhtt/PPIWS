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

// Test fetchResult

function fetchResult(pureText, resultFileType, target, downloadable){
    if (pureText !== null){
        let blob = new Blob([pureText])
        createDownloadLink(blob, target)
    }

    else {
        const downloadData = new FormData();
        downloadData.append("resultFileType", resultFileType)

        if (resultFileType === "graph"){
            downloadData.append("proteinQuery", NetworkSelection_Protein.val())
            downloadData.append("expressionQuery", NetworkSelection_Expression.val())
            downloadData.append("showDDIs", showDDIs)
        }
        // Display the values
        for (const value of downloadData.values()) {
            console.log(value);
        }
        let fetchData = fetch("DownloadServlet",
            {
                method: 'POST',
                body: downloadData
            })

        // If downloadable is true, download file from fetched response under target as filename.
        // Applied for resultFileType of log, sample_summary, output
        if (downloadable)
            fetchData
                .then(response => response.blob())
                .then(blob => createDownloadLink(blob, target))

        // If downloadable is false, display the fetched response in target as container HTML element
        // Applied for resultFileType of graph, sample_summary
        else
            if (resultFileType === "graph"){
                showWarningMessage(WarningMessage,
                    "⏳ Please wait: Loading subnetworks... (Large networks may take a long time to render)",
                    null)
                ProteinNetwork = makePlot(fetchData, cosebilkentLayoutOptions, gridLayoutOptions);
                ProteinNetwork
                    .then(cy => {
                        WarningMessage.css({'display': 'none'});
                        return cy
                    })
            }
            else if (resultFileType === "sample_summary"){
                fetchData
                    .then(response => response.text())
                    .then(text => target.innerHTML = text)
            }
            else if (resultFileType === "protein_list"){
                fetchData
                    .then(response => response.text())
                    .then(text => target.innerHTML = text)
            }
    }
}


fetchResult(null,"sample_summary", SampleSummaryTable[0], false)








