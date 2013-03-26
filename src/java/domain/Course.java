/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package domain;

import java.util.ArrayList;
import util.FieldError;

/**
 * Contains course information from the database, and 
 * links to 
 * @author David Gibbins, James
 * @author Adam Shortall
 */
public class Course implements Comparable<Course> {
    
    private String courseID;
    private String name;
    private ArrayList<Module> coreModules;
    private ArrayList<Module> electiveModules;
    private ArrayList<User> assessors;
    private User courseCoordinator;
    
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
     * Defines fields that require validation.
     */
    public enum Field {
        ID("^[0-9]{5}$", FieldError.COURSE_ID),
        NAME("^.+$", FieldError.COURSE_NAME);
        
        public final String pattern;
        public final FieldError fieldError;
        
        Field(String pattern, FieldError fieldError) {
            this.pattern = pattern;
            this.fieldError = fieldError;
        }
        
        public FieldError validateField(String value) {
            return value.matches(pattern) ? null : fieldError;
        }
    }
    
    public ArrayList<FieldError> validate() {
        ArrayList<FieldError> errors = new ArrayList<FieldError>();
        FieldError courseIDError = Field.ID.validateField(courseID);
        FieldError nameError = Field.NAME.validateField(name);
        if (courseIDError != null) {
            errors.add(courseIDError);
        } if (nameError != null) {
            errors.add(nameError);
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
        list.addAll(this.coreModules);
        list.addAll(this.electiveModules);
        return list;
    }
}
