<%@page import="app.classes.User"%>
<%@page import="app.classes.DbConnector"%>
<%@ page import="app.classes.Project" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete User</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background-color: #f0f2f5; 
            margin: 0;
            font-family: 'Arial', sans-serif;
        }

        .card-container {
            max-width: 800px;
            width: 100%;
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            padding: 20px;
            margin: 20px;
            transition: box-shadow 0.3s, transform 0.5s, opacity 0.5s;
            opacity: 0;
            transform: scale(0.9);
            animation: fadeInUp 0.5s forwards;
        }

        .card-container:hover {
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .btn-primary {
            background-color: #343a40;
            border: none;
            border-radius: 5px;
            transition: background-color 0.3s, transform 0.2s;
        }

        .btn-primary:hover {
            background-color: #a777e3;
            transform: scale(1.05);
        }

        .alert {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<%
    String userRole = (String) session.getAttribute("userRole");
    if (userRole == null) {
        response.sendRedirect("../index.html");
        return;
    }
%>
<div class="card-container">
    <h1>Delete User</h1>
    <%
        int userId = Integer.parseInt(request.getParameter("id"));

        User user = new User();
        user.setId(userId);

        boolean deleted = user.deleteUser(DbConnector.getConnection());
    %>
    <div class="alert alert-<%= deleted ? "success" : "danger" %>" role="alert">
        <%= deleted ? "User deleted successfully!" : "Error deleting user!" %>
    </div>
    <a href="userlist.jsp" class="btn btn-primary">Back to Users List</a>
</div>
</body>
</html>
