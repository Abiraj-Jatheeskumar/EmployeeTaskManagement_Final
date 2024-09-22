<%@page import="app.classes.User"%>
<%@ page import="java.sql.*" %>
<%@ page import="app.classes.DbConnector" %>
<%@ page import="app.classes.Task" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Task</title>
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
        <h1>Edit Task</h1>
        <%
            int taskId = Integer.parseInt(request.getParameter("id"));
            Task task = Task.getTaskById(DbConnector.getConnection(), taskId);
            if (task == null) {
                out.println("<div class='alert alert-danger'>Task not found!</div>");
                return;
            }
        %>
        <form action="updateTask.jsp" method="post">
            <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
            <div class="form-group">
                <label for="taskName">Task Name</label>
                <input type="text" class="form-control" id="taskName" name="taskName" value="<%= task.getTaskName() %>" required>
            </div>
            <div class="form-group">
                <label for="status">Status</label>
                <select class="form-control" id="status" name="status">
                    <option <%= task.getStatus().equals("Pending") ? "selected" : "" %>>Pending</option>
                    <option <%= task.getStatus().equals("In Progress") ? "selected" : "" %>>In Progress</option>
                    <option <%= task.getStatus().equals("Completed") ? "selected" : "" %>>Completed</option>
                </select>
            </div>
            <div class="form-group">
                <label for="priority">Priority</label>
                <select class="form-control" id="priority" name="priority">
                    <option <%= task.getPriority().equals("Low") ? "selected" : "" %>>Low</option>
                    <option <%= task.getPriority().equals("Medium") ? "selected" : "" %>>Medium</option>
                    <option <%= task.getPriority().equals("High") ? "selected" : "" %>>High</option>
                </select>
            </div>
            <div class="form-group">
                <label for="dueDate">Due Date</label>
                <input type="date" class="form-control" id="dueDate" name="dueDate" value="<%= task.getDueDate() %>" required>
            </div>
            <div class="form-group">
                <label for="assignedUser">Assigned User</label>
                <select class="form-control" id="assignedUser" name="assignedUser">
                    <option value="<%= task.getUserId() %>"><%= task.getUserName(DbConnector.getConnection()) %></option>
                    <%
                        ResultSet rs = null;
                        rs = User.getUserAlll();
                            while (rs.next()) {
                                int userId = rs.getInt("user_id");
                                String userName = rs.getString("user_name");
                                if (userId != task.getUserId()) {
                                    out.println("<option value='" + userId + "'>" + userName + "</option>");
                                }
                            }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea class="form-control" id="description" name="description" rows="3" required><%= task.getDescription() %></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Update Task</button>
        </form>
    </div>
</body>
</html>
