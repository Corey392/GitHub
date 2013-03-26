/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package data;

import domain.AccessHistory;
import domain.User.Role;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.ResultSet;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author Ben Morrison
 */
public class AccessHistoryIO extends RPL_IO<AccessHistory> {
    private static String FN_addAccessHistory = "fn_addaccesshistory";
    private static String FN_getAllAccessHistory = "fn_getAllAccessHistory";
    private static String FN_getAccessHistoryByUserID = "fn_getAccessHistoryByUserID";
    
    public AccessHistoryIO(Role role) {
        super(role);
    }
    
    public void insert(String userID, String type) throws SQLException {
        String sql = "SELECT * FROM fn_addaccesshistory(?,?,?)";
        
        int accessID = this.getList().size();
        //int accessID = 5;
        SQLParameter p1 = new SQLParameter(accessID);
        SQLParameter p2 = new SQLParameter(userID);
        SQLParameter p3 = new SQLParameter(type);
        
        super.doPreparedStatement(sql, p1, p2, p3);
    }
    
    public static void delete(AccessHistory history) throws SQLException {
        
    }
    
    public ArrayList<AccessHistory> getList() throws SQLException {
        ArrayList<AccessHistory> list = new ArrayList<AccessHistory>();
        String sql = "SELECT * FROM \"AccessRecords\"";
        ResultSet rs = super.doQuery(sql);
        
        while (rs.next()) {
            list.add(this.getAccessHistoryFromRS(rs));
        }
        return list;
    }
    
    private AccessHistory getAccessHistoryFromRS(ResultSet rs) throws SQLException {
        AccessHistory ah = new AccessHistory();
        
        String accessID = rs.getString(1);
        String userID = rs.getString("userID");
        String accessTime = rs.getString(3);
        String accessType = rs.getString(4);
        
        ah.setAccessID(accessID);
        ah.setUserID(userID);
        ah.setAccessTime(accessTime);
        ah.setAccessType(accessType);
        
        return ah;
    }
}
