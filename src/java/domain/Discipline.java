package domain;

import java.io.Serializable;
import java.text.Collator;
import java.util.ArrayList;
import util.FieldError;

/**
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

    /**
     * @return If the discipline name matches a Field.Name error pattern,
     *          the error is returned. Otherwise, returns null.
     */
    public FieldError validate() {
        if (! name.matches(Field.NAME.pattern)) {
            return Field.NAME.fieldError;
        }
        return null;
    }

    /**
     * @return A unique ID identifying this Discipline
     */
    public int getDisciplineID() {
        return disciplineID;
    }

    /**
     * @param disciplineID A unique ID identifying this Discipline
     */
    public void setDisciplineID(int disciplineID) {
        this.disciplineID = disciplineID;
    }

    /**
     * @return The name of this Discipline
     */
    public String getName() {
        return name;
    }

    /**
     * @param name The name of this Discipline
     */
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return this.name == null ? "" : this.name;
    }

    @Override
    public int compareTo(Discipline that) {
        Collator collator = Collator.getInstance();
        return collator.compare(this.name, that.name);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Discipline && ((Discipline)obj).getDisciplineID() == this.getDisciplineID()) {
            return true;
        }
        return false;
    }

    /**
     * @return Courses this Discipline encompasses
     */
    public ArrayList<Course> getCourses() {
        return courses;
    }

    /**
     * @param courses Courses this Discipline encompasses
     */
    public void setCourses(ArrayList<Course> courses) {
        this.courses = courses;
    }
}