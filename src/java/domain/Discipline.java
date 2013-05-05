/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package domain;

import java.io.Serializable;
import java.text.Collator;
import java.util.ArrayList;
import util.FieldError;

/**
 *
 * @author David Gibbins, James, Adam Shortall, Bryce Carr
 * @version 1.1
 * <b>Created:</b>  Unknown<br/>
 * <b>Modified:</b> 24/04/2013<br/>
 * <b>Change Log:</b>  23/04/2013:  Bryce Carr: Overrode super.equals() function to compare Disciplines by their disciplineID.<br/>
 *                  24/04/2013: Bryce Carr: Added header comments to match code conventions.<br/>
 * <b>Purpose:</b>  Model class for database's Discipline table.
 */
public class Discipline implements Comparable<Discipline>, Serializable {

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
     * Compares two Discipline objects' disciplineIDs.
     * @param obj
     * @return false if disciplineIDs are different or if argument is not of type Discipline
     */
    @Override
    public boolean equals(Object obj) {
        if (obj.getClass() == Discipline.class && ((Discipline)obj).getDisciplineID() == this.getDisciplineID()) {
            return true;
        }
        return false;
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
