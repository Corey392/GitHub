package data;

import domain.Criterion;
import domain.User.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * @author Adam Shortall, Bryce Carr
 * @version 1.030
 * <b>Created:</b>  Unknown<br/>
 * <b>Modified:</b> 24/04/2013<br/>
 * <b>Change Log:</b>  08/04/2013:  Bryce Carr: Removed code to account for removal of moduleID field from DB table.<br/>
 *                  24/04/2013: Bryce Carr: Added header comments to match code conventions.<br/>
 *		    07/05/2013:	Bryce Carr: Updated getList() to account for change in Criterion primary key. Interestingly, the method comment hints that this is how it was previously.
 *					    Updated insert() and getList() methods to account for updated Criterion table (part of implementing Criterion insertion).
 * <b>Purpose:</b>  Controller for interaction with database's Criterion table.
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
	String moduleID = criterion.getModuleID();
        String description = criterion.getDescription();
        SQLParameter p1,p2,p3;
        String sql = "SELECT fn_InsertCriterion(?,?,?)";
        p1 = new SQLParameter(elementID);
        p2 = new SQLParameter(moduleID);
	p3 = new SQLParameter(description);
        
        super.doPreparedStatement(sql, p1, p2, p3);
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
    public ArrayList<Criterion> getList(int elementID, String moduleID){
        ArrayList<Criterion> list = null;
        ResultSet rs;
        String sql = "SELECT * FROM fn_ListCriteria(?, ?)";
        SQLParameter p1, p2;
        p1 = new SQLParameter(elementID);
	p2 = new SQLParameter(moduleID);
        try {
            rs = super.doPreparedStatement(sql, p1, p2);
            list = new ArrayList<Criterion>();
            while(rs.next()){                
                int criterionID = rs.getInt("criterionID");
                String description = rs.getString("description");
                list.add(new Criterion(criterionID, elementID, moduleID, description));
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage() + "\n Error Code: " + e.getErrorCode());
        }
        return list;
    }
}
