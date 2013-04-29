//TODO: BRYCE: Create method that returns list of disciplines associated with a specific Campus
package data;

import domain.Campus;
import domain.User.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author James, Adam Shortall, Bryce Carr
 * @version 1.1
 * <b>Created:</b>  Unknown<br/>
 * <b>Modified:</b> 24/04/2013<br/>
 * <b>Change Log:</b>	23/04/2013: Bryce Carr: Added function removeDiscipline(String, int).<br/>
 *			24/04/2013: Bryce Carr: Added header comments to match code conventions.<br/>
 * <b>Purpose:</b>  Controller class for interaction with database's Campus table.
 */
public class CampusIO extends RPL_IO<Campus> {
    
    public enum Field {
        CAMPUS_ID("campusID"),
        NAME("name");
        
        public final String name;
        
        Field(String name) {
            this.name = name ;
        }
    }
    
    public CampusIO(Role role) {
        super(role); 
    }
    
    /**
     * Returns campus data from the database from a specified campusID.
     * @param campusID
     * @return A campus object with data from the database.
     */
    public Campus getByID(String campusID) {
        Campus campus = null;
        String sql = "SELECT * FROM fn_GetCampusByID(?)";
        SQLParameter p1 = new SQLParameter(String.valueOf(campusID));
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            if (rs.next()) {
                String name = rs.getString(Field.NAME.name);
                campus = new Campus(campusID, name);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CampusIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return campus;
    }

    /**
     * Returns a list of all campuses.
     * @return all campuses in the database
     */
    public ArrayList<Campus> getList() {
        ArrayList<Campus> list = null;
        String sql = "SELECT * FROM fn_ListCampuses();";
        try {
            ResultSet rs = super.doQuery(sql);
            list = new ArrayList<Campus>();
            String campusID, name;
            while (rs.next()) {
                campusID = rs.getString(Field.CAMPUS_ID.name);
                name = rs.getString(Field.NAME.name);
                list.add(new Campus(campusID, name));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CampusIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Inserts a new campus record.
     * @param campus The campus to insert.
     * @throws SQLException If the campusID is not unique.
     */
    public void insert(Campus campus) throws SQLException {
        String campusID = campus.getCampusID();
        String name = campus.getName();
        String sql = "SELECT fn_InsertCampus(?,?)";
        SQLParameter p1 = new SQLParameter(campusID);
        SQLParameter p2 = new SQLParameter(name);
        super.doPreparedStatement(sql, p1, p2);
    }

    /**
     * Updates an existing campus record.
     * @param campus the campus with updated details
     * @param oldID the ID of the record as it exists in the database
     * @throws SQLException if the updated ID is not unique
     */
    public void update(Campus campus, String oldID) throws SQLException {
        String campusID = campus.getCampusID();
        String name = campus.getName();
        String sql = "SELECT fn_UpdateCampus(?,?,?)";
        SQLParameter p1 = new SQLParameter(oldID);
        SQLParameter p2 = new SQLParameter(campusID);
        SQLParameter p3 = new SQLParameter(name);
        super.doPreparedStatement(sql, p1, p2, p3);
    }

    /**
     * Deletes a campus, and all disciplines, courses etc. that depend on it.
     * This should ONLY be invoked by someone with ADMIN level access.
     * @param campus the campus to delete
     * @throws SQLException 
     */
    public void delete(Campus campus) throws SQLException {
        String campusID = campus.getCampusID();
        String sql = "SELECT fn_DeleteCampus(?)";
        SQLParameter p1 = new SQLParameter(campusID);
        super.doPreparedStatement(sql, p1);
    }
    
    /**
     * Associates an existing discipline with a campus.
     * @param disciplineID 
     * @param campusID
     */
    public void addDiscipline(String campusID, int disciplineID) throws SQLException {
        String sql = "SELECT fn_InsertCampusDiscipline(?, ?)";
        SQLParameter p1, p2;
        p1 = new SQLParameter(campusID);
        p2 = new SQLParameter(disciplineID);
        super.doPreparedStatement(sql, p1, p2);
    }

    public void removeDiscipline(String campusID, int removeDisciplineID) throws SQLException   {
        String sql = "SELECT fn_removedisciplinefromcampus(?, ?)";
        SQLParameter p1, p2;
        p1 = new SQLParameter(campusID);
        p2 = new SQLParameter(removeDisciplineID);
        super.doPreparedStatement(sql, p1, p2);
    }
    
}