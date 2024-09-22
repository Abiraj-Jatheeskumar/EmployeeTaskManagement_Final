package app.classes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Files {
    private int fileId;
    private int projectId;
    private int userId;
    private String filePath;
    private String uploadedDate;
    private String fileName;
    private String projectStatus;


    public Files() {
    }

    public Files(int fileId, int projectId, int userId, String filePath, String uploadedDate, String fileName, String projectStatus) {
        this.fileId = fileId;
        this.projectId = projectId;
        this.userId = userId;
        this.filePath = filePath;
        this.uploadedDate = uploadedDate;
        this.fileName = fileName;
        this.projectStatus = projectStatus;
    }


    public int getFileId() {
        return fileId;
    }

    public void setFileId(int fileId) {
        this.fileId = fileId;
    }

    public int getProjectId() {
        return projectId;
    }

    public void setProjectId(int projectId) {
        this.projectId = projectId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getUploadedDate() {
        return uploadedDate;
    }

    public void setUploadedDate(String uploadedDate) {
        this.uploadedDate = uploadedDate;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getProjectStatus() {
        return projectStatus;
    }

    public void setProjectStatus(String projectStatus) {
        this.projectStatus = projectStatus;
    }

    public void addFile(Connection conn) throws SQLException {
        String sql = "INSERT INTO files (project_id, user_id, file_path, uploaded_date, file_name, project_status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, this.projectId);
            pstmt.setInt(2, this.userId);
            pstmt.setString(3, this.filePath);
            pstmt.setString(4, this.uploadedDate);
            pstmt.setString(5, this.fileName);
            pstmt.setString(6, this.projectStatus);
            pstmt.executeUpdate();
        }
    }

    public static List<Files> getFilesByUserId(Connection conn, int userId) throws SQLException {
        String sql = "SELECT * FROM files WHERE user_id = ?";
        List<Files> fileList = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Files file = new Files();
                    file.setFileId(rs.getInt("file_id"));
                    file.setProjectId(rs.getInt("project_id"));
                    file.setUserId(rs.getInt("user_id"));
                    file.setFilePath(rs.getString("file_path"));
                    file.setUploadedDate(rs.getString("uploaded_date"));
                    file.setFileName(rs.getString("file_name"));
                    file.setProjectStatus(rs.getString("project_status"));
                    fileList.add(file);
                }
            }
        }
        return fileList;
    }

    public static void deleteFileById(Connection conn, int fileId) throws SQLException {
        String sql = "DELETE FROM files WHERE file_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, fileId);
            pstmt.executeUpdate();
        }
    }
    public static List<Files> getFilesByUserIdInProjects(Connection conn, int userId) throws SQLException {
        String sql = "SELECT f.* FROM files f " +
                     "INNER JOIN project p ON f.project_id = p.project_id " +
                     "WHERE p.user_id = ?";

        List<Files> fileList = new ArrayList<>();

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Files file = new Files();
                    file.setFileId(rs.getInt("file_id"));
                    file.setProjectId(rs.getInt("project_id"));
                    file.setUserId(rs.getInt("user_id"));
                    file.setFilePath(rs.getString("file_path"));
                    file.setUploadedDate(rs.getString("uploaded_date"));
                    file.setFileName(rs.getString("file_name"));
                    file.setProjectStatus(rs.getString("project_status"));
                    fileList.add(file);
                }
            }
        }

        return fileList;
    }

}
