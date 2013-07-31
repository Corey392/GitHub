package web;

import util.RPLServlet;

/**
 * Used for constants that name parts of a form for
 * registering new teacher accounts.
 * @author Adam Shortall
 */
public class FormAddTeacher extends Form {
    public static final String NAME = "addTeacherForm";
    public static final String ACTION = RPLServlet.ADD_TEACHER.absoluteAddress;
   
    public static final String TEACHER_ID = "teacherID";
    public static final String F_NAME = "firstName";
    public static final String L_NAME = "lastName";
    
    public static final String ROLE = "newUserRole";
    
    public static final String errFirstName = "errFirstName";
    public static final String errLastName = "errLastName";
    public static final String errID = "errID";
    public static final String errUnique = "errUnique";
    public static final String errPassword = "errPassword";
    
    public static final String adminRole = "adminRole";
    public static final String teacherRole = "teacherRole";
    public static final String clericalRole = "clericalRole";
    
    public static final String confirmSuccess = "confirmSuccess";
}