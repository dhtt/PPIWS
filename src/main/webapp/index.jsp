<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--TODO: Safari appearance--%>

<html lang="en">

<head>
    <title>PPI Webserver</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<jsp:include page="html/header.html"/>
    <div style="display: flex; flex-direction: row;">
        <div style="display: flex;flex-direction: column;width: -webkit-fill-available;flex-basis: 50%;min-width: 50%; margin: 2em">
            <span class="level-1-heading">What is PPI-Webserver?</span>
            <p style="margin-left: 1em">PPI-Webserver contains two webservers designed and developed by Volkhard Helms' group at Center for Bioinformatics,
                Saarland University.<br><br>
                <span style="font-weight: bold">PPIXpress:</span> Construction of condition-specific Protein Interaction Networks based on Transcript Expression<br><br>
                <span style="font-weight: bold">PPICompare:</span> Detection of rewiring events in Protein Interaction Networks<br><br>

                <div style="display: flex; flex-direction: row;">
                    <span style="flex-basis: 7.5%;"></span>
                    <a href="./index_PPIXpress.jsp" target="_blank" rel="noopener noreferer" class="button landing_button" style="flex-basis: 40%; background:#b4e8c6">To PPIXpress</a><br>
                    <span style="flex-basis: 5%;"></span>
                    <a href="./index_PPICompare.jsp" target="_blank" rel="noopener noreferer" class="button landing_button" style="flex-basis: 40%; background:#ADD8E6">To PPICompare</a><br>
                    <span style="flex-basis: 7.5%;"></span>
                </div><br><br>
            </p>

            <span class="level-1-heading">Frequently asked questions</span>
            <p style="margin-left: 1em">
                Got questions? Visit our <a href="./FAQs.jsp" target="_blank" rel="noopener noreferer" class="href_to_section">FAQs</a> page for more information.
            </p><br><br>

            <span class="level-1-heading">Our updates</span>
            <ul style="margin-left: 1em">
                <li>April 2024: PPI-Webserver is now online!<br><br></li>
                <li>- 2024: Application note submitted.<br><br></li>
            </ul>
            
        </div> 

        <div style="display: flex;flex-direction: column;flex-basis: 45%; margin: 2em">
            <span class="level-1-heading" style="text-align: center; z-index:10">PPI-Webserver Workflow</span>
            <img src="resources/workflow.png" style="width: -webkit-fill-available;max-width: 100%; margin-top: -1em">
        </div>
    </div>
    <jsp:include page="html/footer.html"/>
</body>