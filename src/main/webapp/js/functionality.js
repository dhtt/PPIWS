import {makePlot} from './network_maker.js'
import {showNoChosenFiles} from './functionality_helper_functions.js'
import {switchButton} from './functionality_helper_functions.js'
import {showWarningMessage} from './functionality_helper_functions.js'
import {generateRandomString} from './functionality_helper_functions.js'
import {stripHTML} from './functionality_helper_functions.js'
import {gridLayoutOptions} from '../resources/PPIXpress/graph_properties.js';
import {cosebilkentLayoutOptions} from '../resources/PPIXpress/graph_properties.js';
import {colorOpts} from '../resources/PPIXpress/graph_properties.js';
import {updateColorScheme} from './functionality_helper_functions.js';

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


    $("#NetworkSelection_Protein").select2({
        placeholder: $( this ).data( 'placeholder' )
    });

    /**
     * Makes all checkboxes in the target array checked or unchecked based on the state of the source checkbox.
     *
     * @param {string} source_ - The ID of the source checkbox.
     * @param {string[]} target_ - An array of IDs of the target checkboxes.
     */
    let make_all_checked = function (source_, target_) {
        const parent = $('#' + source_)
        for (let i = 0; i < target_.length; i++){
            let children = $('#' + target_[i])
            parent.is(':checked') === true ? children.prop("checked", true) : children.prop("checked", false)
        }
    }

    // Make output_major_transcripts true when report_gene_abundance
    $('#report_gene_abundance').on('click', function(){
        make_all_checked('report_gene_abundance',['output_major_transcripts'])
    })
    let PPICompareOptions = ['output_DDINs', 'output_major_transcripts']
    let usePPICompareOptions = $('#usePPICompareOptions')
    usePPICompareOptions.on('click', function(){
        make_all_checked('usePPICompareOptions', PPICompareOptions);
        if ($(this).is(':checked') === true){
            $("[name='usePPICompareOptionsTag']").show()
            $("label[for='usePPICompareOptions']").html("Remove PPICompare-required options")
        } else{
            $("[name='usePPICompareOptionsTag']").hide()
            $("label[for='usePPICompareOptions']").html("Include PPICompare-required options")
        }
    });
    

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
        placeholder.find("#threshold").val(1.00)
        placeholder.find("#percentile").val(0.00)
        placeholder.find("#protein_network_web").val("")
        placeholder.find("#remove_decay_transcripts").prop('checked', true)
    })

    /**
     * Show number of uploaded files
     */
    const protein_network_web = $('#protein_network_web');
    const protein_network_file = $('#protein_network_file')
    const expression_file = $('#expression_file')
    let NO_EXPRESSION_FILE = 0;
    let NAMES_EXPRESSION_FILE = []
    /**
     * Confirm the use of taxon for protein network retrieval. After confirming,
     * filepath for protein_network_file is set to empty string.
     */
    $('#protein_network_web_confirm').on("click", function (){
        $('#protein_network_file_description').html("Selected taxon: " +
            $(this).parent().children('.input').val())
        $(".popup").hide()
        // alert("Use retrieved protein network from database.")
        protein_network_file.val("")
    })
    /**
     * Use user-uploaded network file instead of retrieve by taxon. Upon being selected, taxon and
     * protein_network_web (if chosen) will be invalidated to empty string
     */
    protein_network_file.on("change", function(){
        showNoChosenFiles('protein_network_file', 1, 'show_no_files')
        // alert("Use user-uploaded network file.")
        protein_network_web.val("")
    })

    expression_file.on("change", function(){
        NO_EXPRESSION_FILE = this.files.length
        for (var i = 0; i < this.files.length; i++){
            NAMES_EXPRESSION_FILE.push(this.files.item(i).name)
        }
        console.log(NAMES_EXPRESSION_FILE);
        showNoChosenFiles('expression_file', NO_EXPRESSION_FILE, 'show_no_files')
    })

    $("label[for='protein_network_web']").on("click", function(){
        if (!protein_network_web.prop('disabled')){
            $('#protein_network_web_popup').toggle()
        }
    })


    //Close buttons
    $("[name='close']").on("click", function(){
        $(".popup").hide()
    })


    $('#ExpressionLevelOption').on("change", function (){
        $('label[for="threshold"]').toggle()
        $('#threshold').toggle()
        $('label[for="percentile"]').toggle()
        $('#percentile').toggle()
    })


    // Ajax Handler
    const allPanel = $('#AllPanels');
    const runningProgressContent = $('#RPContent');
    const loader = $('#Loader');
    const leftDisplay = $('#LeftDisplay');
    const LeftPanel = $('#LeftPanel')
    let SampleSummaryTable = $('#SampleSummaryTable')
    const NetworkSelection_Protein = $('#NetworkSelection_Protein');
    const NetworkSelection_Expression = $('#NetworkSelection_Expression');
    const ShowSubnetwork = $('#ShowSubnetwork')
    

    $.fn.submit_form = function(submit_type_){
        const form = $("form")[0];
        const data = new FormData(form);
        
        if (submit_type_ === "RunExample") { 
            USER_ID = "EXAMPLE_USER"; 
        } else { 
            USER_ID = window.sessionStorage.getItem('USER_ID');
        }
        data.append('USER_ID', USER_ID);
        data.append('ExpOptions', 'null')
        data.append('RunOptions', 'null')
        data.append('PPIOptions', 'null')
        
        data.get('ExpOptions')
        data.append('SUBMIT_TYPE', submit_type_);
        data.append('NO_EXPRESSION_FILE', NO_EXPRESSION_FILE);

        // If threshold is chosen, do not send percentile value and vice versa
        if ($('#ExpressionLevelOption').val() === "threshold"){
            data.append('threshold', "-t=" + $('#threshold').val());
            data.append('percentile', "-tp=-1");
        }
        else {
            data.append('threshold', "-t=1.0");
            data.append('percentile', "-tp=" + $('#percentile').val());
        }

        $.ajax({
            url: "PPIXpress",
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
                alert("An error occurred in PPIXpress Webserver, check console log!")
                console.log(e)
            }
        })
    }


    /**
     * Dynamically print PPIXpress progress run in PPIXpressServlet to RPContent
     * @param resultText Messages from PPIXpressServlet
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

                                $("#AfterRunOptions, #RightDisplay").show()
                                $("[name='ScrollToTop']").show()
                                switchButton(ShowSubnetwork, 'on', ['upload'], 'addClasses')
                                StarContents.css({'display': 'inline-block'});
    
                                // json.NO_EXPRESSION_FILE is retrieved from ProgressReporter.java
                                addNetworkExpressionSelection(NAMES_EXPRESSION_FILE, json.NO_EXPRESSION_FILE);
    
                                // Display the sample summary table and then protein list
                                // here a promise chain must be used because of concurrency/synchronous fetches
                                fetchResult(null, "sample_summary", SampleSummaryTable[0], false).then(
                                    response => {
                                        // Display the sample protein list
                                        return fetchResult(null, "protein_list", NetworkSelection_Protein[0], false) 
                                    }
                                ).catch(err => {
                                    console.log("An error occur while fetching sample_summary/protein_list.")
                                })               
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

    let showDDIs = false
    const NVContent_Graph = $('#NVContent_Graph')
    const NVContent = $('#NVContent');
    const NetworkOptions = $('#NetworkOptions')
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
        showDDIs = $('#output_DDINs').prop('checked')

        // Only submit form if user has chosen a protein network file/taxon for protein network retrieval
        // and at least 1 expression file
        if ((protein_network_web.val() === "" && protein_network_file.val() === "") || expression_file.val() === ""){
            alert('Missing input file(s). Please check if protein interaction data is uploaded/chosen and if expression data is uploaded.');
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

        // For example run, RunOptions are all checked
        $("input[name='RunOptions']").each(function () {
            $(this).prop('checked', true);
        });
        // showDDIs is the switch to enable expanding nodes for cytoscape. js. Without this, even when #output_DDINs is checked, 
        // cytoscape would not expand the nodes
        showDDIs = $('#output_DDINs').prop('checked')

        Submit.prop('disabled', true)
        loader.show()
        $.fn.submit_form("RunExample")
        resetInputFields(LeftPanel, true, runNewAnalysis_popup)
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
        switchButton(ApplyGraphStyle, 'off', ['upload'], 'removeClasses')
        Submit.prop('disabled', true)
        loader.show()

        //Fetch current process on the new tab
        updateLongRunningStatus("resultText", 1000)
    })


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
     * Set options to default
     */
    function set_default () {
        $('#remove_decay_transcripts').prop('checked', true)
        $('#threshold').val(1.0)
        $('#percentile').val(0.0)
    }
    set_default()

    /**
     * Reset all forms & clear all fields for new analysis
     */
    function resetForm(){
        $("form")[0].reset(); // Reset the form fields
        $("[name='Reset']").click() // Set default settings for all option panels
        $("[name='ScrollToTop']").hide()
    }

    /**
     * Reset display with old output
     */
    function resetDisplay(){
        // Reset display message (clear message from the previous run)
        $("#AfterRunOptions, #RightDisplay").css({'display': 'none'})
        runningProgressContent.html("")

        // Before resubmit, clear existing graphs and graph options
        NVContent_Graph.html('')
        NetworkSelection_Protein.val('')
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
     * Reset and enable/disable the modification of NetworkOptions
     * @param {*} option_ 'off' or 'on' 
      */
    function switchShowSubnetwork(option_){
        if (option_ === 'off'){
               // Disable buttons in Customize network display   
            switchButton(ShowSubnetwork, 'off', ['upload'], 'removeClasses')
            switchButton(ApplyGraphStyle, 'off', ['upload'], 'removeClasses')
            StarContents.hide()
            
            // In case changes have been made, reset all input fields and disable modification
            resetInputFields(NetworkOptions, true, null)
        } else if (option_ === 'on'){
            switchButton(ApplyGraphStyle, 'on', ['upload'], 'addClasses')

            // In case changes have been made, reset all input fields but keep them modifiable
            resetInputFields(NetworkOptions, false, null)
        }
    }

    runNewAnalysis.on('click', function (){
        resetForm()
        resetDisplay()
        switchShowSubnetwork('off')
        resetInputFields(LeftPanel, false, runNewAnalysis_popup)
        set_default()
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
    ============================ Actions after finishing PPIXPress on Running Progress tab ============================
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
    let WarningMessage_RunningProgressContent = $('#WarningMessage_RunningProgressContent')
    function fetchResult(pureText, resultFileType, target, downloadable){
        if (pureText !== null){
            let blob = new Blob([pureText])
            createDownloadLink(blob, target)

            return Promise.resolve()
        }

        else {
            const downloadData = new FormData();
            downloadData.append("USER_ID", USER_ID)
            downloadData.append("PROGRAM", "PPIXpress")
            downloadData.append("resultFileType", resultFileType)

            if (resultFileType === "graph"){
                downloadData.append("proteinQuery", NetworkSelection_Protein.val())
                downloadData.append("expressionQuery", NetworkSelection_Expression.val())
                downloadData.append("showDDIs", showDDIs)
            }
            
            let fetchData = fetch("DownloadServlet",
                {
                    method: 'POST',
                    body: downloadData
                })

            // If downloadable is true, download file from fetched response under target as filename.
            // Applied for resultFileType of log, sample_summary, output
            if (downloadable){
                if (resultFileType === "output"){
                    showWarningMessage(WarningMessage_RunningProgressContent,
                        "⏳ Please wait: Compressing files for download...",
                        null)
                    }
                fetchData
                    .then(response => response.blob())
                    .then(blob => createDownloadLink(blob, target))
                    .finally(() => {WarningMessage_RunningProgressContent.hide()})
                }

            // If downloadable is false, display the fetched response in target as container HTML element
            // Applied for resultFileType of graph, sample_summary
            else {
                   if (resultFileType === "graph"){
                    showWarningMessage(WarningMessage,
                        "⏳ Please wait: Loading subnetworks... (Large networks may take a long time to render)",
                        null)
                    ProteinNetwork = makePlot(fetchData, cosebilkentLayoutOptions, gridLayoutOptions);
                    ProteinNetwork
                        .then(cy => {
                            WarningMessage.hide();
                            return cy
                        })
                }
                else if (resultFileType === "sample_summary" | resultFileType === "protein_list"){
                    fetchData
                        .then(response => response.text())
                        .then(text => target.innerHTML = text)
                }
            }

            return fetchData
        }
    }

    $('#downloadLogFile').on("click", function(){
        const logContent = stripHTML(runningProgressContent)
        fetchResult(logContent, "log","LogFile.txt", true);
    })

    $('#downloadSampleSummary').on("click", function(){
        const SampleSummary = stripHTML(SampleSummaryTable)
        fetchResult(SampleSummary,"sample_summary", "SampleSummary.txt", true);
    })

    $('#downloadResultFiles').on("click", function(){
        fetchResult(null, "output", "ResultFiles.zip", true);
    })

    $('#DownloadSubnetwork').on("click", function(){
        let fileName = NetworkSelection_Protein.val() + "_" + NetworkSelection_Expression.val() + ".png"
        domtoimage
            .toBlob(document.getElementById('NVContent_Graph_with_Legend'), {quality: 1})
            .then(blob => window.saveAs(blob, fileName))
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

    ShowSubnetwork.on("click", function (){
        if (NetworkSelection_Protein.val() !== "") {
            fetchResult(null, "graph", null, false)
            switchShowSubnetwork('on')
            
            let ShowSubnetworkOption = {
                'expandCollapseOptions': cyOpts,
                'showDDIs': showDDIs
            }
            activateNetwork(ProteinNetwork, WarningMessage, ShowSubnetworkOption)
            NetworkOptions.find('select').prop('selectedIndex', 0).change()
            changeNodeSize.val(15).change()
        } else {
            alert("Please select a protein!")
        }
    })


    /****************************
     * **Graph customization ****
     * **************************/
    // Change graph layout
    let changeLayout = $('#changeLayout')
    changeLayout.on('change', function(){
        if (ProteinNetwork !== null){
            ProteinNetwork
                .then(cy => {
                    const newLayout = {
                        name: changeLayout.val(),
                        animate: true,
                        randomize: false,
                        fit: true
                    }
                    const api = cy.expandCollapse({
                        layoutBy: newLayout
                    })
                    cy.$('node').eq(0).trigger('tap')
                    return cy
                })
        }
    })


    // Change nodes size
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
                    })
                    .update()
                return cy
            })
        }
    })

    //Change nodes color
    const ProteinColor = $('#ProteinColor')[0]
    const DomainColor = $('#DomainColor')[0]
    const PPIColor = $('#PPIColor')[0]
    const DDIColor = $('#DDIColor')[0]
    $('#ApplyGraphColor').on('click', function(){
        if (ProteinNetwork !== null){
            ProteinNetwork
                .then(cy => {
                    cy.style()
                        .selector('node')
                        .style({
                            'background-color': ProteinColor.getAttribute('data-current-color'),
                            'color': ProteinColor.getAttribute('data-current-color')
                        })
                        .selector('.Domain_Node')
                        .style({
                            'background-color': DomainColor.getAttribute('data-current-color'),
                            'color': DomainColor.getAttribute('data-current-color')
                        })
                        .selector('.PPI_Edge')
                        .style({
                            'line-color': PPIColor.getAttribute('data-current-color')
                        })
                        .selector('.DDI_Edge')
                        .style({
                            'line-color': DDIColor.getAttribute('data-current-color')
                        })
                        .selector(':parent')
                        .style({
                            'background-color': colorOpts.parentNodeBackgroundColor,
                        })
                        .update()
                    return cy
                })
        }
       
        
        window.NVContent_Legend.style()
            .selector('node')
            .style({
                'background-color': ProteinColor.getAttribute('data-current-color'),
                'color': ProteinColor.getAttribute('data-current-color')
            })
            .selector('.Domain_Node')
            .style({
                'background-color': DomainColor.getAttribute('data-current-color'),
                'color': DomainColor.getAttribute('data-current-color')
            })
            .selector('.PPI_Edge')
            .style({
                'line-color': PPIColor.getAttribute('data-current-color')
            })
            .selector('.DDI_Edge')
            .style({
                'line-color': DDIColor.getAttribute('data-current-color')
            })
            .selector(':parent')
            .style({
                'background-color': colorOpts.parentNodeBackgroundColor,
            })
            .update()
    })


    //TODO ProteinNetwork is currently on this page
    const ToggleExpandCollapse = $('#ToggleExpandCollapse')
    ToggleExpandCollapse.on('click', function(){
        if (!showDDIs){
            showWarningMessage(WarningMessage,
                '⚠️ Protein nodes are not expandable because "Output DDINs" options was not selected.',
                3000)
        }
    })
    ToggleExpandCollapse.on('change', function(){
        if (ProteinNetwork !== null){
            ProteinNetwork
                .then(cy => {
                    // Toggle while keeping current layout
                    const newLayout = {
                        name: changeLayout.val(),
                        animate: true,
                        randomize: false,
                        fit: true
                    }
                    const api = cy.expandCollapse({layoutBy: newLayout});
                    if (ToggleExpandCollapse.val() === "expandAll"){
                        api.expandAll()
                        cy.$('.DDI_Edge').addClass('DDI_Edge_active')
                        cy.$('.DDI_Edge').removeClass('DDI_Edge_inactive')
                    }
                    else {
                        api.collapseAll()
                        cy.$('.DDI_Edge').removeClass('DDI_Edge_active')
                        cy.$('.DDI_Edge').addClass('DDI_Edge_inactive')
                    }
                    return cy
                })
        }
    })
})


