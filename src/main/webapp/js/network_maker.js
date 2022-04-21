jQuery(document).ready(function() {
    // Show graph
    // const setTheme = theme => document.documentElement.className = theme;
    // var bodyStyles = getComputedStyle(document.documentElement)
    // var nodeColor = bodyStyles.getPropertyValue('--nodecolor'); //get
    // var edgeColor = bodyStyles.getPropertyValue('--edgecolor'); //get
    // document.getElementById('ColorTheme').addEventListener('change', function() {
    //     alert(this.value + ' - ' + nodeColor + ' - ' + edgeColor)
    //     setTheme(this.value);
    // });

    const NetworkSelection = $('#NetworkSelection')
    NetworkSelection.on('change', function () {
        let graphFile = $(this).val()
        makePlot(graphFile, '#433C39', '#1f9b71')
    })

    // $('#CustomizeNetwork').on('click', function (){
    //     window.location.href = "/graphCustomize.jsp"
    //     return false;
    // })
})

export function makePlot(graphFile_, nodeColor_, edgeColor_){
    fetch(graphFile_, {mode: 'no-cors'})
        .then(function(res) {
            return res.json()
        })
        .then(function(data) {
            var graph = cytoscape({
                container: $('#NVContent_Graph'),
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
                            // 'background-color' : '#433C39'
                            'background-color' : nodeColor_
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
                            // 'line-color': '#95d0aa',
                            'line-color': edgeColor_
                        }
                    }
                ]
            });
        })
}