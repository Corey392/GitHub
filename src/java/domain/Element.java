package domain;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * @author David, James
 */
public class Element implements Comparable<Element>, Serializable {
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

    /**
     * @return Returns a list of criteria for this Element
     */
    public ArrayList<Criterion> getCriteria() {
        return criteria;
    }

    /**
     * @param criteria A list of criteria to set for this Element
     */
    public void setCriteria(ArrayList<Criterion> criteria) {
        this.criteria = criteria;
    }

    /**
     * @return Description of this Element
     */
    public String getDescription() {
        return description;
    }

    /**
     * @param description Description of this Element
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * @return Unique identifier for this Element
     */
    public int getElementID() {
        return elementID;
    }

    /**
     * @param elementID Unique identifier to set for this Element
     */
    public void setElementID(int elementID) {
        this.elementID = elementID;
    }

    /**
     * @return Unique ID for the Module this Element pertains to
     */
    public String getModuleID() {
        return moduleID;
    }

    /**
     * @param moduleID Unique ID for the Module this Element pertains to
     */
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
        }
        return (this.elementID == that.elementID ? 0 : 1);
    }
}