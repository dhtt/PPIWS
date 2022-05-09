export function makePlot(fetchedData){
    fetchedData
        .then(res => res.json())
        .then(
            data => {
                if (data[0].Error !== undefined) {
                    alert(data[0].Error)
                    return "null";
                }
                else {
                    alert("Cytoscape")
                    const cy = cytoscape({
                        container: $('#NVContent_Graph'),
                        elements: data,
                        boxSelectionEnabled: false,
                        autounselectify: true,

                        ready: function () {
                            this.layout({
                                name: 'circle',
                                randomize: true,
                                fit: true,
                                animate: false
                            }).run();
                            const api = this.expandCollapse({
                                layoutBy: {
                                    name: "circle",
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
                                    'label': 'data(id)', //Show gene id
                                    'text-valign': 'bottom',
                                    'font-family': 'Roboto, Gill Sans',
                                    'background-color': '#729F82'
                                }
                            },
                            {
                                selector: ':parent',
                                style: {
                                    // 'label': 'data(id)', //Show gene id
                                    'background-opacity': 0.2,
                                    // 'text-valign': 'bottom'
                                }
                            },
                            {
                                selector: "node.cy-expand-collapse-collapsed-node",
                                style: {
                                    "background-color": "deeppink",
                                    "shape": "rectangle"
                                }
                            },
                            {
                                selector: "edge",
                                style: {
                                    'label': '',
                                    'curve-style': 'straight',
                                    'width': "mapData(weight, 0, 5, 1, 10)",
                                    'opacity': "mapData(weight, 0, 5, 0, 1)",
                                    'line-color': "mapData(weight, 0, 5, #95d0aa, #e8067f)"
                                    // 'line-color': edgeColor_
                                }
                            }
                        ]
                    });
                    var api = cy.expandCollapse('get');
                    console.log(api);
                    api.expandAll();
                }
            })

}