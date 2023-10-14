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
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-colorpicker/3.4.0/js/bootstrap-colorpicker.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.21.0/cytoscape.min.js"> </script>
    <script src="webjars/cytoscape-cose-bilkent/4.0.0/cytoscape-cose-bilkent.js"></script>
    <script type="module" src="js/cytoscape-expand-collapse.js"></script>
    <script type="module" src="js/jscolor.js"></script>
    <!-- <script type="module" src="js/functionality.js"></script> -->
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
    <button name="CSS_Style" id="--lostedge" style="color: var(--lostedge)"></button>
    <button name="CSS_Style" id="--gainededge" style="color: var(--gainededge)"></button>
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
                <div class="menu panel">
                    <div style="text-align: center; margin: 0">
                        <label for="PPIXpress_network_1" class="button upload" title="??">First group</label>
                        <input type="file" name="PPIXpress_network_1" id="PPIXpress_network_1" accept=".zip" style="display: none">
<%--                        TODO: Make input accept gzip --%>
                        <label for="PPIXpress_network_2" class="button upload" title="??">Second group</label>
                        <input type="file" name="PPIXpress_network_2" id="PPIXpress_network_2" accept=".zip" style="display: none">
<%--                        TODO: Make input accept gzip --%>
                        
                        <br><br>&nbsp;or get help&nbsp;
                        <button type="button" name="protein_network_example" id="protein_network_example" class="help" title="Example input">?</button>
                    </div>
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
<%--                <h4>Please first run PPICompare and check for progress in Running Progress.</h4>--%>

                <div id="NVContent" style="display: flex; flex-direction: column; flex: 1 1 auto">
                    <div id="NVContent_Graph" style="flex: 1 1 auto; z-index: 0"></div>

                    <div id="NVOptions" class="align_box_right" style="flex: 1 1 auto; text-align: center">
                        <div class="network-option panel" id="ShowNetworkOptions" style="text-align: center; border-radius: 0 0 1em 1em; background: var(--deeppink); color: white; text-shadow: 0 0.1em 0.15em rgb(0 0 0 / 40%); padding: 0.5em 0">Show / Collapse Options</div>

                        <div class="network-option panel" name="NetworkOptions" style="text-align: center; border-radius: 1em">
                            <button type="button" name="ShowSubnetwork" id="ShowSubnetwork" value="null" class="button upload graph-menu-button">Show</button>
                            <button type="button" disabled name="ApplyGraphStyle" id="DownloadSubnetwork" value="null" class="button graph-menu-button">Download</button>
                        </div>

                        <div class="network-option panel" name="NetworkOptions" id="NetworkOptions" style="text-align: center; border-radius: 1em">
                            <label style="font-weight: bold">Customize network display</label>

                            <div style="display: flex; flex-direction: row; padding: 1em; line-height: 2em">
                                <div style="text-align: left; flex: auto">
                                    <label for="ToggleExpandCollapse" style="font-weight: bold; font-size: smaller">Display mode</label><br>
                                    <label for="changeLayout" style="font-weight: bold; font-size: smaller">Graph layout</label><br>
                                    <label for="changeNodeSize" style="font-weight: bold; font-size: smaller">Node size</label>
                                </div>
                                <div style="text-align: right; width: min-content">
                                    <select name="ApplyGraphStyle" id="ToggleExpandCollapse" disabled>
                                        <option value="collapseAll">Collapse all</option>
                                        <option value="expandAll">Expand all</option>
                                    </select><br>
                                    <select name="ApplyGraphStyle" id="changeLayout" disabled>
                                        <option value="cose-bilkent">Cose-bilkent</option>
                                        <option value="circle">Circle</option>
                                    </select><br>
                                    <input type="range" name="ApplyGraphStyle" id="changeNodeSize" disabled value="15" min="1" max="50" step="5" style="width: 100%; height: 0.5em"><br>
                                </div>
                            </div>

                            <label style="font-weight: bold; font-size: smaller">Customize colors</label>
                            <div style="display: flex; flex-direction: row; padding: 0 1em 1em 1em">
                                <div style="flex-basis: 50%; text-align: right">
                                    <label style="font-size: smaller">Protein </label>
                                    <button name="changeGraphColor" id="ProteinColor" data-jscolor="{valueElement: '#--protein'}"></button><br>
                                    <label style="font-size: smaller">Lost Edge </label>
                                    <button name="changeGraphColor" id="LostEdgeColor" data-jscolor="{valueElement: '#--lostedge'}"></button><br>
                                    <label style="font-size: smaller">Gained Edge </label>
                                    <button name="changeGraphColor" id="GainedEdgeColor" data-jscolor="{valueElement: '#--gainededge'}"></button><br>
                                
                                </div>
                                <div style="flex-basis: 50%; text-align: right">
                                    <label style="font-size: smaller">Domains </label>
                                    <button name="changeGraphColor" id="DomainColor" data-jscolor="{valueElement: '#--mint'}"></button><br>
                                    <label style="font-size: smaller">DDI </label>
                                    <button name="changeGraphColor" id="DDIColor" data-jscolor="{valueElement: '#--darkintensemint'}"></button><br>
                                </div>
                            </div>
                            <button type="button" name="ApplyGraphStyle" id="ApplyGraphColor" disabled value="null" class="button graph-menu-button">Apply color changes</button>
                        </div>

<%--                        <div class="network-option panel" name="NetworkOptions" style="text-align: center; border-radius: 1em">--%>
<%--                            <label for="NVContentMetricsTable" style="font-weight: bold">Display network properties</label>--%>
<%--                            <div id="NVContentMetricsTable" class="popup">--%>
<%--                                <jsp:include page="output/network_table.html"/><br>--%>
<%--                                <a href="header.html">Download this table</a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
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