function activateNetwork (graph, warning, ShowSubnetworkOption){
    let hasDDI = ShowSubnetworkOption['showDDIs']
    let options = ShowSubnetworkOption['options']

    if (graph !== null){
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
                    if (!hasDDI){
                        showWarningMessage(warning,
                            '⚠️ Protein nodes are not expandable because "Output DDINs" options was not selected.',
                            3000)
                    }

                    const api = cy.expandCollapse('get');
                    const ele = node.target;

                    let connectedEdges = ele.connectedEdges()
                    if (api.isExpandable(ele)) {
                        api.expand(ele, options)
                        for (let i = 0; i < connectedEdges.length; i++){
                            let child_edge = connectedEdges[i]
                            if (child_edge.hasClass('DDI_Edge')){
                                child_edge.removeClass('DDI_Edge_inactive')
                                child_edge.addClass('DDI_Edge_active')
                            }
                        }
                    }
                    else {
                        api.collapse(ele, options)
                        let connectedEdges = ele.connectedEdges()
                        for (let i = 0; i < connectedEdges.length; i++){
                            let child_edge = connectedEdges[i]
                            if (child_edge.hasClass('DDI_Edge')){
                                child_edge.addClass('DDI_Edge_inactive')
                                child_edge.removeClass('DDI_Edge_active')
                            }
                        }
                    }
                })
                return cy
            })
    }
 
}

