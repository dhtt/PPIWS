<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--TODO: Safari appearance--%>
<html lang="en">
<head>
    <title>PPIXpress</title>
    <link rel="stylesheet" href="css/theme_mint.css">
    <link rel="stylesheet" href="css/interface.css">
    <link rel="stylesheet" href="css/header-and-panel.css">
    <link rel="stylesheet" href="css/cytoscape-style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-colorpicker/3.4.0/js/bootstrap-colorpicker.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.21.0/cytoscape.min.js"> </script>
    <script src="webjars/cytoscape-cose-bilkent/4.0.0/cytoscape-cose-bilkent.js"></script>
    <script type="module" src="js/cytoscape-expand-collapse.js"></script>
    <script type="module" src="js/jscolor.js"></script>
    <script type="module" src="js/functionality.js"></script>
    <script type="module" src="js/network_maker.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.0/FileSaver.min.js"> </script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<jsp:include page="header.html"/>
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

    <div id="RightPanel" class="middle-under" style="flex: 1; display: flex; flex-flow: column;">
        <div id="DisplayTabs" class="tabs" style="flex: 0 1 auto; width: 50%">
            <button type="button" name="DisplayTab" id="RunningProgress" value="RunningProgress" class="header button-tab tab-active" >Running Progress</button>
            <button type="button" name="DisplayTab" id="NetworkVisualization" value="NetworkVisualization" class="header button-tab">Network Visualization</button>
        </div>
        <div id="Display" class="display" style="flex: 1 1 auto; position: relative">
            <div id="RunningProgressContent" name="Display" class="display-content" style="display: flex; flex-direction: row">
                <div id="LeftDisplay" class="display-part" style="flex-basis: 60%">
                    <div id="RPContent" name="RunningProgress"></div>
                    <div id="Loader" name="RunningProgress" style="display: none; position: relative;"></div>
                    <div name="AfterRunOptions" name="RunningProgress" id="AfterRunOptions" class="shadow" style="display: none; max-width: 55%; margin: 1em auto; border-radius: 1em">
                        <p class="header" style="background: #68d3aa; color: white; text-shadow: var(--textshadow)"> PPIXpress pipeline is finished! </p>
                        <div class="panel" style="background: white; text-align: center">
                            <button type="button" name="transit" id="downloadLogFile" value="null" class="button download">Download Log File</button><br>
                            <button type="button" name="transit" id="downloadResultFiles" value="null" class="button download">Download Result Files</button><br>
                            <button type="button" name="transit" id="toNetworkVisualization" value="null" class="button download">Visualize Condition-Specific Networks</button><br>
                            <button type="button" name="transit" id="runNewAnalysis" value="null" class="button download">Run a new analysis</button><br>
                        </div>
                    </div>
                    <p name="ScrollToTop" class="reset" style="display: none; text-align: center">Scroll to top</p>
                </div>
                <div id="RightDisplay" class="display-part" style="display: none; text-align: center; padding: 0.5em">
                    <p class="subsection-text" style="margin: 0; font-size: smaller">Number of proteins and interactions<br>in each expression data</p>
                    <div id="SampleSummaryTable"></div><br>
                    <button type="button" name="transit" id="downloadSampleSummary" value="null" class="button download" style="min-width: fit-content; padding: 0.5em 1em; height: fit-content">Download this table</button><br><br>
                    <p name="ScrollToTop" class="reset" style="text-align: center">Scroll to top</p>
                </div>
            </div>

            <div id="NetworkVisualizationContent" name="Display" class="display-content non-display" style="display: flex; flex-direction: column">
                <div id="NVContent" style="display: flex; flex-direction: column; flex: 1 1 auto">
                    <div id="NVContent_Graph" style="flex: 1 1 auto; z-index: 0"></div>

                    <div id="NVOptions" class="align_box_right" style="flex: 1 1 auto; text-align: center">
                        <div class="network-option panel" id="ShowNetworkOptions" style="text-align: center; border-radius: 0 0 1em 1em; background: var(--deeppink); color: white; text-shadow: 0 0.1em 0.15em rgb(0 0 0 / 40%); padding: 0.5em 0">Show / Collapse Options</div>

                        <div class="network-option panel" name="NetworkOptions" style="text-align: center; border-radius: 1em">
                            <label for="NetworkSelection_Protein" style="font-weight: bold">Select a protein</label>
                            <input id="NetworkSelection_Protein" list="NetworkSelection_Protein_List" class="button upload" style="margin: 0.5em 0; width: 80%; font-size: smaller" placeholder="UniProt ID">
                            <datalist id="NetworkSelection_Protein_List"></datalist><br>
                            <label for="NetworkSelection_Expression" style="font-weight: bold; padding-top: 1em">Select an expression data</label>
                            <select id="NetworkSelection_Expression" class="button upload" style="margin: 0.5em 0"></select>
                            <button type="button" disabled name="ShowSubnetwork" id="ShowSubnetwork" value="null" class="button upload graph-menu-button">Show</button>
                            <button type="button" disabled name="ApplyGraphStyle" id="DownloadSubnetwork" value="null" class="button graph-menu-button">Download</button>
                        </div>

                        <div class="network-option panel" name="NetworkOptions" id="NetworkOptions" style="text-align: center; border-radius: 1em">
                            <label style="font-weight: bold">Customize network display</label>

                            <div style="display: flex; flex-direction: row; padding: 1em; line-height: 2em">
                                <div style="text-align: left; flex: auto">
                                    <label for="ToggleExpandCollapse" style="font-weight: bold; font-size: smaller">Display mode</label><br>
                                    <label for="changeLayout" style="font-weight: bold; font-size: smaller">Graph layout</label><br>
                                    <label for="changeNodeSize" style="font-weight: bold; font-size: smaller">Node size</label>
                                </div>
                                <div style="text-align: right; width: min-content">
                                    <select name="ApplyGraphStyle" id="ToggleExpandCollapse" disabled>
                                        <option value="collapseAll">Collapse all</option>
                                        <option value="expandAll">Expand all</option>
                                    </select><br>
                                    <select name="ApplyGraphStyle" id="changeLayout" disabled>
                                        <option value="cose-bilkent">Cose-bilkent</option>
                                        <option value="circle">Circle</option>
                                    </select><br>
                                    <input type="range" name="ApplyGraphStyle" id="changeNodeSize" disabled value="15" min="1" max="50" step="5" style="width: 100%; height: 0.5em"><br>
                                </div>
                            </div>

                            <label style="font-weight: bold; font-size: smaller">Customize colors</label>
                            <div style="display: flex; flex-direction: row; padding: 0 1em 1em 1em">
                                <div style="flex-basis: 50%; text-align: right">
                                    <label style="font-size: smaller">Protein </label>
                                    <button name="changeGraphColor" id="ProteinColor" data-jscolor="{valueElement: '#--deeppink'}"></button><br>
                                    <label style="font-size: smaller">PPI </label>
                                    <button name="changeGraphColor" id="PPIColor" data-jscolor="{valueElement: '#--darkdeeppink'}"></button><br>
                                </div>
                                <div style="flex-basis: 50%; text-align: right">
                                    <label style="font-size: smaller">Domains </label>
                                    <button name="changeGraphColor" id="DomainColor" data-jscolor="{valueElement: '#--mint'}"></button><br>
                                    <label style="font-size: smaller">DDI </label>
                                    <button name="changeGraphColor" id="DDIColor" data-jscolor="{valueElement: '#--darkintensemint'}"></button><br>
                                </div>
                            </div>
                            <button type="button" name="ApplyGraphStyle" id="ApplyGraphColor" disabled value="null" class="button graph-menu-button">Apply color changes</button>
                        </div>

<%--                        <div class="network-option panel" name="NetworkOptions" style="text-align: center; border-radius: 1em">--%>
<%--                            <label for="NVContentMetricsTable" style="font-weight: bold">Display network properties</label>--%>
<%--                            <div id="NVContentMetricsTable" class="popup">--%>
<%--                                <jsp:include page="output/network_table.html"/><br>--%>
<%--                                <a href="header.html">Download this table</a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
                    </div>
                    <p id="WarningMessage" style="display: none; flex: 1 1 auto"></p>
                </div>
            </div>
        </div>
    </div>
</div><br>
<footer>
    Thorsten Will & Volkhard Helms. Chair of Computational Biology
</footer>
</body>
</html>

