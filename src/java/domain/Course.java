package domain;

import java.io.Serializable;
import java.util.ArrayList;
import util.FieldError;

/**
 * Contains course information from the database, and 
 * links to 
 * @author David Gibbins, James, Adam Shortall, Bryce Carr
 * @version 1.02
 * <b>Created:</b> Unknown 
 * <b>Modified:</b> 24/04/2013
 * <b>Change Log:</b>  08/04/2013:    Made small changes to incorporate guideFileAddress DB field.
 *                  24/04/2013:   Added header comments to match code conventions.
 *		    30/04/2013:	BC: Edited validateField() to account for null field value. Field in database is allowed null, but code didn't previously allow it.
 * <b>Purpose:</b>  Model class for database's Course table.
 */
public class Course implements Comparable<Course>, Serializable {
    
    private String courseID;
    private String name;
    private String guideFileAddress;
    private ArrayList<Module> coreModules;
    private ArrayList<Module> electiveModules;
    private ArrayList<User> assessors;
    private User courseCoordinator;
    
    public Course() {
        this("");
    }
    
    public Course(String courseID) {
        this(courseID, "", "");
    }
    
    public Course(String courseID, String name, String guideFileAddress) {
        this.courseID = courseID;
        this.name = name;
        this.guideFileAddress = guideFileAddress;
        this.coreModules = new ArrayList<Module>();
        this.electiveModules = new ArrayList<Module>();
    }
    
    public String getGuideFileAddress() {
        return guideFileAddress;
    }
    
    public void setGuideFileAddress(String guideFileAddress) {
        this.guideFileAddress = guideFileAddress;
    }

    public ArrayList<FieldError> validate() {
        ArrayList<FieldError> errors = new ArrayList<FieldError>();
        FieldError courseIDError = Field.ID.validateField(courseID);
        FieldError nameError = Field.NAME.validateField(name);
        FieldError guideFileAddressError = Field.GUIDE_FILE_ADDRESS.validateField(guideFileAddress);
        if (courseIDError != null) {
            errors.add(courseIDError);
        } if (nameError != null) {
            errors.add(nameError);
        } if (guideFileAddressError != null)    {
            errors.add(guideFileAddressError);
        }
        return errors;
    }

    public ArrayList<User> getAssessors() {
        return assessors;
    }

    public void setAssessors(ArrayList<User> assessors) {
        this.assessors = assessors;
    }

    public ArrayList<Module> getCoreModules() {
        return coreModules;
    }

    public void setCoreModules(ArrayList<Module> coreModules) {
        this.coreModules = coreModules;
    }

    public User getCourseCoordinator() {
        return courseCoordinator;
    }

    public void setCourseCoordinator(User courseCoordinator) {
        this.courseCoordinator = courseCoordinator;
    }

    public String getCourseID() {
        return courseID;
    }

    public void setCourseID(String courseID) {
        this.courseID = courseID;
    }

    public ArrayList<Module> getElectiveModules() {
        return electiveModules;
    }

    public void setElectiveModules(ArrayList<Module> electiveModules) {
        this.electiveModules = electiveModules;
    }

        public String getName() {
        return name;
    }

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
     * Returns all modules, may be null if coreModules and electiveModules are null.
     * @return all modules, may be null if coreModules and electiveModules are null.
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
}
