/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package data;

import domain.Discipline;
import domain.User.Role;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles IO for Disciplines.
 * @author James
 * @author Adam Shortall
 */
public class DisciplineIO extends RPL_IO<Discipline> {
    
    public enum Field {
        DISCIPLINE_ID("disciplineID"),
        NAME("name");
        
        public final String name;
        
        Field(String name) {
            this.name = name;
        }
    }

    public DisciplineIO(Role role) {
        super(role);
    }
    
    /**
     * Inserts a new discipline with an automatically generated ID
     * @param discipline discipline object with a set name
     * @throws SQLException if the name is not unique
     */
    public void insert(Discipline discipline) throws SQLException {
        String name = discipline.getName();        
        String sql = "SELECT fn_InsertDiscipline(?)";
        SQLParameter p1 = new SQLParameter(name);
        super.doPreparedStatement(sql, p1);
    }
    
    /**
     * Updates the name of the discipline.
     * @param discipline The discipline object with updated name
     * @throws SQLException if the discipline name is not unique
     */
    public void update(Discipline discipline) throws SQLException {
        String name = discipline.getName();
        int id = discipline.getDisciplineID();
        String sql = "SELECT fn_UpdateDiscipline(?,?)";
        SQLParameter p1 = new SQLParameter(id);
        SQLParameter p2 = new SQLParameter(name);        
        super.doPreparedStatement(sql, p1, p2);
    }

    /**
     * Deletes a discipline, and all courses etc. that depend on it. 
     * Can only be done by ADMIN level users.
     * @param discipline the discipline object to delete
     * @throws SQLException 
     */
    public void delete(Discipline discipline) throws SQLException {
        int id = discipline.getDisciplineID();
        String sql = "SELECT fn_DeleteDiscipline(" + id + ")";
        super.doQuery(sql);
    }
    
    /**
     * Gets a list of disciplines from a ResultSet.
     * @param rs result set from database (without any modification of the cursor)
     * @return 
     */
    private ArrayList<Discipline> getListFromRS(ResultSet rs) {
        try {
            int disciplineID;
            String name;
            ArrayList<Discipline> list = new ArrayList<Discipline>();
            while (rs.next()) {
                disciplineID = rs.getInt("disciplineID");
                name = rs.getString("name");
                list.add(new Discipline(disciplineID, name));
            }
            return list;
        } catch (SQLException ex) {
            Logger.getLogger(DisciplineIO.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }
    
    /**
     * Returns a list of all disciplines from the database.
     * @return all disciplines in the database.
     */
    public ArrayList<Discipline> getList() {
        try {
            String sql = "SELECT * FROM fn_ListDisciplines()";
            return getListFromRS(super.doQuery(sql));
        } catch (SQLException ex) {
            Logger.getLogger(DisciplineIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
        
    /**
     * Gets a list of disciplines for a campus.
     * @param campusID
     * @return 
     */
    public ArrayList<Discipline> getList(String campusID) {
        String sql;
        ArrayList<Discipline> list = null;
        sql = "SELECT * FROM fn_ListDisciplines(?)";
        SQLParameter p1 = new SQLParameter(campusID);
        try {
            return this.getListFromRS(super.doPreparedStatement(sql, p1));
        } catch (SQLException ex) {
            Logger.getLogger(DisciplineIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    /**
     * Gets a list of disciplines that is not in a campus.
     * @param campusID ID of the campus to find disciplines not in
     * @return 
     */
    public ArrayList<Discipline> getListNotInCampus(String campusID) {
        String sql = "SELECT * FROM fn_ListDisciplinesNotInCampus(?)";
        ArrayList<Discipline> list = null;
        SQLParameter p1 = new SQLParameter(campusID);
        try {
            return this.getListFromRS(super.doPreparedStatement(sql,p1));
        } catch (SQLException ex) {
            Logger.getLogger(DisciplineIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    /**
     * Gets a discipline from the database based on the ID field.
     * @param discipline discipline with ID field set.
     * @return discipline with data from the database.
     */
    public Discipline getByID(int disciplineID) {        
        String sql = "SELECT * FROM fn_GetDiscipline(?)";
        SQLParameter p1 = new SQLParameter(disciplineID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            if (rs.next()) {
                String name = rs.getString("name");
                return new Discipline(disciplineID, name);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DisciplineIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    /**
     * Adds a course to a Campus-Discipline
     * @param campusID the campus where the course is taught
     * @param disciplineID the discipline where the course it taught
     * @param courseID the course ID
     * @throws SQLException if a constraint is violated
     */    
    public void addCourse(String campusID, int disciplineID, String courseID) throws SQLException {
        String sql = "SELECT fn_AddCourseToDiscipline(?,?,?)";
        SQLParameter p1, p2, p3;
        p1 = new SQLParameter(campusID);        
        p2 = new SQLParameter(disciplineID);
        p3 = new SQLParameter(courseID);
        
        super.doPreparedStatement(sql, p1, p2, p3);       
    }
    
    /**
     * Removes a course from a campus-discipline.
     * @param campusID campus where the course is taught
     * @param disciplineID discipline where the course is taught
     * @param courseID the course to remove
     * @throws SQLException 
     */
    public void removeCourse(String campusID, int disciplineID, String courseID) throws SQLException {
        String sql = "SELECT fn_RemoveCourseFromDiscipline(?,?,?)";
        SQLParameter p1, p2, p3;
        p1 = new SQLParameter(campusID);
        p2 = new SQLParameter(disciplineID);
        p3 = new SQLParameter(courseID);
        
        super.doPreparedStatement(sql, p1, p2, p3);
    }
}
