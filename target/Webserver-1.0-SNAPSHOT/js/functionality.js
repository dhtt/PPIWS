// TODO: Show ResultSummary + NetworkVisualization only after Running Progress is done

jQuery(document).ready(function() {
    // Set default
    let set_default = function () {
        $('#remove_decay_transcripts').prop('checked', true)
        $('#threshold').val(1.0)
    }
    set_default()

    // Make output_major_transcripts true when report_gene_abundance
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

    // Reset button
    let make_none_checked = function (name) {
        $('[name="' + name + '"]').prop('checked', false)
    }
    $('.reset').on('click', function(){
        const name = $(this).attr('id').split('Reset').join("");
        make_none_checked(name)
        set_default()
    })

    // Show number of uploaded files
    $('#protein_network_file').on("change", function(){
        $('#protein_network_file_lab').html("Change file")
        $('#protein_network_description').html("Protein interaction data: " + this.files.length + " file(s) selected")
    })
    let no_expression_file = 0;
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
        scroll_top(leftDisplay)
    })
    $('#ScrollTop_RightDisplay').on('click', function(){
        scroll_top($('#RightDisplay'))
    })

    // Submit
    $('#RunNormal').on('click', function (){
        $.fn.submit_form("RunNormal")
        return false;
    })
    var select = document.getElementById('NetworkSelection');
    $('#RunExample').on('click', function (){
        for (let i = 1; i <= no_expression_file; i++){
            console.log(i)
            const opt = document.createElement('option');
            opt.value = "exp_" + i;
            opt.innerHTML = "Expression file " + i;
            select.appendChild(opt);
        }
        // select.css({'display': 'block'})
        loader.css({'display': 'block'})
        $.fn.submit_form("RunExample")
        return false;
    })

})

function scroll_top(div){
    div[0].scrollTop = 0
}

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