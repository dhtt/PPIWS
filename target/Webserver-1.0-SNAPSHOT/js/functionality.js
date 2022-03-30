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
    $('#expression_file').on("change", function(){
        $('#expression_file_lab').html("Change file(s)")
        $('#expression_description').html("Expression data: " + this.files.length + " file(s) selected")
    })

    // Ajax Handler
    const allPanel = $('#AllPanels');
    const runningProgressContent = $('#RPContent');
    const afterRunOptions = $('#AfterRunOptions');
    const loader = $('#Loader');
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
                        }
                        runningProgressContent.html(
                            json.UPDATE_STATIC_PROGRESS_MESSAGE +
                            json.UPDATE_LONG_PROCESS_MESSAGE
                        )
                    }
                }
            );
        }, updateInterval);
    }

    $('#RunNormal').on('click', function (){
        $.fn.submit_form("RunNormal")
        return false;
    })
    $('#RunExample').on('click', function (){
        loader.css({'display': 'block'})
        $.fn.submit_form("RunExample")
        return false;
    })

    // Show graph
    fetch('js/data.json', {mode: 'no-cors'})
        .then(function(res) {
            return res.json()
        })
        .then(function(data) {
            var graph = cytoscape({
                container: $('#NetworkVisualizationContent'),
                elements: data,
                boxSelectionEnabled: false,
                autounselectify: true,

                layout: {
                    name: 'circle'
                },

                style: [
                    {
                        selector: 'node',
                        style: {
                            'label': 'data(id)', //Show gene id
                            'height': 20, //Adjust node size
                            'width': 20,
                            'background-color' : '#433C39'
                            // 'background-color': 'mapData(rank, 0, 207, #95d0aa, #e8067f)',
                        }
                    },

                    {
                        selector: 'edge',
                        style: {
                            'curve-style': 'haystack',
                            'haystack-radius': 1,
                            'width': 5,
                            'opacity': 0.5,
                            'line-color': '#95d0aa'
                        }
                    }
                ]
            });
        })
})


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