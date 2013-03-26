/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Defines a connection to the RPL Database. There are four 
 * possible connections, each of which can have only one 
 * connection from the application to the database active
 * at a time. 
 * @author Adam Shortall
 */
public enum RPLConnection {
    ADMIN("admin", "XAxiRrJ3Siwm?}4HF9^,"),
    CLERICAL("clerical", "Ar%Lh]l>iAXUJy|hP&&s"),
    STUDENT("student", "Gfn$3k5*l64g58I<mPol"),
    TEACHER("teacher", "HZ(o1uW{btiU/m-/+&P~");

    public final static String URL = "jdbc:postgresql://localhost:5432/RPL_2012";
    public final String userName;
    public final String password;
    private Connection conn;

    RPLConnection(String userName, String password) {
        this.userName = userName;
        this.password = password;
        this.conn = null;
    }

    /**
     * Opens the database by creating a connection.
     */
    public void openDatabase() {
        if (conn != null) { return; }
        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(URL, userName, password);
        } catch (SQLException e) {
            System.err.println("SQLException: " + e.getMessage());
            System.err.println("Error number: " + e.getSQLState());
        } catch (Exception e) {
            System.err.println(e.getMessage());                 
        }
    }

    /**
     * Closes the database connection.
     */
    public void closeDatabase() throws SQLException{
        if (this.conn != null) {
            conn.close();
            conn = null;
        }
    }
    
    /** Prepares a statement for execution in the database. @param sql the statement. */
    public PreparedStatement prepareStatement(String sql) throws SQLException {
        return this.conn.prepareStatement(sql);
    }

    /**
     * Returns the connection to the database, which may or may not be null.
     * @return the connection to the database, which may or may not be null.
     */
    public Connection getConnection() {
        return this.conn;
    }
}
