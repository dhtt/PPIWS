<%--<%@ page import="java.util.*" %>--%>
<%--<%@ page import="java.io.PrintStream" %>--%>
<%--<%@ page import="com.webserver.Utils" %>--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>

<!DOCTYPE html>
<html>

<head>
    <title>PPI Webservices</title>
    <link rel="stylesheet" href="css/page-setting.css">
</head>

<body>
<jsp:include page="html/header.html" />

<%--Test jslt core tags--%>
<% String[] loadings = {".", "..", "..."};
    pageContext.setAttribute("loading", loadings);
%>
<c:forEach var="temp" items="${loading}">
    ${temp}<br>
</c:forEach>

<%--Test jslt function tags --%>
<c:set var="status" value="loaded" />
Length of ${status} is ${fn:toUpperCase(status)}<br>


<form action="PPIXpress" method="POST" enctype="multipart/form-data">
<%--    <form action="jsp/example_form.jsp" method="GET">--%>
<%--    Make a form--%>
    <p><label for="firstname">First name: </label><input type="text" id="firstname" name="firstName" /><br/>

<%--    Make a Dropdown List--%>
    <p><label for="gender">Gender: </label><select id="gender" name="gender">
        <option>Female</option>
        <option>Male</option>
        <option>Other</option>
    </select></p>

    Make Radio buttons or Checkboxes
    <h4>PPI Network Options<br>
        <label for="STRINGWeight"><input type="checkbox" name="PPIOptions" id="STRINGWeight" value="Add STRING weights"> Add STRING weights</label><br>
        <label for="UniProtAcc"><input type="checkbox" name="PPIOptions" id="UniProtAcc" value="Update UniProt accessions"> Update UniProt accessions</label><br>
        <label for="LocalDDI"><input type="checkbox" name="PPIOptions" id="LocalDDI" value="Only local DDI data"> Only local DDI data</label><br>
        <label for="ELMData"><input type="checkbox" name="PPIOptions" id="ELMData" value="Include ELM data"> Include ELM data</label></h4>

    <label for="expFile1"></label><input type="file" name="file" id="expFile1">
    <input type="submit" value="Submit info">
    </form>


<jsp:include page="html/footer.html" />

</body>

</html>