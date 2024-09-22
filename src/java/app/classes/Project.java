package app.classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Project {

    private int project_id;
    private String name;
    private String status;
    private String startDate;
    private String endDate;
    private String projectManager;
    private String description;

    // Default constructor
    public Project() {

    }

    // Constructor
    public Project(String name, String status, String startDate, String endDate, String projectManager, String description) {
        this.name = name;
        this.status = status;
        this.startDate = startDate;
        this.endDate = endDate;
        this.projectManager = projectManager;
        this.description = description;
    }

    // Constructor with id
    public Project(int project_id, String name, String status, String startDate, String endDate, String projectManager, String description) {
        this.project_id = project_id;
        this.name = name;
        this.status = status;
        this.startDate = startDate;
        this.endDate = endDate;
        this.projectManager = projectManager;
        this.description = description;
    }

    public int getId() {
        return project_id;
    }

    public void setId(int id) {
        this.project_id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getProjectManager() {
        return projectManager;
    }

    public void setProjectManager(String projectManager) {
        this.projectManager = projectManager;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    private int getUserIdByName(Connection conn, String userName) throws SQLException {
        String sql = "SELECT user_id FROM user WHERE user_name = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userName);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                } else {
                    throw new SQLException("User not found: " + userName);
                }
            }
        }
    }

    public boolean saveProject(Connection conn) {
        try {
            int userId = getUserIdByName(conn, this.projectManager);
            String sql = "INSERT INTO project (project_name, project_status, start_date, end_date, user_id, description) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, this.name);
            pstmt.setString(2, this.status);
            pstmt.setString(3, this.startDate);
            pstmt.setString(4, this.endDate);
            pstmt.setInt(5, userId);
            pstmt.setString(6, this.description);

            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(Project.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public boolean updateProject(Connection conn) {
        try {
            int userId = getUserIdByName(conn, this.projectManager);
            String sql = "UPDATE project SET project_name = ?, project_status = ?, start_date = ?, end_date = ?, user_id = ?, description = ? WHERE project_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, this.name);
            pstmt.setString(2, this.status);
            pstmt.setString(3, this.startDate);
            pstmt.setString(4, this.endDate);
            pstmt.setInt(5, userId);
            pstmt.setString(6, this.description);
            pstmt.setInt(7, this.project_id);

            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(Project.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public boolean deleteProject(Connection conn) {
        try {
            String sql = "DELETE FROM project WHERE project_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, this.project_id);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(Project.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public static List<Project> getAllProjects(Connection conn) {
        List<Project> projects = new ArrayList<>();
        String sql = "SELECT project_id, project_name, project_status, start_date, end_date, u.user_name, description FROM project p JOIN user u ON p.user_id=u.user_id";

        try (PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Project project = new Project();
                project.setId(rs.getInt("project_id"));
                project.setName(rs.getString("project_name"));
                project.setStatus(rs.getString("project_status"));
                project.setStartDate(rs.getString("start_date"));
                project.setEndDate(rs.getString("end_date"));
                project.setProjectManager(rs.getString("user_name"));
                project.setDescription(rs.getString("description"));
                projects.add(project);
            }
        } catch (SQLException ex) {
            Logger.getLogger(Project.class.getName()).log(Level.SEVERE, null, ex);
        }
        return projects;
    }

    public static Project getProjectById(Connection conn, int id) {
        String sql = "SELECT p.project_id, p.project_name, p.project_status, p.start_date, p.end_date, u.user_name, p.description FROM project p JOIN user u ON p.user_id = u.user_id WHERE p.project_id = ?";
        Project project = null;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    project = new Project();
                    project.setId(rs.getInt("project_id"));
                    project.setName(rs.getString("project_name"));
                    project.setStatus(rs.getString("project_status"));
                    project.setStartDate(rs.getString("start_date"));
                    project.setEndDate(rs.getString("end_date"));
                    project.setProjectManager(rs.getString("user_name"));
                    project.setDescription(rs.getString("description"));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(Project.class.getName()).log(Level.SEVERE, null, ex);
        }
        return project;
    }
    public List<Project> getProjects() throws SQLException {
        List<Project> projectList = new ArrayList<Project>(); // No diamond operator
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnector.getConnection();
            String sql = "SELECT * FROM project";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Project project = new Project();
                project.setId(rs.getInt("project_id"));
                project.setName(rs.getString("project_name"));
                project.setStartDate(rs.getString("start_date"));
                project.setEndDate(rs.getString("end_date"));
                project.setStatus(rs.getString("project_status"));
                projectList.add(project);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (stmt != null) {
                try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }

        return projectList;
    }
    
    public static List<Project> getProjectsByUserId(int userId) {
        List<Project> projectList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DbConnector.getConnection();
            String sql = "SELECT * FROM project WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Project project = new Project();
                project.setId(rs.getInt("project_id"));
                project.setName(rs.getString("project_name"));
                project.setStartDate(rs.getString("start_date"));
                project.setEndDate(rs.getString("end_date"));
                project.setDescription(rs.getString("description"));
                project.setStatus(rs.getString("project_status"));
                projectList.add(project);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }

        return projectList;
    }
    
    public static String getProjectName(Connection conn,int projectId) throws SQLException {
        String ProjectName = "";
        String sql = "SELECT project_name FROM project WHERE project_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, projectId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ProjectName = rs.getString("project_name");
                }
            }
        }
        return ProjectName;
    }
    
    public static String getProjectStatus(Connection conn,int projectId) throws SQLException {
        String ProjectStatus = "";
        String sql = "SELECT project_status FROM project WHERE project_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, projectId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ProjectStatus = rs.getString("project_status");
                }
            }
        }
        return ProjectStatus;
    }
}
