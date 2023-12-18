export function showNoChosenFiles(inputType, noFiles){
    $('#' + inputType + "_description").html(noFiles + " file(s) selected")
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
