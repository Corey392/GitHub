package data;

import domain.User.Role;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;

/**
 * Defines some fields common to all of the IO classes.
 * @author Adam Shortall
 */
public abstract class RPL_IO <T> {
    
    private RPLConnection conn;
    public final Role role;
    
    /**
     * Sets the connection type for the RPL_IO object being constructed.
     * @param role the role of the current user.
     */
    public RPL_IO(Role role) {
        this.role = role;
        switch (role) {
            case ADMIN:
                this.conn = RPLConnection.ADMIN;
                break;
            case CLERICAL:
                this.conn = RPLConnection.CLERICAL;
                break;
            case STUDENT:
                this.conn = RPLConnection.STUDENT;
                break;
            case TEACHER:
                this.conn = RPLConnection.TEACHER;
                break;
            default:
                throw new IllegalArgumentException("Invalid role supplied for RPL_IO.setConn(Role)");
        }
    }
    
    /**
     * Does an executeQuery on the sql String specified. Returns a 
     * ResultSet of results from the database.
     * 
     * @param sql The sql statement. The values of any parameters have to be passed in as
     * part of this String.
     * 
     * @return ResultSet from doing the query
     * @throws SQLException the database threw an exception, check exception's SQLState for Postgre exception code.
     */
    protected ResultSet doQuery(String sql) throws SQLException{
        try {
            conn.openDatabase();
            Statement statement = conn.getConnection().createStatement();
            return statement.executeQuery(sql);
        } finally {
            conn.closeDatabase();
        }
    }

    /**
     * Used when needing to call a function in the database, or any statement with parameters.
     * 
     * @param sql The sql statement, any parameters should be represented as question marks.
     * @param params the parameters, which must be entered in the same order that they 
     * appear in the database.
     * @throws SQLException the database threw an exception, check exception's SQLState for Postgre exception code.
     */
    protected ResultSet doPreparedStatement(String sql, SQLParameter... params) throws SQLException {
        
        try {
            conn.openDatabase();
            PreparedStatement statement = conn.prepareStatement(sql);
            int i = 0;
            for (SQLParameter p : params) {
                i++;
                switch (p.type) {
                    case Types.DATE:
                        statement.setDate(i, (java.sql.Date) p.value);
                        break;
                    case Types.INTEGER:
                        statement.setInt(i, (Integer) p.value);
                        break;
                    case Types.VARCHAR:
                        statement.setString(i, (String) p.value);
                        break;
                    case Types.CHAR:
                        statement.setString(i, p.value.toString());
                        break;
                    case Types.BOOLEAN:
                        statement.setBoolean(i, (Boolean) p.value);
                        break;
                    case Types.BINARY:
                        statement.setBytes(i, (byte[]) p.value);
                        break;
                    case Types.NULL:
                        statement.setNull(i, Types.INTEGER);
                        break;
                    default:
                        throw new IllegalArgumentException ("SQLParameter has wrong type");
                }
            }
            return statement.executeQuery();        
        } finally {
            conn.closeDatabase();
        }
    }
    
    /**
     * Convenience method to return a SQLParameter without having to declare
     * a new object.
     * @param value Parameter's value.
     * @return The SQLParameter.
     */
    public SQLParameter p(Object value) {
        return new SQLParameter(value);
    }
}
