package domain;

import java.io.Serializable;
import util.Util;

/** Object for evidence records.
 *  @author     David, James, Adam Shortall, Todd Wiggins
 *  @version    1.020
 *	Created:    ?
 *	Change Log: 08/05/2013: TW: Added 'updated' field.
 */
public class Evidence implements Serializable {

    private int claimID;
    private Integer elementID;
    private String description;
    private String moduleID;
    private boolean approved;
    private String assessorNote;
    private Element element;
	private boolean updated;

    /**
     * Creates a new evidence object.
     */
    public Evidence() {
        this(Util.INT_ID_EMPTY, "", "");
    }

	@Deprecated
    public Evidence(int claimID, String moduleID) {
        this(claimID, moduleID, "");
    }

    /**
     * Inserts a 'Previous Studies' evidence with description.
     */
	@Deprecated
    public Evidence(int claimID, String moduleID, String description) {
        this(claimID, moduleID, Util.INT_ID_EMPTY, description);
    }

   /**
     * Inserts an 'RPL' evidence with description and associated elementID.
     */
    public Evidence(int claimID, String moduleID, int elementID, String description) {
        this.claimID = claimID;
        this.moduleID = moduleID;
        this.elementID = elementID;
        this.approved = false;
        this.assessorNote = "";
        this.description = description;
	this.updated = false;
    }

    /**
     * @return Unique identifier for the Claim this class depicts evidence for
     */
    public int getClaimID() {
        return claimID;
    }

    /**
     * @return Unique identifier for the Element this class depicts evidence for
     */
    public Integer getElementID() {
        return elementID;
    }

    /**
     * @return Description of the evidence this object depicts
     */
    public String getDescription() {
        return description;
    }

    /**
     * @return Unique identifier for the Module this class depicts evidence for
     */
    public String getModuleID() {
        return moduleID;
    }

    /**
     * @return If the evidence this object depicts has been approved, true.
     *          Otherwise, false.
     */
    public boolean isApproved() {
        return approved;
    }

    /**
     * @return A note left by the Assessor. May be blank.
     */
    public String getAssessorNote() {
        return assessorNote;
    }

    /**
     * @param claimID Unique identifier depicting the Claim that this class 
     *              provides evidence for
     */
    public void setClaimID(int claimID) {
        this.claimID = claimID;
    }

    /**
     * @param elementID Unique identifier depicting the Element that this class 
     *              provides evidence for
     */
    public void setElementID(Integer elementID) {
        this.elementID = elementID;
    }

    /**
     * @param description Text description of the evidence this object depicts
     */
    public void setDescription(String description) {
        this.description = description;
		this.setUpdated(true);
    }

    /**
     * @param moduleID Unique identifier depicting the Module that this class 
     *              provides evidence for
     */
    public void setModuleID(String moduleID) {
        this.moduleID = moduleID;
    }

    /**
     * @param approved If the evidence this object depicts has been approved,
     *                  returns true. Otherwise, false.
     */
    public void setApproved(boolean approved) {
        this.approved = approved;
		this.setUpdated(true);
    }

    /**
     * @param assessorNote A note left by the Assessor for whoever views this
     *                  piece of evidence thereafter.
     */
    public void setAssessorNote(String assessorNote) {
        this.assessorNote = assessorNote;
		this.setUpdated(true);
    }

    /**
     * @return The Element which this object is providing evidence for
     */
    public Element getElement() {
        return element;
    }

    /**
     * @param element The Element which this object is providing evidence for
     */
    public void setElement(Element element) {
        this.element = element;
    }

	/**
	 * Flags this Evidence instance as being updated (or Added)
	 * @return If this object's database entry differs from its current state
         *          in the application, returns true. Otherwise, false.
	 */
	public boolean isUpdated() {
		return this.updated;
	}

	/**
	 * Flags this Evidence instance as being updated (or Added)
	 * @param updated True if this object no longer matches its entry in
         *          the database. Otherwise, false.
	 */
	public void setUpdated(boolean updated) {
		this.updated = updated;
	}

    @Override
    public String toString() {
        return this.description == null ? "" : this.description;
    }
}