<%@ page import="java.util.List" %>
<%@ page import="app.classes.User" %>
<%@ page import="app.classes.DbConnector" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Users List</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <!-- Include sidebar -->
        <jsp:include page="sidebar.jsp"/>
        <style>
            .card-columns {
                column-count: 3;
            }

            .user-card {
                margin-bottom: 20px;
                background-color: white; 
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2); 
                transition: transform 0.3s, box-shadow 0.3s, opacity 0.3s; 
                opacity: 0;
                animation: fadeInUp 0.6s forwards; 
            }

            .user-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 6px 16px rgba(0, 0, 0, 0.3); 
            }

            .card-body p {
                margin: 0;
            }

            .card-footer {
                display: flex;
                justify-content: space-between;
            }

            .btn-primary, .btn-danger, .btn-success {
                transition: background-color 0.3s, transform 0.2s;
            }

            .btn-primary:hover, .btn-danger:hover, .btn-success:hover {
                transform: scale(1.05);
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px); 
                }
                to {
                    opacity: 1;
                    transform: translateY(0); 
                }
            }
            
 
        @media (max-width: 992px) {
            .card-columns {
                column-count: 2; 
            }
        }

        @media (max-width: 768px) {
            .card-columns {
                column-count: 1; 
            }
        }

        @media (max-width: 576px) {
            .card-body h5, .card-body p {
                font-size: 14px; 
            }
            .btn-sm {
                font-size: 12px; 
            }
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

        <div class="content">
            <jsp:include page="navbar.jsp" />
            <div class="container-fluid">
                <h1>Users List</h1>
                <div class="card-columns">
                    <%
                        List<User> users = User.getAllUsers(DbConnector.getConnection());
                        for (User user : users) {
                    %>
                    <div class="card user-card">
                        <div class="card-body">
                            <h5 class="card-title">ID: <%= user.getId()%></h5> 
                            <h5 class="card-title"><%= user.getFirstName()%> <%= user.getLastName()%></h5>
                            <h6 class="card-subtitle mb-2 text-muted">Username: <%= user.getUsername()%></h6>
                            <p class="card-text"><strong>Role:</strong> <%= user.getUserRole()%></p>
                            <p class="card-text"><strong>Contact No:</strong> <%= user.getContact_num()%></p>
                            <p class="card-text"><strong>Email:</strong> <%= user.getEmail()%></p>
                        </div>
                        <%
                            if (!"employee".equals(userRole)) {
                        %>
                        <div class="card-footer">
                            <a href="edituser.jsp?id=<%= user.getId()%>" class="btn btn-primary btn-sm"><i class="fas fa-edit"></i> Edit</a>
                            <a href="deleteuser.jsp?id=<%= user.getId()%>" class="btn btn-danger btn-sm"><i class="fas fa-trash-alt"></i> Delete</a>
                        </div>
                        <%}%>
                    </div>
                    <%
                        }
                    %>
                </div>
                <%
                    if ("admin".equals(userRole)) {
                %>
                <a href="adduser.jsp" class="btn btn-success mt-4">Add New User</a>
                <%}%>
            </div>
            <jsp:include page="footer.jsp" />    
        </div>

        <!-- Include Footer -->

    </body>
</html>
