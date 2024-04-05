jQuery(document).ready(function() {
    $("#ShowNetworkTopions_Example").load('./html/ShowNetworkOptions_PPIXpress.html')
    $("#AfterRunOptions_Example").load('./html/AfterRunOptions_PPIXpress.html')

    $(".help-panel").on('click', function(){
        const neighbors = $('#MenuPanel').find('.help-panel')
        neighbors.removeClass('help-panel-highlight'); // Unhighlight all options
        $(this).addClass('help-panel-highlight') // Highlight this option

        neighbors.addClass('disabled'); // Disable all options
        $(this).removeClass('disabled') // Enable this option

        $(".help-panel-sub").css({'display':'none'})
        $(this).parent().children('.help-panel-sub').toggle()
    })
    $('.DefaultHelpMenu').trigger('click')

    $("[name='HelpMenu']").on('click', function(){
        console.log(this.id)
        $('#to' + this.id)[0].scrollIntoView({behavior: "smooth", block: "start", inline: "nearest"})
    })

    /**
     * Scroll to top of a div
     * */
    $("[name='ScrollToTop']").on('click', function(){
        window.scrollTo({ top: 0, behavior: 'smooth' })
    })
})