import {checkIfCytoscapeNetwork} from './functionality_helper_functions.js'
import {getCytoscapeNetwork} from './functionality_helper_functions.js'

jQuery(document).ready(function() {
    let GOAnnotSubnetwork = $('#GOAnnotSubnetwork')
    let taxonSelect = $('taxonSelect')
    let annotSelect = $('annotSelect')
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
    
    $('#annotGO_yes').on('click', function() {
        let geneInputList = null;
        let refInputList = null;
        let taxon = null;
        let annot = null;
        let ProteinNetwork = $('#NVContent_Graph')
        
        if (checkIfCytoscapeNetwork(ProteinNetwork)){
            // 1. Fetch gene list, should be proteins in subnetwork
            geneInputList = String(getCytoscapeNetwork(ProteinNetwork).filter('.Protein_Node').map(x => x.id()).join(','));

            // 2. Fetch background, should be all avail proteins 
            // (not included right now because of large header)
            refInputList = Array.from(document.getElementById("NetworkSelection_Protein").options).map(x => x.innerText).join(',');

            // 3. Derive organism
            taxon = String($("input[name='selectedTaxon']:checked").val());
            
            // 4. Select annotation type
            annot = String($("input[name='selectedAnnot']:checked").val());
            
            // 5. Fetch GO annotations
            if (geneInputList && refInputList && taxon && annot) {
                var overrepForm = new URLSearchParams();
                overrepForm.append('geneInputList', geneInputList);
                overrepForm.append('organism', taxon); 
                // overrepForm.append('refInputList', refInputList);
                // overrepForm.append('refOrganism', taxon); 
                overrepForm.append('annotDataSet', annot);
                overrepForm.append('enrichmentTestType', "FISHER");
                overrepForm.append('correction', "FDR");

                let result = fetch("https://pantherdb.org/services/oai/pantherdb/enrich/overrep?" + 
                    new URLSearchParams(overrepForm).toString(), {
                    method: "POST",
                    headers: {
                        'Content-Type': 'application/json;charset=UTF-8',
                    }
                })
                .then(response => response.json())
                .then(
                    data => {
                        annotation = response.json()
                        fetch("./js/example.py" + 
                            new URLSearchParams(overrepForm).toString(), {
                            method: "POST",
                            headers: {
                                'Content-Type': 'application/json;charset=UTF-8',
                            }, 
                            body: JSON.stringify(data)
                        })
                    }   
                )
                console.log(result);
                
            }           
        }
    })

})