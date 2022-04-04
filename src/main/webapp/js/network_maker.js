jQuery(document).ready(function() {
    // Show graph
    const NetworkSelection = $('#NetworkSelection')
    NetworkSelection.on('change', function () {
        let graphFile = "output/graph/" + $(this).val() + ".json"
        makePlot(graphFile)
    })
})

export function makePlot(graphFile_){
    fetch(graphFile_, {mode: 'no-cors'})
        .then(function(res) {
            return res.json()
        })
        .then(function(data) {
            var graph = cytoscape({
                container: $('#NVContent'),
                elements: data,
                boxSelectionEnabled: false,
                autounselectify: true,

                layout: {
                    name: 'circle'
                },

                style: [
                    {
                        selector: 'node',
                        style: {
                            'label': 'data(id)', //Show gene id
                            'height': 20, //Adjust node size
                            'width': 20,
                            'background-color' : '#433C39'
                            // 'background-color': 'mapData(rank, 0, 207, #95d0aa, #e8067f)',
                        }
                    },

                    {
                        selector: 'edge',
                        style: {
                            'curve-style': 'haystack',
                            'haystack-radius': 1,
                            'width': 5,
                            'opacity': 0.5,
                            'line-color': '#95d0aa'
                        }
                    }
                ]
            });
        })
}