<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<body>
<h3>
<%--    Print filled form--%>
    Name: ${param.firstname}<br>
    Gender: ${param.gender}<br><br/>

<%--    Print checkboxes--%>
    PPI Options:<br>
    <ul>
        <%
            String[] PPI_options = request.getParameterValues("PPIOptions");
            for (String i:PPI_options){
                out.println("<li>" + i + "</li>");
            }
        %>
    </ul><br>

<%--    Save cookie--%>
    <%
        String gender = request.getParameter("gender");
        Cookie gender_cookie = new Cookie("Gender", gender);
        gender_cookie.setMaxAge(60*60);
        response.addCookie(gender_cookie);
    %>
    Gender has been set to: ${param.gender}<br>
    <a href="example_result.jsp">To result page</a>
    %>

</h3>
</body>
</html>
