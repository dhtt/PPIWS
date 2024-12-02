<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--TODO: Safari appearance--%>
<html lang="en">
<head>
    <title>PPIXpress</title>
    <link rel="shortcut icon" href="resources/PPIN_logo.png">
    <link rel="stylesheet" href="css/interface.css">
    <link rel="stylesheet" href="css/header-and-panel.css">
    <link rel="stylesheet" href="css/cytoscape-style.css">
    <link rel="stylesheet" href="css/animation.css">
    <link rel="stylesheet" href="css/select2_custom_style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/css/select2.min.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/dom-to-image/2.6.0/dom-to-image.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-colorpicker/3.4.0/js/bootstrap-colorpicker.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.21.0/cytoscape.min.js"> </script>
    <script src="webjars/cytoscape-cose-bilkent/4.0.0/cytoscape-cose-bilkent.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/js/select2.full.min.js"></script>
    <script src="https://cdn.plot.ly/plotly-2.35.2.min.js" charset="utf-8"></script>
    <script type="module" src="js/cytoscape-expand-collapse.js"></script>
    <script type="module" src="js/jscolor.js"></script>
    <script type="module" src="js/functionality.js"></script>
    <script type="module" src="js/network_maker.js"></script>
    <script type="module" src="js/PantherDB_prepper.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.0/FileSaver.min.js"> </script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<jsp:include page="html/header_PPIXpress.html"/>

<div class="disabling_layer" id="disabling_window"></div>
<div id="already_open_window_popup" class="popup center-pop" style="display: none">
    <div class="menu header popup_content" style="width: 400px;">
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

<div name="runNewAnalysis_popup" id="runNewAnalysis_popup" class="popup center-pop" style="display: none">
    <div class="menu header" style="width: fit-content;font-size: small;padding: 1em;min-width: 250px;">
        Run a new analysis
    </div>
    <div class="menu panel shadow popup_content" style="min-width: 250px;width: -webkit-fill-available;">
        <span>Do you wish to run a new analysis?<br>(All current results will be removed)<br><br></span>
        <div style="justify-content: space-evenly; display: flex; width: -webkit-fill-available;">   
            <button type="button" id="runNewAnalysis_yes" class="button upload">Yes</button>
            <button type="button" id="runNewAnalysis_no" class="button upload">No</button>
        </div>
    </div>
</div>


<div name="annotGO_popup" id="annotGO_popup" class="popup center-pop" style="display: none; min-width: 500px">
    <div class="menu header" style="font-size: small; width: auto">
        Gene Ontology Overrepresentation Analysis
    </div>
    <div class="menu panel shadow popup_content" style="width: auto;">
        <span style="font-weight: bold;">1. Select species</span>
        <div id="taxonSelect" class="popup_content_row" style="max-height: 11em;"></div>
        <p id="taxonSelect_description" class="description-text" style="display: none; color: var(--deeppink);">An organism must be selected</p>
        <br>
        <span style="font-weight: bold;">2. Select ontology aspect</span><br>
        <div id="annotSelect" style="display: flex; flex-direction: row;"></div> 
        <p id="annotSelect_description" class="description-text" style="display: none; color: var(--deeppink);">A type of gene ontology enrichemnt analysis must be selected</p>
        <br>
        <div style="display: flex;flex-direction: row;justify-content: space-around;width: -webkit-fill-available;">
            <button type="button" id="annotGO_yes" class="button upload">Analyze with PantherDB</button>
            <button type="button" id="annotGO_no" class="button upload">Cancel</button>
        </div>
    </div>
</div>

<jsp:include page="html/PPIXpress2PPICompare.html"/>

