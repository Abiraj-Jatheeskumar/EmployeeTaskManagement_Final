package app.classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Task {

    private int task_id;
    private int project_id;
    private int user_id;
    private String task_name;
    private String status;
    private String priority;
    private String due_date;
    private String description;
    private String projectName;
    private double avgProgress;
    
    public Task() {
    }

    public Task(String task_name, String status, String priority, String due_date, int user_id, String description) {
        this.task_name = task_name;
        this.status = status;
        this.priority = priority;
        this.due_date = due_date;
        this.user_id = user_id;
        this.description = description;
    }

    public Task(int task_id, String task_name, String status, String priority, String due_date, int user_id, String description) {
        this.task_id = task_id;
        this.task_name = task_name;
        this.status = status;
        this.priority = priority;
        this.due_date = due_date;
        this.user_id = user_id;
        this.description = description;
    }

    // Getters and setters
    public int getTaskId() {
        return task_id;
    }

    public void setTaskId(int task_id) {
        this.task_id = task_id;
    }

    public int getProjectId() {
        return project_id;
    }

    public void setProjectId(int project_id) {
        this.project_id = project_id;
    }

    public int getUserId() {
        return user_id;
    }

    public void setUserId(int user_id) {
        this.user_id = user_id;
    }

    public String getTaskName() {
        return task_name;
    }

    public void setTaskName(String task_name) {
        this.task_name = task_name;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getDueDate() {
        return due_date;
    }

    public void setDueDate(String due_date) {
        this.due_date = due_date;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }
    public String getProjectName(){
        return this.projectName;
    }

   public boolean saveTask(Connection conn) {
        String sql = "INSERT INTO task (project_id, task_name, description, status, priority, due_date, user_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, this.project_id);
            pstmt.setString(2, this.task_name);
            pstmt.setString(3, this.description);
            pstmt.setString(4, this.status);
            pstmt.setString(5, this.priority);
            pstmt.setString(6, this.due_date);
            pstmt.setInt(7, this.user_id);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTask(Connection conn) {
        try {
            String sql = "UPDATE task SET task_name = ?, status = ?, priority = ?, due_date = ?, user_id = ?, description = ? WHERE task_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, this.task_name);
            pstmt.setString(2, this.status);
            pstmt.setString(3, this.priority);
            pstmt.setString(4, this.due_date);
            pstmt.setInt(5, this.user_id);
            pstmt.setString(6, this.description);
            pstmt.setInt(7, this.task_id);

            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(Task.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public boolean deleteTask(Connection conn) {
        try {
            String sql = "DELETE FROM task WHERE task_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, this.task_id);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(Task.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

   
       public static List<Task> getAllTasks(Connection conn) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.*, p.project_name FROM task t LEFT JOIN project p ON t.project_id = p.project_id";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setProjectId(rs.getInt("project_id"));
                task.setTaskName(rs.getString("task_name"));
                task.setDescription(rs.getString("description"));
                task.setStatus(rs.getString("status"));
                task.setPriority(rs.getString("priority"));
                task.setDueDate(rs.getString("due_date"));
                task.setUserId(rs.getInt("user_id"));
                task.setProjectName(rs.getString("project_name")); 
                tasks.add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tasks;
    }

    public String getUserName(Connection conn) throws SQLException {
        String userName = "";
        String sql = "SELECT user_name FROM user WHERE user_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, this.user_id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    userName = rs.getString("user_name");
                }
            }
        }
        return userName;
    }
    
    public static int getProjectIdByTaskId(Connection conn,int taskId) throws SQLException {
        int project_id = 0;
        String sql = "SELECT project_id FROM task WHERE task_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, taskId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    project_id = rs.getInt("project_id");
                }
            }
        }
        return project_id;
    }
    
    public static List<Task> getTasksByUserId(int userId) {
        List<Task> taskList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement taskStmt = null;
        ResultSet taskRs = null;

        try {
            conn = DbConnector.getConnection();
            String taskSql = "SELECT t.task_id, t.task_name, p.project_name, t.status, t.priority, t.due_date, " +
                             "COALESCE(SUM(pr.progress_percentage) / COUNT(pr.progress_id), 0) AS avg_progress " +
                             "FROM task t " +
                             "JOIN project p ON t.project_id = p.project_id " +
                             "LEFT JOIN progress pr ON t.task_id = pr.task_id " +
                             "WHERE p.user_id = ? " +
                             "GROUP BY t.task_id, t.task_name, p.project_name, t.status, t.priority, t.due_date";

            taskStmt = conn.prepareStatement(taskSql);
            taskStmt.setInt(1, userId);
            taskRs = taskStmt.executeQuery();

            while (taskRs.next()) {
                Task task = new Task();
                task.setTaskId(taskRs.getInt("task_id"));
                task.setTaskName(taskRs.getString("task_name"));
                task.setProjectName(taskRs.getString("project_name"));
                task.setStatus(taskRs.getString("status"));
                task.setPriority(taskRs.getString("priority"));
                task.setDueDate(taskRs.getString("due_date"));
                task.setAvgProgress(taskRs.getDouble("avg_progress"));
                taskList.add(task);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (taskRs != null) try { taskRs.close(); } catch (SQLException ignore) {}
            if (taskStmt != null) try { taskStmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }

        return taskList;
    }

   public double getAvgProgress() { return avgProgress; }
    public void setAvgProgress(double avgProgress) { this.avgProgress = avgProgress; }
    
    public static List<Task> getUserIDTasks(int userID) throws SQLException {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.*, p.project_name FROM task t " +
                     "LEFT JOIN project p ON t.project_id = p.project_id " +
                     "WHERE p.user_id = ?";
        try (Connection conn = DbConnector.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userID);  
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.setTaskId(rs.getInt("task_id"));
                    task.setProjectId(rs.getInt("project_id"));
                    task.setTaskName(rs.getString("task_name"));
                    task.setDescription(rs.getString("description"));
                    task.setStatus(rs.getString("status"));
                    task.setPriority(rs.getString("priority"));
                    task.setDueDate(rs.getString("due_date"));
                    task.setUserId(rs.getInt("user_id"));
                    task.setProjectName(rs.getString("project_name"));
                    tasks.add(task);
                }
            } catch (SQLException e) {
                e.printStackTrace(); 
            }
        } catch (SQLException e) {
            e.printStackTrace(); 
        }
        return tasks;
    }
    
    public static Task getTaskById(Connection conn, int taskId) throws SQLException {
        Task task = null;
        String sql = "SELECT t.task_id, t.project_id, t.task_name, t.description, t.status, t.priority, t.due_date, t.user_id, p.project_name " +
                     "FROM task t " +
                     "LEFT JOIN project p ON t.project_id = p.project_id " +
                     "WHERE t.task_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    task = new Task();
                    task.setTaskId(rs.getInt("task_id"));
                    task.setProjectId(rs.getInt("project_id"));
                    task.setTaskName(rs.getString("task_name"));
                    task.setDescription(rs.getString("description"));
                    task.setStatus(rs.getString("status"));
                    task.setPriority(rs.getString("priority"));
                    task.setDueDate(rs.getString("due_date"));
                    task.setUserId(rs.getInt("user_id"));
                    task.setProjectName(rs.getString("project_name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return task;
    }


}
