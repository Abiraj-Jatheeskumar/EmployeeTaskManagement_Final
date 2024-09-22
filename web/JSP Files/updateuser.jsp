<%@page import="java.sql.Connection"%>
<%@page import="app.classes.DbConnector"%>
<%@page import="app.classes.User"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update User</title>
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
    String userRolea = (String) session.getAttribute("userRole");
    if (userRolea == null) {
        response.sendRedirect("../index.html");
        return;
    }
%>
<div class="card-container">
    <h1>Update User</h1>
    <%
        Connection conn = null;
        boolean updated = false;
        try {
            conn = DbConnector.getConnection();
            
            int userId = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String userRole = request.getParameter("userRole") != null ? request.getParameter("userRole") : User.getUserRoleByUserId(conn, userId) ;
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String profilePicture = request.getParameter("profilePicture");

            User user = User.getUserById(conn, userId);
            if (user != null) {
                user.setUsername(username);
                user.setFirstName(firstName);
                user.setLastName(lastName);
                user.setUserRole(userRole);
                user.setEmail(email);
                user.setContact_num(phone);
                user.setProfile_picture(profilePicture); 

                updated = user.updateUser(conn);
            } else {
                out.println("<div class='alert alert-danger'>User not found!</div>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger'>An error occurred: " + e.getMessage() + "</div>");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    %>
    <div class="alert alert-<%= updated ? "success" : "danger" %>" role="alert">
        <%= updated ? "User updated successfully!" : "Error updating user!" %>
    </div>
    <a href="userlist.jsp" class="btn btn-primary">Back to Users List</a>
</div>
</body>
</html>
