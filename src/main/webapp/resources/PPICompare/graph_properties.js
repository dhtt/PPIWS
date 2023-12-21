import {updateColorScheme} from '../../js/functionality_helper_functions.js';
import {deepCopyArray} from '../../js/functionality_helper_functions.js'


export const gridLayoutOptions = {
    'name': 'grid',
    'rows': 7,
    'cols': 1,
    'fit': true,
    'animate': false
}

export const cosebilkentLayoutOptions = {
    'name': 'cose-bilkent',
    'randomize': false,
    'fit': true,
    'animate': false
}


/***
 * Define values for button holding CSS style before the document is ready
 */
export const CSS_Style = {}
export var colorOpts = {}
export var styleSheet = []
export var styleSheetLegend = []
let CSS_Style_ = CSS_Style 

jQuery(document).ready(function() {
    CSS_Style_ = updateColorScheme('CSS_Style')

    colorOpts = {
        'ProteinColor': CSS_Style_['--protein'],
        'LostEdgeColor': CSS_Style_['--lostedge'],
        'GainedEdgeColor': CSS_Style_['--gainededge'],
        'HighlightedProteinColor': CSS_Style_['--highlightedprotein'],
        'nodeSize': 2,
        'nodeOpacity': 0.8
    }

    let lineColor = 'mapData(weight, 0, 1, ' + colorOpts.LostEdgeColor + ', ' + colorOpts.GainedEdgeColor + ')'
    
    let shapeMappingFunction = function(ele){ 
        return ele.data('transcriptomicAlteration') === 'gain' ? 'rectangle' : 
        (ele.data('transcriptomicAlteration') === 'loss' ? 'triangle' : 'ellipse'); 
    }

    styleSheet = [
    { // Standard style for nodes
        selector: 'node',
        style: {
            'display': 'element',
            'label': 'data(id)', 
            'color': colorOpts.ProteinColor,
            'text-valign': 'bottom',
            'text-opacity': 1,
            'background-color': colorOpts.ProteinColor,
            'text-margin-y': 5,
            'padding': 15,
            'height': colorOpts.nodeSize,
            'width': colorOpts.nodeSize,
            'opacity': colorOpts.nodeOpacity,
            'shape': 'ellipse',
            'border-width': 0,
            'border-color': colorOpts.ProteinColor,
            'font-size': 15
        }
    },
    { // Node properties for both protein ad domain node when dragged
        selector: ".Node_active",
        style: {
            'font-weight': 'bold'
        }
    },
    { // Node properties for both protein ad domain node when dragged
        selector: ".Node_highlight",
        style: {
            'background-color': colorOpts.HighlightedProteinColor,
            'color': colorOpts.HighlightedProteinColor,
            'border-color': colorOpts.HighlightedProteinColor,
            'font-weight': 'bold'
        }
    },
    { // Node properties for both protein ad domain node when dragged
        selector: ".Node_hidden",
        style: {
            'display': 'none'
        }
    },
    { 
        selector: ".Node_transcriptomicAlteration",
        style: {
            'shape': shapeMappingFunction
        }
    },
    { 
        selector: ".Node_partOfMinReasons",
        style: {
            'border-width': 5,
            'border-color': 'red',
            'font-weight': 'bold'
        }
    },
    { // Default edge properties for PPI
        selector: ".PPI_Edge",
        style: {
            'display': 'element',
            'label': '',
            'curve-style': 'straight',
            'width': 4,
            'opacity': 0.8,
            'line-color': lineColor,
            'visibility': 'visible'
        }
    }]

    let styleSheetLegendChange = [
        {
            'selector': 'node',
            'label': 'data(label)', 
            'color': 'black',
            'text-valign': 'center',
            'text-halign': 'right',
            'text-margin-x': '1em',
        },
        { // Default edge properties for PPI
            'selector': ".PPI_Edge",
            'display': 'element',
            'width': 5
        },
        {
            'selector': ".Node_transcriptomicAlteration",
            'shape': shapeMappingFunction
        },
        {
            'selector': ".Node_partOfMinReasons",
            'font-weight': 'normal'
        }
    ]

    styleSheetLegend = deepCopyArray(styleSheet)
    styleSheetLegendChange.forEach(function(item) {
        for (var i = 0; i < styleSheetLegend.length; i++) {
            if (styleSheetLegend[i]['selector'] === item['selector']){
                for (var attr in item) {
                    if (attr !== 'selector') styleSheetLegend[i]['style'][attr] = item[attr]
                }
            }
        }
    });


})


