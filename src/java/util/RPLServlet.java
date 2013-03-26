/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

/**
 * Servlet urls are stored here.
 * 
 * @author Adam Shortall
 */
public enum RPLServlet {
    ADD_TEACHER("/admins/addTeacher?" + web.FormAddTeacher.ROLE + "=" + web.FormAddTeacher.teacherRole),
    ADD_ADMIN("/admins/addTeacher?" + web.FormAddTeacher.ROLE + "=" + web.FormAddTeacher.adminRole),
    ADD_CLERICAL("/admins/addTeacher?" + web.FormAddTeacher.ROLE + "=" + web.FormAddTeacher.clericalRole),
    MAINTAIN_ELEMENT_CRITERIA_SERVLET("/maintenance/elementCriteria"),
    REGISTER_SERVLET("/register"),
    CREATE_CLAIM_SERVLET("/students/createClaim"),
    UPDATE_PREV_CLAIM_SERVLET("/students/updatePrevClaim"),
    UPDATE_RPL_CLAIM_SERVLET("/students/updateRPLClaim"),
    ADD_EVIDENCE_SERVLET("/students/addEvidence"),
    LOGIN_SERVLET("/home"),
    LIST_CLAIMS_STUDENT_SERVLET("/students/listClaims"),
    ASSESS_CLAIM_RPL_SERVLET("/teachers/AssessRPLClaim"),
    VIEW_TEACHER_CLAIM_SERVLET("/teachers/ViewTeacherClaims"),
    VIEW_EVIDENCE_SERVLET("/teachers/ViewEvidence"),
    MAINTAIN_TABLE_SERVLET("/maintenance/maintainTable"),
    LOGOUT_SERVLET("/logout"),
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
    ADMIN_LIST_ACCOUNTS("/admins/listAccounts"),
    ADMIN_MODIFY_ACCOUNT("/admins/modifyAccount"),
    ADMIN_LIST_UNASSIGNED_CLAIMS("/admins/listUnassignedClaims"),
    STUDENT_LIST_CLAIM_RECORDS("/students/listClaimRecords"), // Kyoungho Lee
    TEACHER_LIST_CLAIM_RECORDS("/teachers/listClaimRecords"), // Kyoungho Lee  
    LIST_ERRORS("/admin/listErrors"); // Kyoungho Lee
    
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
