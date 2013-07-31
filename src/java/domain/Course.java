package domain;

import java.io.Serializable;
import java.util.ArrayList;
import util.FieldError;

/**
 * Contains course information from the database, and 
 * links to 
 * @author David Gibbins, James, Adam Shortall, Bryce Carr, Mitchell Carr
 * @version 1.02
 * <b>Created:</b> Unknown 
 * <b>Modified:</b> 24/04/2013
 * <b>Change Log:</b>  08/04/2013:    Made small changes to incorporate guideFileAddress DB field.
 *                  24/04/2013:   Added header comments to match code conventions.
 *		    30/04/2013:	BC: Edited validateField() to account for null field value. Field in database is allowed null, but code didn't previously allow it.
 *                  15/05/2013: MC: Removed guideFileAddress and associated methods
 * <b>Purpose:</b>  Model class for database's Course table.
 */
public class Course implements Comparable<Course>, Serializable {
    
    private String courseID;
    private String name;
    private ArrayList<Module> coreModules;
    private ArrayList<Module> electiveModules;
    private ArrayList<User> assessors;
    private User courseCoordinator;
    
    /**
     * Defines fields that require validation.
     */
    public enum Field {
        ID("^[0-9]{5}$", FieldError.COURSE_ID),
        NAME("^.+$", FieldError.COURSE_NAME),
        GUIDE_FILE_ADDRESS("", FieldError.COURSE_GUIDE_FILE_ADDRESS);
        
        public final String pattern;
        public final FieldError fieldError;
        
        Field(String pattern, FieldError fieldError) {
            this.pattern = pattern;
            this.fieldError = fieldError;
        }
        
        public FieldError validateField(String value) {
	    if (value == null)	{
		return null;
	    }
            return value.matches(pattern) ? null : fieldError;
        }
    }
    
    public Course() {
        this("");
    }
    
    public Course(String courseID) {
        this(courseID, "");
    }
    
    public Course(String courseID, String name) {
        this.courseID = courseID;
        this.name = name;
        this.coreModules = new ArrayList<Module>();
        this.electiveModules = new ArrayList<Module>();
    }
    
    /**
     * @return List of errors associated with this Course entry.
     *          If there aren't any, a blank list is returned.
     */
    public ArrayList<FieldError> validate() {
        ArrayList<FieldError> errors = new ArrayList<FieldError>();
        FieldError courseIDError = Field.ID.validateField(courseID);
        FieldError nameError = Field.NAME.validateField(name);
        if (courseIDError != null) {
            errors.add(courseIDError);
        } 
        if (nameError != null) {
            errors.add(nameError);
        }
        return errors;
    }

    /**
     * @return Assessors assigned to this Course
     */
    public ArrayList<User> getAssessors() {
        return assessors;
    }

    /**
     * @param assessors List of assessors to assign to this Course
     */
    public void setAssessors(ArrayList<User> assessors) {
        this.assessors = assessors;
    }

    /**
     * @return Core modules for this Course
     */
    public ArrayList<Module> getCoreModules() {
        return coreModules;
    }

    /**
     * @param coreModules Core Modules to associate with this Course
     */
    public void setCoreModules(ArrayList<Module> coreModules) {
        this.coreModules = coreModules;
    }

    /**
     * @return User coordinating this Course
     */
    public User getCourseCoordinator() {
        return courseCoordinator;
    }

    /**
     * @param courseCoordinator User coordinating this Course
     */
    public void setCourseCoordinator(User courseCoordinator) {
        this.courseCoordinator = courseCoordinator;
    }

    /**
     * @return ID to uniquely identify this Course
     */
    public String getCourseID() {
        return courseID;
    }

    /**
     * @param courseID Unique ID to assign to this Course
     */
    public void setCourseID(String courseID) {
        this.courseID = courseID;
    }

    /**
     * @return Returns a list of elective modules associated with this Course
     */
    public ArrayList<Module> getElectiveModules() {
        return electiveModules;
    }

    /**
     * @param electiveModules Elective Modules to associate with this Course
     */
    public void setElectiveModules(ArrayList<Module> electiveModules) {
        this.electiveModules = electiveModules;
    }

    /**
     * @return Name of this Course
     */
    public String getName() {
        return name;
    }

    /**
     * @param name Name of this Course
     */
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return this.courseID == null ? "" : this.courseID + ": " + this.name;
    }

    @Override
    public int compareTo(Course that) {
        int thisID = Integer.parseInt(this.courseID);
        int thatID = Integer.parseInt(that.courseID);
        if (thisID < thatID) {
            return -1;
        }
        return (thisID == thatID ? 0 : 1);
    }
    
    /**
     * @return all modules, may be empty if coreModules and electiveModules are null.
     */
    public ArrayList<Module> getAllModules() {
        ArrayList<Module> list = new ArrayList<Module>();
        
        if (this.coreModules != null){
            for (Module module : this.coreModules){
                if (module != null){
                    list.add(module);                    
                }
            }
        }
        if (this.electiveModules != null){
            for (Module module : this.electiveModules){
                if (module != null){
                    list.add(module);                    
                }
            }
        }
        
        return list;
    }
}