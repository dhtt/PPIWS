
/**
 * Generates a random string of the specified length.
 *
 * @param {number} length - The length of the random string to generate.
 * @returns {string} The randomly generated string.
 */
export function generateRandomString(length) {
    let result = '';
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charactersLength = characters.length;
    for (let i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

/**
 * Show file name or the number of files to be uploaded. The information will be shown in HTML element which has 
 * the ID of the input field + "_description". For example, if the input field has ID 'PPIXpress_network_1',
 * the element which will display the information has to be named 'PPIXpress_network_1_description'
 * 
 * @param {string} inputID - The ID of the form input for file upload.
 * @param {*} noFiles - A file name or a number of files.
 * @param {string} option - Either 'show_name' or 'show_no_files' to determine whether to show the name or the number of files.
 */
export function showNoChosenFiles(inputID, noFiles, option){
    if (option === 'show_name'){
        $('#' + inputID + "_description").html(noFiles)
    }
    else if (option === 'show_no_files'){
        $('#' + inputID + "_description").html(noFiles + " file(s) selected")
    }
}

/**
 * Switches the state of a button and adds or removes CSS classes based on the switch state.
 * 
 * @param {jQuery} button_ - The button element.
 * @param {string} switch_ - The switch state, either 'on' or 'off'.
 * @param {string[]} classes_ - A list of CSS classes to be added or removed from the button.
 * @param {string} option_ - The option, either 'addClasses' or 'removeClasses', to determine whether to add or remove the CSS classes.
 */
export function switchButton(button_, switch_, classes_, option_){
    if (switch_ === 'on' & button_.prop('disabled')){
        button_.prop('disabled', false)
        for (let i = 0; i < classes_.length; i++){
            (option_ === 'addClasses') ? button_.addClass(classes_[i]) : (option_ === 'removeClasses') ? button_.removeClass(classes_[i]) : console.log('');
        }
    } else if (switch_ === 'off' & !button_.prop('disabled')) {
        button_.prop('disabled', true)
        for (let i = 0; i < classes_.length; i++){
            (option_ === 'addClasses') ? button_.addClass(classes_[i]) : (option_ === 'removeClasses') ? button_.removeClass(classes_[i]) : console.log('');
        }
    }
}

/**
 * Shows a warning message with the specified content and timeout.
 * 
 * @param {jQuery} WarningMessage_ - The warning message element.
 * @param {string} message_ - The content of the warning message.
 * @param {number} timeout_ - The timeout in milliseconds before hiding the warning message. Set to null for no timeout.
 */
export function showWarningMessage(WarningMessage_, message_, timeout_){
    WarningMessage_.html(message_)
    WarningMessage_.css({'display': 'block'})
    if (timeout_ !== null)
        setTimeout(function(){
            WarningMessage_.css({'display': 'none'})
        }, timeout_)
}

/**
 * Strips HTML tags from the specified HTML element and returns the resulting text.
 * 
 * @param {jQuery} HTMLElement - The HTML element to strip HTML tags from.
 * @returns {string} The resulting text after stripping HTML tags.
 */
export function stripHTML(HTMLElement){
    return HTMLElement.html().replace(/(<([^>]+)>)/gi, '\n').replace(/\n\s*\n/g, '\n');
}

/**
 * Creates a deep copy of an array of objects.
 * 
 * @param {Object[]} array_ - An array of objects.
 * @returns {Object[]} A deep copy of the input array.
 */
export function deepCopyArray(array_){
    let newArray_ = []
    array_.forEach(function(item){
        newArray_.push(JSON.parse(JSON.stringify(item)))
    })
    return newArray_
}

/**
 * Updates the color scheme of buttons based on the specified color scheme name.
 * 
 * @param {string} colorSchemeName - The name of the color scheme.
 * @returns {Object} An object containing the updated color scheme.
 */
export function updateColorScheme(colorSchemeName){
    let colorScheme = {};
    $("[name='" + colorSchemeName + "']").map(function(){
        let col = window.getComputedStyle(this, null).getPropertyValue("color"); // Get CS value of variable
        this.value = col // Set value of style to value of CSS variable
        colorScheme[this.id] = col; // Return an JSON entry for variable with value as item
    }).get()
    return colorScheme
}

/**
 * Creates a sample table for webserver transition.
 * 
 * @param {string[]} NAMES_EXPRESSION_FILE_ - An array of sample names.
 * @param {HTMLElement} target_ - The target element to append the sample table to.
 */
export function createXpress2CompareSampleTable(NAMES_EXPRESSION_FILE_, target_){
    while (target_.firstChild) {
        target_.removeChild(target_.firstChild);
    }
    
    // Create table for sample selection
    const sampleTable = document.createElement('table');
    sampleTable.style.margin = "auto"

    const tableHead = document.createElement("thead");
    const tableBody = document.createElement("tbody");
    
    const headerText = ['Sample', 'Group 1', 'Group 2', 'Not selected']
    const PPICompareGroups = ['group_1', 'group_2', 'none'] // PPICompareGroups is group id that sample should be labeled by
    let headerRow = document.createElement("tr");
    for (let i = 0; i < headerText.length; i++) {
        let headerCell = document.createElement("td");
        let headerContent = document.createTextNode(headerText[i])
        headerCell.appendChild(headerContent)
        headerRow.appendChild(headerCell);
    }
    tableHead.appendChild(headerRow);
    sampleTable.appendChild(tableHead);

    for (let i = 0; i < NAMES_EXPRESSION_FILE_.length; i++) {
        let bodyRow = document.createElement("tr");
        let bodyCell = document.createElement("th");
        let bodyContent = document.createTextNode(NAMES_EXPRESSION_FILE_[i])
        bodyCell.appendChild(bodyContent)
        bodyRow.appendChild(bodyCell)

        for (let j = 0; j < 3; j++){
            let bodyCell_ = document.createElement("th");
            let radioButton = document.createElement("input")
            radioButton.type = 'radio'
            radioButton.name = (i+1) + ';' + NAMES_EXPRESSION_FILE_[i] // matching putput index of files in NAMES_EXPRESSION_FILE_ starting from 1, 2, 3, ...
            radioButton.value = PPICompareGroups[j] 
            if (PPICompareGroups[j] === 'none') {
                radioButton.checked = "checked"
            }
            bodyCell_.appendChild(radioButton)
            bodyRow.appendChild(bodyCell_)
        }

        tableBody.appendChild(bodyRow)
    }

    tableHead.appendChild(headerRow);
    sampleTable.appendChild(tableHead);
    sampleTable.appendChild(tableBody);
    
    target_.appendChild(sampleTable)
}

/**
 * Toggles the display of input labels.
 * 
 * @param {jQuery} input_name - The input element selected by name.
 * @param {string} option_ - The option, either 'show' or 'hide', to determine whether to show or hide the input labels.
 */
export function toggleInputLabel(input_name, option_){
    if (option_ === 'show'){
        input_name.each(function(){ this.labels.forEach(function(label){ label.style.display = "block" }) })
    } else if (option_ === 'hide') {
        input_name.each(function(){ this.labels.forEach(function(label){ label.style.display = "none" }) })
    }
}