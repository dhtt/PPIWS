<%@ page import="java.io.File" %>
<%@ page import="java.util.Objects" %>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html lang="en">
<head>
    <title>PPIXpress</title>
    <link rel="stylesheet" href="css/interface.css">
    <link rel="stylesheet" href="css/header-and-panel.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.21.0/cytoscape.min.js"> </script>
    <script type="module" src="js/functionality.js"></script>
    <script type="module" src="js/network_maker.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<jsp:include page="html/header.html" />

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
                            <p class="menu panel shadow" style="text-align: center; width: 300px">
                                Please input an organism taxon.<br>e.g. Type 9606 for a human network.<br><br>
                                <input type="text" name="protein_network_web" id="protein_network_web" class="input" style="height: 1.5em"><br><br>
                                <button type="button" id="protein_network_web_confirm" name="confirm" class="button upload" style="width: fit-content;">Enter</button>
                            </p>
                        </div>
                    </div>
                    <p id="protein_network_file_description" class="description-text">&emsp;</p>
                    <span style="display:flex; width: 280px">
                        <span class="subsection-text" style="flex:1;">Options</span><span name="Reset" id="ResetPPIOptions" class="subsection-text reset" style="flex:1;">Reset</span><br>
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
                        <span class="subsection-text" style="flex:1;">Options</span><span name="Reset" id="ResetExpOptions" class="subsection-text reset" style="flex:1;">Reset</span><br>
                    </span>
                    <label>
                        <input type="checkbox" name="ExpOptions" id="gene_level_only" value="-g">Gene-level only
                    </label><br>
                    <label>
                        <input type="checkbox" name="ExpOptions" id="norm_transcripts" value="-n">Normalize transcripts
                    </label><br>

                    <span class="subsection-text" style="flex:1;">Expression level
                    <select id="ExpressionLevelOption" style="width: fit-content; background: white; padding: 0 0.5em; margin: 1em; border: 0">
                        <option value="threshold">Use threshold</option>
                        <option value="percentile">Use percentile</option>
                    </select>
                    </span>
                    <span class="subsection-text" style="flex:1; text-align: center">
                        <label for="threshold">Threshold</label>
                        <input type="number" id="threshold" value="1.00" min="0" max="1.0" step="0.01">
                        <label for="percentile" style="display: none">Percentile</label>
                        <input type="number" id="percentile" value="0.00" min="0" max="1.0" step="0.01" style="display: none">
                    </span>


                    <label></label>
                    <input type="checkbox" name="ExpOptions" class="hidden-checkbox" style="display: none" value=null checked>

                </div>
            </div>

            <div name="LeftPanel3" id="LeftPanel3">
                <p class="menu header">Run Options</p>
                <div class="menu panel">
                    <span style="display:flex; width: 280px">
                        <span class="subsection-text" style="flex:1;">Options</span><span name="Reset" id="ResetRunOptions" class="subsection-text reset" style="flex:1;">Reset</span><br>
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
                        <input type="checkbox" name="RunOptions" id="compress_output" value="-c">Compress output
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" class="hidden-checkbox" style="display: none" value=null checked>
                    </label>
                </div>
            </div>

            <div name="LeftPanel4" id="LeftPanel4" style="text-align: center">
                <button type="submit" name="Submit" id="RunNormal" value="null" class="button submit">Run PPIXPress</button>
                <button type="submit" name="Submit" id="RunExample" value="null" class="button try">or Try with example data!</button>
