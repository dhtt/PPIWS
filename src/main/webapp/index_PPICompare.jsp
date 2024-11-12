<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--TODO: Safari appearance--%>
<html lang="en">
<head>
    <title>PPICompare</title>
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
    <script nonce="abc123def456"  type="module" src="js/jscolor.js"></script>
    <script type="module" src="js/functionality_PPICompare.js"></script>
    <script type="module" src="js/network_maker_PPICompare.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.0/FileSaver.min.js"> </script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<jsp:include page="html/header_PPICompare.html"/>

<div class="disabling_layer" id="disabling_window"></div>
<div id="already_open_window_popup" class="popup center-pop" style="display: none">
    <div class="menu header" style="width: 400px; font-size: small; padding: 1em">
        PPICompare is already open on another tab!
    </div>
    <p class="menu panel shadow" style="text-align: center; width: 400px; font-weight: normal; padding: 1em">
        <span>Please close this window<br>OR click "Stay here" to switch to working on this window<br><br></span>
        <span style="font-size: smaller; color: #707070">Note: PPICompare progress in other window will be continued here.
            <br>If you wish to begin a new analysis, please close all opening PPICompare windows
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
    <p class="menu panel shadow" style="text-align: center;width: fit-content;font-weight: normal;min-width: 250px;padding: 1em">
        <span>Do you wish to run a new analysis?<br>(All current results will be removed)<br><br></span>
        <button type="button" id="runNewAnalysis_yes" class="button upload" style="width: fit-content; margin: 0 1em">Yes</button>
        <button type="button" id="runNewAnalysis_no" class="button upload" style="width: fit-content; margin: 0 1em">No</button>
    </p>
</div>

<jsp:include page="html/PPIXpress2PPICompare.html"/>


