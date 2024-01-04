<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--TODO: Safari appearance--%>
<html lang="en">
<head>
    <title>PPICompare</title>
    <link rel="stylesheet" href="css/theme_blue.css">
    <link rel="stylesheet" href="css/interface.css">
    <link rel="stylesheet" href="css/header-and-panel.css">
    <link rel="stylesheet" href="css/cytoscape-style.css">
    <link rel="stylesheet" href="css/select2_custom_style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"/> -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/css/select2.min.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/dom-to-image/2.6.0/dom-to-image.min.js"></script>
    <!-- <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css"/> -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-colorpicker/3.4.0/js/bootstrap-colorpicker.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.21.0/cytoscape.min.js"> </script>
    <script src="webjars/cytoscape-cose-bilkent/4.0.0/cytoscape-cose-bilkent.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/js/select2.full.min.js"></script>
    <script type="module" src="js/cytoscape-expand-collapse.js"></script>
    <script type="module" src="js/jscolor.js"></script>
    <script type="module" src="js/functionality_PPICompare.js"></script>
    <script type="module" src="js/network_maker_PPICompare.js"></script>
    <!-- <script type="module" src="js/jsTest.js"></script> -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.0/FileSaver.min.js"> </script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<jsp:include page="header_PPICompare.html"/>
<div style="display: none">
    <button name="CSS_Style" id="--cottonblue" style="color: var(--cottonblue)"></button>
    <button name="CSS_Style" id="--darkcottonblue" style="color: var(--darkcottonblue)"></button>
    <button name="CSS_Style" id="--choco" style="color: var(--choco)"></button>
    <button name="CSS_Style" id="--mint" style="color: var(--mint)"></button>
    <button name="CSS_Style" id="--lightmintgrey" style="color: var(--lightmintgrey)"></button>
    <button name="CSS_Style" id="--intensemint" style="color: var(--intensemint)"></button>
    <button name="CSS_Style" id="--darkintensemint" style="color: var(--darkintensemint)"></button>
    <button name="CSS_Style" id="--ultradarkmint" style="color: var(--ultradarkmint)"></button>
    <button name="CSS_Style" id="--deeppink" style="color: var(--deeppink)"></button>
    <button name="CSS_Style" id="--darkdeeppink" style="color: var(--darkdeeppink)"></button>
    <button name="CSS_Style" id="--protein" style="color: var(--protein)"></button>
    <button name="CSS_Style" id="--lostedge" style="color: var(--lostedge)"></button>
    <button name="CSS_Style" id="--gainededge" style="color: var(--gainededge)"></button>
    <button name="CSS_Style" id="--highlightedprotein" style="color: var(--highlightedprotein)"></button>
    <button name="CSS_Style" id="--shadow" style="color: var(--shadow)"></button>
    <button name="CSS_Style" id="--textshadow" style="color: var(--textshadow)"></button>
    <button name="CSS_Style" id="--warning" style="color: var(--warning)"></button>
</div>

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

