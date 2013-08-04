package domain;

import java.sql.Date;
import java.util.ArrayList;
import util.Util;
import java.io.Serializable;

/** A Claim is made by a Student
 *  @author     Adam Shortall, David Gibbins, Todd Wiggins, Mitchell Carr
 *  @version    1.031
 *	Created:    ?
 *	Change Log: 06/05/2013: TW: Added getCode() and EMPTY_DRAFT status to status Enum.
 *	            15/06/2013: TW: Added getValidStatuses() to Enum
 */
public class Claim implements Serializable {

    //<editor-fold defaultstate="collapsed" desc="Enumeration Classes">
    public enum Status {
        EMPTY_DRAFT(0, "No Modules"),
        DRAFT(1, "Draft"),
        PRELIMINARY(2, "Preliminary"),
        EVIDENCE(3, "Attach Evidence"),
        ASSESSMENT(4, "Awaiting Assessment"),
        APPROVAL(5, "Awaiting Approval"),
        SUBMITTED(6, "Submitted"),
        APPROVED(7, "Approved"),
        DECLINED(8, "Declined");

        public final int code;
        public final String desc;

        Status(int code, String desc) {
            this.code = code;
            this.desc = desc;
        }

		public static Status[] getValidStatuses() {
			Status[] statuses = Status.values();
			Status[] validStatuses = new Status[statuses.length - 1];
			for (int i = 0; i < statuses.length-1; i++) {
				validStatuses[i] = statuses[i+1];
			}
			return validStatuses;
		}

        /**
         * @param value Integer indicating the Claim's current status
         * @return Status object indicating the stage at which a Claim currently is
         * @throws IllegalArgumentException if value passed in doesn't map to a
         *          valid Claim Status
         */
        public static Status getFromInt(int value) {
            switch(value) {
                case 0: return DRAFT;  // Daniel
                case 1: return DRAFT;
                case 2: return PRELIMINARY;
                case 3: return EVIDENCE;
                case 4: return ASSESSMENT;
                case 5: return APPROVAL;
                case 6: return SUBMITTED;
                case 7: return APPROVED;
                case 8: return DECLINED;
                default:
                    throw new IllegalArgumentException("Invalid int for Status");
            }
        }

	/**
         * @return Integer indicating current Claim's status
         */
        public int getCode() {
		return this.code;
	}

        /**
         * @return Returns a description of the Claim's current status
         */
        public String getDesc() {
            return this.desc;
        }

        @Override
        public String toString() {
            return this.desc;
        }
    }

    public enum ClaimType {

        RPL(true, "RPL"),
        PREVIOUS_STUDIES(false, "Previous Studies");

        public final Boolean value;
        public final String desc;

        ClaimType(Boolean value, String desc) {
            this.value = value;
            this.desc = desc;
        }

        /**
         * Parses a ClaimType based on the boolean value passed in.
         * @param value Boolean value indicating the claim's type
         * @return ClaimType corresponding to boolean value passed in
         */
        public static ClaimType getFromBool(Boolean value) {
            return value ? RPL : PREVIOUS_STUDIES;
        }

        /**
         * @return Returns a description of the ClaimType
         */
        public String getDesc() {
            return this.desc;
        }

        @Override
        public String toString() {
            return this.desc;
        }
    }

    public enum Option {

        TAFENSW('C'),
        OTHER_PROVIDER('D');

        public final char value;

        Option(char value) {
            this.value = value;
        }

        /**
         * @param value Character representing a Claim Option
         * @return Returns an Option corresponding to the char value passed in
         * @throws IllegalArgumentException if value passed in doesn't map to
         *          a valid Option.
         */
        public static Option getFromChar(char value) {
            switch(value) {
                case 'C': return TAFENSW;
                case 'D': return OTHER_PROVIDER;
                default:
                    throw new IllegalArgumentException("Invalid char for Option");
            }
        }

        /**
         * @return Returns a Character representing this Option type.
         */
        public char getValue() {
            return this.value;
        }
    }
    //</editor-fold>
    // ID Fields:
    private Integer claimID;
    private String studentID;
    private String campusID;
    private Integer disciplineID;
    private String courseID;
    private String assessorID;
    private String delegateID;

