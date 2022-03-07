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
                    <p class="subsection-text">Options</p>
                    <label>
                        <input type="checkbox" name="PPIOptions" id="STRINGWeight" value="Add STRING weights">Add STRING weights
                    </label><br>
                    <label>
                        <input type="checkbox" name="PPIOptions" id="UniProtAcc" value="Update UniProt accessions">Update UniProt accessions
                    </label><br>
                    <label>
                        <input type="checkbox" name="PPIOptions" id="LocalDDI" value="Only local DDI data">Only local DDI data
                    </label><br>
                    <label>
                        <input type="checkbox" name="PPIOptions" id="ELMData" value="Include ELM data">Include ELM data
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
                    <p class="subsection-text">Options</p>
                    <label>
                        <input type="checkbox" name="ExpOptions" id="GeneLevelOnly" value="Gene-level only">Gene-level only
                    </label><br>
                    <label>
                        <input type="checkbox" name="ExpOptions" id="PercentileBased" value="Percentile-based">Percentile-based
                    </label><br>
                    <label style="margin-left: 1em">Expression Level Threshold
                        <input type="text" value="1.0" id="ExpressionLevelThreshold"><br>
                    </label>
                    <label>
                        <input type="checkbox" name="ExpOptions" style="display: none" value=null checked>
                    </label>
                </div>
            </div>

            <div name="LeftPanel3" id="LeftPanel3">
                <p class="menu header">Run Options</p>
                <div class="menu panel">
                    <label>
                        <input type="checkbox" name="RunOptions" id="OutputReferenceNetwork" value="Output reference network">Output reference network
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" id="OutputDDINs" value="Output DDINs">Output DDINs
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" id="OutputMajorTranscripts" value="Output major transcripts">Output major transcripts
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" id="CompressOutput" value="Compress output">Compress output
                    </label><br>
                    <label>
                        <input type="checkbox" name="RunOptions" style="display: none" value=null checked>
                    </label>
                </div>
            </div>

            <div name="LeftPanel4" id="LeftPanel4" style="text-align: center">
                <button type="submit" name="Submit" id="Run" value="Run normal" class="button submit">Run PPIXPress</button>
                <button type="submit" name="Submit" id="RunExample" value="Run example" class="button try">or Try with example data!</button>
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
<%--            <button type="button" name="ClickMe" id="ClickMe" value="Show network" class="button submit">Click Me!</button>--%>
<%--            <div id="cy" style="width: 90%; height: 300px; color: white; display: block; overflow: scroll;"></div>--%>
        </div>
    </div>
</div>

<jsp:include page="html/footer.html" />
<%--<script>--%>
<%--    $("#ClickMe").click(function() {--%>
<%--        alert("Okay");--%>
<%--        // const submit_val = $("#ClickMe").val();--%>
<%--    });--%>
<%--</script>--%>
</body>
</html>

