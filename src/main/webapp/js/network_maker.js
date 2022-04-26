export function makePlot(fetchedData){
    fetchedData
        .then(res => res.json())
        .then(
            data => {
                if (data[0].Error !== undefined)
                    alert(data[0].Error)
                else {
                    const graph = cytoscape({
                        container: $('#NVContent_Graph'),
                        elements: data,
                        boxSelectionEnabled: false,
                        autounselectify: true,

                        layout: {
                            name: 'cose'
                        },

                        style: [
                            {
                                selector: 'node',
                                style: {
                                    'label': 'data(id)', //Show gene id
                                    'height': 20, //Adjust node size
                                    'width': 20,
                                    'background-color': '#433C39'
                                    // 'background-color' : nodeColor_
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
                                    // 'line-color': edgeColor_
                                }
                            }
                        ]
                    });
                }
            })

}