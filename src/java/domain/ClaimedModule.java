package domain;

import java.io.Serializable;
import java.util.ArrayList;
import util.Util;

/**
 *
 * @author David
 * @author Adam Shortall
 */
public final class ClaimedModule extends Module implements Serializable{
    
    private int claimID;
    private String studentID;
    
    private boolean approved;
    private String arrangementNo;
    private String functionalCode;
    private boolean overseasEvidence;
    private char recognition;
    
    private ArrayList<Provider> providers;
    private ArrayList<Evidence> evidence;

    /**
     * Empty constructor
     */
    public ClaimedModule() {
        this(Util.INT_ID_EMPTY, "", "");
    }
    
    /**
     * Constructs a ClaimedModule with all mandatory fields.
     * @param claimID
     * @param studentID
     * @param moduleID 
     */
    public ClaimedModule(int claimID, String studentID, String moduleID) {
        this.setClaimID(claimID);
        this.setStudentID(studentID);
        this.setModuleID(moduleID);
        this.approved = false;
        this.arrangementNo = "";
        this.functionalCode = "";
        this.overseasEvidence = false;
        this.recognition = ' ';
    }
    
    /**
     * @return the claimID
     */
    public int getClaimID() {
        return claimID;
    }

    /**
     * @return the studentID
     */
    public String getStudentID() {
        return studentID;
    }

    /**
     * @return the approved
     */
    public boolean isApproved() {
        return approved;
    }

    /**
     * @return the arrangementNo
     */
    public String getArrangementNo() {
        return arrangementNo;
    }

    /**
     * @return the functionalCode
     */
    public String getFunctionalCode() {
        return functionalCode;
    }

    /**
     * @return the overseasEvidence
     */
    public boolean isOverseasEvidence() {
        return overseasEvidence;
    }

    /**
     * @return the recognition
     */
    public char getRecognition() {
        return recognition;
    }

    /**
     * @return the providers
     */
    public ArrayList<Provider> getProviders() {
        return providers;
    }

    /**
     * @return the evidence
     */
    public ArrayList<Evidence> getEvidence() {
        return evidence;
    }

    /**
     * @param claimID the claimID to set
     */
    public void setClaimID(int claimID) {
        this.claimID = claimID;
    }

    /**
     * @param studentID the studentID to set
     */
    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    /**
     * @param approved the approved to set
     */
    public void setApproved(boolean approved) {
        this.approved = approved;
    }

    /**
     * @param arrangementNo the arrangementNo to set
     */
    public void setArrangementNo(String arrangementNo) {
        this.arrangementNo = arrangementNo;
    }

    /**
     * @param functionalCode the functionalCode to set
     */
    public void setFunctionalCode(String functionalCode) {
        this.functionalCode = functionalCode;
    }

    /**
     * @param overseasEvidence the overseasEvidence to set
     */
    public void setOverseasEvidence(boolean overseasEvidence) {
        this.overseasEvidence = overseasEvidence;
    }

    /**
     * @param recognition the recognition to set
     */
    public void setRecognition(char recognition) {
        this.recognition = recognition;
    }

    /**
     * @param providers the providers to set
     */
    public void setProviders(ArrayList<Provider> providers) {
        this.providers = providers;
    }

    /**
     * @param evidence the evidence to set
     */
    public void setEvidence(ArrayList<Evidence> evidence) {
        this.evidence = evidence;
    }
    
    @Override
    public String toString() {
        return super.toString();
    }
}
