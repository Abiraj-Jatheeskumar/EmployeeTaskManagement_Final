package app.classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ProjectProgress {

    private String projectName;
    private int totalTasks;
    private int completedTasks;
    private double avgProgress;
    private String status;

    public ProjectProgress() {
    }

    public ProjectProgress(String projectName, int totalTasks, int completedTasks, double avgProgress, String status) {
        this.projectName = projectName;
        this.totalTasks = totalTasks;
        this.completedTasks = completedTasks;
        this.avgProgress = avgProgress;
        this.status = status;
    }

    public String getProjectName() {
        return projectName;
    }

    public int getTotalTasks() {
        return totalTasks;
    }

    public int getCompletedTasks() {
        return completedTasks;
    }

    public double getAvgProgress() {
        return avgProgress;
    }

    public String getStatus() {
        return status;
    }

    public static double getTotalProgressForProject(int projectId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(latest_progress.progress_percentage), 0) AS total_progress "
                + "FROM task t "
                + "LEFT JOIN ( "
                + "    SELECT task_id, progress_percentage "
                + "    FROM progress "
                + "    WHERE (task_id, progress_date) IN ( "
                + "        SELECT task_id, MAX(progress_date) "
                + "        FROM progress "
                + "        GROUP BY task_id "
                + "    ) "
                + ") AS latest_progress ON t.task_id = latest_progress.task_id "
                + "WHERE t.project_id = ?";

        try (Connection conn = DbConnector.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, projectId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total_progress");
                }
            }
        }
        return 0;
    }

    private int getTotalTasks(Connection conn, int projectId) throws SQLException {
        String sql = "SELECT COUNT(*) AS total_tasks FROM task WHERE project_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, projectId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_tasks");
                }
            }
        }
        return 0;
    }

    private int getCompletedTasks(Connection conn, int projectId) throws SQLException {
        String sql = "SELECT COUNT(*) AS completed_tasks FROM task WHERE project_id = ? AND status = 'Completed'";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, projectId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("completed_tasks");
                }
            }
        }
        return 0;
    }

    private double getAverageProgress(Connection conn, int projectId) throws SQLException {
        if (getCompletedTasks(conn, projectId) == getTotalTasks(conn, projectId) && getTotalTasks(conn, projectId) != 0) {
            return 100;
        } else if ("Completed".equals(Project.getProjectStatus(conn, projectId))) {
            return 100;
        } else if (getTotalTasks(conn, projectId) != 0) {
            return getTotalProgressForProject(projectId) / getTotalTasks(conn, projectId);
        }
        return 0;
    }

    public List<ProjectProgress> getProjectProgress() throws SQLException {
        List<ProjectProgress> progressList = new ArrayList<>();
        String sql = "SELECT p.project_id, p.project_name "
                + "FROM project p";

        try (Connection conn = DbConnector.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                int projectId = rs.getInt("project_id");
                String projectName = rs.getString("project_name");

                int totalTasks = getTotalTasks(conn, projectId);
                int completedTasks = getCompletedTasks(conn, projectId);
                double avgProgress = getAverageProgress(conn, projectId);
                String status = (avgProgress >= 100) ? "Completed" : "On-Progress";

                progressList.add(new ProjectProgress(projectName, totalTasks, completedTasks, avgProgress, status));
            }
        } catch (SQLException e) {
            Logger.getLogger(ProjectProgress.class.getName()).log(Level.SEVERE, "Error fetching project progress", e);
            throw e;
        }
        return progressList;
    }

    public static int getTotalUsersFromUser() {
        return getCount("SELECT COUNT(*) AS total FROM user");
    }

    public static int getTotalProjectsFromProject() {
        return getCount("SELECT COUNT(*) AS total FROM project");
    }

    public static int getTotalTasksFromTask() {
        return getCount("SELECT COUNT(*) AS total FROM task");
    }

    public static int getTotalFilesFromFiles() {
        return getCount("SELECT COUNT(*) AS total FROM files");
    }

    public static int getCompletedTasksFromTask() {
        return getCount("SELECT COUNT(*) AS total FROM task WHERE status = 'Completed'");
    }

    private static int getCount(String query) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int count = 0;

        try {
            conn = DbConnector.getConnection();
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException ignore) {
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException ignore) {
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ignore) {
                }
            }
        }

        return count;
    }

}
