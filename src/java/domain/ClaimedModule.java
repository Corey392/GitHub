package domain;

import java.io.Serializable;
import java.util.ArrayList;
import util.Util;

/** Domain class for Claimed Modules, an extension of Module.
 *  @author David, Adam Shortall, Todd Wiggins, Mitch Carr
 *  @version    1.020
 *	Created:    ?
 *	Modified:	05/05/2013: TW: Added 'Module Name' into constructor, deprecated existing.
 *				07/05/2013: MC: Updated evidence field, as well as getEvidence and setEvidence methods
 *				07/05/2013: TW: Changed evidence to ArrayList<Evidence>.
 *                              15/05/2013: MC: Removed deprecated constructor and updated another
 */
public final class ClaimedModule extends Module implements Serializable{

    private int claimID;
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
     * @author Todd Wiggins (added Module Name)
     * @param claimID Student's Claim ID
     * @param moduleID TAFE Unit / Module Code
     * @param name Name of Module
     */
    public ClaimedModule(int claimID, String moduleID, String name) {
        this.setClaimID(claimID);
        this.setModuleID(moduleID);
        this.setName(name);
        this.approved = false;
        this.arrangementNo = "";
        this.functionalCode = "";
        this.overseasEvidence = false;
        this.recognition = ' ';
    }

    /**
     * @return Unique identifier of the Claim for this ClaimedModule
     */
    public int getClaimID() {
        return claimID;
    }

    /**
     * @return If this ClaimedModule has been approved, returns true. 
     *          Otherwise, false.
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
     * @param claimID Unique identifier of the Claim for this ClaimedModule
     */
    public void setClaimID(int claimID) {
        this.claimID = claimID;
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