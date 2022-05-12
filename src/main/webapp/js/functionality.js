import {makePlot} from './network_maker.js'
// TODO Disable form while task run
// TODO onbeforeunload

jQuery(document).ready(function() {
    // Test
    addNetworkExpressionSelection(2);
    // fetchResult(null,"protein_list", $('#NetworkSelection_Protein_List')[0], false); // Display the sample summary table


    /**
     * Set options to default
     */
    let set_default = function () {
        $('#remove_decay_transcripts').prop('checked', true)
        $('#threshold').val(1.0)
        $('#percentile').val(0.0)
    }
    set_default()

    /**
     * Make output_major_transcripts true when report_gene_abundance
     * @param source_
     * @param target_
     */
    let make_all_checked = function (source_, target_) {
        const parent = $('#' + source_)
        const children = $('#' + target_)
        if (parent.is(':checked') === true) {
            children.prop("checked", true)
        } else {
            children.prop("checked", false)
        }
    }
    $('#report_gene_abundance').on('click', function(){
        make_all_checked('report_gene_abundance','output_major_transcripts')
    })

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
    let no_expression_file = 0;
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
        showNoChosenFiles('protein_network_file', 1)
        // alert("Use user-uploaded network file.")
        protein_network_web.val("")
    })

    expression_file.on("change", function(){
        no_expression_file = this.files.length
        showNoChosenFiles('expression_file', no_expression_file)
    })
    function showNoChosenFiles(inputType, noFiles){
        $('#' + inputType + "_description").html(noFiles + " file(s) selected")
    }

    $("label[for='protein_network_web']").on("click", function(){
        $('#protein_network_web_popup').toggle()
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
    let SampleSummaryTable = $('#SampleSummaryTable')
    const NetworkSelection_Protein = $('#NetworkSelection_Protein');
    const NetworkSelection_Expression = $('#NetworkSelection_Expression');

    $.fn.submit_form = function(submit_type_){
        const form = $("form")[0];
        const data = new FormData(form);
        data.get('ExpOptions')
        data.append('submitType', submit_type_);

        // If threshold is chosen, do not send percentile value and vice versa
        if ($('#ExpressionLevelOption').val() === "threshold"){
            data.append('threshold', "-t=" + $('#threshold').val());
            data.append('percentile', "-tp=-1");
        }
        else {
            data.append('threshold', "-t=1.0");
            data.append('percentile', "-tp=" + $('#percentile').val());
        }

        // Reset display message (clear message from the previous run)
        $("#AfterRunOptions, #RightDisplay").css({'display': 'none'})
        runningProgressContent.html("")

        $.ajax({
            url: "PPIXpress",
            method: "POST",
            enctype: 'multipart/form-data',
            data: data,
            processData : false,
            contentType : false,
            success: function (resultText) {
                updateLongRunningStatus(resultText, 1000)
            },
            error: function (){
                alert("An error occurred, check console log!")
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
                        if (json.UPDATE_LONG_PROCESS_SIGNAL === true) {
                            clearInterval(interval)
                            allPanel.css({'cursor': 'default'})
                            loader.css({'display': 'none'})

                            addNetworkExpressionSelection(no_expression_file);
                            fetchResult(null,"sample_summary", SampleSummaryTable[0], false); // Display the sample summary table
                            fetchResult(null,"protein_list", $('#NetworkSelection_Protein_List')[0], false); // Display the sample summary table

                            $("#AfterRunOptions, #RightDisplay").css({'display': 'block'})
                            $("[name='ScrollToTop']").css({'display': 'block'})
                            $("form")[0].reset(); // Reset the form fields
                            $("[name='Reset']").click() // Set default settings for all option panels
                        }
                        runningProgressContent.html(json.UPDATE_LONG_PROCESS_MESSAGE)
                        leftDisplay[0].scrollTop = leftDisplay[0].scrollHeight
                    }
                }
            );
        }, updateInterval);
    }

    /**
     * Scroll to top of a div
     * */
    $("[name='ScrollToTop']").on('click', function(){
        $(this).parent()[0].scrollTop = 0
    })

    // Submit
    const NVContent = $('#NVContent');
    $('#RunNormal').on('click', function (){

        // Only submit form if user has chosen a protein network file/taxon for protein network retrieval
        // and at least 1 expression file
        if ((protein_network_web.val() === "" && protein_network_file.val() === "") || expression_file.val() === ""){
            alert('Missing input file(s). Please check if protein interaction data is uploaded/chosen and if expression data is uploaded.');
            return false;
        }
        loader.css({'display': 'block'});
        $.fn.submit_form("RunNormal")
        NVContent.removeClass("non-display")
        return false;
    })
    $('#RunExample').on('click', function (){
        loader.css({'display': 'block'});
        $.fn.submit_form("RunExample");
        NVContent.removeClass("non-display")
        return false;
    })

    // Show tab
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
    function fetchResult(pureText, resultFileType, target, downloadable){
        if (pureText !== null){
            let blob = new Blob([pureText])
            createDownloadLink(blob, target)
        }

        else {
            const downloadData = new FormData();
            downloadData.append("resultFileType", resultFileType)

            if (resultFileType === "graph"){
                downloadData.append("proteinQuery", NetworkSelection_Protein.val())
                downloadData.append("expressionQuery", NetworkSelection_Expression.val())
            }

            let fetchData = fetch("DownloadServlet",
                {
                    method: 'POST',
                    body: downloadData
                })

            // If downloadable is true, download file from fetched response under target as filename.
            // Applied for resultFileType of log, sample_summary, output
            if (downloadable)
                fetchData
                    .then(response => response.blob())
                    .then(blob => createDownloadLink(blob, target))

            // If downloadable is false, display the fetched response in target as container HTML element
            // Applied for resultFileType of graph, sample_summary
            else
                if (resultFileType === "graph"){
                    ProteinNetwork = makePlot(fetchData);
                }
                else if (resultFileType === "sample_summary"){
                    fetchData
                        .then(response => response.text())
                        .then(text => target.innerHTML = text)
                }
                else if (resultFileType === "protein_list"){
                    fetchData
                        .then(response => response.text())
                        .then(text => target.innerHTML = text)
                }
        }
    }

    $('#downloadLogFile').on("click", function(){
        const logContent = stripHTML(runningProgressContent)
        fetchResult(logContent, "log","PPIXpress_Log.txt", true);
    })

    $('#downloadSampleSummary').on("click", function(){
        const SampleSummary = stripHTML(SampleSummaryTable)
        fetchResult(SampleSummary,"sample_summary", "PPIXpress_SampleSummary.txt", true);
    })

    $('#downloadResultFiles').on("click", function(){
        fetchResult(null,"output", "PPIXPress_Output.zip", true);
    })

    // $('#toResultSummary').on("click", function (){
    //     $('#ResultSummary').trigger("click");
    // })

    $('#toNetworkVisualization').on("click", function (){
        $('#NetworkVisualization').trigger("click");
    })

    /*
        ===================================================================================================================
        ================================= Graph customization on Network Visualization tab ================================
        ===================================================================================================================
        */
    //Show Subnetworks
    let cyOpts = {animationDuration : 10}
    $('#ShowSubnetworks').on("click", function (){
        if (NetworkSelection_Protein.val() !== "") {
            // TODO: Add option to center/Download image
            fetchResult(null, "graph", null, false)
            ToggleExpandCollapse.val("collapseAll").change()

            ProteinNetwork
                .then(cy => {
                    cy.unbind("tap"); // unbind event to prevent possible mishaps with firing too many events
                    cy.$('node').bind('grab', function(node) { // bind with .bind() (synonym to .on() but more intuitive
                        var ele = node.target;
                        ele.addClass('Node_active');
                        ele.connectedEdges().addClass('Edge_highlight');
                    });
                    cy.$('node').bind('free', function(node) { // bind with .bind() (synonym to .on() but more intuitive
                        var ele = node.target;
                        ele.removeClass('Node_active');
                        ele.connectedEdges().removeClass('Edge_highlight')
                    });


                    cy.$('node').bind('tap', function(node) { // bind with .bind() (synonym to .on() but more intuitive
                        const api = cy.expandCollapse('get');
                        const ele = node.target;

                        let connectedEdges = ele.connectedEdges()
                        if (api.isExpandable(ele)) {
                            api.expand(ele, cyOpts)
                            for (let i = 0; i < connectedEdges.length; i++){
                                let child_edge = connectedEdges[i]
                                if (child_edge.hasClass('DDI_Edge')){
                                    child_edge.removeClass('DDI_Edge_inactive')
                                    child_edge.addClass('DDI_Edge_active')
                                }
                            }
                        }
                        else {
                            api.collapse(ele, cyOpts)
                            let connectedEdges = ele.connectedEdges()
                            for (let i = 0; i < connectedEdges.length; i++){
                                let child_edge = connectedEdges[i]
                                if (child_edge.hasClass('DDI_Edge')){
                                    child_edge.addClass('DDI_Edge_inactive')
                                    child_edge.removeClass('DDI_Edge_active')
                                }
                            }
                        }
                    });
                })
        }
        else
            alert("Please choose a protein!")
    })

    //TODO ProteinNetwork is currently on this page
    const ToggleExpandCollapse = $('#ToggleExpandCollapse')
    ToggleExpandCollapse.on('change', function(){
        if (ProteinNetwork !== null){
            ProteinNetwork
                .then(cy => {
                    const api = cy.expandCollapse('get');
                    if (ToggleExpandCollapse.val() === "expandAll"){
                        api.expandAll()
                        cy.$('.PPI_Edge').addClass('PPI_Edge_inactive')
                        cy.$('.DDI_Edge').addClass('DDI_Edge_active')
                        cy.$('.DDI_Edge').removeClass('DDI_Edge_inactive')
                    }
                    else {
                        api.collapseAll()
                        cy.$('.PPI_Edge').removeClass('PPI_Edge_inactive')
                        cy.$('.DDI_Edge').removeClass('DDI_Edge_active')
                        cy.$('.DDI_Edge').addClass('DDI_Edge_inactive')
                }
            })
        }
        else alert('Please first select a protein to display the subnetwork.')
    })
})


function stripHTML(HTMLElement){
    return HTMLElement.html().replace(/(<([^>]+)>)/gi, '\n').replace(/\n\s*\n/g, '\n');
}


/**
 * Add network showing options to NetworkSelection
 * based on the number of uploaded expression files
 * @param no_expression_file_ Number of expression file
 */
function addNetworkExpressionSelection(no_expression_file_){
    const NetworkSelection_Expression = document.getElementById('NetworkSelection_Expression');
    NetworkSelection_Expression.innerHTML = '';
    for (let i = 1; i <= no_expression_file_; i++){
        const opt = document.createElement('option');
        opt.value = i;
        opt.innerHTML = "Expression file " + i;
        NetworkSelection_Expression.appendChild(opt);
    }
}


