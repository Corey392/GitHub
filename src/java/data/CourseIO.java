package data;

import domain.Course;
import domain.User.Role;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles I/O for Course updates by the Clerical Admins
 * 
 * 
 * @author David Gibbins, Adam Shortall, Mitch Carr
 * @version 1.02
 * <b>Created:</b>  Unknown
 * <b>Modified:</b> 24/04/2013
 * <b>Change Log:</b>  08/04/2013: Made small changes to incorporate guideFileAddress DB field.
 *                  24/04/2013: Added header comments to match code conventions.
 *                  15/05/2013: MC: Removed guideFileAddress fields to match Course
 * <b>Purpose:</b>  Controller class for interaction with database's Course table.
 */
public class CourseIO extends RPL_IO<Course> {

    public CourseIO(Role role) {
        super(role);
    }

    /**
     * Inserts a Course object.
     * 
     * @param course the Course object to insert
     * @throws SQLException if Course couldn't be inserted.
     *          Usually happens when the Course already exists.
     */
    public void insert(Course course) throws SQLException {
        String courseID = course.getCourseID();
        String name = course.getName();
        
        String sql = "SELECT fn_InsertCourse(?,?)";
        SQLParameter p1 = new SQLParameter(courseID);
        SQLParameter p2 = new SQLParameter(name);
        super.doPreparedStatement(sql, p1, p2);
    }
    
    /**
     * Updates a course with new course data
     * @param course Course object containing the updated details
     * @param oldID the ID of the course to update in the database
     * @throws SQLException if the new ID is not unique
     */
    public void update(Course course, String oldID) throws SQLException {
        String courseID = course.getCourseID();
        String name = course.getName();
        String sql = "SELECT fn_UpdateCourse(?,?,?)";
        SQLParameter p1 = new SQLParameter(oldID);
        SQLParameter p2 = new SQLParameter(courseID);
        SQLParameter p3 = new SQLParameter(name);
        super.doPreparedStatement(sql, p1, p2, p3);
    }

    /**
     * Deletes the course, and all associated modules etc.
     * @param course the course to delete
     * @throws SQLException if course didn't exist
     */
    public void delete(Course course) throws SQLException {
        String courseID = course.getCourseID();
        String sql = "SELECT fn_DeleteCourse(?)";
        SQLParameter p1 = new SQLParameter(courseID);
        super.doPreparedStatement(sql, p1);
    }
    
    /**
     * Gets data from the current position in the result set
     * and returns a course object containing that data.
     * Requires the ResultSet to be at a valid record.
     * 
     * @param rs ResultSet to read a Course object from
     * @return Course object contained within the ResultSet passed in
     */
    private Course getCourseFromRS(ResultSet rs) {
        try {
            String courseID = rs.getString("courseID");
            String name = rs.getString("name");
            return new Course(courseID, name);
        } catch (SQLException ex) {
            Logger.getLogger(CourseIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    /**
     * @return a list of all courses in the database.
     */
    public ArrayList<Course> getList() {
        String sql = "SELECT * FROM fn_ListCourses()";
        ArrayList<Course> list = new ArrayList<Course>();
        try {
            ResultSet rs = super.doQuery(sql);
            while (rs.next()) {
                list.add(this.getCourseFromRS(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    /**
     * Returns all courses belonging to a CampusDiscipline.
     * @param campusID CampusID of the CampusDiscipline
     * @param disciplineID DisciplineID of the CampusDiscipline
     * @return a list of Courses in the CampusDiscipline
     */
    public ArrayList<Course> getList(String campusID, int disciplineID) {
        
        String sql = "SELECT * FROM fn_ListCourses(?,?)";
        SQLParameter p1 = new SQLParameter(campusID);
        SQLParameter p2 = new SQLParameter(disciplineID);
        
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2);
            ArrayList<Course> list = new ArrayList<Course>();
            while (rs.next()) {
                list.add(this.getCourseFromRS(rs));
            }
            return list;
        } catch (SQLException ex) {
            Logger.getLogger(CourseIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    /**
     * Returns a course specified by an ID field.
     * @param courseID ID of course to retrieve from database
     * @return Course with ID matching value passed in
     */
    public Course getByID(String courseID) {
        
        String sql = "SELECT * FROM fn_GetCourse(?)";
        SQLParameter p1 = new SQLParameter(String.valueOf(courseID));
        
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1);
            if (rs.next()) {
                return this.getCourseFromRS(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
    
    /**
     * Returns a list of courses that are not in the selected CampusDiscipline.
     * @param campusID CampusID of the target CampusDiscipline
     * @param disciplineID DisciplineID of the target CampusDiscipline
     * @return list of Course objects not pertaining to a specific CampusDiscipline
     */
    public ArrayList<Course> getListNotInDiscipline(String campusID, int disciplineID) {
        
        String sql = "SELECT * FROM fn_ListCoursesNotInDiscipline(?,?)";
        SQLParameter p1 = new SQLParameter(campusID);
        SQLParameter p2 = new SQLParameter(disciplineID);
        
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2);
            ArrayList<Course> list = new ArrayList<Course>();
            while (rs.next()) {
                list.add(this.getCourseFromRS(rs));
            }
            return list;
        } catch (SQLException ex) {
            Logger.getLogger(CourseIO.class.getName()).log(Level.SEVERE, null, ex);
        }        
        return null;
    }
}