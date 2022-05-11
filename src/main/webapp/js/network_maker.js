export function makePlot(fetchedData){
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
                                'label': 'data(label)', //Show gene id
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
                })
        )
    return graph;
}

jQuery(document).ready(function(){
    const nodeColor = $('#pickNodeColor');
})