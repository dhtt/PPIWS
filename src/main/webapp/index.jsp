<%--<%@ page import="java.util.*" %>--%>
<%--<%@ page import="java.io.PrintStream" %>--%>
<%--<%@ page import="com.webserver.Utils" %>--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>

<!DOCTYPE html>
<html>

<head> <title>PPI Webservices</title> </head>

<body>
<jsp:include page="html/header.html" />


<form action="jsp/example_form.jsp" >
<%--    Make a form--%>
    <p><label for="firstname">First name: </label><input type="text" id="firstname" name="firstName" /><br/>

<%--    Make a Dropdown List--%>
    <p><label for="gender">Gender: </label><select id="gender" name="gender">
        <option>Female</option>
        <option>Male</option>
        <option>Other</option>
    </select></p>

<%--    Make Radio buttons or Checkboxes--%>
    <h4>PPI Network Options<br>
        <label for="STRINGWeight"><input type="checkbox" name="PPIOptions" id="STRINGWeight" value="Add STRING weights"> Add STRING weights</label><br>
        <label for="UniProtAcc"><input type="checkbox" name="PPIOptions" id="UniProtAcc" value="Update UniProt accessions"> Update UniProt accessions</label><br>
        <label for="LocalDDI"><input type="checkbox" name="PPIOptions" id="LocalDDI" value="Only local DDI data"> Only local DDI data</label><br>
        <label for="ELMData"><input type="checkbox" name="PPIOptions" id="ELMData" value="Include ELM data"> Include ELM data</label></h4>

    <input type="submit" value="Submit info">
    </form>

<%--Test jslt core tags--%>
<% String[] arrays = {"a", "b", "c"};
    pageContext.setAttribute("alphabets", arrays);
%>
<c:forEach var="temp" items="${alphabets}">
    ${temp}<br>
</c:forEach>

<%--Test jslt function tags --%>
<c:set var="username" value="tomcat" />
Length of ${username} is ${fn:length(username)}


<jsp:include page="jsp/footer.jsp" />

</body>

</html>