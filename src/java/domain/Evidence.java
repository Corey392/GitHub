/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package domain;

import util.Util;

/**
 * Object for evidence records.
 * 
 * @author David, James
 * @author Adam Shortall
 */
public class Evidence {
    private String studentID;
    private int claimID;
    /** elementID == 0 when Evidence is for a module rather than an element */
    private Integer elementID;
    private String description;
    private String moduleID;
    private boolean approved;
    private String assessorNote;
    private Element element;
    
    /**
     * Creates a new evidence object.
     */
    public Evidence() {
        this(Util.INT_ID_EMPTY, "", "", "");
    }
    
    public Evidence(int claimID, String studentID, String moduleID) {
        this(claimID, studentID, moduleID, "");
    }
    
    /**
     * Inserts a 'Previous Studies' evidence with description.
     * @param claimID
     * @param studentID
     * @param moduleID
     * @param description 
     */
    public Evidence(int claimID, String studentID, String moduleID, String description) {
        this.claimID = claimID;
        this.studentID = studentID;
        this.moduleID = moduleID;
        this.elementID = Util.INT_ID_EMPTY;
        this.approved = false;
        this.assessorNote = "";
        this.description = description;
    }
    
   /**
     * Inserts an 'RPL' evidence with description and associated elementID.
     * @param claimID
     * @param studentID
     * @param moduleID
     * @param description
     * @param elementID 
     */
    public Evidence(int claimID, String studentID, String moduleID, String description, int elementID) {
        this.claimID = claimID;
        this.studentID = studentID;
        this.moduleID = moduleID;
        this.elementID = elementID;
        this.approved = false;
        this.assessorNote = "";
        this.description = description;
    }

    /**
     * @return the studentID
     */
    public String getStudentID() {
        return studentID;
    }

    /**
     * @return the claimID
     */
    public int getClaimID() {
        return claimID;
    }

    /**
     * @return the elementID
     */
    public Integer getElementID() {
        return elementID;
    }

    /**
     * @return the description
     */
    public String getDescription() {
        return description;
    }

    /**
     * @return the moduleID
     */
    public String getModuleID() {
        return moduleID;
    }

    /**
     * @return the approved
     */
    public boolean isApproved() {
        return approved;
    }

    /**
     * @return the assessorNote
     */
    public String getAssessorNote() {
        return assessorNote;
    }

    /**
     * @param studentID the studentID to set
     */
    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    /**
     * @param claimID the claimID to set
     */
    public void setClaimID(int claimID) {
        this.claimID = claimID;
    }

    /**
     * @param elementID the elementID to set
     */
    public void setElementID(Integer elementID) {
        this.elementID = elementID;
    }

    /**
     * @param description the description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * @param moduleID the moduleID to set
     */
    public void setModuleID(String moduleID) {
        this.moduleID = moduleID;
    }

    /**
     * @param approved the approved to set
     */
    public void setApproved(boolean approved) {
        this.approved = approved;
    }

    /**
     * @param assessorNote the assessorNote to set
     */
    public void setAssessorNote(String assessorNote) {
        this.assessorNote = assessorNote;
    }

    /**
     * @return the element
     */
    public Element getElement() {
        return element;
    }

    /**
     * @param element the element to set
     */
    public void setElement(Element element) {
        this.element = element;
    }
    
    @Override
    public String toString() {
        return this.description == null ? "" : this.description;
    }
}
