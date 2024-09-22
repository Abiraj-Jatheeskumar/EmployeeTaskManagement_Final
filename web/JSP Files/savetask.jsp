<%@page import="app.classes.DbConnector"%>
<%@page import="app.classes.Task"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Save Task</title>
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
    <h1>Save Task</h1>
    <%
        String taskName = request.getParameter("taskName");
        String status = request.getParameter("taskStatus");
        String priority = request.getParameter("taskPriority");
        String dueDate = request.getParameter("dueDate");
        String assignedUser = request.getParameter("assignedUser");
        String description = request.getParameter("taskDescription");
        String projectName = request.getParameter("projectName");

        int userId = Integer.parseInt(assignedUser);
        int projectId = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnector.getConnection();
            
            // Log input parameters
            out.println("<p>Task Name: " + taskName + "</p>");
            out.println("<p>Status: " + status + "</p>");
            out.println("<p>Priority: " + priority + "</p>");
            out.println("<p>Due Date: " + dueDate + "</p>");
            out.println("<p>Assigned User ID: " + userId + "</p>");
            out.println("<p>Description: " + description + "</p>");
            out.println("<p>Project Name: " + projectName + "</p>");

            if (projectName != null && !projectName.isEmpty()) {
                String projectSql = "SELECT project_id FROM project WHERE project_name = ?";
                pstmt = conn.prepareStatement(projectSql);
                pstmt.setString(1, projectName);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    projectId = rs.getInt("project_id");
                    out.println("<p>Project ID: " + projectId + "</p>");
                } else {
                    out.println("<div class='alert alert-warning'>Project not found!</div>");
                    return;
                }
            }

            Task task = new Task(taskName, status, priority, dueDate, userId, description);
            task.setProjectId(projectId);

            if (task.saveTask(conn)) {
                out.println("<div class='alert alert-info'>Task added successfully!</div>");
            } else {
                out.println("<div class='alert alert-danger'>Failed to add task!</div>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger'>SQLException: " + e.getMessage() + "</div>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger'>Exception: " + e.getMessage() + "</div>");
        } finally {
            // Clean up resources
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
    <a href="addtask.jsp" class="btn btn-primary">Back to Add Task</a>
</div>
</body>
</html>
