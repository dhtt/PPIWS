import {makePlot} from './network_maker_PPICompare.js'

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

/***
 * Define values for button holding CSS style before the document is ready
 * @type {{}}
 */
const CSS_Style = {};
$("[name='CSS_Style']").map(function(){
    const col = window.getComputedStyle(this, null).getPropertyValue("color"); // Get CS value of variable
    this.value = col // Set value of style to value of CSS variable
    CSS_Style[this.id] = col; // Return an JSON entry for variable with value as item
}).get()

jQuery(document).ready(function() {
    // // Test

    /**
     * Set options to default
     */
    let set_default = function () {
        $('#return_protein_attribute').prop('checked', true)
        $('#fdr').val(0.05)
    }
    set_default()


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
    const PPIXpress_network_1 = $('#PPIXpress_network_1');
    const PPIXpress_network_2 = $('#PPIXpress_network_2');
    let NO_PPIXpress_network_1 = 0;
    let NO_PPIXpress_network_2 = 0;
  
    // TODO: Shorten this script
    PPIXpress_network_1.on("change", function(){
        NO_PPIXpress_network_1 = this.files.length
        showNoChosenFiles('PPIXpress_network_1', NO_PPIXpress_network_1)
    })
    PPIXpress_network_2.on("change", function(){
        NO_PPIXpress_network_2 = this.files.length
        showNoChosenFiles('PPIXpress_network_2', NO_PPIXpress_network_2)
    })
    function showNoChosenFiles(inputType, noFiles){
        $('#' + inputType + "_description").html(noFiles + " file(s) selected")
    }


    // Ajax Handler
    const allPanel = $('#AllPanels');
    const runningProgressContent = $('#RPContent');
    const loader = $('#Loader');
    const leftDisplay = $('#LeftDisplay');
    const NetworkSelection_Protein = $('#NetworkSelection_Protein');

    $.fn.submit_form = function(submit_type_){
        const form = $("form")[0];
        const data = new FormData(form);
        data.append('SUBMIT_TYPE', submit_type_);

        data.append('fdr', "-fdr=" + $('#fdr').val());

        $.ajax({
            url: "PPICompare",
            method: "POST",
            enctype: 'multipart/form-data',
            data: data,
            processData : false,
            contentType : false,
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
     * Dynamically print PPIXpress progress run in PPIXpressServlet to RPContent
     * @param resultText Messages from PPIXpressServlet
     * @param updateInterval Update interval in millisecond
     */
    let updateLongRunningStatus = function (resultText, updateInterval) {
        const interval = setInterval(function (json) {
            $.ajax({
                type: "POST",
                url: 'ProgressReporter',
                cache: false,
                contentType: "application/json",
                dataType: "json",
                success: function (json) {
                    allPanel.css({'cursor': 'progress'})

                    // When new tab is open but no job is currently running for this user
                    // json.UPDATE_LONG_PROCESS_MESSAGE is retrieved from ProgressReporter.java
                    if (json.UPDATE_LONG_PROCESS_MESSAGE === ""){
                        // Stop updateLongRunningStatus & make allPanel cursor default
                        clearInterval(interval)
                        allPanel.css({'cursor': 'default'})
                        loader.css({'display': 'none'})
                        // Submit.prop('disabled', false)
                    }
                    // If job is running on one more or tabs, the main tab (or new tabs)
                    // will all be updated with the process
                    // json.UPDATE_LONG_PROCESS_SIGNAL is retrieved from ProgressReporter.java
                    else {
                        if (json.UPDATE_LONG_PROCESS_SIGNAL === true) {
                            // Stop updateLongRunningStatus & return to default setting
                            clearInterval(interval)
                            allPanel.css({'cursor': 'default'})
                            loader.css({'display': 'none'})
                            // Submit.prop('disabled', false)
                            $("#AfterRunOptions").css({'display': 'block'})
                            $("[name='ScrollToTop']").css({'display': 'block'})

                          }
                        runningProgressContent.html(json.UPDATE_LONG_PROCESS_MESSAGE)
                        leftDisplay[0].scrollTop = leftDisplay[0].scrollHeight
                    }
                },
                error: function(e){
                    alert("An error occurred in updateLongRunningStatus, check console log!")
                    console.log(e)
                }
                
            })
        }, updateInterval);
    }

    /***
     * Submit form and run analysis
     * @type {boolean}
     */
    const NVContent = $('#NVContent');
    let ApplyGraphStyle = $("[name='ApplyGraphStyle']")
    let Submit = $("[name='Submit']")
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
            alert('Missing input file(s). TODO');
            return false;
        }

        Submit.prop('disabled', true)
        loader.css({'display': 'block'})
        $.fn.submit_form("RunNormal")
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
        loader.css({'display': 'block'})
        $.fn.submit_form("RunExample")
        NVContent.removeClass("non-display")
        return false;
    })


    /***
     * Continue running progress when user open a new window
     */
    $('#already_open_window_switch').on('click', function(){
        already_open_window_popup.toggle()
        disabling_window.toggle()

        //Show current files and settings on the new tab
        disableButton(ApplyGraphStyle, ['upload'])
        Submit.prop('disabled', true)
        loader.css({'display': 'block'});

        //Fetch current process on the new tab
        updateLongRunningStatus("resultText", 1000)
    })


    /**
     * Scroll to top of a div
     * */
    $("[name='ScrollToTop']").on('click', function(){
        $(this).parent()[0].scrollTop = 0
    })


    /**
     * Reset all forms & clear all fields for new analysis
     */
    function resetForm(){
        $("form")[0].reset(); // Reset the form fields
        $("[name='Reset']").click() // Set default settings for all option panels
        $("[name='ScrollToTop']").css({'display': 'none'})
    }
    function resetDisplay(){
        // Reset display message (clear message from the previous run)
        $("#AfterRunOptions").css({'display': 'none'})
        runningProgressContent.html("")

        // Before resubmit, clear existing graphs and graph options
        $('#NVContent_Graph').html('')
        disableButton(ApplyGraphStyle, ['upload'])
        NetworkSelection_Protein.val('')
    }

    $('#runNewAnalysis').on('click', function (){
        resetForm()
        resetDisplay()
        Submit.prop('disabled', false)
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


    /* CONTINUE FROM HERE
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
    // Default colors for graphs
    let colorOpts = {
        'ProteinColor': CSS_Style['--protein'],
        'LostEdgeColor': CSS_Style['--lostedge'],
        'GainedEdgeColor': CSS_Style['--gainededge'],
        'nodeSize': 2,
        'opacity': 0.6
    }
    function fetchResult(pureText, resultFileType, target, downloadable){
        if (pureText !== null){
            let blob = new Blob([pureText])
            createDownloadLink(blob, target)
        }

        else {
            const downloadData = new FormData();
            downloadData.append("resultFileType", resultFileType)

            if (resultFileType === "graph"){
                // Do something
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
                        "⏳ Please wait: Loading subnetworks... (Large networks may take a long time to render)",
                        null)
                    ProteinNetwork = makePlot(fetchData, colorOpts);
                    ProteinNetwork
                        .then(cy => {
                            WarningMessage.css({'display': 'none'});
                            return cy
                        })
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

    $('#DownloadSubnetwork').on("click", function(){
        let fileName ="PPICompare_graph.png"
        ProteinNetwork
            .then(cy => {
                saveAs(cy.png(), fileName)
                return cy
            })
    })

    $('#toNetworkVisualization').on("click", function (){
        $('#NetworkVisualization').trigger("click");
    })
    // STOP FROM HERE

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

    $('#ShowSubnetwork').on("click", function (){
            fetchResult(null, "graph", null, false)
            enableButton(ApplyGraphStyle, ['upload'])
            activateNetwork(ProteinNetwork, WarningMessage)
            changeNodeSize.val(colorOpts.nodeSize).change()
      })


    /****************************
     * **Graph customization ****
     * **************************/
    // Change graph layout
    let changeLayout = $('#changeLayout')
    changeLayout.on('change', function(){
        ProteinNetwork
            .then(cy => {
                const newLayout = {
                    name: changeLayout.val(),
                    animate: true,
                    randomize: false,
                    fit: true
                }
                // TODO check expandCollpase api
                return cy
            })
    })


    // Change nodes size
    let changeNodeSize = $('#changeNodeSize')
    changeNodeSize.on('change', function(){
        let nodeSize = changeNodeSize.val()
        ProteinNetwork
            .then(cy => {
                cy.style()
                    .selector('node')
                    .style({
                        'height':  nodeSize,
                        'width': nodeSize,
                    })
                    .update()
                return cy
            })
    })

    //Change nodes color
    const ProteinColor = $('#ProteinColor')[0]
    const LostEdgeColor = $('#LostEdgeColor')[0]
    const GainedEdgeColor = $('#GainedEdgeColor')[0]
    $('#ApplyGraphColor').on('click', function(){
        var LostEdgeColor_updated = LostEdgeColor.getAttribute('data-current-color')
        var GainedEdgeColor_updated = GainedEdgeColor.getAttribute('data-current-color')
        var line_color = 'mapData(weight, 0, 1, ' + LostEdgeColor_updated + ', ' + GainedEdgeColor_updated + ')'

        ProteinNetwork
            .then(cy => {
                cy.style()
                    .selector('node')
                    .style({
                        'background-color': ProteinColor.getAttribute('data-current-color'),
                        'color': ProteinColor.getAttribute('data-current-color')
                    })
                    .selector('.PPI_Edge')
                    .style({
                        'line-color': line_color
                    })
                    .update()
                return cy
            })
    })
})


/***
 *
 * @param button_
 * @param classes_
 */
function enableButton(button_, classes_){
    if (button_.prop('disabled')){
        button_.prop('disabled', false)
        for (let i = 0; i < classes_.length; i++){
            button_.addClass(classes_[i])
        }
    }
}
function disableButton(button_, classes_){
    if (!button_.prop('disabled')){
        button_.prop('disabled', true)
        for (let i = 0; i < classes_.length; i++){
            button_.removeClass(classes_[i])
        }
    }
}
/***
 *
 * @param WarningMessage_
 * @param message_
 * @param timeout_
 */
function showWarningMessage(WarningMessage_, message_, timeout_){
    WarningMessage_.html(message_)
    WarningMessage_.css({'display': 'block'})
    if (timeout_ !== null)
        setTimeout(function(){
            WarningMessage_.css({'display': 'none'})
        }, timeout_)
}


function activateNetwork(graph, warning){
    graph
        .then(cy => {
            cy.unbind("grab"); // unbind event to prevent possible mishaps with firing too many events
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
/***
 *
 * @param HTMLElement
 * @returns {*}
 */
function stripHTML(HTMLElement){
    return HTMLElement.html().replace(/(<([^>]+)>)/gi, '\n').replace(/\n\s*\n/g, '\n');
}
