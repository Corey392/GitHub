package domain;

import java.io.Serializable;
import util.Util;

/**
 * @author James, Bryce Carr
 * @version 1.02
 * <b>Created:</b> Unknown<br/>
 * <b>Modified:</b> 24/04/2013<br/>
 * <b>Change Log:</b>  08/04/2013:  Bryce Carr: Removed code to account for removal of moduleID field in DB table.<br/>
 *                  24/04/2013: Bryce Carr: Added header comments to match code conventions.<br/>
 *		    07/05/2013:	Bryce Carr: Added moduleID field and updated methods/constructors to match. Part of implementing Criterion insertion.
 * <b>Purpose:</b>  Model class for database's Criterion table.
 */
public class Criterion implements Comparable<Criterion>, Serializable {
    private int criterionID;
    private int elementID;
    private String moduleID;
    private String description;

    public Criterion(){
        this(Util.INT_ID_EMPTY,Util.INT_ID_EMPTY,"","");
    }

    public Criterion(int elementID, String moduleID, String description) {
        this(0, elementID, moduleID, description);
    }

    public Criterion(int criterionID, int elementID, String moduleID, String description) {
        this.criterionID = criterionID;
        this.elementID = elementID;
	this.moduleID = moduleID;
        this.description = description;
    }

    /**
     * @return ID to uniquely identify this Criterion
     */
    public int getCriterionID() {
        return criterionID;
    }

    /**
     * @param criterionID ID to uniquely identify this Criterion
     */
    public void setCriterionID(int criterionID) {
        this.criterionID = criterionID;
    }

    /**
     * @return Description of this Criterion
     */
    public String getDescription() {
        return description;
    }

    /**
     * @param description Description of this Criterion
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * @return ID uniquely identifying the Element associated with this Criterion
     */
    public int getElementID() {
        return elementID;
    }

    /**
     * @param elementID ID uniquely identifying the Element associated with
     *          this Criterion
     */
    public void setElementID(int elementID) {
        this.elementID = elementID;
    }

    /**
     * @return ID uniquely identifying the Module associated with this Criterion
     */
    public String getModuleID()	{
	return this.moduleID;
    }

    /**
     * @param moduleID ID uniquely identifying the Module associated with
     *              this Criterion
     */
    public void setModuleID(String moduleID)	{
	this.moduleID = moduleID;
    }

    @Override
    public String toString() {
        return this.description == null ? "" : this.description;
    }

    @Override
    public int compareTo(Criterion that) {
        if (this.criterionID < that.criterionID) {
            return -1;
        }
        return (this.criterionID == that.criterionID ? 0 : 1);
    }
}