<div id="AllPanels" class="container-body">
    <div id="LeftPanel" style="flex: 0 0 280px; margin-left: 1em">
        <form name="form" id="form" enctype="multipart/form-data">
            <div name="LeftPanel1" id="LeftPanel1">
                <p class="menu header">Step 1. Upload condition-specific<br>networks
                    <a href="./info_page_PPICompare.jsp#toCondPPINData" target="_blank"> 
                        <button type="button" name="protein_network_example" id="protein_network_example" class="help" title="Example input">?</button>
                    </a>
                    
                </p>
                <div class="menu panel" style="text-align: center;">
                    <div style="text-align: center; margin: 0; display: flex; margin-bottom: 0.5em; padding: 0 0.5em">
                        <div style="flex: 0 0 50%; overflow:hidden"> 
                            <!-- Input uploaded by user -->
                            <label for="PPIXpress_network_1" class="button upload" title="Control group">First group</label>
                            <label for="PPIXpress_network_1" id="PPIXpress_network_1_description" class="description-text">&emsp;</label>
                            <input type="file" name="PPIXpress_network" id="PPIXpress_network_1" accept=".zip" style="display: none">

                            <!-- Input from PPIXpress -->
                            <label for="PPIXpress_network_1_text" class="button upload" title="Control group" style="display: none;">First group</label>
                            <label for="PPIXpress_network_1_text" id="PPIXpress_network_1_text_description" class="description-text" style="display: none;">&emsp;</label>
                            <input type="text" name="PPIXpress_network_text" id="PPIXpress_network_1_text" style="display: none">
                        </div>
                        <div style="flex: 0 0 50%; overflow:hidden"> 
                            <!-- Input uploaded by user -->
                            <label for="PPIXpress_network_2" class="button upload" title="Experiment group">Second group</label>
                            <label for="PPIXpress_network_2" id="PPIXpress_network_2_description" class="description-text">&emsp;</label> 
                            <input type="file" name="PPIXpress_network" id="PPIXpress_network_2" accept=".zip" style="display: none">

                            <!-- Input from PPIXpress -->
                            <label for="PPIXpress_network_2_text" class="button upload" title="Control group" style="display: none;">Second group</label>
                            <label for="PPIXpress_network_2_text" id="PPIXpress_network_2_text_description" class="description-text" style="display: none;">&emsp;</p></label>
                            <input type="text" name="PPIXpress_network_text" id="PPIXpress_network_2_text" style="display: none">
                        </div>
                    </div>
                    <span style="display:flex; margin-top: -1em">
                        <span name="Reset" id="ResetRunOptions" class="reset" style="flex:1; margin-top: 1em; text-align: center">Reset</span><br>
                    </span>
                </div>
            </div>

            <div name="LeftPanel2" id="LeftPanel2">
                <p class="menu header">Step 2. Adjust Run Options</p>
                <div class="menu panel">
                    <span style="display:flex; width: 280px; margin-top: -1em">
                        <span class="subsection-text" style="flex:1;">Options</span>
                        <span name="Reset" id="ResetRunOptions" class="subsection-text reset" style="flex:1;">Reset</span><br>
                    </span>

                    <label style="display: none;">
                        <input checked type="checkbox" name="RunOptions" id="return_protein_attribute" value="-x">Return protein attribute table 
                    </label>

                    <span class="subsection-text" style="flex:1; text-align: center">
                        <label for="fdr">FDR</label>
                        <input type="number" id="fdr" value="0.05" min="0" max="1.0" step="0.005">
                    </span>
                </div>
            </div>

            <div name="LeftPanel3" id="LeftPanel3" style="text-align: center">
                <button type="submit" name="Submit" id="RunNormal" value="null" class="button submit" style="font-size: medium; ">Run PPICompare</button>
                <button type="submit" name="Submit" id="RunExample" value="null" class="button try">Try with example data!</button>
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
                <div id="LeftDisplay" class="display-part">
                    <div id="RPContent" name="RunningProgress"></div>
                    <div id="Loader" name="RunningProgress" style="display: none; position: relative;"></div>
                    <div name="AfterRunOptions" name="RunningProgress" id="AfterRunOptions" class="shadow" style="display: none; max-width: 30%; margin: 1em auto; border-radius: 1em">
                        <p class="header" style="color: white; text-shadow: var(--textshadow)"> PPICompare pipeline is finished! </p>
                        <div class="panel" style="background: white; text-align: center">
                            <button type="button" name="transit" id="downloadLogFile" value="null" class="button download">Download Log File</button><br>
                            <button type="button" name="transit" id="downloadResultFiles" value="null" class="button download">Download Result Files</button><br>
                            <div class="star" name="Star" id="toNetworkVisualization_star"></div>
                            <button type="button" name="transit" id="toNetworkVisualization" value="null" class="button download">Visualize Differential Networks</button><br>
                            <button type="button" name="transit" id="runNewAnalysis" value="null" class="button download">Run a new analysis</button><br>
                        </div>
                    </div>
                    <p name="ScrollToTop" class="reset" style="display: none; text-align: center">Scroll to top</p>
                </div>
            </div>


            <div id="NetworkVisualizationContent" name="Display" class="display-content non-display" style="display: flex; flex-direction: column">
                <div id="NVContent" style="display: flex; flex-direction: column; flex: 1 1 auto">
                    <div id="NVContent_Graph_with_Legend" style="flex: 1 1 auto; z-index: 0">
                        <div id="NVContent_Graph" style="position: absolute;"></div>
                        <div id="NVContent_Legend" class="graph_legend"></div>
                    </div>

                    <div id="NVOptions" class="align_box_right" style="flex: 1 1 auto;">
                        <div class="network-option panel" id="ShowNetworkOptions">Show / Collapse Options</div>

                        <div class="star2" name="Star" id="ShowNetworkMain_star" style="left: 0"></div>
                        <div class="network-option panel" name="NetworkOptions" id="ShowNetworkMain" style="text-align: center; border-radius: 1em">
                            <span style="font-weight: bold">Differential PPI network</span><br>
                            <!-- button-typed items are enabled when UPDATE_LONG_PROCESS_SIGNAL === true. Then, class 'upload' is added to style the buttons -->
                            <button type="button" disabled id="ShowNetwork" value="null" class="button graph-menu-button">Show</button>
                            <button type="button" disabled id="DownloadSubnetwork" value="null" class="button graph-menu-button">Download</button>
                        </div>

                        <div class="star2" name="Star" id="ShowNetworkSub_star"></div>
                        <div class="network-option panel" name="NetworkOptions" id="ShowNetworkSub" style="text-align: center; border-radius: 1em">
                            <label for="NetworkSelection_HighlightProtein" style="font-weight: bold">Show subnetwork</label><br>
                            <select id="NetworkSelection_HighlightProtein" class="button upload" style="margin: 0.5em 0; width: min-content; font-size: smaller" data-placeholder="UniProt ID"></select><br>
                            
                            <div style="align-items: baseline;justify-content: space-evenly;display: flex;flex-direction: row">
                                <!-- TODO: ShowSubnetwork class same or not? -->
                                <button type="button" disabled id="ShowSubnetwork" value="null" class="button graph-menu-button" style="display: none">Show</button>
                                <label for="NetworkSelection_HighlightProtein_All" class="button graph-menu-button radio-button disabled">Show<input type="radio" disabled="" name="NetworkSelection_HighlightProtein_Option" value="all" id="NetworkSelection_HighlightProtein_All" style="display: none;"></label>
                                <label for="NetworkSelection_HighlightProtein_Focus" class="button graph-menu-button radio-button disabled">Focus<input type="radio" disabled="" name="NetworkSelection_HighlightProtein_Option" value="focus" id="NetworkSelection_HighlightProtein_Focus" style="display: none;"></label>
                                <label for="NetworkSelection_UnhighlightProtein" class="reset" style="font-size: smaller;">Reset<input type="radio" disabled="" name="NetworkSelection_HighlightProtein_Option" value="reset" id="NetworkSelection_UnhighlightProtein" style="display: none;"></label>
                            </div>
                        </div>                            
                        

                        <div class="network-option panel" name="NetworkOptions" id="CustomizeNetworkOptions" style="text-align: center; border-radius: 1em">
                            <span style="font-weight: bold">Customize network display</span>
                            <div style="display: flex; flex-direction: row; padding: 1em; line-height: 2em">
                                <div style="text-align: left; flex: auto">
                                    <label for="ToggleProteinID" style="font-weight: bold; font-size: smaller">Protein ID</label><br>
                                    <label for="changeNodeSize" style="font-weight: bold; font-size: smaller">Node size</label><br>
                                    <label for="ToggleTranscriptomicAlteration" style="font-weight: bold; font-size: smaller">Alteration type</label><br>
                                    <label for="ToggleRelativeImportance" style="font-weight: bold; font-size: smaller">Relative importance</label><br>
                                    <label for="ToggleMinReasons" style="font-weight: bold; font-size: smaller">Min reasons</label>
                                </div>
                                <div style="text-align: right; width: min-content">
                                    <select name="ApplyGraphStyle" id="ToggleProteinID" disabled>
                                        <option value="UniProtID" selected="selected">UniProt</option>
                                        <option value="SymbolID">Symbol</option>
                                    </select><br>    
                                    <input type="range" name="ApplyGraphStyle" id="changeNodeSize" disabled value="10" min="0.5" max="25" step="1" style="width: 100%; height: 0.5em">
                                    
                                    <div style="display: flex; float: right; position: relative;">
                                        <input type="checkbox" name="ApplyGraphStyle" id="ToggleTranscriptomicAlteration" disabled value="0" min="0" max="1" step="1" class="toggle_input">
                                        <div style="position: absolute">
                                            <span class="toggle_slider"></span>
                                            <span class="toggle_button"></span>
                                        </div>
                                    </div>

                                    <div style="display: flex; float: right; position: relative;">
                                        <input type="checkbox" name="ApplyGraphStyle" id="ToggleRelativeImportance" disabled value="0" min="0" max="1" step="1" class="toggle_input">
                                        <div style="position: absolute">
                                            <span class="toggle_slider"></span>
                                            <span class="toggle_button"></span>
                                        </div>
                                    </div>

                                    <div style="display: flex; float: right; position: relative;">
                                        <input type="checkbox" name="ApplyGraphStyle" id="ToggleMinReasons" disabled value="0" min="0" max="1" step="1" class="toggle_input">
                                        <div style="position: absolute">
                                            <span class="toggle_slider"></span>
                                            <span class="toggle_button"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div style="padding: 1em">
                                <span style="font-weight: bold; font-size: smaller">Customize colors</span>
                                <div style="display: flex; flex-direction: row; line-height: 2em">
                                    <div style="text-align: left; flex: auto">
                                        <label for="ToggleBackgroundColor" style="font-size: smaller">Background color</label><br>
                                        <label for="ProteinColor" style="font-size: smaller">Protein </label><br>
                                        <label for="LostEdgeColor" style="font-size: smaller">Lost edge </label><br>
                                        <label for="GainedEdgeColor" style="font-size: smaller">Gained edge </label><br>
                                        <label for="HighlightedProteinColor" style="font-size: smaller">Highlighted protein </label><br>
                                    </div>
                                    <div style="text-align: right; width: min-content">
                                        <select name="ApplyGraphStyle" id="ToggleBackgroundColor" disabled> 
                                            <option value="white">White</option>
                                            <option value="black">Black</option>
                                        </select><br>
                                        <button name="changeGraphColor" id="ProteinColor" data-jscolor="{valueElement: '#--protein'}"></button><br>
                                        <button name="changeGraphColor" id="LostEdgeColor" data-jscolor="{valueElement: '#--lostedge'}"></button><br>
                                        <button name="changeGraphColor" id="GainedEdgeColor" data-jscolor="{valueElement: '#--gainededge'}"></button><br>
                                        <button name="changeGraphColor" id="HighlightedProteinColor" data-jscolor="{valueElement: '#--highlightedprotein'}"></button><br>
                                    </div>
                                </div>
                            </div>
                            
                            <button type="button" name="ApplyGraphStyle" id="ApplyGraphColor" disabled value="null" class="button graph-menu-button">Apply color changes</button>
                        </div>
                    </div>
                    <p id="WarningMessage" class="warning" style="display: none; flex: 1 1 auto"></p>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="html/footer.html"/>
</body>
</html>

