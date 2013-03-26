/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
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
 * @author David Gibbins, Adam Shortall
 */
public class CourseIO extends RPL_IO<Course> {

    public CourseIO(Role role) {
        super(role);
    }

    /**
     * Inserts a Course object.
     * 
     * @param Course the Course object to insert
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
     * @param course the course to update containing the updated details
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
     * @throws SQLException 
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
     * @param rs
     * @return 
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
     * Returns a list of all courses.
     * @return 
     */
    public ArrayList<Course> getList() {
        String sql = "SELECT * FROM fn_ListCourses()";
        ArrayList<Course> list = null;
        try {
            ResultSet rs = super.doQuery(sql);
            list = new ArrayList<Course>();
            while (rs.next()) {
                list.add(this.getCourseFromRS(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    /**
     * Returns all courses belonging to a campus and a discipline.
     * @param campusID
     * @param disciplineID
     * @return 
     */
    public ArrayList<Course> getList(String campusID, int disciplineID) {
        ArrayList<Course> list = null;
        String sql;
        sql = "SELECT * FROM fn_ListCourses(?,?)";
        SQLParameter p1 = new SQLParameter(campusID);
        SQLParameter p2 = new SQLParameter(disciplineID);
        try {
            ResultSet rs = super.doPreparedStatement(sql, p1, p2);
            list = new ArrayList<Course>();
            while (rs.next()) {
                list.add(this.getCourseFromRS(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseIO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    /**
     * Returns a course specified by an ID field.
     * @param course course with ID field set.
     * @return 
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
     * Returns a list of courses that are not in the selected campus-discipline.
     * @param campusID
     * @param disciplineID
     * @return 
     */
    public ArrayList<Course> getListNotInDiscipline(String campusID, int disciplineID) {
        ArrayList<Course> list = null;
        String sql = "SELECT * FROM fn_ListCoursesNotInDiscipline(?,?)";
        SQLParameter p1, p2;
        p1 = new SQLParameter(campusID);
        p2 = new SQLParameter(disciplineID);
        ResultSet rs;
        try {
            rs = super.doPreparedStatement(sql, p1, p2);
            list = new ArrayList<Course>();
            while (rs.next()) {
                list.add(this.getCourseFromRS(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(CourseIO.class.getName()).log(Level.SEVERE, null, ex);
        }        
        return list;
    }
}