    // Data & Object references:
    private ArrayList<ClaimedModule> claimedModules;
    private Campus campus;
    private Discipline discipline;
    private Course course;
    private User assessor;
    private User delegate;
    private Date dateMade;
    private Date dateResolved;
    private Boolean assessorApproved;
    private Boolean delegateApproved;
    private Boolean requestCompletion;
    private Option option;
    private Status status;
    private ClaimType claimType;

    /**
     * Empty constructor, sets default values.
     */
    public Claim() {
        this(Util.INT_ID_EMPTY, null);
    }

    public Claim(int claimID, String studentID) {
        this(
                claimID,
                studentID,
                null,
                Util.INT_ID_EMPTY,
                null,
                false,
                false,
                Option.TAFENSW,
                Status.DRAFT,
                ClaimType.PREVIOUS_STUDIES,
                null,
                null,
                null,
                null,
                null);
    }

    /**
     * Constructor for student users who get a claim from the database.
     */
    public Claim(
            Integer claimID,
            String studentID,
            String campusID,
            Integer disciplineID,
            String courseID,
            Boolean assessorApproved,
            Boolean delegateApproved,
            Option option,
            Status status,
            ClaimType claimType,
            Date dateMade,
            Date dateResolved,
            Boolean requestCompletion,
            String assessorID,
            String delegateID) {
        this.claimID = claimID;
        this.studentID = studentID;
        this.campusID = campusID;
        this.disciplineID = disciplineID;
        this.courseID = courseID;
        this.assessorApproved = assessorApproved;
        this.delegateApproved = delegateApproved;
        this.option = option;
        this.status = status;
        this.claimType = claimType;
        this.dateMade = dateMade;
        this.dateResolved = dateResolved;
        this.requestCompletion = requestCompletion;
        this.assessorID = assessorID;
        this.delegateID = delegateID;
    }

    /**
     * @return Unique identifier for this Claim
     */
    public Integer getClaimID() {
        return claimID;
    }

    /**
     * @return Unique identifier for this student who lodged this Claim
     */
    public String getStudentID() {
        return studentID;
    }

    /**
     * @return Unique identifier for the Campus this Claim was lodged to
     */
    public String getCampusID() {
        return campusID;
    }

    /**
     * @return Unique identifier for the Course this Claim pertains to
     */
    public String getCourseID() {
        return courseID;
    }

    /**
     * @return Unique identifier for the Discipline this Claim pertains to
     */
    public Integer getDisciplineID() {
        return disciplineID;
    }

    /**
     * @return Unique identifier for the Assessor responsible for this Claim
     */
    public String getAssessorID() {
        return assessorID;
    }

    /**
     * @return Unique identifier for the Delegate responsible for this Claim
     */
    public String getDelegateID() {
        return delegateID;
    }

    /**
     * @return List of modules this Claim encompasses
     */
    public ArrayList<ClaimedModule> getClaimedModules() {
        return claimedModules;
    }

    /**
     * @return Campus at which this Claim was lodged
     */
    public Campus getCampus() {
        return campus;
    }

    /**
     * @return Discipline this Claim targets
     */
    public Discipline getDiscipline() {
        return discipline;
    }

    /**
     * @return Course this Claim is being lodged for
     */
    public Course getCourse() {
        return course;
    }

    /**
     * @return Assessor responsible for this Claim
     */
    public User getAssessor() {
        return assessor;
    }

    /**
     * @return Delegate responsible for this Claim
     */
    public User getDelegate() {
        return delegate;
    }

    /**
     * @return Date on which this Claim was lodged
     */
    public Date getDateMade() {
        return dateMade;
    }

    /**
     * @return Date on which this Claim was resolved
     */
    public Date getDateResolved() {
        return dateResolved;
    }

    /**
     * @return If an Assessor approved this claim, returns true.
     *          Otherwise, returns false.
     */
    public Boolean getAssessorApproved() {
        return assessorApproved;
    }

    /**
     * @return If a Delegate approved this claim, returns true.
     *          Otherwise, returns false.
     */
    public Boolean getDelegateApproved() {
        return delegateApproved;
    }

    /**
     * @return If this Claim has been processed, returns true.
     *          Otherwise, returns false.
     */
    public Boolean getRequestCompletion() {
        return requestCompletion;
    }

