package domain;

import java.util.ArrayList;
import util.FieldError;
import java.io.Serializable;

/**
 * @author David Gibbins, Adam Shortall
 */
public class Campus implements Comparable<Campus>, Serializable {    
    
    public enum Field {
        ID("^[0-9]{3}$", FieldError.CAMPUS_ID), 
        NAME("^[\\w+\\s\\w]+$", FieldError.CAMPUS_NAME);

        public final String pattern;
        public final FieldError fieldError;
        
        Field(String pattern, FieldError fieldError) {
            this.pattern = pattern;
            this.fieldError = fieldError;
        }
    }
    
    //Instance fields
    private ArrayList<Discipline> disciplines;
    private String campusID;
    private String name;
    
    /**
     * Empty Constructor
     */
    public Campus() {
        this("");
    }
    
    public Campus(String campusID) {
        this(campusID, "");
    }
    
    public Campus (String campusID, String name) {
        this(campusID, name, new ArrayList<Discipline>());
    }
    
    public Campus(String campusID, String name, ArrayList<Discipline> disciplines) {
        this.campusID = campusID;
        this.name = name;
        this.disciplines = disciplines;
    }
    
    /**
     * Validates the fields of Campus. 
     * @return An ArrayList of Field
     * is returned filled with Fields 
     * that map to those found to be invalid.
     */
    public ArrayList<Field> validate() {
        ArrayList<Field> invalidFields = new ArrayList<Field>();
        if (! campusID.matches(Field.ID.pattern)) {
            invalidFields.add(Field.ID);
        }
        if (! name.matches(Field.NAME.pattern)) {
            invalidFields.add(Field.NAME);
        }
        return invalidFields;
    }
    
    /**
     * @return campusID Unique identifier representing this specific Campus
     */
    public String getCampusID() {
        return this.campusID;
    }
    
    /**
     * @return name Name of this Campus
     */
    public String getName() {
        return this.name;
    }
    
    /**
     * @return List of disciplines this Campus encompasses
     */
    public ArrayList<Discipline> getDisciplines() {
        return this.disciplines;
    }
    
    /**
     * @param campusID Unique identifier representing this specific Campus
     */
    public void setCampusID(String campusID) {
        this.campusID = campusID;
    }
    
    /**
     * @param name Name of this Campus
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * @param disciplines List of disciplines this Campus encompasses
     */
    public void setDisciplines(ArrayList<Discipline> disciplines) {
        this.disciplines = disciplines;
    }
    
    @Override
    public String toString() {
        if (campusID == null || campusID.isEmpty()) {
            return "";
        }
        return this.campusID + ": " + this.name;
    }
    
    @Override
    public int compareTo(Campus that) {
        return this.campusID.compareTo(that.campusID);
    }
}