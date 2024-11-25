from dash import Dash, html, callback, Input, Output, dcc
import pandas as pd
import numpy as np
import json
import plotly.express as px
import plotly.graph_objects as go
import textwrap

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
    if color_scheme_reverse_ == 'True':
        color_scheme_ = color_scheme_ + '_r'
    labels = {'FDR': '-Log(FDR)', 'p_value': '-Log(p-value)', 'fold_enrichment': 'Fold Enrichment'}
    
    fig = px.scatter(df_, x = sort_by_, y = 'GO_label', 
                     color = color_by_, color_continuous_scale = color_scheme_, 
                     range_color = scale_cmap(min(df_[color_by_]), max(df_[color_by_]), 0.1),
                     custom_data = [color_by_],
                     labels = {
                         'x' : labels[sort_by_],
                         'y' : 'GO terms',
                         'color' : labels[color_by_]
                         }
                     )
    
    fig.update_traces(marker=dict(size=15), 
                      legendgroup = color_by_,
                      hovertemplate = labels[sort_by_] + ': %{x:.2f}' + '<br>GO terms: %{y}<br>' + labels[color_by_] + 
                      ': %{customdata[0]:.2f}')
    
    fig.add_trace(go.Bar(x = df_[sort_by_], y = df_['GO_label'], orientation='h', width = 0.1, showlegend=False,
                         marker = dict(color = df_[color_by_], colorscale = color_scheme_)))
    
    fig.update_layout(
        title=dict(
            text = 'Gene Ontology Overrepresentation Test\n(PantherDB)',
            x = 0.5,
            xanchor = 'center',
            yanchor = 'top'
            ),
        xaxis = dict(
            title = dict(
                text = labels[sort_by_],
                standoff = 15
                ),
            automargin = True
            ),
        yaxis = dict(
            title = dict(
                text = 'GO terms',
                standoff = 25
                ),
            automargin = True,
            categoryorder = 'total ascending'
            ),
        coloraxis_colorbar = dict(
            title = dict(
                text = labels[color_by_],
                font = dict(
                    weight = 'bold'
                    )
                )
            ),
        font = dict(
            family = 'sans-serif'
            )
        )  
    
    return(fig)


if __name__ == '__main__':
    with open('../resources/PantherDB/example_overrep_result.json', 'r') as f:
        data = json.load(f)
        df = pd.DataFrame(data['results']['result'])
        df = df.rename({'pValue': 'p_value', 'fdr': 'FDR'}, axis='columns')
        df['FDR'] = -np.log(df['FDR'])
        df['p_value'] = -np.log(df['p_value'])
        df['GO_label'] = df['term'].apply(lambda x: "<br>".join(textwrap.wrap(x['label'], 50)) if 'label' in x.keys() else None)
        df['GO_id'] = df['term'].apply(lambda x: "<br>".join(textwrap.wrap(x['id'], 50)) if 'id' in x.keys() else None)
        df = df.dropna()
        max_entries_cutoff = 20
        
        # Initialize the app
        app = Dash()
        app.layout = html.Div([
            html.Div([
                html.Div([
                    html.Div('Sort by:', style={'font-weight': 'bold'}),
                    dcc.RadioItems(
                        options=[
                            {'label': 'FDR', 'value': 'FDR'},
                            {'label': 'p-value', 'value': 'p_value'},
                            {'label': 'Fold enrichment', 'value': 'fold_enrichment'}
                            ],
                        value='p_value', 
                        id='sort_by')
                    ], style={'flex-basis': '50%'}),
                
                     
                html.Div([
                    html.Div('Color by:', style={'font-weight': 'bold'}),
                    dcc.RadioItems(
                        options=[
                            {'label': 'FDR', 'value': 'FDR'},
                            {'label': 'p-value', 'value': 'p_value'},
                            {'label': 'Fold enrichment', 'value': 'fold_enrichment'}
                            ],
                        value='fold_enrichment', 
                        id='color_by')
                    ]),
                html.Div([
                    html.Div('Change color scheme:', style={'font-weight': 'bold'}),
                    dcc.Dropdown(
                        options=[{'label': x, 'value': x} for x in ['viridis', 'plasma', 'Blues', 'Greens', 'Purples', 'Reds']],
                        value='viridis', 
                        id='color_scheme')
                    ]),
            
                html.Div([
                    html.Div('Reverse color scheme:', style={'font-weight': 'bold'}),
                    dcc.RadioItems(
                        options=[
                            {'label': 'True', 'value': 'True'},
                            {'label': 'False', 'value': 'False'}
                            ],
                        value='False', 
                        id='color_scheme_reverse'),
                    ]),
                
                html.Div([  
                        html.Div('Significance level cutoff:', style={'font-weight': 'bold'}),
                        dcc.Slider(0, 0.05, 0.01, value=0.05, id='sig_cutoff')
                        ], style={'flex-basis': '50%'}),
                
                html.Div([
                    html.Div('Show entries:', style={'font-weight': 'bold'}),
                    dcc.Slider(min = 1, max = min(df.shape[0], max_entries_cutoff), step = 5, value=10, id='entries_cutoff')
                    ]),
    
        ], style={'display': 'block', 'flex-direction': 'column', 'flex-basis': '40%'}),
                html.Div([        
                    dcc.Graph(id = 'GO_plot_placeholder')   
                ], style={'display': 'block', 'flex-direction': 'column', 'flex-basis': '60%'})
            ], style={'display': 'flex', 'flex-direction': 'row'}),
        
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

        app.run(debug=False)