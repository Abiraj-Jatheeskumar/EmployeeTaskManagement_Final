package app.classes;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class User {
    private int id;
    private String firstName;
    private String lastName;
    private String userRole;
    private String email;
    private String password;
    private String username;
    private String contact_num;
    private String profile_picture;

    public User() {}

    public User(String username, String firstName, String lastName, String userRole, String email, String contact_num, String password) {
        this.username = username;
        this.firstName = firstName;
        this.lastName = lastName;
        this.userRole = userRole;
        this.email = email;
        this.contact_num = contact_num;
        this.password = password;
    }

    public String getContact_num() {
        return contact_num;
    }

    public void setContact_num(String contact_num) {
        this.contact_num = contact_num;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getProfile_picture() {
        return profile_picture;
    }

    public void setProfile_picture(String profile_picture) {
        this.profile_picture = profile_picture;
    }
public static User authenticateUser(String email, String password) {
        Connection connection = null;
        PreparedStatement statement = null;
        ResultSet resultSet = null;
        User user = null;

        try {
            connection = DbConnector.getConnection();
            String hashedPassword = MD5.getMd5(password);

            String sql = "SELECT * FROM user WHERE email = ? AND password = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, email);
            statement.setString(2, hashedPassword);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                user = new User();
                user.setId(resultSet.getInt("user_id"));
                user.setFirstName(resultSet.getString("first_name"));
                user.setLastName(resultSet.getString("last_name"));
                user.setUserRole(resultSet.getString("role"));
                user.setEmail(resultSet.getString("email"));
                user.setProfile_picture(resultSet.getString("profile_picture"));
                user.setUsername(resultSet.getString("user_name"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(User.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
            if (statement != null) try { statement.close(); } catch (SQLException ignore) {}
            if (connection != null) try { connection.close(); } catch (SQLException ignore) {}
        }
        return user;
    }
    public boolean saveUser(Connection connection) throws SQLException {
        String query = "INSERT INTO user (user_name, first_name, last_name, role, email, contact_num,profile_picture, password) VALUES (?, ?, ?, ?, ?,?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, this.username);
            stmt.setString(2, this.firstName);
            stmt.setString(3, this.lastName);
            stmt.setString(4, this.userRole);
            stmt.setString(5, this.email);
            stmt.setString(6, this.contact_num);
            stmt.setString(7, this.profile_picture);
            stmt.setString(8, this.password);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public boolean updateUser(Connection conn) {
        String sql = "UPDATE user SET user_name=?, first_name=?, last_name=?, role=?, email=?, contact_num=?, password=?, profile_picture= ? WHERE user_id=?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, this.username);
            pstmt.setString(2, this.firstName);
            pstmt.setString(3, this.lastName);
            pstmt.setString(4, this.userRole);
            pstmt.setString(5, this.email);
            pstmt.setString(6, this.contact_num);
            pstmt.setString(7, this.password);
            pstmt.setString(8, this.profile_picture);
            pstmt.setInt(9, this.id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(User.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public boolean deleteUser(Connection conn) {
        String sql = "DELETE FROM user WHERE user_id=?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, this.id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(User.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public static List<User> getAllUsers(Connection conn) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM user";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setUsername(rs.getString("user_name"));
                user.setFirstName(rs.getString("first_name"));
                user.setLastName(rs.getString("last_name"));
                user.setUserRole(rs.getString("role"));
                user.setContact_num(rs.getString("contact_num"));
                user.setEmail(rs.getString("email"));
                users.add(user);
            }
        } catch (SQLException ex) {
            Logger.getLogger(User.class.getName()).log(Level.SEVERE, null, ex);
        }
        return users;
    }

    public static User getUserById(Connection conn, int id) {
        String sql = "SELECT * FROM user WHERE user_id=?";
        User user = null;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("user_name"));
                    user.setFirstName(rs.getString("first_name"));
                    user.setLastName(rs.getString("last_name"));
                    user.setUserRole(rs.getString("role"));
                    user.setEmail(rs.getString("email"));
                    user.setContact_num(rs.getString("contact_num"));
                    user.setProfile_picture(rs.getString("profile_picture"));
                    user.setPassword(rs.getString("password"));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(User.class.getName()).log(Level.SEVERE, null, ex);
        }
        return user;
    }
    
    public static ResultSet getManager(){
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            conn = DbConnector.getConnection();
            String sql = "SELECT user_id, user_name FROM user WHERE role = 'manager'";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            return rs;
        } catch (SQLException ex) {
            Logger.getLogger(User.class.getName()).log(Level.SEVERE, null, ex);
        }
            return null;
    }
    
     public static ResultSet getUserAlll(){
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            conn = DbConnector.getConnection();
            String sql = "SELECT user_id, user_name FROM user";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            return rs;
        } catch (SQLException ex) {
            Logger.getLogger(User.class.getName()).log(Level.SEVERE, null, ex);
        }
            return null;
    }
     
     public static String getUserRoleByUserId(Connection conn, int userId){
          String sql = "SELECT role FROM user WHERE user_id=?";
           String userRole1 = "";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    userRole1 = rs.getString("role");
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(User.class.getName()).log(Level.SEVERE, null, ex);
        }
        return userRole1;
     }
}
