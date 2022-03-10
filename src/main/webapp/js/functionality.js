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

    // Run example data and options


    // Ajax Handler
    $("#form").submit(function (){
        const form = $("form")[0];
        const data = new FormData(form);
        $.ajax({
            url: "PPIXpress",
            method: "POST",
            enctype: 'multipart/form-data',
            data: data,
            processData : false,
            contentType : false,
            success: function (resultText) {
                $('#RunningProgressContent').html(resultText)
                $('#NetworkVisualizationContent').html("<h1>A network<h1>")
            }
        })
        return false;
    })
});


// $.ajax({
//     xhr: function () {
//         var xhr = new window.XMLHttpRequest();
//         xhr.upload.addEventListener("progress", function (evt) {
//             if (evt.lengthComputable) {
//                 var percentComplete = evt.loaded / evt.total;
//                 console.log(percentComplete);
//                 $('.progress').css({
//                     width: percentComplete * 100 + '%'
//                 });
//                 if (percentComplete === 1) {
//                     $('.progress').addClass('hide');
//                 }
//             }
//         }, false);
//         xhr.addEventListener("progress", function (evt) {
//             if (evt.lengthComputable) {
//                 var percentComplete = evt.loaded / evt.total;
//                 console.log(percentComplete);
//                 $('.progress').css({
//                     width: percentComplete * 100 + '%'
//                 });
//             }
//         }, false);
//         return xhr;
//     },
//     type: 'POST',
//     url: "/echo/html",
//     data: data,
//     success: function (data) {}
// });


function toggle1(name, displayTabs, chosenTab, chosenTab_contents){
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
    toggle1(name, displayTabs, chosenTab, chosenTab_contents);
}