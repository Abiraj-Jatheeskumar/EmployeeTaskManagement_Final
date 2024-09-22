<%@page import="app.classes.ProjectProgress"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="app.classes.DbConnector" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        .progress-bar.bg-green {
            background-color: #28a745;
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

<jsp:include page="sidebar.jsp"/>

<div class="content">
    <jsp:include page="navbar.jsp" />
    <div class="container-fluid">
     
        <% 
    List<ProjectProgress> projectProgressList = null;
    try {
        ProjectProgress stats = new ProjectProgress();
        projectProgressList = stats.getProjectProgress();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>


<div class="container-fluid">
    <h2>Project Progress Report</h2>
    <div class="card card-outline card-success">
        <div class="card-header">
            <b>Project Progress</b>
            <div class="card-tools">
                <button class="btn btn-flat btn-sm bg-gradient-success btn-success" id="print"><i class="fa fa-print"></i> Print</button>
            </div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive" id="printable">
                <table class="table m-0 table-bordered">
                    <thead>
                        <th>#</th>
                        <th>Project</th>
                        <th>Total Tasks</th>
                        <th>Completed Tasks</th>
                        <th>Average Progress</th>
                        <th>Status</th>
                    </thead>
                    <tbody>
                        <%
                            int index = 1;
                            if (projectProgressList != null) {
                                for (ProjectProgress progress : projectProgressList) {
                        %>
                        <tr>
                            <td><%= index++ %></td>
                            <td><%= progress.getProjectName() %></td>
                            <td class="text-center"><%= progress.getTotalTasks() %></td>
                            <td class="text-center"><%= progress.getCompletedTasks() %></td>
                            <td class="project_progress">
                                <div class="progress progress-sm">
                                    <div class="progress-bar bg-green" role="progressbar" aria-valuenow="<%= progress.getAvgProgress() %>" aria-valuemin="0" aria-valuemax="100" style="width: <%= progress.getAvgProgress() %>%;"></div>
                                </div>
                                <small><%= String.format("%.2f", progress.getAvgProgress()) %> % Complete</small>
                            </td>
                            <td class="project-state">
                                <span class='badge badge-info'><%= progress.getStatus() %></span>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
   
    </div>
    <jsp:include page="footer.jsp" />    
</div>

<!-- Include Footer -->
<script>
    document.getElementById('print').addEventListener('click', function() {
        var printContent = document.getElementById('printable').innerHTML;
        var originalContent = document.body.innerHTML;
        document.body.innerHTML = printContent;
        window.print();
        document.body.innerHTML = originalContent;
    });
</script>
</body>
</html>
