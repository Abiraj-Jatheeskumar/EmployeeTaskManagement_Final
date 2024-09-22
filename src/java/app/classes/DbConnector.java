package app.classes;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DbConnector {
    final static String URL = "jdbc:mysql://localhost:3306/emptaskmanagement"; // Update your database URL
    final static String USER = "root";
    final static String PASSWORD = "";
    final static String DRIVER = "com.mysql.jdbc.Driver";

    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName(DRIVER);
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DbConnector.class.getName()).log(Level.SEVERE, null, ex);
        }
        return con;
    }
}
