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
     * @param criterion Criterion to add to the database
     * @throws SQLException if Criterion could not be added.
     *          Usually happens if the Criterion already exists.
     */
    public void insert(Criterion criterion) throws SQLException {
        //The criterionID is automatically generated, so only the elementID, 
        //moduleID and description need be set in the Criterion parameter.
        int elementID = criterion.getElementID();
	String moduleID = criterion.getModuleID();
        String description = criterion.getDescription();
        
        String sql = "SELECT fn_InsertCriterion(?,?,?)";
        SQLParameter p1 = new SQLParameter(elementID);
        SQLParameter p2 = new SQLParameter(moduleID);
	SQLParameter p3 = new SQLParameter(description);
        
        super.doPreparedStatement(sql, p1, p2, p3);
    }

    /**
     * Updates the criterion with a new description.
     * @param criterion Criterion with fields that we want to update
     * @throws SQLException if the Criterion doesn't exist or couldn't be updated
     */
    public void update(Criterion criterion) throws SQLException {
        
        int criterionID = criterion.getCriterionID();
        int elementID = criterion.getElementID();
        String description = criterion.getDescription();
        
        String sql = "SELECT fn_UpdateCriterion(?,?,?)";
        SQLParameter p1 = new SQLParameter(criterionID);
        SQLParameter p2 = new SQLParameter(elementID);
        SQLParameter p3 = new SQLParameter(description);
        
        super.doPreparedStatement(sql, p1, p2, p3);
    }
    
    /**
     * Deletes the specified criterion.
     * @param criterion The criterion to delete. Must contain criterionID & elementID.
     * @throws SQLException if Criterion doesn't exist
     */
    public void delete(Criterion criterion) throws SQLException {
        
        int criterionID = criterion.getCriterionID();
        int elementID = criterion.getElementID();
        
        String sql = "SELECT fn_DeleteCriterion(?,?)";
        SQLParameter p1 = new SQLParameter(criterionID);
        SQLParameter p2 = new SQLParameter(elementID);
        
        super.doPreparedStatement(sql, p1, p2);
    }
    
    /**
     * Gets criteria that belong to an Element of a specific Module.
     * @param elementID the ID of the element
     * @param moduleID the ID of the module
     * @return a list of criteria for the given element & module.
     *          If there was a problem with the retrieval, returns an empty list.
     */
    public ArrayList<Criterion> getList(int elementID, String moduleID){
        
        ArrayList<Criterion> list = new ArrayList<Criterion>();
        
        String sql = "SELECT * FROM fn_ListCriteria(?, ?)";
        SQLParameter p1 = new SQLParameter(elementID);
	SQLParameter p2 = new SQLParameter(moduleID);
        
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2);
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