jQuery(document).ready(function() {
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

                let allow_taxons = [9606, 10090]
                if (allow_taxons.includes(taxon_id)) {
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

            $('#taxonSelect')[0].appendChild(sampleTable)
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
                let radioButton = document.createElement("input")
                radioButton.type = 'radio'
                radioButton.name = 'selectedTaxon'
                radioButton.value = annot.id
                radioButton.id = annot.id

                let label = document.createElement("label")
                label.htmlFor = annot.id
                label.innerHTML =  annot.label.split('_').join(' ').toUpperCase()
                
                $('#annotSelect')[0].appendChild(radioButton)
                $('#annotSelect')[0].appendChild(label)
            })
        },
        error: function (e){
            alert("Cannot retrieve annotation type from PantherDB")
            console.log(e)
        }
    })
})