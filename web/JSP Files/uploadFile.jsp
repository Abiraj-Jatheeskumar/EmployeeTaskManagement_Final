<%@page import="app.classes.Project"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="app.classes.Files" %>
<%@ page import="app.classes.DbConnector" %>
<%@ page import="app.classes.Task" %>
<%@ page import="app.classes.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload File</title>
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
    <div class="card-container">
        <h1>Upload File</h1>
        <%
            String userRole = (String) session.getAttribute("userRole");
            if (userRole == null) {
                response.sendRedirect("../index.html");
                return;
            }

            Connection conn = null;
            String fileName = null;
            String fileLink = null;
            int taskId = 0; 
            User user = (User) session.getAttribute("loggedInUser");
            int userId = user.getId();
            String projectStatus = "pending";

            try {
                String taskIdParam = request.getParameter("task_id");
                if (taskIdParam != null && !taskIdParam.trim().isEmpty()) {
                    taskId = Integer.parseInt(taskIdParam);
                } else {
                    throw new Exception("Task ID is missing or invalid.");
                }

                fileName = request.getParameter("file_name");
                fileLink = request.getParameter("file_link");

                if (fileName == null || fileLink == null || fileName.trim().isEmpty() || fileLink.trim().isEmpty()) {
                    throw new Exception("File name or link is missing.");
                }

                conn = DbConnector.getConnection();
                if (conn == null) {
                    throw new SQLException("Failed to establish a connection to the database.");
                }

                Files file = new Files();
                file.setProjectId(Task.getProjectIdByTaskId(conn, taskId));
                file.setUserId(userId);
                file.setFilePath(fileLink);
                file.setUploadedDate(new java.sql.Date(System.currentTimeMillis()).toString());
                file.setFileName(fileName);
                file.setProjectStatus(Project.getProjectStatus(conn, Task.getProjectIdByTaskId(conn, taskId)));

                file.addFile(conn);

                out.println("<div class='alert alert-success' role='alert'>Google Drive link submitted successfully!</div>");
            } catch (NumberFormatException e) {
                out.println("<div class='alert alert-danger' role='alert'>Invalid Task ID: " + e.getMessage() + "</div>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger' role='alert'>An error occurred: " + e.getMessage() + "</div>");
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>
        <a href="home.jsp" class="btn btn-primary">Back to Dashboard</a>
    </div>
</body>
</html>
