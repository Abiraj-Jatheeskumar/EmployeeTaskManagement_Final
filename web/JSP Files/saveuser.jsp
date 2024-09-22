<%@page import="app.classes.MD5"%>
<%@page import="app.classes.DbConnector"%>
<%@page import="java.sql.Connection"%>
<%@page import="app.classes.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Save User</title>
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
            transform: scale(1.05); /* Slight zoom effect */
        }

        .alert {
            margin-bottom: 20px;
            opacity: 0;
            animation: fadeIn 0.5s forwards;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
    </style>
</head>
<body>
<%
    String userRolea = (String) session.getAttribute("userRole");
    if (userRolea == null) {
        response.sendRedirect("../index.html");
        return;
    }
%>
<div class="card-container">
    <h1>Save User</h1>
    <%
        String username = request.getParameter("username");
        String firstName = request.getParameter("firstname");
        String lastName = request.getParameter("lastname");
        String userRole = request.getParameter("userrole");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String profilePicture = request.getParameter("profilePicture");
        String password = MD5.getMd5(request.getParameter("password"));
        String confirmPassword = MD5.getMd5(request.getParameter("confirm_password"));

        if (username == null || firstName == null || lastName == null || userRole == null || email == null || phone == null || password == null || confirmPassword == null) {
            out.println("<div class='alert alert-danger'>All fields are required!</div>");
        } else if (!password.equals(confirmPassword)) {
            out.println("<div class='alert alert-danger'>Passwords do not match!</div>");
        } else {
            try {
                User user = new User(username, firstName, lastName, userRole, email, phone, password);
                user.setProfile_picture(profilePicture);
                if (user.saveUser(DbConnector.getConnection())) {
                    out.println("<div class='alert alert-info'>User added successfully!</div>");
                } else {
                    out.println("<div class='alert alert-danger'>Failed to add user! Please check the database connection and table structure.</div>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger'>An error occurred: " + e.getMessage() + "</div>");
            }
        }
    %>
    <a href="adduser.jsp" class="btn btn-primary">Back to Add User</a>
</div>
</body>
</html>
