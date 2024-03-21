
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
 * @param switch_ : 'on' or 'off'
 * @param classes_ : a list of CSS classes to be added or removed from the button. This will not work for <label + input> type button
 * @param option_ : 'addClasses' or 'removeClasses'
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