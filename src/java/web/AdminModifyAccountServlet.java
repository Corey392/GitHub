/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import data.PostgreError;
import data.UserIO;
import domain.User;
import domain.User.Role;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.FieldError;
import util.RPLError;
import util.RPLPage;
import util.RPLServlet;

/**
 * Handles the page that modifies a non-student account.
 * 
 * @author Adam Shortall
 */
public class AdminModifyAccountServlet extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String url = RPLPage.ADMIN_MODIFY_USER.relativeAddress;
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            User selectedUser = (User) session.getAttribute("selectedUser");
            User modifiedUser = null;
            UserIO userIO = new UserIO(user.role);
            String oldUserID = selectedUser.getUserID();
            
            // Get user inputs:
            String newUserID = request.getParameter(FormAdminModifyAccount.USER_ID);
            String newFName = request.getParameter(FormAdminModifyAccount.F_NAME);
            String newLName = request.getParameter(FormAdminModifyAccount.L_NAME);
            String isAdmin = request.getParameter(FormAdminModifyAccount.IS_ADMIN);
            String resetPW = request.getParameter(FormAdminModifyAccount.RESET_PW);
            String submit = request.getParameter(FormAdminModifyAccount.SUBMIT);
            String cancel = request.getParameter(FormAdminModifyAccount.CANCEL);
            
            // Event handling:
            boolean isValid = true;
            if (submit != null && selectedUser != null) {
                selectedUser.setUserID(newUserID);
                if (!selectedUser.validateField(User.Field.USER_ID)) {
                    request.setAttribute(FormAdminModifyAccount.errID, new RPLError(FieldError.TEACHER_ID));
                    isValid = false;
                }
                selectedUser.setFirstName(newFName);
                if (selectedUser.validateField(User.Field.FIRST_NAME)) {
                    request.setAttribute(FormAdminModifyAccount.errFName, new RPLError(FieldError.NAME));
                    isValid = false;
                }
                selectedUser.setLastName(newLName);
                if (selectedUser.validateField(User.Field.LAST_NAME)) {
                    request.setAttribute(FormAdminModifyAccount.errLName, new RPLError(FieldError.NAME));
                    isValid = false;
                }
                if (isAdmin != null) {
                    if (selectedUser.role != Role.ADMIN) {
                        modifiedUser = new User(newUserID, newFName, newLName, newUserID, Role.ADMIN);
                    }
                } else {
                    modifiedUser = new User(newUserID, newFName, newLName, newUserID, Role.TEACHER);
                }
                if (resetPW != null) {
                modifiedUser.setPassword(userIO.resetPassword(oldUserID));
                request.setAttribute(FormAdminModifyAccount.passwordReset, new RPLError(
                    "New password for user: " + modifiedUser.getPassword() + "<br/>"
                    + "<a href=\"mailto:" + modifiedUser.getEmail() + "?Subject=Your RPL Account"
                    + "&body=Your RPL account has been modified. %0A%0A"
                    + "Your user id: " + modifiedUser.getUserID() + "%0A"
                    + "Your password: " + modifiedUser.getPassword() + "%0A%0A"
                    + "You should change your password on the system after you log in.%0A"
                    + "Log in here: " + RPLPage.URL + "\">"
                    + "Send email with account details</a>"));
                }
                try {
                    userIO.update(modifiedUser, oldUserID);
                } catch (SQLException ex) {
                    if (ex.getSQLState().equals(PostgreError.UNIQUE_VIOLATION.code)) {
                        request.setAttribute(FormAdminModifyAccount.errUniqueID, new RPLError(FieldError.TEACHER_UNIQUE));
                    }
                    Logger.getLogger(AdminModifyAccountServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else if (cancel != null) {
                url = RPLServlet.ADMIN_LIST_ACCOUNTS.relativeAddress;
                session.removeAttribute("selectedUser");
            } else if (selectedUser == null) {
                url = RPLServlet.ADMIN_LIST_ACCOUNTS.relativeAddress;
            }

            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        } finally {            
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
