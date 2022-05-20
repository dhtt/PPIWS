<%--<%@ page import="java.util.*" %>--%>
<%--<%@ page import="java.io.PrintStream" %>--%>
<%--<%@ page import="com.webserver.Utils" %>--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>

<!DOCTYPE html>
<html>
<sql:query var="rs" dataSource="jdbc/TestDB">
    select id, foo, bar from testdata
</sql:query>
<head>
    <title>PPI Webservices</title>
</head>

<body>
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

<%--Test sql--%>
<c:forEach var="row" items="${rs.rows}">
    Foo ${row.foo}<br/>
    Bar ${row.bar}<br/>
</c:forEach>


</body>

</html>