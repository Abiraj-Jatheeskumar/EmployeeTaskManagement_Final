<%@page import="app.classes.User"%>
<%@ page import="java.sql.*" %>
<%@ page import="app.classes.DbConnector" %>
<%@ page import="app.classes.Project" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Project</title>
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
            transform: scale(1.05); /* Slight zoom effect */
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
    <h1>Edit Project</h1>
    <%
        int projectId = Integer.parseInt(request.getParameter("id"));
        Project project = Project.getProjectById(DbConnector.getConnection(), projectId);
    %>
    <form action="updateProject.jsp" method="post">
        <input type="hidden" name="projectId" value="<%= project.getId() %>">
        <div class="form-group">
            <label for="name">Project Name</label>
            <input type="text" class="form-control" id="name" name="name" value="<%= project.getName() %>" required>
        </div>
        <div class="form-group">
            <label for="status">Status</label>
            <select class="form-control" id="status" name="status">
                <option <%= project.getStatus().equals("Pending") ? "selected" : "" %>>Pending</option>
                <option <%= project.getStatus().equals("On Hold") ? "selected" : "" %>>On Hold</option>
                <option <%= project.getStatus().equals("Completed") ? "selected" : "" %>>Completed</option>
            </select>
        </div>
        <div class="form-group">
            <label for="startDate">Start Date</label>
            <input type="date" class="form-control" id="startDate" name="startDate" value="<%= project.getStartDate() %>" required>
        </div>
        <div class="form-group">
            <label for="endDate">End Date</label>
            <input type="date" class="form-control" id="endDate" name="endDate" value="<%= project.getEndDate() %>" required>
        </div>
        <div class="form-group">
            <label for="projectManager">Project Manager</label>
            <select class="form-control" id="projectManager" name="projectManager">
                <option value="<%=project.getProjectManager() %>"><%=project.getProjectManager() %></option>
                <%
                    ResultSet rs = null;
                    rs = User.getManager();
                    while (rs.next()) {
                        String userName = rs.getString("user_name");
                        out.println("<option value='" + userName + "'>" + userName + "</option>");
                    }
                %>
            </select>
        </div>
        <div class="form-group">
            <label for="description">Description</label>
            <textarea class="form-control" id="description" name="description" rows="3" required><%= project.getDescription() %></textarea>
        </div>
        <button type="submit" class="btn btn-primary">Update Project</button>
    </form>
</div>

</body>
</html>
