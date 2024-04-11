import {makePlot} from './network_maker_PPICompare.js'
import {showNoChosenFiles} from './functionality_helper_functions.js'
import {switchButton} from './functionality_helper_functions.js'
import {showWarningMessage} from './functionality_helper_functions.js'
import {generateRandomString} from './functionality_helper_functions.js'
import {stripHTML} from './functionality_helper_functions.js'
import {gridLayoutOptions} from '../resources/PPICompare/graph_properties.js';
import {cosebilkentLayoutOptions} from '../resources/PPICompare/graph_properties.js';
import {colorOpts} from '../resources/PPICompare/graph_properties.js';
import {updateColorScheme} from './functionality_helper_functions.js';
const legendData = './resources/PPICompare/legend.json'

// /***
//  * alert when new window is open
//  * @type {number}
//  */
// localStorage.openpages = Date.now();
// let already_open_window_popup = $('#already_open_window_popup')
// let disabling_window = $('#disabling_window')
// window.addEventListener('storage', function (e) {
//     if(e.key === "openpages") {
//         // Listen if anybody else is opening the same page!
//         localStorage.page_available = Date.now();
//     }
//     if(e.key === "page_available") {
//         already_open_window_popup.toggle()
//         disabling_window.toggle()
//     }
// }, false);

