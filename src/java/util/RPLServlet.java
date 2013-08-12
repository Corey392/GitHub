package util;

/**
 * @author Adam Shortall, Kyoungho Lee, Bryce Carr, Todd Wiggins, Vince Lombardo
 * @version 1.032
 * <b>Created:</b>  Unknown<br/>
 * <b>Modified:</b> 07/05/2013<br/>
 * <b>Change Log:</b>  22/04/2013:  Bryce Carr: Re-ordered enums for servlet URLs in a more logical fashion.<br/>
 *                          24/04/2013: Bryce Carr: Added header comments to match code conventions.<br/>
 *		            07/05/2013:	Bryce Carr: Added RPLServlet field for Provider maintenance servlet.
 *		            08/05/2013:	TW: Added RPLServlet field for ADD_EVIDENCE_PREV.
 *		            12/05/2013:	TW: Added RPLServlet field for ATTACH_EVIDENCE_.
 *                          1/08/2013:	VL: Added RPLServlet field for DELEGATE_ASSIGN_ASSESSOR_SERVLET.
 *                          3/08/2013:	VL: Added RPLServlet field for DELEGATE_ASSESS_APPROVE_CLAIM_SERVLET.
 *                          3/08/2013:	VL: Added RPLServlet field for ADMIN_MANAGE_TEACHERS_SERVLET.
 * <b>Purpose:</b>  Servlet urls are stored here.
 */
public enum RPLServlet {
    /* Non-Specific Servlets */
    LOGIN_SERVLET("/home"),
    LOGOUT_SERVLET("/logout"),
    REGISTER_SERVLET("/register"),
    /* Clerical Admin Servlets */
    ADD_ADMIN("/admins/addTeacher?" + web.FormAddTeacher.ROLE + "=" + web.FormAddTeacher.adminRole),
    ADD_CLERICAL("/admins/addTeacher?" + web.FormAddTeacher.ROLE + "=" + web.FormAddTeacher.clericalRole),
    ADD_TEACHER("/admins/addTeacher?" + web.FormAddTeacher.ROLE + "=" + web.FormAddTeacher.teacherRole),
    ADMIN_LIST_ACCOUNTS("/admins/listAccounts"),
    LIST_ERRORS("/admins/listErrors"), // Kyoungho Lee
    ADMIN_LIST_UNASSIGNED_CLAIMS("/admins/listUnassignedClaims"),
    ADMIN_MODIFY_ACCOUNT("/admins/modifyAccount"),
    ADMIN_MANAGE_TEACHERS_SERVLET("/maintenance/manageTeachers"), // Added by Vince Lombardo
    ADMIN_MANAGE_USERS_SERVLET("/maintenance/manageUsers"), // Added by Vince Lombardo
    MAINTAIN_ELEMENT_CRITERIA_SERVLET("/maintenance/elementCriteria"),
    MAINTAIN_CAMPUS_SERVLET("/maintenance/maintainCampus"),
    MAINTAIN_DISCIPLINE_SERVLET("/maintenance/maintainDiscipline"),
    MAINTAIN_COURSE_SERVLET("/maintenance/maintainCourse"),
    MAINTAIN_COURSE_MODULES_SERVLET("/maintenance/maintainCourseModules"),
    MAINTAIN_MODULE_SERVLET("/maintenance/maintainModule"),
    MAINTAIN_CAMPUS_DISCIPLINE_SERVLET("/maintenance/campusDiscipline"),
    MAINTAIN_DISCIPLINE_COURSES_SERVLET("/maintenance/disciplineCourses"),
    MAINTAIN_CORE_MODULES_SERVLET("/maintenance/coreModules"),
    MAINTAIN_COURSE_ELECTIVES_SERVLET("/maintenance/courseElectives"),
    MAINTAIN_MODULE_ELEMENTS_SERVLET("/maintenance/moduleElements"),
    MAINTAIN_PROVIDER_SERVLET("/maintenance/maintainProviders"),
    MAINTAIN_TABLE_SERVLET("/maintenance/maintainTable"),
    DELEGATE_ASSIGN_ASSESSOR_SERVLET("/admins/assignAssessors"), // Added by Vince Lombardo
    DELEGATE_ASSESS_APPROVE_CLAIM_SERVLET("/admins/assessApproveClaims"), // Added by Vince Lombardo    
    /* Student Servlets */
    ADD_EVIDENCE_SERVLET("/students/addEvidence"),
    ADD_EVIDENCE_PREV("/students/AddEvidencePrev"),//Added by: Todd Wiggins
    ATTACH_EVIDENCE("/students/attachEvidence"),//Added by: Todd Wiggins
    CREATE_CLAIM_SERVLET("/students/createClaim"),
    STUDENT_LIST_CLAIM_RECORDS("/students/listClaimRecords"), // Kyoungho Lee
    LIST_CLAIMS_STUDENT_SERVLET("/students/listClaims"),
    UPDATE_PREV_CLAIM_SERVLET("/students/updatePrevClaim"),
    UPDATE_RPL_CLAIM_SERVLET("/students/updateRPLClaim"),
    /* Teacher Servlets */
    ASSESS_CLAIM_RPL_SERVLET("/teachers/AssessRPLClaim"),
    TEACHER_LIST_CLAIM_RECORDS("/teachers/listClaimRecords"),
    VIEW_EVIDENCE_SERVLET("/teachers/ViewEvidence"),
    VIEW_TEACHER_CLAIM_SERVLET("/teachers/ViewTeacherClaims"), // Kyoungho Lee
    MAINTAIN_SERVLET("/maintenance/dataMaintenanceSelect"); // Vince Lombardo

    public final String relativeAddress;
    public final String absoluteAddress;

    RPLServlet(String relativeAddress) {
        this.relativeAddress = relativeAddress;
        this.absoluteAddress = RPLPage.ROOT + relativeAddress;
    }

    @Override
    public String toString() {
        return this.absoluteAddress;
    }
}
