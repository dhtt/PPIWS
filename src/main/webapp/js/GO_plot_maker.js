
// colorOpts is defined in functionality.js
export function makeGOPlot(fetchedData, divID_holder){
    var graph = fetchedData
        .then(response => response.json())
        .then(data => {
            let x_label = $("#sort_by").val() === "FDR" ? "-Log(FDR)" : $("#sort_by" ).val() === "p_value" ?  "-Log(p-value)" : "Fold Enrichment"
            let color_label = $("#color_by").val() === "FDR" ? "-Log(FDR)" : $("#color_by" ).val() === "p_value" ?  "-Log(p-value)" : "Fold Enrichment"

            
            let x_data = Object.values(data.x)
            let y_data = Object.values(data.y)
            let color_data = Object.values(data.color)
            let sig_cutoff = $("#sig_cutoff").val()
            let color_scheme = $("#color_scheme").val() 
            let color_scheme_reverse = $("#color_scheme_reverse").val() === 'False' ? false : true

            var dot_trace = {
                x: x_data, y: y_data, customdata: color_data, mode: 'markers',
                hovertemplate: x_label + ': %{x:.2f}<br>GO terms: %{y}<br>' + 
                                color_label + ': %{customdata:.2f}',
                marker: {
                    color: color_data,
                    colorscale: color_scheme, 
                    reversescale: color_scheme_reverse,
                    size: 12
                }
            };
            var line_trace = {
                x: x_data, y: y_data, customdata: color_data, type: 'bar',
                hovertemplate: x_label + ': %{x:.2f}<br>GO terms: %{y}<br>' + 
                                color_label + ': %{customdata:.2f}',
                orientation: 'h',
                width: 0.1,
                marker: {
                    color: color_data,
                    colorscale: color_scheme,
                    reversescale: color_scheme_reverse,
                    colorbar: {
                        title: {
                            text: color_label},
                        thickness: 15
                    }
                }
            };

            var plot_data =  [dot_trace, line_trace];
           
            fetch("./resources/PantherDB/GO_layout.json")
            .then(response => response.json())
            .then(layout => {
                layout.main_layout.xaxis.title.text = x_label
                layout.main_layout.coloraxis.colorbar.title.text = color_label

                if ($("#sort_by").val() !== "fold_enrichment"){
                    layout.main_layout.shapes = [{
                        type: 'line',
                        xref: 'x', x0: -Math.log(sig_cutoff), x1: -Math.log(sig_cutoff), 
                        yref: 'paper', y0: 0, y1: 1,
                        line:{
                            color: 'red',
                            width: 2,
                            dash:'dot'
                        }
                    }]
                }
                Plotly.newPlot(divID_holder, plot_data, layout.main_layout, layout.config);
            })
        })
        .catch(error => {
            return null;
        })
    return graph;
}

jQuery(document).ready(function(){
})