/**
 * Add network showing options to NetworkSelection
 * based on the number of uploaded expression files
 * @param NO_EXPRESSION_FILE_ Number of expression file
 */
function addNetworkExpressionSelection(NAMES_EXPRESSION_FILE_, NO_EXPRESSION_FILE_){
    const NetworkSelection_Expression = document.getElementById('NetworkSelection_Expression');
    NetworkSelection_Expression.innerHTML = '';

    // In case of RunExample, the NAMES_EXPRESSION_FILE_ are not defined and NO_EXPRESSION_FILE_ is retrieved by PPIXpressServlet
    // In this case, the NAMES_EXPRESSION_FILE_ is generated from NO_EXPRESSION_FILE_
    if (NAMES_EXPRESSION_FILE_.length === 0 && NO_EXPRESSION_FILE_ !== 0){
        for (let i = 0; i < NO_EXPRESSION_FILE_; i++){
            NAMES_EXPRESSION_FILE_.push("expression_" + (i+1) + ".txt")
        }
    }

    for (let i = 0; i < NAMES_EXPRESSION_FILE_.length; i++){
        const opt = document.createElement('option');
        opt.value = i+1; // Because PPIXpress_Tomcat name the output files from 1, 2, 3...
        opt.innerHTML = NAMES_EXPRESSION_FILE_[i];
        NetworkSelection_Expression.appendChild(opt);
    }
}