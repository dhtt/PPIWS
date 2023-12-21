/***
 * Show file name or the number of files to be uploaded. The information will be shown in HTML element which has 
 * the ID of the input field + "_description". For example, if the input field has ID 'PPIXpress_network_1',
 * the element which will display the information has to be named 'PPIXpress_network_1_description'
 * @param inputID the id of form input for file upload
 * @param {*} noFiles a file name or a number of files 
 * @param option either 'show_name' or 'show_no_files' for show the name of number of uploaded files.
 *  
 */
export function showNoChosenFiles(inputID, noFiles, option){
    if (option === 'show_name'){
        $('#' + inputID + "_description").html(noFiles)
    }
    else if (option === 'show_no_files'){
        $('#' + inputID + "_description").html(noFiles + " file(s) selected")
    }
}

/***
 *
 * @param button_
 * @param classes_
 */
export function enableButton(button_, classes_){
    if (button_.prop('disabled')){
        button_.prop('disabled', false)
        for (let i = 0; i < classes_.length; i++){
            button_.addClass(classes_[i])
        }
    }
}


/***
 *
 * @param button_ the button to enable
 * @param classes_ a list of style classes to remove from the button after disabling it
 */
export function disableButton(button_, classes_){
    if (!button_.prop('disabled')){
        button_.prop('disabled', true)
        for (let i = 0; i < classes_.length; i++){
            button_.removeClass(classes_[i])
        }
    }
}


/***
 *
 * @param WarningMessage_
 * @param message_
 * @param timeout_
 */
export function showWarningMessage(WarningMessage_, message_, timeout_){
    WarningMessage_.html(message_)
    WarningMessage_.css({'display': 'block'})
    if (timeout_ !== null)
        setTimeout(function(){
            WarningMessage_.css({'display': 'none'})
        }, timeout_)
}

/***
 *
 * @param HTMLElement
 * @returns {*}
 */
export function stripHTML(HTMLElement){
    return HTMLElement.html().replace(/(<([^>]+)>)/gi, '\n').replace(/\n\s*\n/g, '\n');
}

/***
 *
 * @param array_ an array of Objects
 * @returns {*}
 */
export function deepCopyArray(array_){
    let newArray_ = []
    array_.forEach(function(item){
        newArray_.push(JSON.parse(JSON.stringify(item)))
    })
    return newArray_
}

/***
 * Define values for button holding CSS style before the document is ready
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