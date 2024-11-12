<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html lang="en">
        
<head>
    <title>PPI Webserver FAQs</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<jsp:include page="html/header.html"/>
<div>
    <div id="AllPanels" class="container-body">
        <div style="flex: 0 0 280px; margin-left: 1em; position: fixed">
            <div id="MenuPanel" class="menu panel shadow" style="position: relative; padding: 0; border-radius: 1em; margin-top: 1em">
                <div>
                    <p name="HelpMenu" id="PPIXpress" class="help-panel DefaultHelpMenu" style="border-radius: 1em 1em 0 0">PPIXpress</p>
                    <!-- <p name="HelpMenu" id="ProteinInteractionData" class="help-panel-sub">Protein interaction data</p> -->
                </div>
                <div>
                    <p name="HelpMenu" id="PPICompare" class="help-panel" style="border-radius: 0 0 1em 1em">PPICompare</p>
                    <!-- <p name="HelpMenu" id="SampleSummaryFile" class="help-panel-sub">Sample summary file</p> -->
                </div>
            </div>
            <div name="ScrollToTop" class="reset" style="text-align: center; position: relative; padding: 0; border-radius: 1em; margin-top: 1em">Scroll to top</div>
        </div>
        <div id="RightPanel" class="middle-under-info-page" style="flex: 1; display: flex; flex-flow: column">
            <!--------------------------->
            <!-- SECTION toPPIXpressFAQs -->
            <!--------------------------->

            <div id="toPPIXpressFAQs">
                <p class="menu header help-section-title" style="color: var(--mint);">PPIXpress</p>

                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <ul>
                            <li class="question">Q: </li>
                            <li class="answer">A: </li>

                            <li class="question">Q: </li>
                            <li class="answer">A: </li>

                            <li class="question">Q: </li>
                            <li class="answer">A: </li>
                        </ul>
                    </div>
                </div>
            </div>

            <!------------------------------->
            <!-- SECTION totoPPICompareFAQs -->
            <!------------------------------->
            <div id="totoPPICompareFAQs">
                <p class="menu header help-section-title" style="color: var(--mint);">PPICompare</p>
                
                <div class="menu panel" style="width: 100%">
                    <div class="help-section-body">
                        <ul>
                            <li class="question">Q: </li>
                            <li class="answer">A: </li>

                            <li class="question">Q: </li>
                            <li class="answer">A: </li>
                            
                            <li class="question">Q: </li>
                            <li class="answer">A: </li>
                        </ul>
                    </div>
                </div>

            </div>
           
        </div>
    </div>
</div>
<jsp:include page="html/footer.html"/>
</body>
</html>
