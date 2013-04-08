/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package data;

import domain.Criterion;
import domain.User.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Handles IO for Criteria.
 * @author Adam Shortall
 */
public class CriterionIO extends RPL_IO<Criterion> {

    public CriterionIO(Role role) {
        super(role);
    }
    
    /**
     * Inserts a new Criterion into the database. 
     * 
     * @param criterion The criterionID is automatically generated, 
     * so only the elementID, moduleID and description need be set 
     * in the Criterion parameter.
     */
    public void insert(Criterion criterion) throws SQLException {
        int elementID = criterion.getElementID();
        String description = criterion.getDescription();
        SQLParameter p1,p2;
        String sql = "SELECT fn_InsertCriterion(?,?)";
        p1 = new SQLParameter(elementID);
        p2 = new SQLParameter(description);
        
        super.doPreparedStatement(sql, p1, p2);
    }

    /**
     * Updates the criterion with a new description.
     * @param criterion with all ID fields and the updated description
     * @throws SQLException if there is something wrong with the description
     */
    public void update(Criterion criterion) throws SQLException {
        int criterionID = criterion.getCriterionID();
        int elementID = criterion.getElementID();
        String description = criterion.getDescription();
        String sql = "SELECT fn_UpdateCriterion(?,?,?)";
        SQLParameter p1, p2, p3;
        p1 = new SQLParameter(criterionID);
        p2 = new SQLParameter(elementID);
        p3 = new SQLParameter(description);
        
        super.doPreparedStatement(sql, p1, p2, p3);
    }
    
    /**
     * Deletes the specified criterion.
     * @param criterion The criterion to delete, must contain criterionID, elementID.
     * @throws SQLException 
     */
    public void delete(Criterion criterion) throws SQLException {
        int criterionID = criterion.getCriterionID();
        int elementID = criterion.getElementID();
        SQLParameter p1, p2;
        String sql = "SELECT fn_DeleteCriterion(?,?)";
        p1 = new SQLParameter(criterionID);
        p2 = new SQLParameter(elementID);
        
        super.doPreparedStatement(sql, p1, p2);
    }
    
    /**
     * Gets criteria that belong to an Element of a specific Module.
     * @param elementID the ID of the element
     * @param moduleID the ID of the module
     * @return a list of criteria for the given element or an empty list
     */
    public ArrayList<Criterion> getList(int elementID){
        ArrayList<Criterion> list = null;
        ResultSet rs;
        String sql = "SELECT * FROM fn_ListCriteria(?)";
        SQLParameter p1;
        p1 = new SQLParameter(elementID);
        try {
            rs = super.doPreparedStatement(sql, p1);
            list = new ArrayList<Criterion>();
            while(rs.next()){                
                int criterionID = rs.getInt("criterionID");
                String description = rs.getString("description");
                list.add(new Criterion(criterionID, elementID, description));
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage() + "\n Error Code: " + e.getErrorCode());
        }
        return list;
    }
}
