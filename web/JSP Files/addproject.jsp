<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="app.classes.DbConnector" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Project</title>
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

<div class="content">
    <jsp:include page="navbar.jsp" />
    <div class="container-fluid">
        <h1>Add New Project</h1>
        <form action="saveproject.jsp" method="post">
            <div class="form-group">
                <label for="projectName">Project Name</label>
                <input type="text" class="form-control" id="projectName" name="projectName" placeholder="Enter project name">
            </div>
            <div class="form-group">
                <label for="projectStatus">Status</label>
                <select class="form-control" id="projectStatus" name="projectStatus">
                    <option>Pending</option>
                    <option>On Hold</option>
                    <option>Completed</option>
                </select>
            </div>
            <div class="form-group">
                <label for="startDate">Start Date</label>
                <input type="date" class="form-control" id="startDate" name="startDate">
            </div>
            <div class="form-group">
                <label for="endDate">End Date</label>
                <input type="date" class="form-control" id="endDate" name="endDate">
            </div>
            <div class="form-group">
                <label for="projectManager">Project Manager</label>
                <select class="form-control" id="projectManager" name="projectManager">
                    <option value="">Select Project Manager</option>
                    <%
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;
                        try {
                            conn = DbConnector.getConnection();
                            String sql = "SELECT user_id, user_name FROM user WHERE role = 'manager'";
                            stmt = conn.prepareStatement(sql);
                            rs = stmt.executeQuery();
                            while (rs.next()) {
                                int userId = rs.getInt("user_id");
                                String userName = rs.getString("user_name");
                                out.println("<option value='" + userName + "'>" + userName + "</option>");
                            }
                        } catch (SQLException e) {
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
                <label for="description">Description</label>
                <textarea class="form-control" id="description" name="description" rows="3" placeholder="Enter project description"></textarea>
            </div>
            <button type="submit" class="btn btn-primary">Save</button>
            <button type="button" class="btn btn-secondary" onclick="window.location.href='home.jsp'">Cancel</button>
        </form>
    </div>
    <jsp:include page="footer.jsp" />
</div>

<!-- Include Footer -->

</body>
</html>
