jQuery(document).ready(function() {
    $("#ClickMe").click(function() {
        alert("In js file");
    });
    $("#form").submit(function (){
        // const form = $("form");
        // const data = new FormData(form);
        var data = $("#form").serialize();
        $.ajax({
            url: "PPIXpress",
            method: "POST",
            // enctype: 'multipart/form-data',
            data: data,
            // processData : false,
            // contentType : false,
            success: function (resultText) {
                $('#RunningProgressContent').html(resultText)
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

