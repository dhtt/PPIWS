import {makePlot} from './network_maker.js'

jQuery(document).ready(function() {
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
        placeholder.find('.description-text').html("&emsp;")

        // Specific settings for each datatype-panel
        placeholder.find("#threshold").val(1.00)
        placeholder.find("#percentile").val(0.00)
        placeholder.find("#protein_network_web").val("")
        placeholder.find("#remove_decay_transcripts").prop('checked', true)
    })

    /**
     * Show number of uploaded files
     */
    var protein_network_web = $('#protein_network_web')
    var protein_network_file = $('#protein_network_file')
    var expression_file = $('#expression_file')
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
                            $("#AfterRunOptions, #RightDisplay").css({'display': 'block'})
                            $("[name='ScrollToTop']").css({'display': 'block'})
                            makePlot("output/graph/exp_1.json", '#ff00ae', '#14cb9a')
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

        if ((protein_network_web.val() === "" && protein_network_file.val() === "") || expression_file.val() === ""){
            alert('Missing input file(s). Please check if protein interaction data is uploaded/chosen and if expression data is uploaded.');
            return false;
        }
        addNetworkSelection(no_expression_file);
        loader.css({'display': 'block'});
        $.fn.submit_form("RunNormal")
        NVContent.removeClass("non-display")
        return false;
    })
    $('#RunExample').on('click', function (){
        addNetworkSelection(no_expression_file);
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

    $("label").on("click", function (){
        var NetworkOptions = $('#' + $(this).attr('for'))
        if (NetworkOptions.attr("name") === "NetworkOptions")
            NetworkOptions.toggle()
    })


    // Actions after finishing PPIXPress
    function downloadResultFile(pathToFile, fileName, pureText){
        let blob = new Blob([pureText], { type: "text/plain" })
        if (pureText === "null") {
            $.ajax({
                type: "POST",
                url: pathToFile,
                dataType: "text",
                success: function(result) {
                    blob = new Blob([result], { type: "text/plain" })
                }
            })
        }
        let a = document.createElement('a');
        a.href = window.URL.createObjectURL(blob);
        a.download = fileName;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        window.URL.revokeObjectURL(a.href);
    }
    $('#downloadLogFile').on("click", function(){
        const logContent = stripHTML(runningProgressContent)
        // const logContent = runningProgressContent.html().replace(/(<([^>]+)>)/gi, '\n').replace(/\n\s*\n/g, '\n');
        downloadResultFile(null, "PPIXpress_Log.txt", logContent);
    })

    $('#downloadSampleSummary').on("click", function(){
        const SampleSummary = stripHTML($('#SampleSummaryTable'))
        downloadResultFile(null,
            "PPIXpress_SampleSummary.txt", SampleSummary);
    })

    $('#toResultSummary').on("click", function (){
        $('#ResultSummary').trigger("click");
    })

    $('#toNetworkVisualization').on("click", function (){
        $('#NetworkVisualization').trigger("click");
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
function addNetworkSelection(no_expression_file_){
    const NetworkSelection = document.getElementById('NetworkSelection');
    NetworkSelection.innerHTML = '';
    for (let i = 1; i <= no_expression_file_; i++){
        const opt = document.createElement('option');
        opt.value = "exp_" + i;
        opt.innerHTML = "Expression file " + i;
        NetworkSelection.appendChild(opt);
    }
}


