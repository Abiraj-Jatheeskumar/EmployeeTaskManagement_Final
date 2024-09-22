<%@ page import="java.util.List" %>
<%@ page import="app.classes.User" %>
<%@ page import="app.classes.DbConnector" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Profile</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <style>
            .profile-card {
                background: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
                transition: box-shadow 0.3s ease;
            }
            .profile-card:hover {
                box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2);
            }
            .profile-header {
                background: #343a40;
                color: #ffffff;
                padding: 20px;
                text-align: center;
            }
            .profile-header h4 {
                margin: 0;
                font-size: 1.75rem;
                font-weight: bold;
            }
            .profile-header p {
                margin: 5px 0;
                font-size: 1.2rem;
            }
            .profile-container {
                padding: 20px;
            }
            .profile-container p {
                font-size: 1rem;
                margin: 15px 0;
                color: #495057;
            }
            .profile-container strong {
                color: #343a40; 
            }
            .profile-actions {
                border-top: 1px solid #dee2e6;
                padding: 20px;
                text-align: center; 
            }

            .profile-actions .btn {
                width: auto; 
                display: inline-block; 
                padding: 10px 20px; 
                background-color: #6c757d; 
                color: #ffffff;
                border-radius: 5px; 
            }

            .profile-actions .btn:hover {
                background-color: #5a6268; 
                text-decoration: none;
            }

        </style>
        <!-- Include sidebar -->
        <jsp:include page="sidebar.jsp"/>
    </head>
    <body>
        <%
            String userRole = (String) session.getAttribute("userRole");
            if (userRole == null) {
                response.sendRedirect("../index.html");
                return;
            }
        %>
   
        <div class="content">
            <jsp:include page="navbar.jsp" />
            <div class="container-fluid">
                <h1 class="my-4 text-center">User Profile</h1>
                <%
                    User user = (User) session.getAttribute("loggedInUser");
                    if (user != null) {
                %>
                <div class="col-md-8 offset-md-2">
                    <div class="card profile-card">
                        <div class="profile-header">
                            <h4><%= user.getFirstName()%> <%= user.getLastName()%> </h4>
                            <p><%= user.getUserRole()%></p>
                            <img src="<%= user.getProfile_picture()%>" class="avatar img-fluid profile-img" alt="User Profile Icon" id="modalProfileImg" >
                        </div>
                        <div class="profile-container">
                            <p><strong>First Name:</strong> <%= user.getFirstName()%></p>
                            <p><strong>Last Name:</strong> <%= user.getLastName()%></p>
                            <p><strong>Username:</strong> <%= user.getUsername()%></p>
                            <p><strong>Email:</strong> <%= user.getEmail()%></p>
                            <p><strong>Role:</strong> <%= user.getUserRole()%></p>

                        </div>
                            
                            
                        <div class="profile-actions text-center">
                            <a href="edituser.jsp?id=<%= user.getId()%>" class="btn btn-secondary btn-block">Edit</a>

                        </div>
                    </div>
                </div>
                <%
                } else {
                %>
                <p class="text-center">No user is logged in.</p>
                <%
                    }
                %>
            </div>

            <jsp:include page="footer.jsp" />    
        </div>
    </body>
</html>
