// TODO: Show ResultSummary + NetworkViualization only after Running Progress is done
// TODO: Check if progress shown while running
jQuery(document).ready(function() {
    // Set default
    $.fn.set_default = function(){
        $('#remove_decay_transcripts').prop('checked', true)
        $('#threshold').val(1.0)
    }
    $.fn.set_default()

    // Make output_major_transcripts true when report_gene_abundance
    $.fn.make_all_checked = function(source_, target_){
        const parent = $('#' + source_)
        const children = $('#' + target_)
        if (parent.is(':checked') === true){
            children.prop("checked", true)
        } else {
            children.prop("checked", false)
        }
    }
    $('#report_gene_abundance').on('click', function(){
        $.fn.make_all_checked('report_gene_abundance','output_major_transcripts')
    })

    // Reset button
    $.fn.make_none_checked = function (name){
        $('[name="'+name+'"]').prop('checked', false)
    }
    $('.reset').on('click', function(){
        const name = $(this).attr('id').split('Reset').join("");
        $.fn.make_none_checked(name)
        $.fn.set_default()
    })

    // Show number of uploaded files
    $('#protein_network_file').on("change", function(){
        $('#protein_network_file_lab').html("Change file")
        $('#protein_network_description').html("Protein interaction data: " + this.files.length + " file(s) selected")
    })
    $('#expression_file').on("change", function(){
        $('#expression_file_lab').html("Change file(s)")
        $('#expression_description').html("Expression data: " + this.files.length + " file(s) selected")
    })

    // Ajax Handler
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
                $.fn.updateLongRunningStatus(resultText)
            },
            error: function (){
                alert("An error occurred, checked console log!")
            }
        })
    }

    $.fn.updateLongRunningStatus = function(resultText) {
        var interval = setInterval(function(data){
            $.ajax({
                    type: "POST",
                    url: 'ProgressReporter',
                    cache: false,
                    contentType: "application/json",
                    dataType: "json",
                    success: function (data) {
                        // console.log(data)
                        if (data.UPDATE_LONG_PROCESS_SIGNAL === true) {
                            alert("PPIXpress pipeline is finished!")
                            clearInterval(interval)
                        }
                        $('#RunningProgressContent').html(data.UPDATE_STATIC_PROGRESS_MESSAGE + data.UPDATE_LONG_PROCESS_MESSAGE)
                    }
                }
            );
        }, 1000);
    }

    $('#RunNormal').on('click', function (){
        $.fn.submit_form("RunNormal")
        return false;
    })
    $('#RunExample').on('click', function (){
        $.fn.submit_form("RunExample")
        return false;
    })

});

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