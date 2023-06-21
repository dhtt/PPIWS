<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--TODO: Safari appearance--%>
<html lang="en">
<head>
    <title>PPIXpress</title>
    <link rel="stylesheet" href="./shared_resources/css/interface.css">
    <link rel="stylesheet" href="./shared_resources/css/header-and-panel.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-colorpicker/3.4.0/js/bootstrap-colorpicker.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.21.0/cytoscape.min.js"> </script>
    <script src="https://unpkg.com/layout-base/layout-base.js"></script>
    <script src="https://unpkg.com/cose-base/cose-base.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/cytoscape-cose-bilkent@4.1/cytoscape-cose-bilkent.min.js"></script>
    <script type="module" src="./shared_resources/js/cytoscape-expand-collapse.js"></script>
    <script type="module" src="./shared_resources/js/jscolor.js"></script>
    <script type="module" src="./shared_resources/js/functionality.js"></script>
    <script type="module" src="./shared_resources/js/network_maker.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.0/FileSaver.min.js"> </script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<jsp:include page="./ppicompare_resources/html/header.html"/>
<div style="display: none">
    <button name="CSS_Style" id="--mint" style="color: var(--mint)"></button>
    <button name="CSS_Style" id="--darkmint" style="color: var(--darkmint)"></button>
    <button name="CSS_Style" id="--choco" style="color: var(--choco)"></button>
    <button name="CSS_Style" id="--lightmintgrey" style="color: var(--lightmintgrey)"></button>
    <button name="CSS_Style" id="--intensemint" style="color: var(--intensemint)"></button>
    <button name="CSS_Style" id="--darkintensemint" style="color: var(--darkintensemint)"></button>
    <button name="CSS_Style" id="--ultradarkmint" style="color: var(--ultradarkmint)"></button>
    <button name="CSS_Style" id="--deeppink" style="color: var(--deeppink)"></button>
    <button name="CSS_Style" id="--darkdeeppink" style="color: var(--darkdeeppink)"></button>
    <button name="CSS_Style" id="--shadow" style="color: var(--shadow)"></button>
    <button name="CSS_Style" id="--textshadow" style="color: var(--textshadow)"></button>
    <button name="CSS_Style" id="--warning" style="color: var(--warning)"></button>
</div>

<div class="disabling_layer" id="disabling_window"></div>
<div id="already_open_window_popup" class="popup center-pop" style="display: none">
    <div class="menu header" style="width: 400px; font-size: small; padding: 1em">
        PPIXpress is already open on another tab!
    </div>
    <p class="menu panel shadow" style="text-align: center; width: 400px; font-weight: normal; padding: 1em">
        <span>Please close this window<br>OR click "Stay here" to switch to working on this window<br><br></span>
        <span style="font-size: smaller; color: #707070">Note: PPIXpress progress in other window will be continued here.
            <br>If you wish to begin a new analysis, please close all opening PPIXpress windows
            <br>or continue and click on "Run a new analysis" in the dialog for finished job.
            <br><br>
        </span>
        <button type="button" id="already_open_window_switch" class="button upload" style="width: fit-content; margin: 0 1em">Stay here</button>
    </p>
</div>

<div id="AllPanels" class="container-body">
    <div id="LeftPanel" style="flex: 0 0 280px; margin-left: 1em">
        <form name="form" id="form" enctype="multipart/form-data">
            <div name="LeftPanel1" id="LeftPanel1">
                <p class="menu header">Load Protein Interaction Data</p>
                <div class="menu panel">
                    <div style="text-align: center; margin: 0">
                        <label for="protein_network_file" class="button upload" title="Upload a protein network">From file</label>
                        <input type="file" name="protein_network_file" id="protein_network_file" accept=".sif" style="display: none">