<div id="AllPanels" class="container-body">
    <div id="LeftPanel" style="flex: 0 0 280px; margin-left: 1em">
        <form name="form" id="form" enctype="multipart/form-data">
            <div name="LeftPanel1" id="LeftPanel1">
                <p class="menu header">Upload condition specific<br>networks</p>
                <div class="menu panel" style="text-align: center;">
                    <div style="text-align: center; margin: 0; display: flex; margin-bottom: 0.5em; padding: 0 0.5em">
                        <div style="flex: 0 0 50%; overflow:hidden"> 
                            <label for="PPIXpress_network_1" class="button upload" title="??">First group</label>
                            <input type="file" name="PPIXpress_network" id="PPIXpress_network_1" accept=".zip" style="display: none">
                            <p id="PPIXpress_network_1_description" class="description-text">&emsp;</p>
                        </div>
                        <div style="flex: 0 0 50%; overflow:hidden"> 
                            <label for="PPIXpress_network_2" class="button upload" title="??">Second group</label>
                            <input type="file" name="PPIXpress_network" id="PPIXpress_network_2" accept=".zip" style="display: none">
                            <p id="PPIXpress_network_2_description" class="description-text">&emsp;</p> 
                        </div>
                    </div>
                    <span>&nbsp;or get help&nbsp;</span>
                    <button type="button" name="protein_network_example" id="protein_network_example" class="help" title="Example input">?</button>
                </div>
            </div>

            <div name="LeftPanel2" id="LeftPanel2">
                <p class="menu header">Run Options</p>
                <div class="menu panel">
                    <span style="display:flex; width: 280px; margin-top: -1em">
                        <span class="subsection-text" style="flex:1;">Options</span>
                        <span name="Reset" id="ResetRunOptions" class="subsection-text reset" style="flex:1;">Reset</span><br>
                    </span>

                    <label>
                        <input type="checkbox" name="RunOptions" id="return_protein_attribute" value="-x">Return protein attribute table 
                    </label><br><br>

                    <span class="subsection-text" style="flex:1; text-align: center">
                        <label for="fdr">FDR</label>
                        <input type="number" id="fdr" value="0.05" min="0" max="1.0" step="0.005">
                    </span>
                </div>
            </div>

            <div name="LeftPanel3" id="LeftPanel3" style="text-align: center">
                <button type="submit" name="Submit" id="RunNormal" value="null" class="button submit" style="font-size: medium; ">Run PPICompare</button>
                <button type="submit" name="Submit" id="RunExample" value="null" class="button try">or Try with example data!</button>
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

                        <div class="network-option panel" name="NetworkOptions" style="text-align: center; border-radius: 1em">
                            <label style="font-weight: bold">Differential PPI network</label><br>
                            <!-- button-typed items are enabled when UPDATE_LONG_PROCESS_SIGNAL === true. Then, class 'upload' is added to style the buttons -->
                            <button type="button" disabled name="ShowSubnetwork" id="ShowSubnetwork" value="null" class="button graph-menu-button">Show</button>
                            <button type="button" disabled name="ApplyGraphStyle" id="DownloadSubnetwork" value="null" class="button graph-menu-button">Download</button>
                        </div>

                        <div class="network-option panel" name="NetworkOptions" id="NetworkOptions" style="text-align: center; border-radius: 1em">
                            <label style="font-weight: bold">Customize network display</label>
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
                                        <option value="UniProtID">UniProt</option>
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

                            <div>
                                <label for="NetworkSelection_HighlightProtein" style="font-weight: bold; font-size: smaller">View a protein (UniProt ID)</label><br>
                                <select id="NetworkSelection_HighlightProtein" class="button upload" style="margin: 0.5em 0; width: min-content; font-size: smaller" data-placeholder="UniProt ID"></select><br>
                                
                                <button type="button" disabled name="ApplyGraphStyle" id="NetworkSelection_HighlightProtein_All" value="null" class="button graph-menu-button">Highlight</button>
                                <button type="button" disabled name="ApplyGraphStyle" id="NetworkSelection_HighlightProtein_Single" value="null" class="button graph-menu-button">Focus</button>
                                <!-- TODO -->
                                <input type="checkbox" id="ToggleNetworkSelection_HighlightProtein" value="0" min="0" max="1" step="1" class="toggle_input">
                                <span class="toggle_button_with_text button" style="width: fit-content; background: var(--deeppink); position: absolute">Highlight</span>
                                
                                <button type="button" disabled name="ApplyGraphStyle" id="NetworkSelection_UnhighlightProtein" class="subsection-text reset button" style="font-size: smaller; margin: 0" title="Reset">❌<br>
                            </div>                            
                            
                            <div style="padding: 1em">
                                <label style="font-weight: bold; font-size: smaller">Customize colors</label>
                                <div style="display: flex; flex-direction: row; line-height: 2em">
                                    <div style="text-align: left; flex: auto">
                                        <label for="ToggleBackgroundColor" style="font-size: smaller">Background color</label><br>
                                        <label for="ProteinColor" style="font-size: smaller">Protein </label><br>
                                        <label for="LostEdgeColor" style="font-size: smaller">Lost Edge </label><br>
                                        <label for="GainedEdgeColor" style="font-size: smaller">Gained Edge </label><br>
                                        <label for="HighlightedProteinColor" style="font-size: smaller">Highlighted Protein </label><br>
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

