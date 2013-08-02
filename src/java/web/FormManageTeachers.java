/*
 * This package contains all servlets
 */
package web;

import util.RPLServlet;

/**
 * @author Vince Lombardo
 * Document   : manageTeachers
 * Purpose    : allows delegate users to set which assessors can assess specific displine
 * Created on : 02/08/2013, 8:27:03 PM
 * 
 */
public class FormManageTeachers extends Form {
    public static final String NAME = "adminManageTeachersForm";
    public static final String ACTION = RPLServlet.ADMIN_MANAGE_TEACHERS_SERVLET.absoluteAddress;
    
    
}
