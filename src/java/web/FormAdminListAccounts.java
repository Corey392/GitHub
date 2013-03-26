/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import util.RPLServlet;

/**
 * Constants for the form that handles the list of accounts 
 * for the Admin level users to select from.
 * 
 * @author Adam Shortall
 */
public class FormAdminListAccounts extends Form {
    public static final String NAME = "listAccountsForm";
    public static final String ACTION = RPLServlet.ADMIN_LIST_ACCOUNTS.absoluteAddress;
    
    public static final String selectedAccountID = "selectedAccountID";
}
