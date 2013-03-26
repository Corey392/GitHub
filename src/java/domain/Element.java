/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package domain;

import java.util.ArrayList;

/**
 *
 * @author David, James
 */
public class Element implements Comparable<Element> {
    private ArrayList<Criterion> criteria;
    private int elementID;
    private String moduleID;
    private String description;

    public Element() {
        this(-1,"","");
    }
    
    public Element(int elementID, String moduleID) {
        this(elementID, moduleID, "");
    }

    public Element(int elementID, String moduleID, String description) {
        this.elementID = elementID;
        this.moduleID = moduleID;
        this.description = description;
    }

    public ArrayList<Criterion> getCriteria() {
        return criteria;
    }

    public void setCriteria(ArrayList<Criterion> criteria) {
        this.criteria = criteria;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getElementID() {
        return elementID;
    }

    public void setElementID(int elementID) {
        this.elementID = elementID;
    }

    public String getModuleID() {
        return moduleID;
    }

    public void setModuleID(String moduleID) {
        this.moduleID = moduleID;
    }

    @Override
    public String toString() {
        return this.description == null ? "" : this.description;
    }

    @Override
    public int compareTo(Element that) {
        if (this.elementID < that.elementID) {
            return -1;
        } return (this.elementID == that.elementID ? 0 : 1);
    }
}
