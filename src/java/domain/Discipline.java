/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package domain;

import java.text.Collator;
import java.util.ArrayList;
import util.FieldError;

/**
 *
 * @author David Gibbins, James
 * @author Adam Shortall
 */
public class Discipline implements Comparable<Discipline> {
    
    public enum Field {
        NAME("^[\\w+\\s]+$", FieldError.DISCIPLINE_NAME);
        
        public final String pattern;
        public final FieldError fieldError;
        
        Field(String pattern, FieldError fieldError) {
            this.pattern = pattern;
            this.fieldError = fieldError;
        }
    }
    private int disciplineID;
    private String name;
    private ArrayList<Course> courses;

    public Discipline() {
        this("");
    }
    
    public Discipline(String name) {
        this.name = name;
    }
    
    public Discipline(int disciplineID, String name) {
        this.disciplineID = disciplineID;
        this.name = name;
    }
    
    public FieldError validate() {
        if (! name.matches(Field.NAME.pattern)) {
            return Field.NAME.fieldError;
        }
        return null;
    }

    public int getDisciplineID() {
        return disciplineID;
    }

    public void setDisciplineID(int disciplineID) {
        this.disciplineID = disciplineID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return this.name == null ? "" : this.name;
    }

    /**
     * For sorting Disciplines in alphabetical order
     * @param that
     * @return 
     */
    @Override
    public int compareTo(Discipline that) {
        Collator collator = Collator.getInstance();
        return collator.compare(this.name, that.name);
    }

    /**
     * @return the courses
     */
    public ArrayList<Course> getCourses() {
        return courses;
    }

    /**
     * @param courses the courses to set
     */
    public void setCourses(ArrayList<Course> courses) {
        this.courses = courses;
    }
}
