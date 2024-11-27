from flask import Flask, request, jsonify, after_this_request
from dash import Dash, callback, Input, Output
import pandas as pd
import numpy as np
import json
import plotly.express as px
import plotly.graph_objects as go
import textwrap
from make_GO_interface import make_GO_interface

def prepare_data(df_):
    df_ = df_.rename({'pValue': 'p_value', 'fdr': 'FDR'}, axis='columns')
    df_['FDR'] = -np.log(df_['FDR'])
    df_['p_value'] = -np.log(df_['p_value'])
    df_['GO_label'] = df_['term'].apply(lambda x: "<br>".join(textwrap.wrap(x['label'], 50)) if 'label' in x.keys() else None)
    df_['GO_id'] = df_['term'].apply(lambda x: "<br>".join(textwrap.wrap(x['id'], 50)) if 'id' in x.keys() else None)
    df_ = df_.dropna()
    return df_

def get_significance_level(df_, sort_by_, entries_cutoff, FDR_cutoff, p_value_cutoff): 
    df_filtered = df_
    cutoff_value = -np.log(FDR_cutoff) if sort_by_ == "FDR" else -np.log(p_value_cutoff) if sort_by_ == "p_value" else -1.0
    df_filtered['significance'] = df_filtered[sort_by_] >= cutoff_value if cutoff_value != -1.0 else True
    df_filtered = df_filtered.sort_values(by=[sort_by_], ascending=False)
    
    if df_filtered.loc[df_filtered['significance'] == True].shape[0]:
        df_filtered = df_filtered.head(min(df_filtered.shape[0], entries_cutoff))
    else: 
        df_filtered = df_filtered.head(entries_cutoff) 
    return df_filtered

def scale_cmap(cmap_start, cmap_end, frac):
    cmap_start = cmap_start * (1 + frac)
    cmap_end = cmap_end * (1 - frac)
    return [cmap_start, cmap_end]
 
def make_plot(df_, sort_by_, color_by_, color_scheme_, color_scheme_reverse_):
    color_scheme_ = color_scheme_ + '_r' if color_scheme_reverse_ == 'True' else color_scheme_
    labels = {'FDR': '-Log(FDR)', 'p_value': '-Log(p-value)', 'fold_enrichment': 'Fold Enrichment'}
    
    fig = px.scatter(df_, x = sort_by_, y = 'GO_label', 
                     color = color_by_, color_continuous_scale = color_scheme_, 
                     range_color = scale_cmap(min(df_[color_by_]), max(df_[color_by_]), 0),
                     custom_data = [color_by_],
                     labels = {
                         'x' : labels[sort_by_],
                         'y' : 'GO terms',
                         'color' : labels[color_by_]
                         }
                     )
    
    fig.update_traces(marker=dict(size=15),
                      hovertemplate = labels[sort_by_] + ': %{x:.2f}' + '<br>GO terms: %{y}<br>' + labels[color_by_] + 
                      ': %{customdata[0]:.2f}')
    
    fig.add_trace(go.Bar(x = df_[sort_by_], y = df_['GO_label'], orientation='h', width = 0.1, showlegend=False,
                         marker = dict(color = df_[color_by_], colorscale = color_scheme_)))
    
    layout = main_layout
    layout['xaxis']['title']['text'] = labels[sort_by_]
    layout['coloraxis_colorbar']['title']['text'] = labels[color_by_]
    fig.update_layout(layout)
    fig.write_html('GO_plot.html')
    return(fig)

if __name__ == '__main__':
    with open('../resources/PantherDB/example_overrep_result.json', 'r') as f:
        data = json.load(f)
    df = pd.DataFrame(data['results']['result'])
    df = prepare_data(df)
        
    with open('../resources/PantherDB/GO_layout.json', 'r') as f:
        main_layout = json.load(f)
        
    max_entries_cutoff = 20
    server = Flask(__name__)
    
    # Initialize the app
    app = Dash(__name__, server=server)
    app.layout = make_GO_interface(df, max_entries_cutoff)
    
    @callback(
        Output(component_id='GO_plot_placeholder', component_property='figure'),
        Input(component_id='sort_by', component_property='value'),
        Input(component_id='color_by', component_property='value'),
        Input(component_id='color_scheme', component_property='value'),
        Input(component_id='color_scheme_reverse', component_property='value'),
        Input(component_id='entries_cutoff', component_property='value'),
        Input(component_id='sig_cutoff', component_property='value')
    )
    
    def update_graph(sort_by, color_by, color_scheme, color_scheme_reverse, entries_cutoff, sig_cutoff):
        GO_df = get_significance_level(df, sort_by, entries_cutoff=entries_cutoff, FDR_cutoff=sig_cutoff, p_value_cutoff=sig_cutoff)
        GO_plot = make_plot(GO_df, sort_by, color_by, color_scheme, color_scheme_reverse)
        return GO_plot

    @server.route("/GO_dash_app/")
    def MyDashApp():
        return app.index()
     
    app.run_server(debug=False, port='5000')
    