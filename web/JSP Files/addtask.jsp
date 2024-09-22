<%@ page import="app.classes.DbConnector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Task</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        .content {
            width: 100%;
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
<!-- Page Content -->
<div class="content">
    <jsp:include page="navbar.jsp" />
    <div class="container-fluid">
        <h1>Add New Task</h1>
        <form action="savetask.jsp" method="post">
            <div class="form-group">
                <label for="taskName">Task Name</label>
                <input type="text" class="form-control" id="taskName" name="taskName" placeholder="Enter task name" required>
            </div>
            <div class="form-group">
                <label for="taskStatus">Status</label>
                <select class="form-control" id="taskStatus" name="taskStatus" required>
                    <option value="Pending">Pending</option>
                    <option value="On Hold">On Hold</option>
                    <option value="Completed">Completed</option>
                </select>
            </div>
            <div class="form-group">
                <label for="taskPriority">Priority</label>
                <select class="form-control" id="taskPriority" name="taskPriority" required>
                    <option value="Low">Low</option>
                    <option value="Medium">Medium</option>
                    <option value="High">High</option>
                </select>
            </div>
            <div class="form-group">
                <label for="dueDate">Due Date</label>
                <input type="date" class="form-control" id="dueDate" name="dueDate" required>
            </div>
            <div class="form-group">
                <label for="assignedUser">Assigned Employee</label>
                <select class="form-control" id="assignedUser" name="assignedUser" required>
                    <option value="">Select Employee</option>
                    <%
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;
                        try {
                            DbConnector db = new DbConnector();
                            conn = db.getConnection();
                            String sql = "SELECT user_id, user_name FROM user";
                            stmt = conn.prepareStatement(sql);
                            rs = stmt.executeQuery();
                            while (rs.next()) {
                                int userId = rs.getInt("user_id");
                                String userName = rs.getString("user_name");
                                out.println("<option value='" + userId + "'>" + userName + "</option>");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                        }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="taskDescription">Description</label>
                <textarea class="form-control" id="taskDescription" name="taskDescription" rows="3" placeholder="Enter task description" required></textarea>
            </div>
            <div class="form-group">
                <label for="projectName">Project Name</label>
                <select class="form-control" id="projectName" name="projectName">
                    <option value="">None</option>
                    <%
                        conn = null;
                        stmt = null;
                        rs = null;
                        try {
                            DbConnector db = new DbConnector();
                            conn = db.getConnection();
                            String sql = "SELECT project_name FROM project";
                            stmt = conn.prepareStatement(sql);
                            rs = stmt.executeQuery();
                            while (rs.next()) {
                                String projectName = rs.getString("project_name");
                                out.println("<option value='" + projectName + "'>" + projectName + "</option>");
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                        }
                    %>
                </select>
            </div>
            
            <button type="submit" class="btn btn-primary">Save</button>
            <button type="button" class="btn btn-secondary" onclick="window.location.href='tasklist.jsp'">Cancel</button>
        </form>
    </div>
    <jsp:include page="footer.jsp" />
</div>

<!-- Include Footer -->

</body>
</html>
