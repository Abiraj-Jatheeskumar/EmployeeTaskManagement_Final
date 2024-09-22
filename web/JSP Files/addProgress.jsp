<%@page import="app.classes.User"%>
<%@page import="app.classes.DbConnector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="app.classes.Progress" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Progress</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function redirectToHome() {
            setTimeout(function() {
                window.location.href = 'home.jsp';
            }, 3000); 
        }
    </script>
</head>
<body>
<%
    if (session.getAttribute("userRole") == null || !"employee".equals(session.getAttribute("userRole"))) {
        response.sendRedirect("../index.html");
        return;
    }

    int taskId = Integer.parseInt(request.getParameter("task_id"));
    Date progressDate = Date.valueOf(request.getParameter("progress_date"));
    String progressDescription = request.getParameter("progress_description");
    int progressPercentage = Integer.parseInt(request.getParameter("progress_percentage"));
    User user = (User) session.getAttribute("loggedInUser");
    int userId = user.getId();

    if (request.getMethod().equalsIgnoreCase("POST")) {
        if (request.getParameter("confirm") == null) {
            out.println("<div class='container mt-4'>");
            out.println("<h4>Review Your Input</h4>");
            out.println("<table class='table table-bordered'>");
            out.println("<tr><th>Task ID</th><td>" + taskId + "</td></tr>");
            out.println("<tr><th>Date</th><td>" + progressDate + "</td></tr>");
            out.println("<tr><th>Description</th><td>" + progressDescription + "</td></tr>");
            out.println("<tr><th>Percentage</th><td>" + progressPercentage + "%</td></tr>");
            out.println("</table>");
            out.println("<form action='addProgress.jsp' method='post'>");
            out.println("<input type='hidden' name='task_id' value='" + taskId + "'>");
            out.println("<input type='hidden' name='progress_date' value='" + progressDate + "'>");
            out.println("<input type='hidden' name='progress_description' value='" + progressDescription + "'>");
            out.println("<input type='hidden' name='progress_percentage' value='" + progressPercentage + "'>");
            out.println("<button type='submit' class='btn btn-primary' name='confirm' value='true'>Confirm</button>");
            out.println("<a href='home.jsp' class='btn btn-secondary'>Cancel</a>");
            out.println("</form>");
            out.println("</div>");
        } else {
            Connection conn = null;
            Progress progress = null;

            try {
                conn = DbConnector.getConnection();
                progress = new Progress(conn);
                boolean success = progress.addProgress(taskId, userId, progressDate, progressDescription, progressPercentage);

                if (success) {
                    out.println("<div class='container mt-4'>");
                    out.println("<div class='alert alert-success' role='alert'>Progress added successfully!</div>");
                    out.println("</div>");

                    out.println("<script>redirectToHome();</script>");
                } else {
                    out.println("<div class='container mt-4'>");
                    out.println("<div class='alert alert-danger' role='alert'>Failed to add progress. Please try again.</div>");
                    out.println("</div>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='container mt-4'>");
                out.println("<div class='alert alert-danger' role='alert'>An error occurred: " + e.getMessage() + "</div>");
                out.println("</div>");
            } finally {
                if (conn != null) {
                    try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        }
    } else {
        out.println("<div class='container mt-4'>");
        out.println("<h4>Invalid Request</h4>");
        out.println("<p>Please submit the form to view and confirm your input.</p>");
        out.println("</div>");
    }
%>
</body>
</html>
