/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package data;

import domain.Errors;
import domain.User.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author James, Adam Shortall
 */
public class ErrorsIO extends RPL_IO<Errors> {
    
    public enum Field {
        ERROR_ID("errorID"),
        ERROR_MESSGAE("errorMessage"),
        EANABLED("enabled");
        
        public final String name;
        
        Field(String name) {
            this.name = name;
        }
    }
    
    public ErrorsIO(Role role) {
        super(role);
    }
    
    /**
     * Returns a list of all claim records according to a specific user.
     * @return all claim records in the database
     */
    public ArrayList<Errors> getList(Errors pErrors) {
        ArrayList<Errors> list = null;
        String sql = "SELECT * FROM fn_ListErrors()";
        
        try {
            ResultSet rs = super.doPreparedStatement(sql);
            list = new ArrayList<Errors>();
            while (rs.next()) {
                list.add(new Errors(rs.getString(Field.ERROR_ID.name)
                                  , rs.getString(Field.ERROR_MESSGAE.name)
                                  , true));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CampusIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    /**
     * 
     * @param pErrors
     * @param role
     * @return 
     */
    public int getListCount(Errors pErrors) {
        Integer listCount = 0;
        String sql = "SELECT * FROM fn_listErrorsCount();";
        
        try {
            ResultSet rs = super.doPreparedStatement(sql);
            if (rs.next()) {
                listCount = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CampusIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return listCount;
    }    
    
 
    /**
     * Inserts a new error record.
     * @param pErrors The error to insert.
     * @throws SQLException If the errorID is not unique.
     */
    public void insert(Errors pErrors) throws SQLException {
        String sql = "SELECT fn_InsertError(?,?)";
        SQLParameter p1 = new SQLParameter(pErrors.getErrorID());
        SQLParameter p2 = new SQLParameter(pErrors.getErrorMessage());
        super.doPreparedStatement(sql, p1, p2);
    }
    
    /**
     * Update a error record.
     * @param pErrors The error to insert.
     * @throws SQLException If the errorID is not unique.
     */
    public void update(Errors pErrors) throws SQLException {
        String sql = "SELECT fn_UpdateError(?,?)";
        SQLParameter p1 = new SQLParameter(pErrors.getErrorID());
        SQLParameter p2 = new SQLParameter(pErrors.getErrorMessage());
        super.doPreparedStatement(sql, p1, p2);
    }    
    
   
}