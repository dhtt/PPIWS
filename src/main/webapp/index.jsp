<%@ page import="java.util.*" %>
<%@ page import="java.io.PrintStream" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<!DOCTYPE html>
<html>
<head>
    <title>JSP - Hello World</title>
</head>
<body>
<h1><%= "Hello World!" %>
</h1>

<br/>
<h2>
    <%= com.example.webserver.FunUtils.findDate() %>
</h2>

<br/>
<a href="hello-servlet">Hello Servlet.
</a>
</body>
</html>