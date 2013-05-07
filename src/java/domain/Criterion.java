package domain;
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
public class Criterion implements Comparable<Criterion> {
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
    
    public String getModuleID()	{
	return this.moduleID;
    }
    
    public void setModuleID(String moduleID)	{
	this.moduleID = moduleID;
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