    /**
     * @return Returns Option indicating what type of Claim this is.
     *          eg. One for previous TAFE studies as opposed to outside education
     */
    public Option getOption() {
        return option;
    }

    /**
     * @return The current Status of this claim.
     *          eg. Draft, Preliminary, Approved, etc.
     */
    public Status getStatus() {
        return status;
    }

    /**
     * @return The type of Claim this is.
     *          Either "RPL" or "Previous Studies".
     */
    public ClaimType getClaimType() {
        return claimType;
    }

    /**
     * @param claimID Unique ID representing this specific Claim
     */
    public void setClaimID(Integer claimID) {
        this.claimID = claimID;
    }

    /**
     * @param studentID Unique ID representing the student who lodged this
     *                  specific Claim.
     */
    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    /**
     * @param campusID Unique ID representing the Campus at which this
     *                  specific Claim was lodged.
     */
    public void setCampusID(String campusID) {
        this.campusID = campusID;
    }

    /**
     * @param courseID Unique ID representing the Course this specific Claim
     *                  pertains to.
     */
    public void setCourseID(String courseID) {
        this.courseID = courseID;
    }

    /**
     * @param disciplineID Unique ID representing the Discipline this specific
     *                      Claim targets.
     */
    public void setDisciplineID(Integer disciplineID) {
        this.disciplineID = disciplineID;
    }

    /**
     * @param assessorID Unique ID representing the Assessor responsible for
     *                  this specific Claim
     */
    public void setAssessorID(String assessorID) {
        this.assessorID = assessorID;
    }

    /**
     * @param delegateID Unique ID representing the Delegate responsible for
     *                  this specific Claim
     */
    public void setDelegateID(String delegateID) {
        this.delegateID = delegateID;
    }

    /**
     * @param claimedModules The modules which this Claim encompasses
     */
    public void setClaimedModules(ArrayList<ClaimedModule> claimedModules) {
        this.claimedModules = claimedModules;
    }

    /**
     * @param campus Campus for this Claim to be lodged at
     */
    public void setCampus(Campus campus) {
        this.campus = campus;
    }

    /**
     * @param discipline Discipline for this Claim to pertain to
     */
    public void setDiscipline(Discipline discipline) {
        this.discipline = discipline;
    }

    /**
     * @param course Course this Claim targets
     */
    public void setCourse(Course course) {
        this.course = course;
    }

    /**
     * @param assessor Assessor responsible for this Claim
     */
    public void setAssessor(User assessor) {
        this.assessor = assessor;
    }

    /**
     * @param delegate Delegate responsible for this Claim
     */
    public void setDelegate(User delegate) {
        this.delegate = delegate;
    }

    /**
     * @param dateMade Date on which this Claim was lodged
     */
    public void setDateMade(Date dateMade) {
        this.dateMade = dateMade;
    }

    /**
     * @param dateResolved Date on which this Claim was resolved
     */
    public void setDateResolved(Date dateResolved) {
        this.dateResolved = dateResolved;
    }

    /**
     * @param assessorApproved Boolean value indicating whether an Assessor
     *                      approved this Claim or not.
     */
    public void setAssessorApproved(Boolean assessorApproved) {
        this.assessorApproved = assessorApproved;
    }

    /**
     * @param delegateApproved Boolean value indicating whether a Delegate
     *                      approved this Claim or not.
     */
    public void setDelegateApproved(Boolean delegateApproved) {
        this.delegateApproved = delegateApproved;
    }

    /**
     * @param requestCompletion Boolean value indicating whether this Claim
     *                          has been completely processed or not.
     */
    public void setRequestCompletion(Boolean requestCompletion) {
        this.requestCompletion = requestCompletion;
    }

    /**
     * @param option Option indicating what type of Claim this is.
     *          eg. One for previous TAFE studies as opposed to outside education
     */
    public void setOption(Option option) {
        this.option = option;
    }

    /**
     * @param status The current Status of this claim.
     *          eg. Draft, Preliminary, Approved, etc.
     */
    public void setStatus(Status status) {
        this.status = status;
    }

    /**
     * @param claimType The type of Claim this is.
     *          Either "RPL" or "Previous Studies".
     */
    public void setClaimType(ClaimType claimType) {
        this.claimType = claimType;
    }
}