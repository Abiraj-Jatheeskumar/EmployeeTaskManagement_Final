<%@ page import="java.sql.Connection"%>
<%@ page import="app.classes.DbConnector"%>
<%@ page import="app.classes.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit User</title>
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
            max-width: 600px;
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

        .card-container h1 {
            font-size: 1.8rem;
            margin-bottom: 20px;
            color: #333;
        }

        .form-group label {
            font-weight: bold;
            color: #333;
        }

        .form-control {
            border-radius: 5px;
            border: 1px solid #ddd;
            padding: 10px;
            font-size: 1rem;
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
    <h1>Edit User</h1>
    <%
        Connection conn = null;
        User user = null;
        int userId = Integer.parseInt(request.getParameter("id"));
        try {
            conn = DbConnector.getConnection();
            user = User.getUserById(conn, userId);
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger'>Error retrieving user details. Please try again later.</div>");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        if (user == null) {
            out.println("<div class='alert alert-danger'>User not found!</div>");
        } else {
            String userRole = user.getUserRole();
    %>
    <form action="updateuser.jsp" method="post">
        <input type="hidden" name="id" value="<%= user.getId() %>">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" class="form-control" id="username" name="username" value="<%= user.getUsername() %>" required>
        </div>
        <div class="form-group">
            <label for="firstName">First Name</label>
            <input type="text" class="form-control" id="firstName" name="firstName" value="<%= user.getFirstName() %>" required>
        </div>
        <div class="form-group">
            <label for="lastName">Last Name</label>
            <input type="text" class="form-control" id="lastName" name="lastName" value="<%= user.getLastName() %>" required>
        </div>
         <%
                       if ("admin".equals(userRolea)) {
                        
                    %> 
        <div class="form-group">
            <label for="userRole">User Role</label>
            <select class="form-control" id="userRole" name="userRole">
                <option value="employee" <%= "employee".equals(userRole) ? "selected" : "" %>>Employee</option>
                <option value="admin" <%= "admin".equals(userRole) ? "selected" : "" %>>Admin</option>
                <option value="manager" <%= "manager".equals(userRole) ? "selected" : "" %>>Project Manager</option>
            </select>
        </div>
            <% } %>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" class="form-control" id="email" name="email" value="<%= user.getEmail() %>" required>
        </div>
        <div class="form-group">
            <label for="phone">Contact Number</label>
            <input type="text" class="form-control" id="phone" name="phone" value="<%= user.getContact_num()%>" required>
        </div>
        <div class="form-group">
            <label for="profilePicture">Profile Picture URL</label>
            <input type="text" class="form-control" id="profilePicture" name="profilePicture" value="<%= user.getProfile_picture()%>" required>
        </div>
        <button type="submit" class="btn btn-primary">Update User</button>
    </form>
    <% } %>
</div>

</body>
</html>
