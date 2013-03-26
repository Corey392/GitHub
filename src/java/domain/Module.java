/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package domain;

import java.util.ArrayList;
import util.FieldError;

/**
 * A module is part of a course. Courses have elective modules
 * and core modules, but the modules as defined in this class
 * are the same either way. Each module has a list of elements
 * that list performance criteria for gaining credit for the 
 * module, but the list of elements may be empty. 
 * 
 * @author Adam Shortall
 */
public class Module implements Comparable<Module> {
    
    protected String moduleID;

    private String name;
    private String instructions;
    
    private ArrayList<Element> elements;
    
    /**
     * Defines validity of fields in this class.
     */
    public enum Field {
        MODULE_ID("^\\w+$", FieldError.MODULE_ID),
        INSTRUCTIONS("^\\w+$", FieldError.NONE);
        
        public final String pattern;
        public final FieldError error;
        
        Field(String pattern, FieldError error) {
            this.pattern = pattern;
            this.error = error;
        }
        
        public boolean validate(String value) {
            boolean matches = value.matches(pattern);
            return value.matches(pattern);
        }
    }
    
    public Module() {
        this("","","");
    }
    
    public Module(String moduleID) {
        this(moduleID, "", "");
    }
    
    public Module(String moduleID, String name) {
        this(moduleID, name, "");
    }
    
    public Module(String moduleID, String name, String instructions) {
        this(moduleID, name, instructions, new ArrayList<Element>());
    }
    
    public Module(String moduleID, String name, String instructions, ArrayList<Element> elements) {
        this.elements = elements;
        this.instructions = instructions;
        this.moduleID = moduleID;
        this.name = name;   
    }
    
    /**
     * 
     * @return a list of FieldError, one for each Module.Field in error.
     */
    public ArrayList<FieldError> validate() {
        ArrayList<FieldError> list = new ArrayList<FieldError>();
        
        if (! Field.MODULE_ID.validate(moduleID)) {
            list.add( Field.MODULE_ID.error);
        }
        
        return list;
    }

    public ArrayList<Element> getElements() {
        return elements;
    }

    public void setElements(ArrayList<Element> elements) {
        this.elements = elements;
    }

    public String getInstructions() {
        return instructions;
    }

    public void setInstructions(String guide) {
        this.instructions = guide;
    }

    public String getModuleID() {
        return moduleID;
    }

    public void setModuleID(String moduleID) {
        this.moduleID = moduleID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        if (this.moduleID == null || this.moduleID.isEmpty()) {
            return "";
        }
        return this.moduleID + ": " + this.name;
    }

    /**
     * Compares modules by moduleID.
     * @param that
     * @return 
     */
    @Override
    public int compareTo(Module that) {
        return this.moduleID.compareTo(that.moduleID);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Module other = (Module) obj;
        if ((this.moduleID == null) ? (other.moduleID != null) : !this.moduleID.equals(other.moduleID)) {
            return false;
        }
        return true;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 89 * hash + (this.moduleID != null ? this.moduleID.hashCode() : 0);
        return hash;
    }
}
