<%--
  Created by IntelliJ IDEA.
  User: trangdo
  Date: 21.02.22
  Time: 17:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Result</title>
</head>
<body>
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

</body>
</html>
