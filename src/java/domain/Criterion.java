/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package domain;
import util.Util;

/**
 *
 * @author James
 */
public class Criterion implements Comparable<Criterion> {
    private int criterionID;
    private int elementID;
    private String description;
    
    public Criterion(){
        this(Util.INT_ID_EMPTY,Util.INT_ID_EMPTY,"");
    }

    public Criterion(int elementID, String description) {
        this(0, elementID, description);
    }
    
    public Criterion(int criterionID, int elementID, String description) {
        this.criterionID = criterionID;
        this.elementID = elementID;
        this.description = description;
    }

    public int getCriterionID() {
        return criterionID;
    }

    public void setCriterionID(int criterionID) {
        this.criterionID = criterionID;
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

    /**
     * 
     * @return The criterion's description (text that student/teacher sees).
     */
    @Override
    public String toString() {
        return this.description == null ? "" : this.description;
    }

    @Override
    public int compareTo(Criterion that) {
        if (this.criterionID < that.criterionID) {
            return -1;
        } return (this.criterionID == that.criterionID ? 0 : 1);
    }
}
