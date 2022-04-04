// TODO: Show ResultSummary + NetworkVisualization only after Running Progress is done
import {makePlot} from './network_maker.js'
// makePlot = require('network_maker');

jQuery(document).ready(function() {
    /**
     * Set options to default
     */
    let set_default = function () {
        $('#remove_decay_transcripts').prop('checked', true)
        $('#threshold').val(1.0)
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
     * Make none of the options checked
     * @param name
     */
    let make_none_checked = function (name) {
        $('[name="' + name + '"]').prop('checked', false)
    }
    $('.reset').on('click', function(){
        const name = $(this).attr('id').split('Reset').join("");
        make_none_checked(name)
        set_default()
    })

    // Show number of uploaded files
    let no_expression_file = 0;
    $('#protein_network_file').on("change", function(){
        $('#protein_network_file_lab').html("Change file")
        $('#protein_network_description').html("Protein interaction data: " + this.files.length + " file(s) selected")
    })
    $('#expression_file').on("change", function(){
        no_expression_file = this.files.length
        $('#expression_file_lab').html("Change file(s)")
        $('#expression_description').html("Expression data: " + this.files.length + " file(s) selected")
    })

    // Ajax Handler
    const allPanel = $('#AllPanels');
    const runningProgressContent = $('#RPContent');
    const afterRunOptions = $('#AfterRunOptions');
    const loader = $('#Loader');
    const leftDisplay = $('#LeftDisplay');
    const ScrollTop_LeftDisplay = $('#ScrollTop_LeftDisplay');
    $.fn.submit_form = function(submit_type_){
        const form = $("form")[0];
        const data = new FormData(form);
        data.get('ExpOptions')
        data.append('submitType', submit_type_);
        data.append('threshold', "-t=" + $('#threshold').val());
        // TODO: Add percentile adjustment
        // data.append('percentile', "-tp=" + $('#percentile').val());
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
                alert("An error occurred, checked console log!")
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
                            afterRunOptions.css({'display': 'block'})
                            ScrollTop_LeftDisplay.css({'display': 'block'})
                            $('#RightDisplay').css({'display': 'block'})
                            makePlot("output/graph/exp_1.json")
                        }
                        runningProgressContent.html(
                            json.UPDATE_STATIC_PROGRESS_MESSAGE +
                            json.UPDATE_LONG_PROCESS_MESSAGE
                        )
                        leftDisplay[0].scrollTop = leftDisplay[0].scrollHeight
                    }
                }
            );
        }, updateInterval);
    }

    // Scroll to top
    ScrollTop_LeftDisplay.on('click', function(){
        scrollToTop(leftDisplay)
    })
    $('#ScrollTop_RightDisplay').on('click', function(){
        scrollToTop($('#RightDisplay'))
    })

    // Submit
    $('#RunNormal').on('click', function (){
        $.fn.submit_form("RunNormal")
        return false;
    })
    $('#RunExample').on('click', function (){
        addNetworkSelection(no_expression_file);
        loader.css({'display': 'block'});
        $.fn.submit_form("RunExample");
        return false;
    })

    // Show tab
    $("[name='DisplayTab']").on('click', function(){
        const tabName = $(this).val()
        $("[name='Display']").addClass("non-display")
        $('#' + tabName + "Content").removeClass("non-display")

        $("[name='DisplayTab']").removeClass("active")
        $(tabName).addClass("active")
    })

    // $('#RunningProgress').on('click', function(){
    //     $("[name='Display']").addClass("non-display")
    //     $('#RunningProgressContent').removeClass("non-display")
    // })
    // $('#NetworkVisualization').on('click', function(){
    //     $("[name='Display']").addClass("non-display")
    //     $('#NetworkVisualizationContent').removeClass("non-display")
    // })
})
// function toggleDisplay(contentDiv){
//     $("[name='Display']").addClass("non-display")
//
//     $( + "Content").removeClass("non-display")
// }

/**
 * Toggle tab active and display
 * @param name
 * @param displayTabs
 * @param chosenTab
 * @param chosenTab_contents
 */
function toggle_tab(name, displayTabs, chosenTab, chosenTab_contents){
    for (let i=0; i < displayTabs.length; i++){
        // Set tab as active
        displayTabs[i].classList.remove("active")

        // Show content for tab
        if (chosenTab_contents[i].getAttribute('name') !== name){
            chosenTab_contents[i].classList.add("non-display")
        }
        else {
            chosenTab_contents[i].classList.remove("non-display")
        }
    }
    chosenTab.classList.add("active")
}

function getContent(name){
    let displayTabs, chosenTab, chosenTab_contents;
    displayTabs = document.getElementsByClassName("button-tab");
    chosenTab = document.getElementById(name);
    chosenTab_contents = document.getElementsByClassName("display-content");
    toggle_tab(name, displayTabs, chosenTab, chosenTab_contents);
}
/**
 * Add network showing options to NetworkSelection
 * based on the number of uploaded expression files
 * @param no_expression_file_ Number of expression file
 */
function addNetworkSelection(no_expression_file_){
    const NetworkSelection = document.getElementById('NetworkSelection');
    for (let i = 1; i <= no_expression_file_; i++){
        const opt = document.createElement('option');
        opt.value = "exp_" + i;
        opt.innerHTML = "Expression file " + i;
        NetworkSelection.appendChild(opt);
    }
}

/**
 * Scroll to top of a div
 * */
function scrollToTop(div){
    div[0].scrollTop = 0
    alert('scrolled')
}
