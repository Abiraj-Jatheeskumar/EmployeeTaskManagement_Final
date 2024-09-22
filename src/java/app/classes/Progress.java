package app.classes;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Progress {
    private int progres_id;
    private int task_id;
    private int user_id;
    private Date progress_date;
    private String progress_description;
    private int progress_percentage;


    public Progress() {
    }

    public Progress(int progres_id, int task_id, int user_id, Date progress_date, String progress_description, int progress_percentage) {
        this.progres_id = progres_id;
        this.task_id = task_id;
        this.user_id = user_id;
        this.progress_date = progress_date;
        this.progress_description = progress_description;
        this.progress_percentage = progress_percentage;
    }

    public int getProgres_id() {
        return progres_id;
    }

    public void setProgres_id(int progres_id) {
        this.progres_id = progres_id;
    }

    public int getTask_id() {
        return task_id;
    }

    public void setTask_id(int task_id) {
        this.task_id = task_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public Date getProgress_date() {
        return progress_date;
    }

    public void setProgress_date(Date progress_date) {
        this.progress_date = progress_date;
    }

    public String getProgress_description() {
        return progress_description;
    }

    public void setProgress_description(String progress_description) {
        this.progress_description = progress_description;
    }

    public int getProgress_percentage() {
        return progress_percentage;
    }

    public void setProgress_percentage(int progress_percentage) {
        this.progress_percentage = progress_percentage;
    }

    private Connection connection;

    public Progress(Connection connection) {
        this.connection = connection;
    }

    public boolean addProgress(int taskId, int userId, Date progressDate, String progressDescription, int progressPercentage) {
        String sql = "INSERT INTO progress (task_id, user_id, progress_date, progress_description, progress_percentage) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            stmt.setInt(2, userId);
            stmt.setDate(3, progressDate);
            stmt.setString(4, progressDescription);
            stmt.setInt(5, progressPercentage);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Task> getTasksByUserId(int userId) throws SQLException {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT task_id, task_name FROM task WHERE user_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.setTaskId(rs.getInt("task_id"));
                    task.setTaskName(rs.getString("task_name"));
                    tasks.add(task);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return tasks;
    }
    public String getTaskNameById(int taskId) throws SQLException {
        String taskName = null;
        String sql = "SELECT task_name FROM task WHERE task_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    taskName = rs.getString("task_name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return taskName;
    }
    
    public List<Progress> getProgressByUserId(int userId) throws SQLException {
        List<Progress> progressList = new ArrayList<>();
        String sql = "SELECT progress_id, task_id, progress_date, progress_description, progress_percentage FROM progress WHERE user_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Progress progress = new Progress();
                    progress.setProgres_id(rs.getInt("progress_id"));
                    progress.setTask_id(rs.getInt("task_id"));
                    progress.setProgress_date(rs.getDate("progress_date"));
                    progress.setProgress_description(rs.getString("progress_description"));
                    progress.setProgress_percentage(rs.getInt("progress_percentage"));
                    progressList.add(progress);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return progressList;
    }
    
    
}
