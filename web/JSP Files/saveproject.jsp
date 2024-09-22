<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="app.classes.DbConnector"%>
<%@page import="app.classes.Project"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Save Project</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
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
    String userRole = (String) session.getAttribute("userRole");
    if (userRole == null) {
        response.sendRedirect("../index.html");
        return;
    }
%>
<div class="card-container">
    <h1>Save Project</h1>
    <%
        String projectName = request.getParameter("projectName");
        String status = request.getParameter("projectStatus");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String projectManager = request.getParameter("projectManager");
        String description = request.getParameter("description");

        if (projectName == null || status == null || startDate == null || endDate == null || projectManager == null || description == null) {
            out.println("<div class='alert alert-warning'>All fields are required!</div>");
            return;
        }

        Connection conn = null;

        try {
            conn = DbConnector.getConnection();

    
            out.println("<p>Project Name: " + projectName + "</p>");
            out.println("<p>Status: " + status + "</p>");
            out.println("<p>Start Date: " + startDate + "</p>");
            out.println("<p>End Date: " + endDate + "</p>");
            out.println("<p>Project Manager: " + projectManager + "</p>");
            out.println("<p>Description: " + description + "</p>");

            Project project = new Project(projectName, status, startDate, endDate, projectManager, description);
            boolean result = project.saveProject(conn);

            if (result) {
                out.println("<div class='alert alert-info'>Project added successfully!</div>");
            } else {
                out.println("<div class='alert alert-danger'>Failed to add project!</div>");
            }
        
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger'>Exception: " + e.getMessage() + "</div>");
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
    <a href="addproject.jsp" class="btn btn-primary">Back to Add Project</a>
</div>
</body>
</html>