updateColorScheme('CSS_Style')
jQuery(document).ready(function() {
    let USER_ID = generateRandomString(12);
    window.sessionStorage.setItem('USER_ID', USER_ID);

    $("#NetworkSelection_HighlightProtein").select2({
        placeholder: $( this ).data( 'placeholder' ),
        minimumInputLength: 3,
        formatInputTooShort: "Please enter 3 or more characters. Only UniProt ID is accepted."
    });

    /**
     * Set options to default
     */
    let set_default = function () {
        $('#return_protein_attribute').prop('checked', true)
        $('#fdr').val(0.05)
    }
    set_default()

    // TODO might be integrated with reset fields below
    /**
     * Set checkboxes and input values to default
     */
    $("[name='Reset']").on('click', function(){
        const placeholder = $(this).closest(".menu");
        placeholder.find("input[type='checkbox']").prop('checked', false)
        placeholder.find('.hidden-checkbox').prop("checked", true)
        placeholder.find("input[type='file']").val("")
        placeholder.find('.description-text').html("&emsp;") // A space is needed so that there is an empty line

        // Specific settings for each datatype-panel
        placeholder.find("#fdr").val(0.05)
        placeholder.find("#return_protein_attribute").prop('checked', true)
    })

    /**
     * Show number of uploaded files
     */
    const PPIXpress_network = $("[name='PPIXpress_network']");
    const PPIXpress_network_1 = $('#PPIXpress_network_1');
    const PPIXpress_network_2 = $('#PPIXpress_network_2');
    let PPIXpress_network_name = "";
  
    PPIXpress_network.on("change", function(){
        PPIXpress_network_name = this.files.item(0).name
        let PPIXpress_network_id = this.id;
        showNoChosenFiles(PPIXpress_network_id, PPIXpress_network_name, 'show_name')
    })

    // Ajax Handler
    const allPanel = $('#AllPanels');
    const runningProgressContent = $('#RPContent');
    const loader = $('#Loader');
    const leftDisplay = $('#LeftDisplay');
    const LeftPanel = $('#LeftPanel')
    const NetworkSelection_HighlightProtein = $('#NetworkSelection_HighlightProtein');
    const NetworkSelection_UnhighlightProtein = $('#NetworkSelection_UnhighlightProtein')
    const NetworkSelection_HighlightProtein_All = $('#NetworkSelection_HighlightProtein_All')
    const ShowNetwork = $('#ShowNetwork')
    const NetworkSelection_HighlightProtein_Option =  $("[name='NetworkSelection_HighlightProtein_Option']")

    $.fn.submit_form = function(submit_type_){
        const form = $("form")[0];
        const data = new FormData(form);

        if (submit_type_ === "RunExample") { USER_ID = "EXAMPLE_USER"; }
        data.append('USER_ID', USER_ID);   
        data.append('SUBMIT_TYPE', submit_type_);
        data.append('fdr', "-fdr=" + $('#fdr').val());

        $.ajax({
            url: "PPICompare",
            method: "POST",
            enctype: 'multipart/form-data',
            data: data,
            processData : false,
            contentType : false,
            dataType: "json",
            success: function (resultText) {   
                updateLongRunningStatus(resultText, 1000)
            },
            error: function (e){
                alert("An error occurred in PPICompare Webserver, check console log!")
                console.log(e)
            }
        })
    }


    /**
     * Dynamically print PPICompare progress run in PPICompareServlet to RPContent
     * @param resultText Responses from PPICompareServlet
     * @param updateInterval Update interval in millisecond
     */
    let updateLongRunningStatus = function (res, updateInterval) {
        const interval = setInterval(function (json) {
            $.ajax({
                type: "POST",
                url: 'ProgressReporter',
                cache: false,
                dataType: "json",
                data: res,
                success: function (json) {
                    if (json.USER_ID === res.USER_ID){
                        allPanel.css({'cursor': 'progress'})
    
                        // When new tab is open but no job is currently running for this user
                        // json.UPDATE_LONG_PROCESS_MESSAGE is retrieved from ProgressReporter.java
                        if (json.UPDATE_LONG_PROCESS_MESSAGE === ""){
                            // Stop updateLongRunningStatus & make allPanel cursor default
                            clearInterval(interval)
                            allPanel.css({'cursor': 'default'})
                            loader.hide()
                            // Submit.prop('disabled', false)
                        }
                        // If job is running on one more or tabs, the main tab (or new tabs)
                        // will all be updated with the process
                        // json.UPDATE_LONG_PROCESS_STOP_SIGNAL is retrieved from ProgressReporter.java
                        else {
                            if (Boolean(json.UPDATE_LONG_PROCESS_STOP_SIGNAL) === true) {
                                // Stop updateLongRunningStatus & return to default setting
                                clearInterval(interval)
                                allPanel.css({'cursor': 'default'})
                                loader.hide() 

                                $("#AfterRunOptions").show()
                                $("[name='ScrollToTop']").show()
    
                                // Display the sample protein list 
                                fetchResult(null, "protein_list", NetworkSelection_HighlightProtein[0], false); 
                            }
                            
                            // Update running progress to runningProgressContent
                            runningProgressContent.html(json.UPDATE_LONG_PROCESS_MESSAGE)
                            leftDisplay[0].scrollTop = leftDisplay[0].scrollHeight
                        }
                        res = json
                    } 
                },
                error: function(e){
                    alert("An error occurred in updateLongRunningStatus, check console log!")
                    console.log(e)
                }
            })
        }, updateInterval);
    }

    const NVContent_Graph = $('#NVContent_Graph')
    const CustomizeNetworkOptions = $('#CustomizeNetworkOptions')
    const ShowNetworkMain = $('#ShowNetworkMain')
    const NVContent = $('#NVContent');
    let ApplyGraphStyle = $("[name='ApplyGraphStyle']")
    let StarContents = $("[name='Star'")
    let Submit = $("[name='Submit']")
    let runNewAnalysis = $('#runNewAnalysis')
    let runNewAnalysis_popup = $('#runNewAnalysis_popup')

    /***
     * Submit form and run analysis
     * @type {boolean}
     */
    $('#RunNormal').on('click', function (){
        // Reset displayed result from previous run
        resetDisplay()

        // showDDIs is the switch to enable expanding nodes for cytoscape. js. Without this, even when #output_DDINs is checked, 
        // cytoscape would not expand the nodes
        // showDDIs = $('#output_DDINs').prop('checked') 
        // TODO: Check showDDIs

        // Only submit form if user has chosen a protein network file/taxon for protein network retrieval
        // and at least 1 expression file
        if (PPIXpress_network_1.val() === "" || PPIXpress_network_2.val() === ""){
            alert('Missing input file(s)');
            return false;
        }
        if (PPIXpress_network_1.val() === PPIXpress_network_2.val()){
            alert('Please select two different files for comparison.');
            return false;
        }

        Submit.prop('disabled', true)
        loader.show()
        $.fn.submit_form("RunNormal")
        resetInputFields(LeftPanel, true, runNewAnalysis_popup)
        NVContent.removeClass("non-display")
        return false;
    })
    $('#RunExample').on('click', function (){
        // Reset displayed result from previous run
        resetDisplay()

        // showDDIs is the switch to enable expanding nodes for cytoscape. js. Without this, even when #output_DDINs is checked, 
        // cytoscape would not expand the nodes
        // showDDIs = $('#output_DDINs').prop('checked')
        // TODO: Check showDDIs


        Submit.prop('disabled', true)
        loader.show()
        $.fn.submit_form("RunExample")
        resetInputFields(LeftPanel, true, runNewAnalysis_popup)
        NVContent.removeClass("non-display")
        return false;
    })


    // /***
    //  * Continue running progress when user open a new window
    //  */
    // $('#already_open_window_switch').on('click', function(){
    //     already_open_window_popup.toggle()
    //     disabling_window.toggle()

    //     //Show current files and settings on the new tab
    //     switchButton(ApplyGraphStyle, 'off', ['upload'], 'removeClasses')
    //     Submit.prop('disabled', true)
    //     loader.hide()

    //     //Fetch current process on the new tab
    //     updateLongRunningStatus("resultText", 1000)
    // })


    /**
     * Scroll to top of a div
     * */
    $("[name='ScrollToTop']").on('click', function(){
        $(this).parent()[0].scrollTop = 0
    })

    /* 
    ===================================================================================================================
    ================================================= Reset functions =================================================
    ===================================================================================================================
    */
    /**
     * Reset all forms & clear all fields for new analysis
     */
    function resetForm(){
        $("form")[0].reset(); // Reset the form fields
        $("[name='Reset']").click() // Set default settings for all option panels
        $("[name='ScrollToTop']").hide()
    }

    function resetShowSubnetwork(){
        NetworkSelection_UnhighlightProtein.prop('checked', true)
        NetworkSelection_UnhighlightProtein.change()
    }

    /**
     * Reset display with old output
     */
    function resetDisplay(){
        // Reset display message (clear message from the previous run)
        $("#AfterRunOptions").hide()
        runningProgressContent.html("")

        // Before resubmit, clear existing graphs and graph options
        NVContent_Graph.html('')
        NetworkSelection_HighlightProtein.val('')
        NetworkSelection_HighlightProtein.empty()
        resetShowSubnetwork()
        ShowSubnetwork.hide()
        NetworkSelection_HighlightProtein_All.parent('label').show()
    }

    /**
     * In case changes have been made, reset all input fields. 'checkbox' and 'radio' are unchecked. 
     * 'select-one' is reset to first option 
     * @param {*} field_ div containing input fields to reset
     * @param {*} disable_ where input fields should be disabled after reset
     * @param {*} popup_ a popup window showing warnings/messages if field_ is clicked
     */
    function resetInputFields(field_, disable_, popup_){
        field_.find(':input').each(function(){
            let type = this.type
            if ($(this).prop('checked')){
                $(this).prop('checked', false)
            }
        
            if (type === 'select-one'){
                $(this).prop("selectedIndex", 0);
                $(this).change()
            }

            (disable_ === true) ? $(this).prop('disabled', true) : $(this).prop('disabled', false)
        })

        if (popup_ !== null) {
            if (disable_ === true){  
                field_.on("click", function(){ popup_.show()})
            } else {
                field_.off("click")
                popup_.hide()
            }
        }
    }

    /**
     * Reset and enable/disable the modification of CustomizeNetworkOptions
     * @param {*} option_ 'off' or 'on' 
      */
    function switchShowNetwork(option_){
        if (option_ === 'on'){
            switchButton(ApplyGraphStyle, 'on', ['upload'], 'addClasses')
            NetworkSelection_HighlightProtein_Option.each(function(){
                switchButton($(this), 'on', [''], 'addClasses')
                $(this).parent('label').removeClass('disabled')
            })

            // In case changes have been made, reset all input fields but keep them modifiable
            resetInputFields(CustomizeNetworkOptions, false, null)
        } else if (option_ === 'off'){
               // Disable buttons in Customize network display   
            switchButton(ShowNetwork, 'off', ['upload'], 'removeClasses')
            switchButton(ShowSubnetwork, 'off', ['upload'], 'removeClasses')
            switchButton(ApplyGraphStyle, 'off', ['upload'], 'removeClasses')
            StarContents.hide()
            
            NetworkSelection_HighlightProtein_Option.each(function(){
                switchButton($(this), 'off', [''], 'removeClasses')
                $(this).parent('label').addClass('disabled')
            })

            // In case changes have been made, reset all input fields and disable modification
            resetInputFields(CustomizeNetworkOptions, true, null)
        } 
    }

    runNewAnalysis.on('click', function (){
        resetForm()
        resetDisplay()
        switchShowNetwork('off')
        resetInputFields(LeftPanel, false, runNewAnalysis_popup)
        Submit.prop('disabled', false)
    })

    $('#runNewAnalysis_yes').on('click', function(){
        runNewAnalysis.trigger('click')
        runNewAnalysis_popup.hide()
    })
    $('#runNewAnalysis_no').on('click', function(){
        runNewAnalysis_popup.hide()
    })

    /***
     * Switch and highlight tabs
     */
    $("[name='DisplayTab']").on('click', function(){
        const tabName = $(this).val()
        $("[name='Display']").addClass("non-display")
        $('#' + tabName + "Content").removeClass("non-display")

        $("[name='DisplayTab']").removeClass("tab-active")
        $(this).addClass("tab-active")
    })


    $("#ShowNetworkOptions").on("click", function (){
        $("[name='NetworkOptions']").toggle()
    })


    /* 
    ===================================================================================================================
    ============================ Actions after finishing PPICompare on Running Progress tab ============================
    ===================================================================================================================
    */
    /**
     * Create a download link from a blob and delete it after click
     * @param Blob_ a blob
     * @param fileName_ name of downloaded file
     */
    function createDownloadLink(Blob_, fileName_){
        let a = document.createElement('a');
        a.href = window.URL.createObjectURL(Blob_);
        a.download = fileName_;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(a.href);
    }

    /**
     * Trigger downloading a file when click download button. if pureText is null, use a path to file, else let user
     * download pure text. Downloadable can be switched to false in order to fetch result files from local storage to
     * target HTML element
     * @param pureText Pure HTML/plain text to download as file
     * @param resultFileType Type of result to be downloaded. Options include "log", "output", "sample"
     * @param target Name of downloaded file or HTML element that will carry the resulted text
     * @param downloadable true or false
     */
    let ProteinNetwork = null;
    // Default layouts and colors for graphs & legend
 
    
    function fetchResult(pureText, resultFileType, target, downloadable){
        if (pureText !== null){
            let blob = new Blob([pureText])
            createDownloadLink(blob, target)
        }

        else {
            const downloadData = new FormData();
            downloadData.append("USER_ID", USER_ID)
            downloadData.append("PROGRAM", "PPICompare")
            downloadData.append("resultFileType", resultFileType)

            if (resultFileType === "subgraph"){
                downloadData.append("proteinQuery", NetworkSelection_HighlightProtein.val())
            }

            let fetchData = fetch("DownloadServlet",
                {
                    method: 'POST',
                    body: downloadData
                })

            // If downloadable is true, download file from fetched response under target as filename.
            // Applied for resultFileType of log, output
            if (downloadable) {
                fetchData
                    .then(response => response.blob())
                    .then(blob => createDownloadLink(blob, target))
            }

            // If downloadable is false, display the fetched response in target as container HTML element
            // Applied for resultFileType of graph
            else {
                if (resultFileType === "graph"){
                    showWarningMessage(WarningMessage,
                        "⏳ Please wait: Loading differential network... (Large networks may take a long time to render)",
                        null)
                    ProteinNetwork = makePlot(fetchData, cosebilkentLayoutOptions, gridLayoutOptions);
                    ProteinNetwork
                        .then(cy => {
                            WarningMessage.hide()
                            return cy
                        })
                } else if (resultFileType === "subgraph"){
                    showWarningMessage(WarningMessage,
                        "⏳ Please wait: Loading differential subnetworks... (Large networks may take a long time to render)",
                        null)
                    ProteinNetwork = makePlot(fetchData, cosebilkentLayoutOptions, gridLayoutOptions);
                    ProteinNetwork
                        .then(cy => {
                            WarningMessage.hide()
                            return cy
                        })
                }
                else if (resultFileType === "protein_list"){
                    fetchData
                        .then(response => response.text())
                        .then(text =>{
                            let proteinList = text.split("n_nodes=")
                            target.innerHTML = proteinList[0] // Display protein list

                            let n_nodes = proteinList[1] // Get number of proteins
                            if (n_nodes >= 200){
                                showWarningMessage(WarningMessage,
                                    "❗️ Number of proteins in differential network exceeds 200. To visualize the full network, please download the network and visualize it in Cytoscape. To visualize a subnetwork, please select a protein from the list.",
                                    null)

                                switchButton(ShowSubnetwork, 'on', ['upload'], 'addClasses')
                                ShowSubnetwork.show()
                                NetworkSelection_HighlightProtein_All.parent('label').hide()
                            } else {
                                switchButton(ShowNetwork, 'on', ['upload'], 'addClasses')
                                ShowSubnetwork.hide()
                                NetworkSelection_HighlightProtein_All.parent('label').show()
                            }
                        })
                    console.log(target);
                    
                }
            }
                
        }
    }
    $('#downloadLogFile').on("click", function(){
        const logContent = stripHTML(runningProgressContent)
        fetchResult(logContent, "log", "LogFile.txt", true);
    })

    $('#downloadResultFiles').on("click", function(){
        fetchResult(null,"output", "ResultFiles.zip", true);
    })

    $('#DownloadNetwork').on("click", function(){
        domtoimage
            .toBlob(document.getElementById('NVContent_Graph_with_Legend'), {quality: 1})
            .then(blob => window.saveAs(blob, "PPICompareDifferentialNetwork.png"))
    })

    $('#toNetworkVisualization').on("click", function (){
        $('#NetworkVisualization').trigger("click");
    })

    /*
        ===================================================================================================================
        ================================= Graph customization on Network Visualization tab ================================
        ===================================================================================================================
        */
    //Show Subnetworks
    let WarningMessage = $('#WarningMessage')
    let cyOpts = {
        animate: false
    }

    ShowNetwork.on("click", function (){
        // Fetch graph data, enable buttons in Customize network display   
        fetchResult(null, "graph", null, false)
        switchShowNetwork('on')
        
        // Reset NetworkSelection_HighlightProtein
        resetShowSubnetwork()

        activateNetwork(ProteinNetwork, WarningMessage)
        changeNodeSize.val(colorOpts.nodeSize).change()
    }) 

    const ShowSubnetwork = $('#ShowSubnetwork')
    ShowSubnetwork.on("click", function (){
        // Fetch graph data, enable buttons in Customize network display   
        fetchResult(null, "subgraph", null, false)
        switchButton(ApplyGraphStyle, 'on', ['upload'], 'addClasses')
        resetInputFields(CustomizeNetworkOptions, false, null)

        activateNetwork(ProteinNetwork, WarningMessage)
        changeNodeSize.val(colorOpts.nodeSize).change()
  })


    
     

    /****************************
     * **Graph customization ****
     * **************************/

    // Change Protein ID
    const ToggleProteinID = $('#ToggleProteinID')
    ToggleProteinID.on('change', function(){  
        let ProteinIDType = ToggleProteinID.val()
        if (ProteinNetwork !== null){
            ProteinNetwork
                .then(cy => {
                    cy.style()
                    .selector('node')
                    .style({
                        'label': ProteinIDType === "UniProtID" ? 'data(id)' :  'data(label)',     
                    })
                    .update()
                    return cy
                })
        }
    }) 


    // Change Node size
    let changeNodeSize = $('#changeNodeSize')
    changeNodeSize.on('change', function(){
        let nodeSize = changeNodeSize.val()

        if (ProteinNetwork !== null){
            ProteinNetwork
                .then(cy => {
                    cy.style()
                        .selector('node')
                        .style({
                            'height':  nodeSize,
                            'width': nodeSize,
                            'font-size': 15
                        })
                        .update()
                })
        }
      
        $('#ToggleRelativeImportance').prop('checked', false)
    })


    $('.toggle_input').on('change', function(){
        let ID = this.id;
        let checked = $(this).prop('checked');
        
        if (ID !== 'ToggleRelativeImportance'){
            let nodeFilter = ''
            let nodeClass = ''

            if (ID === 'ToggleTranscriptomicAlteration'){
                nodeFilter = '[alterationType="DE"]'
                nodeClass = 'Node_transcriptomicAlteration'
            } else if (ID === 'ToggleMinReasons'){
                nodeFilter = '[partOfMinReasons="yes"]'
                nodeClass = 'Node_partOfMinReasons'
            }

            if (checked){
                ProteinNetwork.then(cy => {cy.nodes(nodeFilter).addClass(nodeClass)})
                modifyCyElements(window.NVContent_Legend, ID, legendData, 'add', 'grid')
            } else {
                ProteinNetwork.then(cy => {cy.nodes(nodeFilter).removeClass(nodeClass)})
                modifyCyElements(window.NVContent_Legend, ID, legendData, 'remove', 'grid')
            }
        } else {
            if (checked){
                ProteinNetwork.then(cy => {
                    cy.style()
                    .selector('node')
                    .style({
                        'height': 'mapData(score, 50, 500, 1, 100)',
                        'width': 'mapData(score, 50, 500, 1, 100)',
                        'font-size': 'mapData(score, 50, 500, 15, 30)',
                    })
                    .update()
                    rearrange(cy, "cose-bilkent")
                })
            } else {
                changeNodeSize.trigger('change')
            }
        }
       
    })

    // View a single protein
    let unhighlightProtein = function(){
        if (ProteinNetwork !== null){
            ProteinNetwork
                .then(cy => {
                    cy.nodes().removeClass('Node_highlight');
                    cy.nodes().removeClass('Node_hidden');
                })
        }
    }
    let highlightPPIN = function(proteinName){
        ProteinNetwork
            .then(cy => {
                const ele = cy.$('#' + proteinName)
                ele.addClass('Node_highlight');
                ele.neighborhood().addClass('Node_highlight')
            })
    }

    NetworkSelection_HighlightProtein.on('change', function(){
        resetShowSubnetwork()
        NetworkSelection_HighlightProtein_All.trigger('click')
    })

    NetworkSelection_HighlightProtein_Option.on('change', function(){
        NetworkSelection_HighlightProtein_Option.each(function(){
            if ($(this).prop('checked')){
                let option = $(this).val()
                console.log(option);

                if (option === 'all' | option === 'focus'){
                    $(this).parent('label').addClass("button-active") // Only show Highlight/Focus button if selected, not Reset
                    unhighlightProtein()
                    highlightPPIN(NetworkSelection_HighlightProtein.val())
                    if (option === 'focus'){
                        ProteinNetwork
                            .then(cy => {
                                const hidden_eles = cy.$('*').not(cy.$('.Node_highlight'))
                                hidden_eles.addClass('Node_hidden');
                            })
                    }
                } else {
                    unhighlightProtein()
                }
            }
            else {
                $(this).parent('label').removeClass('button-active')
            }
        })
        
    })


    // Customize colors
    // Background color
    const ToggleBackgroundColor = $('#ToggleBackgroundColor')
    ToggleBackgroundColor.on('change', function(){  
        let BackgroundColor = ToggleBackgroundColor.val()
        NVContent_Graph.css({'background': BackgroundColor})
    }) 

    // Node/edge color
    const ProteinColor = $('#ProteinColor')[0]
    const LostEdgeColor = $('#LostEdgeColor')[0]
    const GainedEdgeColor = $('#GainedEdgeColor')[0]
    const HighlightedProteinColor = $('#HighlightedProteinColor')[0]
    let ApplyGraphColor = $('#ApplyGraphColor') 
    ApplyGraphColor.on('click', function(){
        var LostEdgeColor_updated = LostEdgeColor.getAttribute('data-current-color')
        var GainedEdgeColor_updated = GainedEdgeColor.getAttribute('data-current-color')
        var ProteinColor_updated = ProteinColor.getAttribute('data-current-color')
        var HighlightedProteinColor_updated = HighlightedProteinColor.getAttribute('data-current-color')
        var line_color = 'mapData(weight, 0, 1, ' + LostEdgeColor_updated + ', ' + GainedEdgeColor_updated + ')'


        if (ProteinNetwork !== null){
            ProteinNetwork
                .then(cy => {
                    cy.style()
                        .selector('node')
                        .style({
                            'background-color': ProteinColor_updated,
                            'color': ProteinColor_updated
                        })
                        .selector('.PPI_Edge')
                        .style({
                            'line-color': line_color
                        })
                        .selector('.Node_highlight')
                        .style({
                            'background-color': HighlightedProteinColor_updated,
                            'color': HighlightedProteinColor_updated,
                        })
                        .update()
                    return cy
                })
        }
      
        window.NVContent_Legend.style()
                    .selector('node')
                    .style({
                        'background-color': ProteinColor_updated
                    })
                    .selector('.PPI_Edge')
                    .style({
                        'line-color': line_color
                    })
                    .selector('.Node_highlight')
                    .style({
                        'background-color': HighlightedProteinColor_updated,
                        'color': HighlightedProteinColor_updated,
                    })
                    .update()
        
    })
})


