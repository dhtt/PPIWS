jQuery(document).ready(function() {
    // Create GO Annotation analysis request form interface
    let GOAnnotSubnetwork = $('#GOAnnotSubnetwork')
    let annotGO_popup = $('#annotGO_popup')

    $.ajax({
        url: "./resources/PantherDB/supportedgenomes.json",
        success: function (json) {
            // Create table for sample selection
            const sampleTable = document.createElement('table');
            sampleTable.style.margin = "auto"

            const tableHead = document.createElement("thead");
            const tableBody = document.createElement("tbody");
            
            const headerText = ['', 'Name', 'Taxon', 'Version']
            let headerRow = document.createElement("tr");
            for (let i = 0; i < headerText.length; i++) {
                let headerCell = document.createElement("td");
                let headerContent = document.createTextNode(headerText[i])
                headerCell.appendChild(headerContent)
                headerRow.appendChild(headerCell);
            }
            tableHead.appendChild(headerRow);
            sampleTable.appendChild(tableHead);

            json.search.output.genomes.genome.map(genome => {
                let name = genome.name;
                let taxon_id = genome.taxon_id;
                let version = genome.version;

                let allowed_taxons = [9606, 10090]
                if (allowed_taxons.includes(taxon_id)) {
                    let radioButton = document.createElement("input")
                    radioButton.type = 'radio'
                    radioButton.name = 'selectedTaxon'
                    radioButton.value = taxon_id
                    let info = [name, taxon_id, version]

                    let bodyRow = document.createElement("tr");
                    for (let j = 0; j <= info.length; j++) {
                        let bodyCell = document.createElement("th");
                        j === 0 ? bodyCell.appendChild(radioButton) : bodyCell.appendChild(document.createTextNode(info[j-1]))
                        bodyRow.appendChild(bodyCell)
                    }
                    tableBody.appendChild(bodyRow)
                }            
            })
            sampleTable.appendChild(tableHead);
            sampleTable.appendChild(tableBody);

            $('#taxonSelect')[0].append(sampleTable)
        },
        error: function (e){
            alert("Cannot retrieve taxons from PantherDB")
            console.log(e)
        }
    })


    $.ajax({
        url: "./resources/PantherDB/supportedannotdatasets.json",
        success: function (json) {
            json.search.annotation_data_sets.annotation_data_type.map(annot => {
                let allowed_annot = ["GO:0003674", "GO:0008150", "GO:0005575"]

                if (allowed_annot.includes(annot.id)) {
                    let radioButton = document.createElement("input")
                    radioButton.type = 'radio'
                    radioButton.name = 'selectedAnnot'
                    radioButton.value = annot.id
                    radioButton.id = annot.id
    
                    let label = document.createElement("label")
                    label.htmlFor = annot.id
                    label.innerHTML =  annot.label.split('_').join(' ').toUpperCase()
                    
                    $('#annotSelect').append(radioButton)
                    $('#annotSelect').append(label)
                    $('#annotSelect').append("<br>")
                }
            })
        },
        error: function (e){
            alert("Cannot retrieve annotation type from PantherDB")
            console.log(e)
        }
    })

    GOAnnotSubnetwork.on('click', function(){
        annotGO_popup.toggle()
    })
    

    // Create GO Annotation analysis result interface
    const labels = ['FDR', 'p-value', 'Fold enrichment']
    const params = ['FDR', 'p_value', 'fold_enrichment']
    
    // Make sort_by radio buttons
    
    var option;
    for (let i = 0; i < params.length; i++) {
        option = document.createElement('option');
        option.value = params[i];
        option.textContent = labels[i];
        $('#sort_by').append( option );
    }
    $('#sort_by').val("p_value").change();

    for (let i = 0; i < params.length; i++) {
        option = document.createElement('option');
        option.value = params[i];
        option.textContent = labels[i];
        $('#color_by').append( option );
    }
    $('#color_by').val("fold_enrichment").change();

    // Make color_scheme options  
    const color_schemes = ['Viridis', 'Blues','Greens','Greys','YlGnBu', 'YlOrRd', 'Earth', 'Jet']
    color_schemes.forEach(item => {
        option = document.createElement('option');
        option.value = option.textContent = item;
        $('#color_scheme').append( option );
    })
    $('#color_scheme').val("Viridis").change();

    // Make color_scheme_reverse radio buttons
    const reverse = ["True", "False"]
    reverse.forEach(item => {
        option = document.createElement('option');
        option.value = option.textContent = item;
        $('#color_scheme_reverse').append( option );
    })
    $('#color_scheme_reverse').val("False").change();

    // Make show_significance radio buttons
    reverse.forEach(item => {
        option = document.createElement('option');
        option.value = option.textContent = item;
        $('#show_sig_cutoff').append( option );
    })
    $('#show_sig_cutoff').val("True").change();
})