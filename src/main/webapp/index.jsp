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
    <script src="js/result-tab.js"></script>
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
                        <label for="protein_network_file" class="button upload">From file</label>
                        <input type="file" name="protein_network_file" id="protein_network_file" style="display: none" >
                        &nbsp;or&nbsp;
                        <label for="protein_network_web" class="button upload">From web</label>
                        <input type="file" name="protein_network_web" id="protein_network_web" style="display: none">
                        <button type="button" name="protein_network_example" id="protein_network_example" class="help">?</button>
                    </p>
                    <p class="subsection-text">Options</p>
                    <input type="checkbox" name="PPIOptions" id="STRINGWeight" value="Add STRING weights">
                    <label for="STRINGWeight">Add STRING weights</label><br>
                    <input type="checkbox" name="PPIOptions" id="UniProtAcc" value="Update UniProt accessions">
                    <label for="UniProtAcc">Update UniProt accessions</label><br>
                    <input type="checkbox" name="PPIOptions" id="LocalDDI" value="Only local DDI data">
                    <label for="LocalDDI">Only local DDI data</label><br>
                    <input type="checkbox" name="PPIOptions" id="ELMData" value="Include ELM data">
                    <label for="ELMData">Include ELM data</label>
                </div>
            </div>

            <div name="LeftPanel2" id="LeftPanel2">
                <p class="menu header">Load Processed Expression Data</p>
                <div class="menu panel">
                    <p style="text-align: center; margin: 0">
                        <label for="expression_file" class="button upload">Upload file(s)</label>
                        <input type="file" name="expression_file" id="expression_file" style="display: none" multiple>
                        <button type="button" name="expression_example" id="expression_example" class="help">?</button>
                    </p>
                    <p class="subsection-text">Options</p>
                    <input type="checkbox" name="ExpOptions" id="GeneLevelOnly" value="Gene-level only">
                    <label for="GeneLevelOnly">Gene-level only</label><br>
                    <input type="checkbox" name="ExpOptions" id="PercentileBased" value="Percentile-based">
                    <label for="PercentileBased">Percentile-based</label><br>
                    <label for="ExpressionLevelThreshold" style="margin-left: 1em">Expression Level Threshold</label>
                    <input type="text" value="1.0" id="ExpressionLevelThreshold">
                </div>
            </div>

            <div name="LeftPanel3" id="LeftPanel3">
                <p class="menu header">Run Options</p>
                <div class="menu panel">
                    <input type="checkbox" name="RunOptions" id="OutputReferenceNetwork" value="Output reference network">
                    <label for="OutputReferenceNetwork">Output reference network</label><br>
                    <input type="checkbox" name="RunOptions" id="OutputDDINs" value="Output DDINs">
                    <label for="OutputDDINs">Output DDINs</label><br>
                    <input type="checkbox" name="RunOptions" id="OutputMajorTranscripts" value="Output major transcripts">
                    <label for="OutputMajorTranscripts">Output major transcripts</label><br>
                    <input type="checkbox" name="RunOptions" id="CompressOutput" value="Compress output">
                    <label for="CompressOutput">Compress output</label>
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
                Page 1
            </div>
            <div id="ResultSummaryContent" name="ResultSummary" class="display-content non-display">
                Page 2
            </div>
            <div id="NetworkVisualizationContent" name="NetworkVisualization" class="display-content non-display" style="width: 50%; height: 300px; overflow: hidden;">
                Example network
            </div>
<%--            <div id="cy" style="width: 90%; height: 300px; display: block; overflow: hidden;"></div>--%>
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