/***
 *
 * @param cy_ Cytoscape graph container
 * @param type_ 'default', 'ToggleTranscriptomicAlteration' or 'ToggleMinReasons' options in json file containing legend info\
 * @param jsonPath_ relative path from jsp (!important) to json file containing legend info 
 * @param option_ 'add' or 'remove' nodes
 * @param layoutOptions_ layout for the graph update
 */
function modifyCyElements(cy_, type_, jsonPath_, option_, layoutOptions_) {
    if (option_ === 'add'){
        fetch(jsonPath_)
            .then(res => res.json())
            .then(res => res.filter((node) => node.data.type === type_))
            .then(nodes => {
                cy_.add(nodes)
                rearrange(cy_, layoutOptions_)
            })
    } else if (option_ === 'remove'){
        cy_.remove(cy_.nodes('[type="' + type_ + '"]'))
        rearrange(cy_, layoutOptions_)
    }
}

/***
 *
 * @param cy_
 * @param layoutName_
 */
function rearrange(cy_, layoutName_) {
    if (layoutName_ === "cose-bilkent"){
        cy_.layout(cosebilkentLayoutOptions).run()
    } else if (layoutName_ === "grid"){
        cy_.nodes().layout(gridLayoutOptions).run()
    }
    return cy_
}


function activateNetwork(graph, warning){
    if (graph !== null){
        graph
        .then(cy => {
            cy.$('node').bind('grab', function(node) { // bind with .bind() (synonym to .on() but more intuitive
                const ele = node.target;
                ele.addClass('Node_active');
                ele.connectedEdges().addClass('Edge_highlight');
            });

            cy.$('node').bind('free', function(node) { // bind with .bind() (synonym to .on() but more intuitive
                const ele = node.target;
                ele.removeClass('Node_active');
                ele.connectedEdges().removeClass('Edge_highlight')
            });

            cy.unbind("tap"); // unbind event to prevent possible mishaps with firing too many events
            cy.$('node').bind('tap', function(node) { // bind with .bind() (synonym to .on() but more intuitive
                const ele = node.target;
            })
            return cy
        })
    }
}