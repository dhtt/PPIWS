//TODO: A tab is active until another tab is clicked > remove active status for this.tab > include active for another.tab
//TODO: A content page is active until another tab is clicked > include non-display for this.content > remove non-display for another.content

function toggle1(name, displayTabs, chosenTab, chosenTab_contents){
    for (var i=0; i < displayTabs.length; i++){
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
    var displayTabs, chosenTab, chosenTab_contents;
    displayTabs = document.getElementsByClassName("button-tab");
    chosenTab = document.getElementById(name);
    chosenTab_contents = document.getElementsByClassName("display-content");
    toggle1(name, displayTabs, chosenTab, chosenTab_contents);
}