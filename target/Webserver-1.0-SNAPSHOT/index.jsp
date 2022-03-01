<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>

<html>
<head>
    <title>PPIXpress</title>
    <link rel="stylesheet" href="css/page-setting.css">
</head>
<body>
<jsp:include page="html/header.html" />

<div>
    <p class="menu-header">Load Protein Interaction Data</p>
    <div class="menu-panel">
        <p style="text-align: center; margin: 0">
            <label for="protein_network_file" class="upload-button">From file</label><input type="file" name="protein_network_file" id="protein_network_file" style="display: none">
            &nbsp;or&nbsp;
            <label for="protein_network_web" class="upload-button">From web</label><input type="file" name="protein_network_web" id="protein_network_web" style="display: none">
            <button type="button" name="protein_network_example" id="protein_network_example" class="help-button">?</button>
        </p>
        <p class="menu-subsection-text">Options</p>
        <label for="STRINGWeight"><input type="checkbox" name="PPIOptions" id="STRINGWeight" value="Add STRING weights"> Add STRING weights</label><br>
        <label for="UniProtAcc"><input type="checkbox" name="PPIOptions" id="UniProtAcc" value="Update UniProt accessions"> Update UniProt accessions</label><br>
        <label for="LocalDDI"><input type="checkbox" name="PPIOptions" id="LocalDDI" value="Only local DDI data"> Only local DDI data</label><br>
        <label for="ELMData"><input type="checkbox" name="PPIOptions" id="ELMData" value="Include ELM data"> Include ELM data</label>
    </div>
</div>

<div>
    <p class="menu-header">Load Pre-Processed Expression Data</p>
    <div class="menu-panel">
        <p style="text-align: center; margin: 0">
            <label for="expression_file" class="upload-button">Upload file(s)</label><input type="file" multiple name="expression_file" id="expression_file" style="display: none">
            <button type="button" name="expression_example" id="expression_example" class="help-button">?</button>
        </p>
        <p class="menu-subsection-text">Options</p>
        <label for="GeneLevelOnly"><input type="checkbox" name="ExpOptions" id="GeneLevelOnly" value="Gene-level only">Gene-level only</label><br>
        <label for="PercentileBased"><input type="checkbox" name="ExpOptions" id="PercentileBased" value="Percentile-based">Percentile-based</label><br>
        <label for="ExpressionLevelThreshold">Expression Level Threshold<input type="text" value="1.0" id="ExpressionLevelThreshold"></label>
    </div>
</div>

<div>
    <p class="menu-header">Run Options</p>
    <div class="menu-panel">
        <label for="OutputReferenceNetwork"><input type="checkbox" name="RunOptions" id="OutputReferenceNetwork" value="Output reference network"> Output reference network</label><br>
        <label for="OutputDDINs"><input type="checkbox" name="RunOptions" id="OutputDDINs" value="Output DDINs"> Output DDINs</label><br>
        <label for="OutputMajorTranscripts"><input type="checkbox" name="RunOptions" id="OutputMajorTranscripts" value="Output major transcripts"> Output major transcripts</label><br>
        <label for="CompressOutput"><input type="checkbox" name="RunOptions" id="CompressOutput" value="Compress output"> Compress output</label>
    </div>
</div>

<div>
    <div class="menu-panel" style="background-color: white">
        <input type="submit" name="submit_try" value="Try with example data!" class="submit-button" style="background-color: white; text-decoration: underline; color: darkgrey; width: 320px">
        <input type="submit" name="submit_data" value="Run PPIXpress" class="submit-button" style="background-color: #433C39; color: white; width: 320px; margin: 0 0.2em 0.2em 0">
    </div>
</div>


<jsp:include page="html/footer.html" />
</body>
</html>
