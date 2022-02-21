<%--<%@ page import="java.util.*" %>--%>
<%--<%@ page import="java.io.PrintStream" %>--%>
<%--<%@ page import="com.webserver.Utils" %>--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>

<!DOCTYPE html>
<html>

<head> <title>PPI Webservices</title> </head>

<body>
<jsp:include page="html/header.html" />

<h3><form action="jsp/form.jsp" >
<%--    Make a form--%>
    <p><label for="firstname">First name: </label><input type="text" id="firstname" name="firstName" /><br/>

<%--    Make a Dropdown List--%>
    <p><label for="gender">Gender: </label><select id="gender" name="gender">
        <option>Female</option>
        <option>Male</option>
        <option>Other</option>
    </select></p>

<%--    Make Radio buttons or Checkboxes--%>
    <h4><p>PPI Network Options<br>
        <label for="STRINGWeight"><input type="checkbox" name="PPIOptions" id="STRINGWeight" value="Add STRING weights"> Add STRING weights</label><br>
        <label for="UniProtAcc"><input type="checkbox" name="PPIOptions" id="UniProtAcc" value="Update UniProt accessions"> Update UniProt accessions</label><br>
        <label for="LocalDDI"><input type="checkbox" name="PPIOptions" id="LocalDDI" value="Only local DDI data"> Only local DDI data</label><br>
        <label for="ELMData"><input type="checkbox" name="PPIOptions" id="ELMData" value="Include ELM data"> Include ELM data</label></p></h4>

    <input type="submit" value="Submit info">
    </form>
</h3>


<jsp:include page="jsp/footer.jsp" />

</body>

</html>