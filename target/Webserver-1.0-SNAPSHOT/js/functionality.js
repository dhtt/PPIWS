// TODO: Show ResultSummary + NetworkViualization only after Running Progress is done
// TODO: Check if progress shown while running

jQuery(document).ready(function() {
    $('#protein_network_file').on("change", function(){
        $('#protein_network_file_lab').html("Change file")
        $('#protein_network_description').html("Protein interaction data: " + this.files.length + " file(s) selected")
    })
    $('#expression_file').on("change", function(){
        $('#expression_file_lab').html("Change file(s)")
        $('#expression_description').html("Expression data: " + this.files.length + " file(s) selected")
    })

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
//
// function changeText(){
//     var fileName = document.getElementById("protein_network_file").value;
//     document.getElementById("protein_network_file_lab").innerHTML = fileName;
// }