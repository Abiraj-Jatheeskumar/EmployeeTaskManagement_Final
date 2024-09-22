<%@page import="app.classes.Files"%>
<%@page import="app.classes.ProjectProgress"%>
<%@page import="app.classes.Project"%>
<%@page import="app.classes.User"%>
<%@page import="java.util.List"%>
<%@page import="app.classes.Task"%>
<%@page import="app.classes.Progress"%>
<%@page import="java.util.ArrayList"%>
<%@page import="app.classes.DbConnector"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskPilot Dashboard</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <!-- Include sidebar -->
    <style>
        
        .card{
            background-color: #0000FF;
        }
        
    </style>
    
    
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
<!-- Include Navbar -->


<!-- Page Content -->
<div class="content">
    <jsp:include page="navbar.jsp" />
    <div class="container-fluid">
        <!-- Page content goes here -->
        
        <%
                       if ("employee".equals(userRole)) {
                        
                    %>
                    <h1>Record Your Progress</h1>
                    
    <!-- Progress Form -->
                    <div class="card progress-form">
                        <div class="card-body">
                            <h5 class="card-title">Add New Progress</h5>
                            <form action="addProgress.jsp" method="post">
                                <div class="form-group">
                                    <label for="task_id">Task:</label>
                                    <select class="form-control" id="task_id" name="task_id" required>
                                        <%
                                            Connection conn = null;
                                            List<Task> tasks = new ArrayList<Task>();  
                                            User user = (User) session.getAttribute("loggedInUser");
                                            
                                            int userId = user.getId();
                                            
                                            try {
                                                conn = DbConnector.getConnection();
                                                if (conn == null) {
                                                    throw new SQLException("Failed to establish a connection to the database.");
                                                }

                                                Progress progress = new Progress(conn);
                                                tasks = progress.getTasksByUserId(userId);

                                                for (Task task : tasks) {
                                                    %>
                                                    <option value="<%= task.getTaskId() %>"><%= task.getTaskName() %> : <%=Project.getProjectName(conn, Task.getProjectIdByTaskId(conn,task.getTaskId() )) %></option>
                                                    <%
                                                }
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
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="progress_date">Date:</label>
                                    <input type="date" class="form-control" id="progress_date" name="progress_date" required>
                                </div>
                                <div class="form-group">
                                    <label for="progress_description">Description:</label>
                                    <textarea class="form-control" id="progress_description" name="progress_description" rows="3" required></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="progress_percentage">Percentage:</label>
                                    <input type="number" class="form-control" id="progress_percentage" name="progress_percentage" min="0" max="100" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Add Progress</button>
                            </form>
                        </div>
                    </div>
                                    
                                    
              <!-- Google Drive Link Form -->
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">Submit Google Drive Link</h5>
                <form action="uploadFile.jsp" method="post">
                    <div class="form-group">
                        <label for="task_id">Task:</label>
                        <select class="form-control" id="task_id" name="task_id" required>
                            <%

                                try {
                                    conn = DbConnector.getConnection();
                                    if (conn == null) {
                                        throw new SQLException("Failed to establish a connection to the database.");
                                    }

                                    Progress progress = new Progress(conn);
                                    tasks = progress.getTasksByUserId(userId);

                                    for (Task task : tasks) {
                                        %>
                                        <option value="<%= task.getTaskId() %>"><%= task.getTaskName() %> : <%=Project.getProjectName(conn, Task.getProjectIdByTaskId(conn,task.getTaskId() )) %></option>
                                        <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    out.println("<div class='alert alert-danger' role='alert'>An error occurred: " + e.getMessage() + "</div>");
                                } finally {
                                    if (conn != null) {
                                        try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    }
                                }
                            %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="file_name">File Name:</label>
                        <input type="text" class="form-control" id="file_name" name="file_name" required>
                    </div>
                    <div class="form-group">
                        <label for="file_link">Google Drive Link:</label>
                        <input type="url" class="form-control" id="file_link" name="file_link" required placeholder="https://drive.google.com/your-file-link">
                    </div>
                    <button type="submit" class="btn btn-primary">Submit Link</button>
                </form>
            </div>
        </div>

        <!-- List Submitted Links -->
        <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Submitted Links</h5>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th scope="col">File ID</th>
                                <th scope="col">File Name</th>
                                <th scope="col">Project Name</th>
                                <th scope="col">Uploaded Date</th>
                                <th scope="col">Google Drive Link</th>
                                <th scope="col">Actions</th> 
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Files> fileList = null;
                                try {
                                    conn = DbConnector.getConnection();
                                    if (conn == null) {
                                        throw new SQLException("Failed to establish a connection to the database.");
                                    }
                                    fileList = Files.getFilesByUserId(conn, userId);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    out.println("<div class='alert alert-danger' role='alert'>An error occurred: " + e.getMessage() + "</div>");
                                } finally {
                                    if (conn != null) {
                                        try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    }
                                }
                            %>
                            <% if (fileList != null) {
                                    for (Files file : fileList) {
                                        String projectName = null;
                                        try {
                                            conn = DbConnector.getConnection();
                                            projectName = Project.getProjectName(conn, file.getProjectId());
                                        } catch (Exception e) {
                                            out.println("<div class='alert alert-danger' role='alert'>Error retrieving project name: " + e.getMessage() + "</div>");
                                        }
                            %>
                                <tr>
                                    <td><%= file.getFileId() %></td>
                                    <td><%= file.getFileName() %></td>
                                    <td><%= projectName %></td>
                                    <td><%= file.getUploadedDate() %></td>
                                    <td><a href="<%= file.getFilePath() %>" class="btn btn-success btn-sm" target="_blank">View File</a></td>
                                    <td>
                                        
                                        <form action="deleteFile.jsp" method="post" style="display:inline;">
                                            <input type="hidden" name="file_id" value="<%= file.getFileId() %>" />
                                            <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                        </form>
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


                    <!-- Progress Table -->
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Your Progress Records</h5>
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th scope="col">Progress ID</th>
                                        <th scope="col">Task Name</th>
                                        <th scope="col">Date</th>
                                        <th scope="col">Description</th>
                                        <th scope="col">Percentage</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Progress progress = null;
                                        List<Progress> progressList = null;

                                        try {
                                            conn = DbConnector.getConnection();
                                            if (conn == null) {
                                                throw new SQLException("Failed to establish a connection to the database.");
                                            }
                                            progress = new Progress(conn);
                                            progressList = progress.getProgressByUserId(userId);
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                            out.println("<div class='alert alert-danger' role='alert'>An error occurred: " + e.getMessage() + "</div>");
                                        } 
                                    %>
                                    <% if (progressList != null) {
                                            for (Progress record : progressList) {
                                                String taskName = null;
                                                try {
                                                    taskName = progress.getTaskNameById(record.getTask_id());
                                                } catch (SQLException e) {
                                                    out.println("<div class='alert alert-danger' role='alert'>Error retrieving task name: " + e.getMessage() + "</div>");
                                                }
                                    %>
                                        <tr>
                                            <td><%= record.getProgres_id() %></td>
                                            <td><%= taskName %></td>
                                            <td><%= record.getProgress_date() %></td>
                                            <td><%= record.getProgress_description() %></td>
                                            <td><%= record.getProgress_percentage() %></td>
                                        </tr>
                                    <% 
                                            }
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    
                    
                    <%}%>
                    
           <%
                       if ("admin".equals(userRole)) {
                        
                    %>         
         <h1>Welcome to the Admin Dashboard</h1>
        <%
                            
                    int totalUsers = ProjectProgress.getTotalUsersFromUser();
                    int totalProjects = ProjectProgress.getTotalProjectsFromProject();
                    int totalTasks = ProjectProgress.getTotalTasksFromTask();
                    int totalFiles = ProjectProgress.getTotalFilesFromFiles();
                    int completedTasks = ProjectProgress.getCompletedTasksFromTask();

                        %>
         
        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Total Users</h5>
                        <p class="card-text"><%= totalUsers %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Total Projects</h5>
                        <p class="card-text"><%= totalProjects %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Total Tasks</h5>
                        <p class="card-text"><%= totalTasks %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Total Files</h5>
                        <p class="card-text"><%= totalFiles %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Completed Tasks</h5>
                        <p class="card-text"><%= completedTasks %></p>
                    </div>
                </div>
            </div>
        </div>
        
        
         <%}%>
         
                   <%
                       if ("manager".equals(userRole)) {
                        
                    %> 
                    
                    
    
         
         <h1>Manager Dashboard</h1>
        <h3>Your Assigned Projects</h3>

        <!-- Project Overview -->
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title">Project Overview</h5>
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th scope="col">Project ID</th>
                            <th scope="col">Project Name</th>
                            <th scope="col">Start Date</th>
                            <th scope="col">End Date</th>
                            <th scope="col">Description</th>
                            <th scope="col">Status</th>
                            <th scope="col">Edit Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            User user = (User) session.getAttribute("loggedInUser");
                    int userId = user.getId();
                    List<Project> projectList = Project.getProjectsByUserId(userId);

                        %>
                        <% for (Project project : projectList) { %>
                            <tr>
                                <td><%= project.getId() %></td>
                                <td><%= project.getName() %></td>
                                <td><%= project.getStartDate() %></td>
                                <td><%= project.getEndDate() %></td>
                                <td><%= project.getDescription()%></td>
                                <td><%= project.getStatus() %></td>
                                <td><a href="editProject.jsp?id=<%= project.getId() %>" class="btn btn-primary btn-sm">Edit</a></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Task Progress Overview -->
        <h3>Task Progress for Your Projects</h3>
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title">Task Progress</h5>
                <table class="table table-striped">
                   <thead>
                <tr>
                    <th scope="col">Task ID</th>
                    <th scope="col">Task Name</th>
                    <th scope="col">Project Name</th>
                    <th scope="col">Status</th>
                    <th scope="col">Priority</th>
                    <th scope="col">Due Date</th>
                    <th scope="col">Average Progress</th>
                </tr>
            </thead>
            <tbody>
                <%
                    
                    List<Task> taskList = Task.getTasksByUserId(userId);

                    for (Task task : taskList) {
                %>
                <tr>
                    <td><%= task.getTaskId() %></td>
                    <td><%= task.getTaskName() %></td>
                    <td><%= task.getProjectName() %></td>
                    <td><%= task.getStatus() %></td>
                    <td><%= task.getPriority() %></td>
                    <td><%= task.getDueDate() %></td>
                    <td>
                                <div class="progress">
                                    <div class="progress-bar bg-green" role="progressbar" style="width: <%= task.getAvgProgress() %>%" aria-valuenow="<%= task.getAvgProgress() %>" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <small><%= String.format("%.2f", task.getAvgProgress()) %> % Complete</small>
                            </td>
                </tr>
                <% } %>
            </tbody>
                </table>
            </div>
        </div>
            
            
            
             <!-- List Submitted Links -->
           <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Submitted Links</h5>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th scope="col">File ID</th>
                                <th scope="col">File Name</th>
                                <th scope="col">Project Name</th>
                                <th scope="col">Uploaded Date</th>
                                <th scope="col">Google Drive Link</th>
                                <th scope="col">Actions</th> 
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Files> fileList = null;
                                Connection conn = null;
                                try {
                                    conn = DbConnector.getConnection();
                                    if (conn == null) {
                                        throw new SQLException("Failed to establish a connection to the database.");
                                    }
                                    fileList = Files.getFilesByUserIdInProjects(conn, userId);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    out.println("<div class='alert alert-danger' role='alert'>An error occurred: " + e.getMessage() + "</div>");
                                } finally {
                                    if (conn != null) {
                                        try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    }
                                }
                            %>
                            <% if (fileList != null) {
                                    for (Files file : fileList) {
                                        String projectName = null;
                                        try {
                                            conn = DbConnector.getConnection();
                                            projectName = Project.getProjectName(conn, file.getProjectId());
                                        } catch (Exception e) {
                                            out.println("<div class='alert alert-danger' role='alert'>Error retrieving project name: " + e.getMessage() + "</div>");
                                        }
                            %>
                                <tr>
                                    <td><%= file.getFileId() %></td>
                                    <td><%= file.getFileName() %></td>
                                    <td><%= projectName %></td>
                                    <td><%= file.getUploadedDate() %></td>
                                    <td><a href="<%= file.getFilePath() %>" class="btn btn-success btn-sm" target="_blank">View File</a></td>
                                    <td>
                                        <form action="deleteFile.jsp" method="post" style="display:inline;">
                                            <input type="hidden" name="file_id" value="<%= file.getFileId() %>" />
                                            <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                        </form>
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

            
         <%}%> 
         
         
         
         
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