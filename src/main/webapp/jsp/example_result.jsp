<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<html>
<head>
    <title>Result</title>
</head>
<body>
<h3>
<%--    Using cookie--%>
    <%
        Cookie[] myCookies = request.getCookies();
        String my_gender = "Female";
        if (myCookies != null){
            for (Cookie tempCookie : myCookies){
                if ("Gender".equals(tempCookie.getName())){
                    my_gender = tempCookie.getValue();
                    break;
                }
            }
        }
        out.println("Previously selected gender: " + my_gender);
    %>
</h3>

</body>
</html>