<div id="AllPanels" class="container-body">
    <div id="LeftPanel" style="flex: 0 0 280px; margin-left: 1em">
        <form name="form" id="form" enctype="multipart/form-data">
            <div name="LeftPanel1" id="LeftPanel1">
                <p class="menu header">Step 1. Load Protein Interactions</p>
                <div class="menu panel">
                    <div style="text-align: center; margin: 0">
                        <label for="protein_network_file" class="button upload" title="Upload a protein network">From file</label>
                        <input type="file" name="protein_network_file" id="protein_network_file" accept=".sif" style="display: none">
                        <!--TODO: Make input accept gzip -->
                        &nbsp;or&nbsp;
                        <label for="protein_network_web" class="button upload" title="Use protein interaction network from Mentha or IntAct">From web</label>
                        
                        <a href="./info_page_PPIXpress.jsp#toProteinInteractionData" target="_blank"> 
                            <button type="button" name="protein_network_example" id="protein_network_example" class="help" title="Example input">?</button>
                        </a>
                        <div id="protein_network_web_popup" class="popup center-pop" style="display: none">
                            <div class="menu header" style="width: 300px; font-size: small">
                                <button type="button" name="close" class="help close">x</button>
                                Retrieve a network<br>from Mentha or IntAct database
                            </div>
                            <p class="menu panel shadow popup_content" style="width: auto">
                                Please input an organism taxon.<br>e.g. Type 9606 for a human network.<br><br>
                                <input type="text" name="protein_network_web" id="protein_network_web" class="input" style="height: 1.5em"><br>
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
                </div>
            </div>

            <div name="LeftPanel2" id="LeftPanel2">
                <p class="menu header">Step 2. Load Expression Data</p>
                <div class="menu panel">
                    <p style="text-align: center; margin: 0">
                        <label for="expression_file" class="button upload" title="Upload one or more expression datasets">Upload file(s)</label>
                        <input type="file" name="expression_file" id="expression_file" accept=".txt,.gz" style="display: none" multiple>

                        <!-- TODO: Open page to ExpressionData section -->
                        <a href="./info_page_PPIXpress.jsp#toExpressionData" target="_blank"> 
                            <button type="button" name="expression_example" id="expression_example" class="help" title="Example input">?</button>
                        </a>
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
                        <input type="number" id="threshold" value="1.00" min="0" max="100" step="1">
                        <label for="percentile" style="display: none">Percentile</label>
                        <input type="number" id="percentile" value="0.00" min="0" max="100.0" step="1" style="display: none">
                    </span>
                </div>
            </div>

            <div name="LeftPanel3" id="LeftPanel3">
                <p class="menu header">Step 3. Adjust Run Options</p>
                <div class="menu panel">
                    <span style="display:flex; width: 280px; margin-top: -1em">
                        <span class="subsection-text" style="flex:1;">Options</span>
                        <span name="Reset" id="ResetRunOptions" class="subsection-text reset" style="flex:1;">Reset</span><br>
                    </span>
                    <label>
                        <input type="checkbox" name="RunOptions" id="remove_decay_transcripts" value="-x">Remove decay transcripts
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" id="report_reference" value="-reference">Output reference network
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" id="output_DDINs" value="-d">Output DDINs
                        <sup name="usePPICompareOptionsTag" style="display:none; font-size: x-small; font-weight: bold; color: var(--deeppink);">PPICompare</sup>
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" id="output_major_transcripts" value="-m">Output major transcripts
                        <sup name="usePPICompareOptionsTag" style="display:none; font-size: x-small; font-weight: bold; color: var(--deeppink);">PPICompare</sup>
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" id="report_gene_abundance" value="-mg">Report gene abundance
                    </label><br>
                    <!-- <label hidden>
                        <input type="checkbox" name="RunOptions" id="compress_output" value="-c" hidden> Compress outputs
                    </label> -->
                </div>
            </div>
            

            <div name="LeftPanel4" id="LeftPanel4" style="text-align: center">
                <div style="display: flex; flex-direction: row;">
                    <label for="usePPICompareOptions" value="null" class="button submit" style="width: -webkit-fill-available; font-size: small; margin-bottom: 0.5em; background: var(--lightmintgrey);color: var(--choco); min-height: fit-content; height:2em; padding: 0.5em;">Use PPICompare-required options</label> 
                    <a href="./info_page_PPIXpress.jsp#toUsePPICompareOptions" target="_blank"><button type="button" name="protein_network_example" class="help">?</button></a>
                </div>
                <input type="checkbox" id="usePPICompareOptions" style="display: none;">
                <button type="submit" name="Submit" id="RunNormal" value="null" class="button submit" style="font-size: medium">Run PPIXpress</button>
                <button type="submit" name="Submit" id="RunExample" value="null" class="button try">Try with example data!</button>
            </div>
        </form>
    </div>

    <div id="RightPanel" class="middle-under" style="flex: 1; display: flex; flex-flow: column;">
        <div id="DisplayTabs" class="tabs" style="flex: 0 1 auto; width: 75%">
            <button type="button" name="DisplayTab" id="RunningProgress" value="RunningProgress" class="header button-tab tab-active" >Running Progress</button>
            <button type="button" name="DisplayTab" id="NetworkVisualization" value="NetworkVisualization" class="header button-tab">Network Visualization</button>
            <button type="button" name="DisplayTab" id="GOAnnotationAnalysis" value="GOAnnotationAnalysis" class="header button-tab">GO  Analysis</button>
        </div>
        <div id="Display" class="display" style="flex: 1 1 auto; position: relative">
            <div id="RunningProgressContent" name="Display" class="display-content" style="display: flex; flex-direction: row">
                <div id="LeftDisplay" class="display-part" style="flex-basis: 60%">
                    <p id="WarningMessage_RunningProgressContent" class="warning" style="display: none;"></p>
                    <div id="RPContent" name="RunningProgress"></div>
                    <div id="Loader" name="RunningProgress" style="display: none; position: relative;"></div>
                    <div name="AfterRunOptions" name="RunningProgress" id="AfterRunOptions" class="shadow" style="display: none; max-width: 55%; margin: 1em auto; border-radius: 1em">
                        <p class="header" style="background: #68d3aa; color: white; text-shadow: var(--textshadow)"> PPIXpress pipeline is finished! </p>
                        <div class="panel" style="background: white; text-align: center">
                            <button type="button" name="transit" id="downloadLogFile" value="null" class="button download">Download Log File</button><br>
                            <button type="button" name="transit" id="downloadResultFiles" value="null" class="button download">Download Result Files</button><br>
                            <div class="star" name="Star" id="toNetworkVisualization_star"></div>
                            <button type="button" name="transit" id="toNetworkVisualization" value="null" class="button download">Visualize Condition-Specific Networks</button><br>
                            <button type="button" name="transit" id="toPPICompare" value="null" disabled class="button download disabled" title="Required 'Output DDINs' and 'Output major transcripts' with at least 4 samples.">Build differential network (PPICompare)</button><br>
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
                    <div id="NVContent_Graph_with_Legend" style="flex: 1 1 auto; z-index: 0">
                        <div id="NVContent_Graph" style="position: absolute;"></div>
                        <div id="NVContent_Legend" class="graph_legend"></div>
                    </div>

                    <div id="NVOptions" class="align_box_right" style="flex: 1 1 auto; text-align: center">
                        <div class="network-option panel ShowNetworkOptions" name="ShowNetworkOptions">Show / Collapse Options</div>

                        <div class="star2" name="Star" id="NetworkOptions_star"></div>
                        <div class="network-option panel" name="NetworkOptions" style="text-align: center; border-radius: 1em">
                            <label for="NetworkSelection_Protein" style="font-weight: bold">Select a protein</label><br>
                            <select id="NetworkSelection_Protein" class="button upload" style="margin: 0.5em 0; width: min-content; font-size: smaller" data-placeholder="UniProt ID"></select><br>
                            
                            
                            <label for="NetworkSelection_Expression" style="font-weight: bold; padding-top: 1em">Select an expression data</label>
                            <select id="NetworkSelection_Expression" class="button upload" style="margin: 0.5em 0"></select><br>
                            <button type="button" disabled name="ShowSubnetwork" id="ShowSubnetwork" value="null" class="button graph-menu-button">Show</button>
                            <button type="button" disabled name="ApplyGraphStyle" id="DownloadSubnetwork" value="null" class="button graph-menu-button">Download</button>
                            <button type="button" disabled name="ApplyGraphStyle" id="GOAnnotSubnetwork" value="null" class="button graph-menu-button">Gene enrichment analysis</button>
                        </div>

                        <div class="network-option panel" name="NetworkOptions" id="CustomizeNetworkOptions" style="text-align: center; border-radius: 1em">
                            <span style="font-weight: bold">Customize network display</span>

                            <div style="display: flex; flex-direction: row; padding: 1em; line-height: 2em">
                                <div style="text-align: left; flex: auto">
                                    <label for="ToggleExpandCollapse" class="subsubsection-text">Display mode</label><br>
                                    <label for="changeLayout" class="subsubsection-text">Graph layout</label><br>
                                    <label for="changeNodeSize" class="subsubsection-text">Node size</label>
                                </div>

                                <div style="text-align: right; width: min-content">
                                    <select name="ApplyGraphStyle" id="ToggleExpandCollapse" style="width: auto" disabled>
                                        <option value="collapseAll">Collapse all</option>
                                        <option value="expandAll">Expand all</option>
                                    </select><br>
                                    <select name="ApplyGraphStyle" id="changeLayout" style="width: 100%" disabled>
                                        <option value="cose-bilkent">Cose-bilkent</option>
                                        <option value="circle">Circle</option>
                                    </select><br>
                                    <input type="range" name="ApplyGraphStyle" id="changeNodeSize" disabled value="15" min="1" max="50" step="5" style="width: 100%; height: 0.5em"><br>
                                </div>
                            </div>

                            <span class="subsection-text">Customize colors</span>
                            <div style="display: flex; flex-direction: row; padding: 0 1em 1em 1em">
                                <div style="flex-basis: 50%; text-align: right">
                                    <label for="ProteinColor" style="font-size: smaller">Protein </label>
                                    <button name="changeGraphColor" id="ProteinColor" data-jscolor="{valueElement: '#--deeppink'}"></button><br>
                                    <label for="PPIColor" style="font-size: smaller">PPI </label>
                                    <button name="changeGraphColor" id="PPIColor" data-jscolor="{valueElement: '#--darkdeeppink'}"></button><br>
                                </div>
                                <div style="flex-basis: 50%; text-align: right">
                                    <label for="DomainColor" style="font-size: smaller">Domains </label>
                                    <button name="changeGraphColor" id="DomainColor" data-jscolor="{valueElement: '#--mint'}"></button><br>
                                    <label for="DDIColor" style="font-size: smaller">DDI </label>
                                    <button name="changeGraphColor" id="DDIColor" data-jscolor="{valueElement: '#--darkintensemint'}"></button><br>
                                </div>
                            </div>
                            <button type="button" name="ApplyGraphStyle" id="ApplyGraphColor" disabled value="null" class="button graph-menu-button">Apply color changes</button>
                        </div>
                    </div>
                    <p id="WarningMessage" class="warning" style="display: none; flex: 1 1 auto"></p>
                </div>
            </div>

            <div id="GOAnnotationAnalysisContent" name="Display" class="display-content non-display" style="display: flex; flex-direction: column">
                <div id="GOAAContent" style="display: flex; flex-direction: column; flex: 1 1 auto">
                    <div id="GO_plot_holder" style="flex: 1 1 auto; width: 80%; height: 80%; z-index: 0"></div>

                    <div id="GOAAOptions" class="align_box_right" style="flex: 1 1 auto; text-align: center">
                        <div class="network-option panel ShowNetworkOptions" name="ShowNetworkOptions">Show / Collapse Options</div>

                        <div class="network-option panel" name="NetworkOptions" style="text-align: center; border-radius: 1em">
                            <span style="font-weight: bold">Customize plot</span>
                            <div style="display: flex; flex-direction: column; padding: 1em; align-items: center;">
                                    <label for="sort_by" class="subsubsection-text">Sort terms by</label>
                                    <select name="ApplyGraphStyle" id="sort_by" disabled></select><br>

                                    <label for="color_by" class="subsubsection-text">Color by</label>
                                    <select name="ApplyGraphStyle" id="color_by" disabled></select><br>
                                    
                                    <label for="color_scheme" class="subsubsection-text">Color palette</label>
                                    <select name="ApplyGraphStyle" id="color_scheme" disabled></select><br>
                                    
                                    <label for="color_scheme_reverse" class="subsubsection-text">Reverse color palette</label>
                                    <select name="ApplyGraphStyle" id="color_scheme_reverse" disabled></select><br>
                                    
                                    <label for="sig_cutoff" class="subsubsection-text">Significance threshold</label>
                                    <span style="display: flex;flex-direction: row;align-items: center;column-gap: 0.5em;">
                                        <input type="range" name="ApplyGraphStyle" id="sig_cutoff" disabled value="0.05" min="0.01" max="0.05" step="0.01" style="width: 110px; height: 0.5em">
                                        <output id="sig_cutoff_val" for="sig_cutoff">0.05</output><br>
                                    </span><br>

                                    <label for="show_sig_cutoff" class="subsubsection-text">Show significance threshold</label>
                                    <select name="ApplyGraphStyle" id="show_sig_cutoff" disabled></select><br>

                                    <button type="button" disabled="" name="ApplyGraphStyle" id="downloadGOFile" value="null" class="button graph-menu-button">Download GO analysis result</button>
                            </div>
                        </div>
                    </div>
                    <p id="WarningMessage_GOAAContent" class="warning" style="display: none; flex: 1 1 auto"></p>
                </div>
            </div>

        </div>
    </div>
</div>
<jsp:include page="html/footer.html"/>
</body>
</html>