<%--                        TODO: Make input accept gzip --%>
                        &nbsp;or&nbsp;
                        <label for="protein_network_web" class="button upload" title="Use protein interaction network from Mentha or IntAct">From web</label>
                        <button type="button" name="protein_network_example" id="protein_network_example" class="help" title="Example input">?</button>
                        <div id="protein_network_web_popup" class="popup center-pop" style="display: none">
                            <div class="menu header" style="width: 300px; font-size: small">
                                <button type="button" name="close" class="help close">x</button>
                                Retrieve a network<br>from Mentha or IntAct database
                            </div>
                            <p class="menu panel shadow" style="text-align: center; width: 300px; font-weight: normal">
                                Please input an organism taxon.<br>e.g. Type 9606 for a human network.<br><br>
                                <input type="text" name="protein_network_web" id="protein_network_web" class="input" style="height: 1.5em"><br><br>
                                <button type="button" id="protein_network_web_confirm" name="confirm" class="button upload" style="width: fit-content;">Enter</button>
                            </p>
                        </div>
                    </div>
                    <p id="protein_network_file_description" class="description-text">&emsp;</p>
                    <span style="display:flex; width: 280px">
                        <span class="subsection-text" style="flex:1;">Options</span>
                        <span name="Reset" id="ResetPPIOptions" class="subsection-text reset" style="flex:1;">Reset</span><br>
                    </span>
                    <label>
                        <input type="checkbox" name="PPIOptions" id="STRING_weights" value="-w">Add STRING weights
                    </label><br>
                    <label>
                        <input type="checkbox" name="PPIOptions" id="update_UniProt" value="-u">Update UniProt accessions
                    </label><br>
                    <label>
                        <input type="checkbox" name="PPIOptions" id="up2date_DDIs" value="-l">Only local DDI data
                    </label><br>
                    <label>
                        <input type="checkbox" name="PPIOptions" id="include_ELM" value="-elm">Include ELM data
                    </label><br>
                    <label>
                        <input type="checkbox" name="PPIOptions" class="hidden-checkbox" style="display: none" value=null checked>
                    </label>

                </div>
            </div>

            <div name="LeftPanel2" id="LeftPanel2">
                <p class="menu header">Load Processed Expression Data</p>
                <div class="menu panel">
                    <p style="text-align: center; margin: 0">
                        <label for="expression_file" class="button upload" title="Upload one or more expression datasets">Upload file(s)</label>
                        <input type="file" name="expression_file" id="expression_file" accept=".txt,.gz" style="display: none" multiple>
                        <button type="button" name="expression_example" id="expression_example" class="help" title="Example input">?</button>
                    </p>
                    <p id="expression_file_description" class="description-text">&emsp;</p>
                    <span style="display:flex; width: 280px">
                        <span class="subsection-text" style="flex:1;">Options</span>
                        <span name="Reset" id="ResetExpOptions" class="subsection-text reset" style="flex:1;">Reset</span><br>
                    </span>
                    <label>
                        <input type="checkbox" name="ExpOptions" id="gene_level_only" value="-g">Gene-level only
                    </label><br>
                    <label>
                        <input type="checkbox" name="ExpOptions" id="norm_transcripts" value="-n">Normalize transcripts
                    </label><br>

                    <span class="subsection-text" style="flex:1;">Expression level
                    <label for="ExpressionLevelOption">
                        <select id="ExpressionLevelOption" style="width: fit-content; margin: 0.5em; border: 0">
                        <option value="threshold">Use threshold</option>
                        <option value="percentile">Use percentile</option>
                    </select>
                    </label>
                    </span>
                    <span class="subsection-text" style="flex:1; text-align: center">
                        <label for="threshold">Threshold</label>
                        <input type="number" id="threshold" value="1.00" min="0" max="1.0" step="0.01">
                        <label for="percentile" style="display: none">Percentile</label>
                        <input type="number" id="percentile" value="0.00" min="0" max="100.0" step="1" style="display: none">
                    </span>


                    <label>
                        <input type="checkbox" name="ExpOptions" class="hidden-checkbox" style="display: none" value=null checked>
                    </label>

                </div>
            </div>

            <div name="LeftPanel3" id="LeftPanel3">
                <p class="menu header">Run Options</p>
                <div class="menu panel">
                    <span style="display:flex; width: 280px; margin-top: -1em">
                        <span class="subsection-text" style="flex:1;">Options</span>
                        <span name="Reset" id="ResetRunOptions" class="subsection-text reset" style="flex:1;">Reset</span><br>
                    </span>
                    <label>
                        <input type="checkbox" name="RunOptions" id="remove_decay_transcripts" value="-x">Remove decay transcripts
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" id="report_reference" value="reference">Output reference network
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" id="output_DDINs" value="-d">Output DDINs
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" id="output_major_transcripts" value="-m">Output major transcripts
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" id="report_gene_abundance" value="-mg">Report gene abundance
                    </label><br>
                    <label style="display: none">
<%--                        Do not allow compression of text files because Utils.filterProtein() only read _ppin.txt--%>
                        <input type="checkbox" name="RunOptions" id="compress_output" value="-c" style="display: none">Compress output
                    </label>
                    <label>
                        <input type="checkbox" name="RunOptions" class="hidden-checkbox" style="display: none" value=null checked>
                    </label>
                </div>
            </div>

            <div name="LeftPanel4" id="LeftPanel4" style="text-align: center">
                <button type="submit" name="Submit" id="RunNormal" value="null" class="button submit" style="font-size: medium">Run PPIXPress</button>
                <button type="submit" name="Submit" id="RunExample" value="null" class="button try">or Try with example data!</button>
<%--                <button type="button" name="SubmitExample" id="RunExample" value="Run example" class="button try">or Try with example data!</button>--%>
            </div>
        </form>
    </div>

</div><br>
<footer>
    Thorsten Will & Volkhard Helms. Chair of Computational Biology
</footer>
</body>
</html>

