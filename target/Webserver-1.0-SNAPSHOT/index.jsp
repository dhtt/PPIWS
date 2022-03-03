<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>

<html>
<head>
    <title>PPIXpress</title>
    <link rel="stylesheet" href="css/interface.css">
    <link rel="stylesheet" href="css/header-and-panel.css">
    <script src="js/result-tab.js"></script>
</head>
<body>
<jsp:include page="html/header.html" />

<div class="container-body">
    <div style="flex: 0 0 280px; margin-left: 1em">
        <div>
            <p class="menu header">Load Protein Interaction Data</p>
            <div class="menu panel">
                <p style="text-align: center; margin: 0">
                    <label for="protein_network_file" class="button upload">From file</label><input type="file" name="protein_network_file" id="protein_network_file" style="display: none">
                    &nbsp;or&nbsp;
                    <label for="protein_network_web" class="button upload">From web</label><input type="file" name="protein_network_web" id="protein_network_web" style="display: none">
                    <button type="button" name="protein_network_example" id="protein_network_example" class="help">?</button>
                </p>
                <p class="subsection-text">Options</p>
                <label for="STRINGWeight"><input type="checkbox" name="PPIOptions" id="STRINGWeight" value="Add STRING weights"> Add STRING weights</label><br>
                <label for="UniProtAcc"><input type="checkbox" name="PPIOptions" id="UniProtAcc" value="Update UniProt accessions"> Update UniProt accessions</label><br>
                <label for="LocalDDI"><input type="checkbox" name="PPIOptions" id="LocalDDI" value="Only local DDI data"> Only local DDI data</label><br>
                <label for="ELMData"><input type="checkbox" name="PPIOptions" id="ELMData" value="Include ELM data"> Include ELM data</label>
            </div>
        </div>

        <div>
            <p class="menu header">Load Processed Expression Data</p>
            <div class="menu panel">
                <p style="text-align: center; margin: 0">
                    <label for="expression_file" class="button upload">Upload file(s)</label><input type="file" multiple name="expression_file" id="expression_file" style="display: none">
                    <button type="button" name="expression_example" id="expression_example" class="help">?</button>
                </p>
                <p class="subsection-text">Options</p>
                <label for="GeneLevelOnly"><input type="checkbox" name="ExpOptions" id="GeneLevelOnly" value="Gene-level only">Gene-level only</label><br>
                <label for="PercentileBased"><input type="checkbox" name="ExpOptions" id="PercentileBased" value="Percentile-based">Percentile-based</label><br>
                <label for="ExpressionLevelThreshold" style="margin-left: 1em">Expression Level Threshold<input type="text" value="1.0" id="ExpressionLevelThreshold"></label>
            </div>
        </div>

        <div>
            <p class="menu header">Run Options</p>
            <div class="menu panel">
                <label for="OutputReferenceNetwork"><input type="checkbox" name="RunOptions" id="OutputReferenceNetwork" value="Output reference network"> Output reference network</label><br>
                <label for="OutputDDINs"><input type="checkbox" name="RunOptions" id="OutputDDINs" value="Output DDINs"> Output DDINs</label><br>
                <label for="OutputMajorTranscripts"><input type="checkbox" name="RunOptions" id="OutputMajorTranscripts" value="Output major transcripts"> Output major transcripts</label><br>
                <label for="CompressOutput"><input type="checkbox" name="RunOptions" id="CompressOutput" value="Compress output"> Compress output</label>
            </div>
        </div>

        <div style="text-align: center">
            <input type="submit" name="submit" value="Run PPIXpress" class="button submit" style="margin: 0">
            <input type="submit" name="submit" value="or Try with example data!" class="button try">
        </div>
    </div>

    <div class="middle-under" style="flex: 1; display: flex; flex-flow: column;">
        <div class="tabs" style="flex: 0 1 auto">
            <button class="header button-tab active" type="button" name="Display" id="RunningProgress" onclick="getContent('RunningProgress')">Running Progress</button>
            <button class="header button-tab" type="button" name="Display" id="ResultSummary" onclick="getContent('ResultSummary')">Result Summary</button>
            <button class="header button-tab" type="button" name="Display" id="NetworkVisualization" onclick="getContent('NetworkVisualization')">Network Visualization</button>
        </div>
        <div class="display" style="flex: 1 1 auto">
            <div class="display-content" name="RunningProgress" id="RunningProgress_c" style="font-size: large">Page 1</div>
            <div class="display-content non-display" name="ResultSummary" id="ResultSummary_c" style="font-size: medium">Page 2</div>
            <div class="display-content non-display" name="NetworkVisualization" id="NetworkVisualization_c" style="font-size: small">Page 3</div>
        </div>
    </div>
</div>

<jsp:include page="html/footer.html" />
</body>
</html>
