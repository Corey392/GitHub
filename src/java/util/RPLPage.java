package util;

/**
 * Stores values for names and addresses of pages for
 * the RPL website.
 * @author Adam Shortall
 */
public enum RPLPage {
    HOME("RPL Homepage", "/index.jsp"),
    REGISTER("RPL Student Registration", "/studentRegister.jsp"),
    REGISTER_CONFIRM("RPL Registration Confirmed", "/students/registerConfirm.jsp"),
	RESET_PASSWORD("Reset Password", "/resetPassword.jsp"),//Added by: Todd Wiggins
    STUDENT_HOME("Student Homepage", "/students/index.jsp"),
    CREATE_CLAIM("Create Claim", "/students/createClaim.jsp"),
    REVIEW_CLAIM_PREV("Review Claim", "/students/reviewClaimPrev.jsp"),
    REVIEW_CLAIM_RPL("Review Claim", "/students/reviewClaimRPL.jsp"),
    ADD_RPL_EVIDENCE("Add Evidence", "/students/addRPLEvidence.jsp"),
    CLERICAL_HOME("Clerical Home Page", "/maintenance/index.jsp"),
    TEACHER_HOME("Teacher Home Page", "/teachers/index.jsp"),
    ADMIN_HOME("Admin Home page", "/admins/index.jsp"),
    LIST_CLAIMS_STUDENT("List Claims", "/students/listClaims.jsp"),
    LIST_CLAIMS_TEACHER("List Claims", "/teachers/listClaims.jsp"),
    CLERICAL_CAMPUS("Campus Table Maintenance", "/maintenance/campus.jsp"),
    CLERICAL_DISCIPLINE("Discipline Table Maintenance", "/maintenance/discipline.jsp"),
    CLERICAL_COURSE("Course Table Maintenance", "/maintenance/course.jsp"),
    CLERICAL_MODULE("Module Table Maintenance", "/maintenance/module.jsp"),
    ASSESS_CLAIM_PREV("Assess Claim", "/teachers/assessClaimPrev.jsp"),
    ASSESS_CLAIM_RPL("Assess Claim", "/teachers/assessClaimRPL.jsp"),
    VIEW_EVIDENCE_PAGE("View Evidence", "/teachers/viewEvidence.jsp"),
    CLERICAL_NEW_CAMPUS("Add Campus", "/maintenance/newCampus.jsp"),
    CLERICAL_COURSE_MODULES("Course Modules Maintenance", "/maintenance/courseModules.jsp"),
    CLERICAL_CAMPUS_DISCIPLINE("Assign Disciplines to Campus", "/maintenance/campusDiscipline.jsp"),
    CLERICAL_DISCIPLINE_COURSES("Add Courses to Discipline", "/maintenance/disciplineCourses.jsp"),
    CLERICAL_CORE_MODULES("Add Core Modules", "/maintenance/coreModules.jsp"),
    CLERICAL_COURSE_ELECTIVES("Add Electives to Course", "/maintenance/courseElectives.jsp"),
    MAINTAIN_MODULE_ELEMENTS("Add Elements to Module", "/maintenance/moduleElements.jsp"),
    MAINTAIN_ELEMENT_CRITERIA("Add Criteria to Element", "/maintenance/elementCriteria.jsp"),
    MODIFY_COURSE("Modify Course", "/admins/modifyCourse.jsp"),
    EVIDENCE_UPDATED_PAGE("Evidence Updated","/teachers/evidenceUpdated.jsp"),
    ADMIN_ADD_USER("Add User Account", "/admins/addTeacherAccount.jsp"),
    ADMIN_MODIFY_USER("Modify User Account", "/admins/modifyAccount.jsp"),
    ADMIN_LIST_USERS("Modify a User Account", "/admins/listAccounts.jsp"),
    TEACHER_LIST_CLAIM_RECORDS("View Claim Status", "/teachers/listClaimRecords.jsp"),  // Kyoungho Lee
    STUDENT_LIST_CLAIM_RECORDS("View Claim Status", "/students/listClaimRecords.jsp"),   // Kyoungho Lee
    LIST_ERRORS("View Errors", "/admins/listErrors.jsp"),  // Kyoungho Lee
    ADMIN_ACCESS_HISTORY("View Access History", "/admins/accessHistory.jsp"),  // Ben
    TERMS_AND_CONDITIONS("Terms And Conditions", "/legal/terms.jsp"),//Added by: Todd Wiggins
	PRIVACY_POLICY("Privacy Policy", "/legal/privacy.jsp");//Added by: Todd Wiggins

    /** The name of the website, should match the name of the directory on the server. */
    public final static String ROOT = "/RPL2013";
    public final static String URL = "rpl.cccit.info";

    public final String title;
    public final String absoluteAddress;
    public final String relativeAddress;

    /**
     * Used for servlets and fragments to store addresses.
     * @param relativeAddress address relative to ROOT, beginning with a slash.
     */
    RPLPage(String relativeAddress) {
        this("", relativeAddress);
    }

    /**
     * Used for jsp pages. Has a title as well as an address.
     * @param title The page title.
     * @param relativeAddress address relative to ROOT, beginning with a slash.
     */
    RPLPage(String title, String relativeAddress) {
        this.title = title;
        this.relativeAddress = relativeAddress;
        this.absoluteAddress = ROOT + relativeAddress;
    }

    /** @return The absolute address. */
    @Override
    public String toString() {
        return this.absoluteAddress;
    }
}
