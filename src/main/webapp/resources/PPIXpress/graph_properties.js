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
    'randomize': true,
    'fit': true,
    'animate': false
}


/***
 * Define values for button holding CSS style before the document is ready
 */
export var colorOpts = {}
export var styleSheet = []
export var styleSheetLegend = []
let CSS_Style_ = {} 

jQuery(document).ready(function() {
    CSS_Style_ = updateColorScheme('CSS_Style')

    // Default colors for graphs
    colorOpts = {
        'ProteinColor': CSS_Style_['--deeppink'],
        'DomainColor': CSS_Style_['--intensemint'],
        'PPIColor': CSS_Style_['--darkdeeppink'],
        'DDIColor': CSS_Style_['--darkintensemint'],
        'parentNodeBackgroundColor': 'lightgray',
        'nodeSize': 15,
        'opacity': 1
    }

    styleSheet =[
        {
            selector: 'node',
            style: {
                'label': 'data(label)', //Show gene id
                'color': colorOpts.ProteinColor,
                'text-valign': 'bottom',
                'background-color': colorOpts.ProteinColor,
                'text-margin-y': 5,
                'padding': 10,
                'line-color': colorOpts.PPIColor,
                'line-height': 2,
                'height': colorOpts.nodeSize,
                'width': colorOpts.nodeSize,
                'opacity': colorOpts.opacity
            }
        },
        { // Node properties for both protein ad domain node when dragged
            selector: ".Node_active",
            style: {
                'font-weight': 'bold'
            }
        },
        { // Node properties for domain node
            selector: ".Domain_Node",
            style: {
                'color': colorOpts.DDIColor,
                'background-color': colorOpts.DomainColor
            }
        },
        { // Node properties for parents (compound nodes)
            selector: ':parent',
            style: {
                'background-opacity': 0.4,
                'background-color': colorOpts.parentNodeBackgroundColor,
                'text-margin-y': 5,
                'border-width': 0,
                'shape' : 'round-rectangle',
            }
        },
        { // Collapsed nodes properties
            selector: "node.cy-expand-collapse-collapsed-node",
            style: {
                "background-color": colorOpts.ProteinColor,
                "shape": "round-triangle"
            }
        },
        { // Collapsed nodes properties
            selector: ".collapsed_node",
            style: {
                "background-color": colorOpts.ProteinColor,
                "shape": "round-triangle"
            }
        },
        { // Default edge properties for PPI
            selector: ".PPI_Edge",
            style: {
                'label': '',
                'curve-style': 'straight',
                'width': "mapData(weight, 0, 5, 1, 10)",
                'opacity': 0.4,
                'line-color': colorOpts.PPIColor
            }
        },
        { // Default edge properties for DDI
            selector: ".DDI_Edge",
            style: {
                'line-color': colorOpts.DDIColor
            }
        },
        {  // Edge properties for DDI in expand mode
            selector: ".DDI_Edge_active",
            style: {
                'opacity': 0.4
            }
        },
        { // Edge properties for DDI in collapse mode
            selector: ".DDI_Edge_inactive",
            style: {
                'opacity': 0 // Do not show DDI edge in the default collapsed mode
            }
        },
        { // Edge properties for both PPI and DDI while a connected node is selected
            selector: ".Edge_highlight",
            style: {
                'opacity': 1
            }
        }
    ]


    let styleSheetLegendChange = [
        {
            'selector': 'node',
            'label': 'data(label)', 
            'color': 'black',
            'text-valign': 'center',
            'text-halign': 'right',
            'text-margin-x': '1em',
        },
        {
            'selector': '.Domain_Node',
            'color': 'black'
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