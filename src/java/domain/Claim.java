package domain;

import java.sql.Date;
import java.util.ArrayList;
import util.Util;
import java.io.Serializable;

/** A Claim is made by a Student
 *  @author     Adam Shortall, David Gibbins, Todd Wiggins, Mitchell Carr
 *  @version    1.030
 *	Created:    ?
 *	Change Log: 06/05/2013: TW: Added getCode() and EMPTY_DRAFT status to status Enum.
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

		public int getCode() {
			return this.code;
		}

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

        public static ClaimType getFromBool(Boolean value) {
            return value ? RPL : PREVIOUS_STUDIES;
        }

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

        public static Option getFromChar(char value) {
            switch(value) {
                case 'C': return TAFENSW;
                case 'D': return OTHER_PROVIDER;
                default:
                    throw new IllegalArgumentException("Invalid char for Option");
            }
        }

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
     * @return the claimID
     */
    public Integer getClaimID() {
        return claimID;
    }

    /**
     * @return the studentID
     */
    public String getStudentID() {
        return studentID;
    }

    /**
     * @return the campusID
     */
    public String getCampusID() {
        return campusID;
    }

    /**
     * @return the courseID
     */
    public String getCourseID() {
        return courseID;
    }

    /**
     * @return the disciplineID
     */
    public Integer getDisciplineID() {
        return disciplineID;
    }

    /**
     * @return the assessorID
     */
    public String getAssessorID() {
        return assessorID;
    }

    /**
     * @return the delegateID
     */
    public String getDelegateID() {
        return delegateID;
    }

    /**
     * @return the claimedModules
     */
    public ArrayList<ClaimedModule> getClaimedModules() {
        return claimedModules;
    }

    /**
     * @return the campus
     */
    public Campus getCampus() {
        return campus;
    }

    /**
     * @return the discipline
     */
    public Discipline getDiscipline() {
        return discipline;
    }

    /**
     * @return the course
     */
    public Course getCourse() {
        return course;
    }

    /**
     * @return the assessor
     */
    public User getAssessor() {
        return assessor;
    }

    /**
     * @return the delegate
     */
    public User getDelegate() {
        return delegate;
    }

    /**
     * @return the dateMade
     */
    public Date getDateMade() {
        return dateMade;
    }

    /**
     * @return the dateResolved
     */
    public Date getDateResolved() {
        return dateResolved;
    }

    /**
     * @return the assessorApproved
     */
    public Boolean getAssessorApproved() {
        return assessorApproved;
    }

    /**
     * @return the delegateApproved
     */
    public Boolean getDelegateApproved() {
        return delegateApproved;
    }

    /**
     * @return the requestCompletion
     */
    public Boolean getRequestCompletion() {
        return requestCompletion;
    }

    /**
     * @return the option
     */
    public Option getOption() {
        return option;
    }

    /**
     * @return the status
     */
    public Status getStatus() {
        return status;
    }

    /**
     * @return the claimType
     */
    public ClaimType getClaimType() {
        return claimType;
    }

    /**
     * @param claimID the claimID to set
     */
    public void setClaimID(Integer claimID) {
        this.claimID = claimID;
    }

    /**
     * @param studentID the studentID to set
     */
    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    /**
     * @param campusID the campusID to set
     */
    public void setCampusID(String campusID) {
        this.campusID = campusID;
    }

    /**
     * @param courseID the courseID to set
     */
    public void setCourseID(String courseID) {
        this.courseID = courseID;
    }

    /**
     * @param disciplineID the disciplineID to set
     */
    public void setDisciplineID(Integer disciplineID) {
        this.disciplineID = disciplineID;
    }

    /**
     * @param assessorID the assessorID to set
     */
    public void setAssessorID(String assessorID) {
        this.assessorID = assessorID;
    }

    /**
     * @param delegateID the delegateID to set
     */
    public void setDelegateID(String delegateID) {
        this.delegateID = delegateID;
    }

    /**
     * @param claimedModules the claimedModules to set
     */
    public void setClaimedModules(ArrayList<ClaimedModule> claimedModules) {
        this.claimedModules = claimedModules;
    }

    /**
     * @param campus the campus to set
     */
    public void setCampus(Campus campus) {
        this.campus = campus;
    }

    /**
     * @param discipline the discipline to set
     */
    public void setDiscipline(Discipline discipline) {
        this.discipline = discipline;
    }

    /**
     * @param course the course to set
     */
    public void setCourse(Course course) {
        this.course = course;
    }

    /**
     * @param assessor the assessor to set
     */
    public void setAssessor(User assessor) {
        this.assessor = assessor;
    }

    /**
     * @param delegate the delegate to set
     */
    public void setDelegate(User delegate) {
        this.delegate = delegate;
    }

    /**
     * @param dateMade the dateMade to set
     */
    public void setDateMade(Date dateMade) {
        this.dateMade = dateMade;
    }

    /**
     * @param dateResolved the dateResolved to set
     */
    public void setDateResolved(Date dateResolved) {
        this.dateResolved = dateResolved;
    }

    /**
     * @param assessorApproved the assessorApproved to set
     */
    public void setAssessorApproved(Boolean assessorApproved) {
        this.assessorApproved = assessorApproved;
    }

    /**
     * @param delegateApproved the delegateApproved to set
     */
    public void setDelegateApproved(Boolean delegateApproved) {
        this.delegateApproved = delegateApproved;
    }

    /**
     * @param requestCompletion the requestCompletion to set
     */
    public void setRequestCompletion(Boolean requestCompletion) {
        this.requestCompletion = requestCompletion;
    }

    /**
     * @param option the option to set
     */
    public void setOption(Option option) {
        this.option = option;
    }

    /**
     * @param status the status to set
     */
    public void setStatus(Status status) {
        this.status = status;
    }

    /**
     * @param claimType the claimType to set
     */
    public void setClaimType(ClaimType claimType) {
        this.claimType = claimType;
    }
}
