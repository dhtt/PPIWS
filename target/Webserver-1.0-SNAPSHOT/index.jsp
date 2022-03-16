<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>

<html>
<head>
    <title>PPIXpress</title>
    <link rel="stylesheet" href="css/interface.css">
    <link rel="stylesheet" href="css/header-and-panel.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.21.0/cytoscape.min.js"> </script>
    <script src="js/functionality.js"></script>
    <script src="js/network_maker.js"></script>
</head>
<body>
<jsp:include page="html/header.html" />

<div class="container-body">
    <div id="LeftPanel" style="flex: 0 0 280px; margin-left: 1em">
        <form name="form" id="form" enctype="multipart/form-data">
            <div name="LeftPanel1" id="LeftPanel1">
                <p class="menu header">Load Protein Interaction Data</p>
                <div class="menu panel">
                    <p style="text-align: center; margin: 0">
                        <label id="protein_network_file_lab" class="button upload" title="Upload a protein network">From file
                            <input type="file" name="protein_network_file" id="protein_network_file" style="display: none">
                        </label>
                        &nbsp;or&nbsp;
                        <label class="button upload" title="Use protein interaction network from Mentha or IntAct">From web
                            <input type="file" name="protein_network_web" id="protein_network_web" style="display: none">
                        </label>
                        <button type="button" name="protein_network_example" id="protein_network_example" class="help" title="Example input">?</button>
                    </p>
                    <p id="protein_network_description" class="description-text">&emsp;</p>
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
                        <input type="checkbox" name="PPIOptions" style="display: none" value=null checked>
                    </label>


                </div>
            </div>

            <div name="LeftPanel2" id="LeftPanel2">
                <p class="menu header">Load Processed Expression Data</p>
                <div class="menu panel">
                    <p style="text-align: center; margin: 0">
                        <label id="expression_file_lab" for="expression_file" class="button upload" title="Upload one or more expression datasets">Upload file(s)</label>
                        <input type="file" name="expression_file" id="expression_file" style="display: none" multiple>
                        <button type="button" name="expression_example" id="expression_example" class="help" title="Example input">?</button>
                    </p>
                    <p id="expression_description" class="description-text">&emsp;</p>
                    <span style="display:flex; width: 280px">
                        <span class="subsection-text" style="flex:1;">Options</span><span name="Reset" id="ResetExpOptions" class="subsection-text reset" style="flex:1;">Reset</span><br>
                    </span>
                    <label>
                        <input type="checkbox" name="ExpOptions" id="gene_level_only" value="-g">Gene-level only
                    </label><br>
                    <label>
                        <input type="checkbox" name="ExpOptions" id="percentile" value="-tp">Percentile-based
                    </label><br>
                    <label>
                        <input type="checkbox" name="ExpOptions" id="norm_transcripts" value="-n">Normalize transcripts
                    </label><br>
                    <label style="margin-left: 1em">Expression Level Threshold
                        <input type="number" name="ExpOptions" id="threshold" value="1.00" min="0" max="1.0" step="0.01"><br>
                    </label>
<%--                    TODO: Add percentile adjustment--%>
                    <label>
                        <input type="checkbox" name="ExpOptions" style="display: none" value=null checked>
                    </label>
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
                        <input type="checkbox" name="RunOptions" style="display: none" value=null checked>
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
            <button type="button" name="Display" id="RunningProgress" class="header button-tab active" onclick="getContent('RunningProgress')">Running Progress</button>
            <button type="button" name="Display" id="ResultSummary" class="header button-tab" onclick="getContent('ResultSummary')">Result Summary</button>
            <button type="button" name="Display" id="NetworkVisualization" class="header button-tab" onclick="getContent('NetworkVisualization')">Network Visualization</button>
        </div>
        <div id="Display" class="display" style="flex: 1 1 auto">
            <div id="RunningProgressContent" name="RunningProgress" class="display-content">
<%--                Page 1--%>
            </div>
            <div id="ResultSummaryContent" name="ResultSummary" class="display-content non-display">
<%--                Page 2--%>
            </div>
            <div id="NetworkVisualizationContent" name="NetworkVisualization" class="display-content non-display" style="width: 50%; height: 300px; overflow: hidden;">
<%--                Example network--%>
            </div>
        </div>
    </div>
</div>

<jsp:include page="html/footer.html" />
</body>
</html>

