<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--TODO: Safari appearance--%>
<html lang="en">
<head>
    <title>PPI Webserver</title>
    <link rel="shortcut icon" href="resources/PPIN_logo.png">
    <link rel="stylesheet" href="css/theme_blue.css">
    <link rel="stylesheet" href="css/interface.css">
    <link rel="stylesheet" href="css/header-and-panel.css">
    <link rel="stylesheet" href="css/cytoscape-style.css">
    <link rel="stylesheet" href="css/animation.css">
    <link rel="stylesheet" href="css/select2_custom_style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-colorpicker/3.4.0/js/bootstrap-colorpicker.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.21.0/cytoscape.min.js"> </script>
    <script src="webjars/cytoscape-cose-bilkent/4.0.0/cytoscape-cose-bilkent.js"></script>
    <script type="module" src="js/cytoscape-expand-collapse.js"></script>
    <script type="module" src="js/jscolor.js"></script>
    <script type="module" src="js/functionality.js"></script>
    <script type="module" src="js/network_maker.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.0/FileSaver.min.js"> </script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
    <div style="display: none">
        <button name="CSS_Style" id="--mint" style="color: var(--mint)" value="rgb(173, 216, 230)"></button>
        <button name="CSS_Style" id="--darkmint" style="color: var(--darkmint)" value="rgb(78, 163, 200)"></button>
        <button name="CSS_Style" id="--choco" style="color: var(--choco)" value="rgb(67, 60, 57)"></button>
        <button name="CSS_Style" id="--lightmintgrey" style="color: var(--lightmintgrey)" value="rgb(237, 242, 244)"></button>
        <button name="CSS_Style" id="--intensemint" style="color: var(--intensemint)" value="rgb(78, 163, 200)"></button>
        <button name="CSS_Style" id="--darkintensemint" style="color: var(--darkintensemint)" value="rgb(61, 163, 204)"></button>
        <button name="CSS_Style" id="--ultradarkmint" style="color: var(--ultradarkmint)" value="rgb(0, 57, 36)"></button>
        <button name="CSS_Style" id="--deeppink" style="color: var(--deeppink)" value="rgb(255, 20, 147)"></button>
        <button name="CSS_Style" id="--darkdeeppink" style="color: var(--darkdeeppink)" value="rgb(164, 38, 143)"></button>
        <button name="CSS_Style" id="--shadow" style="color: var(--shadow)" value="rgb(67, 60, 57)"></button>
        <button name="CSS_Style" id="--textshadow" style="color: var(--textshadow)" value="rgb(67, 60, 57)"></button>
        <button name="CSS_Style" id="--warning" style="color: var(--warning)" value="rgb(255, 237, 37)"></button>
    </div>
    
    <div class="container-header" style="min-height: 70px">
        <div style="flex: 0 400px;background-color: var(--lostedge);border-radius: 0 0 2em 2em;margin-left: 1em">
            <h1 class="left vcenter">PPI-Webserver</h1>
        </div>
    <!-- TODO: add https://www-cbi.cs.uni-saarland.de and https://zbi-www.bioinf.uni-sb.de/en/  -->

        <div style="flex: 1; display: none">
            <h2 class="middle">Construction of condition-specific Protein Interaction Networks<br>based on Transcript Expression</h2>
        </div>
    </div>
    
    <div style="display: flex; flex-direction: row;">
        <div style="display: flex;flex-direction: column;width: -webkit-fill-available;flex-basis: 50%;min-width: 50%; margin: 2em">
            <span class="level-1-heading" style="color: var(--choco)">What is PPI-Webserver?</span>
            <p style="margin-left: 1em">PPI-Webserver contains two webservers designed and developed by Volkhard Helms' group at Center for Bioinformatics,
                Saarland University.<br><br>
                <span style="font-weight: bold">PPIXpress:</span> Construction of condition-specific Protein Interaction Networks based on Transcript Expression<br><br>
                <span style="font-weight: bold">PPICompare:</span> Detection of rewiring events in Protein Interaction Networks<br><br>
            </p>

            <span class="level-1-heading" style="color: var(--choco)">Our updates</span>
            <span style="margin-left: 1em">April 2024: PPI-Webserver is now online!<br><br></span>
            <span style="margin-left: 1em">- 2024: Application note submitted.<br><br><br></span>
            

            <div style="display: flex; flex-direction: row;">
                    <span style="flex-basis: 7.5%;"></span>
                    <a href="./index_PPIXpress.jsp" target="_blank" rel="noopener noreferer" class="button landing_button" style="flex-basis: 40%; background:#b4e8c6">To PPIXpress</a><br>
                    <span style="flex-basis: 5%;"></span>
                    <a href="./index_PPICompare.jsp" target="_blank" rel="noopener noreferer" class="button landing_button" style="flex-basis: 40%; background:#ADD8E6">To PPICompare</a><br>
                    <span style="flex-basis: 7.5%;"></span>
            </div>
            <footer style="margin: 2em">Hoang Thu Trang Do &amp; Volkhard Helms. Chair of Computational Biology</footer>
        </div> 

        <div style="display: flex;flex-direction: column;flex-basis: 45%;">
            <span class="level-1-heading" style="text-align: center; color: var(--choco); z-index:10">PPI-Webserver Workflow</span>
            <img src="resources/workflow.png" style="width: -webkit-fill-available;max-width: 100%; margin-top: -1em">
        </div>
    </div>
</body>