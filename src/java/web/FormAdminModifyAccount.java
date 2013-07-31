package web;

import util.RPLServlet;

/**
 * Has constants for the jsp that allows admin users to 
 * modify user accounts.
 * @author Adam Shortall
 */
public class FormAdminModifyAccount extends Form {
    public static final String NAME = "adminModifyAccountForm";
    public static final String ACTION = RPLServlet.ADMIN_MODIFY_ACCOUNT.absoluteAddress;
    
    public static final String IS_ADMIN = "isAdmin";
    public static final String USER_ID = "userID";
    public static final String F_NAME = "firstName";
    public static final String L_NAME = "lastName";
    public static final String RESET_PW = "resetPW";
    
    public static final String errID = "errID";
    public static final String errFName = "errFName";
    public static final String errLName = "errLName";
    public static final String errUniqueID = "errUniqueID";
    
    public static final String passwordReset = "passwordReset";
}