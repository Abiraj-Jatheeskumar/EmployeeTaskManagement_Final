<%@ page import="java.sql.*, app.classes.DbConnector, app.classes.User, app.classes.MD5" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="3;url=home.jsp">
    <title>Login Processing</title>
</head>
<body>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    User user = User.authenticateUser(email, password);

    if (user != null) {
        session.setAttribute("loggedInUser", user); 
        String role = user.getUserRole();
        session.setAttribute("userRole", role); 

        if ("admin".equals(role) || "employee".equals(role) || "manager".equals(role)) {
            response.sendRedirect("JSP Files/home.jsp");
        } else {
            out.println("<script type='text/javascript'>");
            out.println("alert('Invalid role.');");
            out.println("location='index.html';");
            out.println("</script>");
        }
    } else {
        out.println("<script type='text/javascript'>");
        out.println("alert('Invalid email or password');");
        out.println("location='index.html';");
        out.println("</script>");
    }
%>
</body>
</html>
