<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html lang="en">
<head>
    <title>PPIXpress</title>
    <link rel="stylesheet" href="css/interface.css">
    <link rel="stylesheet" href="css/header-and-panel.css">
    <link rel="stylesheet" href="css/cytoscape-style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.0/FileSaver.min.js"> </script>
    <script type="module" src="js/help-page-functionality.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<jsp:include page="header.html"/>
<div>
    <div id="AllPanels" class="container-body">
        <div style="flex: 0 0 280px; margin-left: 1em">
            <div id="MenuPanel" class="menu panel shadow" style="position: fixed; padding: 0; border-radius: 1em; margin-top: 1em">
                <div>
                    <p name="HelpMenu" id="Instruction" class="help-panel DefaultHelpMenu" style="border-radius: 1em 1em 0 0;">Instruction</p>
                    <p name="HelpMenu" id="ProteinInteractionData" class="help-panel-sub">Protein interaction data</p>
                    <p name="HelpMenu" id="ExpressionData" class="help-panel-sub">Expression data</p>
                    <p name="HelpMenu" id="PPIXpressRunOptions" class="help-panel-sub">PPIXpress run options</p>
                    <p name="HelpMenu" id="ExampleData" class="help-panel-sub">Example data</p>
                </div>
                <div>
                    <p name="HelpMenu" id="PPIXpressOutput" class="help-panel">PPIXpress Output</p>
                    <p name="HelpMenu" id="MainOutputFile" class="help-panel-sub">Main output file</p>
                    <p name="HelpMenu" id="PipelineLogFile" class="help-panel-sub">Pipeline log file</p>
                    <p name="HelpMenu" id="SampleSummaryFile" class="help-panel-sub">Sample summary file</p>
                    <p name="HelpMenu" id="SubnetworkVisualization" class="help-panel-sub">Subnetwork visualization</p>
                </div>
                <div>
                    <p name="HelpMenu" id="PPIXpressStandaloneTool" class="help-panel">PPIXpress Standalone Tool</p>
                    <p name="HelpMenu" id="Download" class="help-panel-sub">Download</p>
                    <p name="HelpMenu" id="Documentation" class="help-panel-sub">Documentation</p>
                    <p name="HelpMenu" id="Contact" class="help-panel-sub">Contact</p>
                </div>
                <div>
                    <p name="HelpMenu" id="Citation" class="help-panel" style="border-radius: 0 0 1em 1em;">Cite PPIXpress</p>
                </div>
            </div>
        </div>
        <div id="RightPanel" class="middle-under" style="flex: 1; display: flex; flex-flow: column;">
            <div id="toInstruction">
                <p class="menu header help-section-title">Instruction</p>
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <span id="toProteinInteractionData" style="font-weight: bold; text-transform: uppercase">Protein interaction data</span><br>
                        <span>Text</span>
                    </div>
                    <div class="help-section-body">
                        <span id="toExpressionData" style="font-weight: bold; text-transform: uppercase">Expression data</span><br>
                        <span>Text</span>
                    </div>
                    <div class="help-section-body">
                        <span id="toPPIXpressRunOptions" style="font-weight: bold; text-transform: uppercase">PPIXpress run options</span><br>
                        <span>Text</span>
                    </div>
                    <div class="help-section-body">
                        <span id="toExampleData" style="font-weight: bold; text-transform: uppercase">Example data</span><br>
                        <span>Text</span>
                    </div>
                </div>
            </div>

            <div id="toPPIXpressOutput">
                <p class="menu header help-section-title">PPIXpress Output</p>
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <span id="toMainOutputFile" style="font-weight: bold; text-transform: uppercase">Main output file</span><br>
                        <span>Text</span>
                    </div>
                    <div class="help-section-body">
                        <span id="toPipelineLogFile" style="font-weight: bold; text-transform: uppercase">Pipeline log file</span><br>
                        <span>Text</span>
                    </div>
                    <div class="help-section-body">
                        <span id="toSampleSummaryFile" style="font-weight: bold; text-transform: uppercase">Sample summary file</span><br>
                        <span>Text</span>
                    </div>
                    <div class="help-section-body">
                        <span id="toSubnetworkVisualization" style="font-weight: bold; text-transform: uppercase">Subnetwork visualization</span><br>
                        <span>Text</span>
                    </div>
                </div>
            </div>

            <div id="toPPIXpressStandaloneTool">
                <p class="menu header help-section-title">PPIXpress Standalone Tool</p>
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <span id="toDownload" style="font-weight: bold; text-transform: uppercase">Download</span><br>
                        <span>Text</span>
                    </div>
                    <div class="help-section-body">
                        <span id="toDocumentation" style="font-weight: bold; text-transform: uppercase">Documentation</span><br>
                        <span>Text</span>
                    </div>
                    <div class="help-section-body">
                        <span id="toContact" style="font-weight: bold; text-transform: uppercase">Contact</span><br>
                        <span>Text</span>
                    </div>
                </div>
            </div>
            <div id="toCitation">
                <p class="menu header help-section-title">Citation</p>
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <span>Text</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