<%--                <button type="button" name="SubmitExample" id="RunExample" value="Run example" class="button try">or Try with example data!</button>--%>
            </div>
        </form>
    </div>

    <div id="RightPanel" class="middle-under" style="flex: 1; display: flex; flex-flow: column;">
        <div id="DisplayTabs" class="tabs" style="flex: 0 1 auto">
            <button type="button" name="DisplayTab" id="RunningProgress" value="RunningProgress" class="header button-tab tab-active" >Running Progress</button>
            <button type="button" name="DisplayTab" id="ResultSummary" value="ResultSummary" class="header button-tab">Result Summary</button>
            <button type="button" name="DisplayTab" id="NetworkVisualization" value="NetworkVisualization" class="header button-tab">Network Visualization</button>
        </div>
        <div id="Display" class="display" style="flex: 1 1 auto; position: relative">
            <div id="RunningProgressContent" name="Display" class="display-content" style="display: flex; flex-direction: row">
                <div id="LeftDisplay" class="display-part" style="flex-basis: 70%">
                    <div id="RPContent" name="RunningProgress"></div>
                    <div id="Loader" name="RunningProgress" style="display: none; position: relative;"></div>
                    <div name="AfterRunOptions" name="RunningProgress" id="AfterRunOptions" class="shadow" style="display: none; max-width: 50%; margin: 1em auto; border-radius: 1em">
                        <p class="header" style="background: #68d3aa; color: white; text-shadow: var(--textshadow)"> PPIXpress pipeline is finished! </p>
                        <div class="panel" style="background: white; text-align: center">
                            <button type="button" name="transit" id="downloadLogFile" value="null" class="button download">Download Log File</button><br>
                            <button type="button" name="transit" id="toResultSummary" value="null" class="button download">View PPIXPress Results</button><br>
                            <button type="button" name="transit" id="toNetworkVisualization" value="null" class="button download">Visualize Condition-Specific Networks</button><br>
                        </div>
                    </div>
                    <p name="ScrollToTop" class="reset" style="display: none; text-align: center">Scroll to top</p>
                </div>
                <div id="RightDisplay" class="display-part" style="display: none; flex-basis: 30%; text-align: center">
                    <p class="subsection-text" style="margin: 0; font-size: smaller">Number of proteins and interactions<br>in each expression data</p>
                    <jsp:include page="output/test_table.html"/>
                    <a href="header.html">Download this table</a><br><br>
                    <p name="ScrollToTop" class="reset" style="text-align: center">Scroll to top</p>
                </div>
            </div>

            <div id="ResultSummaryContent" name="Display" class="display-content non-display">
<%--                <h4>Please first run PPIXpress and check for progress in Running Progress.</h4>--%>
            </div>

            <div id="NetworkVisualizationContent" name="Display" class="display-content non-display" style="display: flex; flex-direction: column">
<%--                <h4>Please first run PPIXpress and check for progress in Running Progress.</h4>--%>

                <div id="NVContent" class="non-display" style="display: flex; flex-direction: column; flex: 1 1 auto">
                    <div id="NVContent_Graph" style="flex: 1 1 auto"></div>

                    <div id="NVOptions" class="align_box_right" style="flex: 1 1 auto; text-align: center">
                        <div class="network-option panel" style="text-align: center; border-radius: 1em">
                            <label for="NetworkSelection" style="font-weight: bold">Show network for</label>
                            <select id="NetworkSelection" name="NetworkOptions" class="button upload" style="margin-top: 0.5em"></select>
                        </div>

                        <div class="network-option panel" style="text-align: center; border-radius: 1em">
                            <label for="NodesNumber" style="font-weight: bold">Number of displayed nodes</label>
                            <input type="range" id="NodesNumber" name="NetworkOptions" value="1.00" min="0" max="1.0" step="0.01" style="display:none; width: 80%; margin-top: 0.5em">
                        </div>

                        <div class="network-option panel" style="text-align: center; border-radius: 1em">
                            <label for="NVContentMetricsTable" style="font-weight: bold">Display network properties</label>
                            <div id="NVContentMetricsTable" name="NetworkOptions" class="popup" style="display:none">
                                <jsp:include page="output/network_table.html"/><br>
                                <a href="header.html">Download this table</a>
                            </div>
                        </div>

                        <div class="network-option panel" style="text-align: center; border-radius: 1em">
                            <label for="ColorTheme" style="font-weight: bold">Customize graph color</label>
                            <select id="ColorTheme" name="NetworkOptions" class="button upload" style="display:none; margin-top: 0.5em">
                                <option value="default">Default</option>
                            </select>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<footer>
    Thorsten Will & Volkhard Helms. Chair of Computational Biology
</footer>
</body>
</html>

