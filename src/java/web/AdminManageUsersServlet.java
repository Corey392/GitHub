package web;

import data.UserIO;
import domain.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.RPLPage;
import util.Util;
/**
 * @author Vince Lombardo
 * @version 1.00
 * <b>Created:</b>  2/08/2013<br/>
 * <b>Modified:</b> <br/>
 * <b>Change Log:</b>1/08/2013:	VL: Added RPLServlet.
 * <b>Purpose:</b>  Loads list of assessors/teachers for the delegate. Responds to a delegate user selecting
 * a teacher from the list and which disciplines the assessor is eligible to assess
 */

public class AdminManageTeachersServlet extends HttpServlet {

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
            String url = RPLPage.ADMIN_MANAGE_TEACHERS.relativeAddress;
            HttpSession session = request.getSession();
//            User user = (User) session.getAttribute("user");
//            
//            UserIO userIO = new UserIO(user.role);
//            
//            // Get user input:
//            String selectedAccountID = Util.getPageStringID(request, FormAdminListAccounts.selectedAccountID);
//            String cancel = request.getParameter(Form.CANCEL); 
//            
//            // Set list of accounts:
//            ArrayList<User> accounts = userIO.getListOfTeacherAndAdminUsers();
//            Collections.sort(accounts);
//            request.setAttribute("accounts", accounts);
//            
//            // Event handling:
//            if (selectedAccountID != null) {
//                User selectedUser = userIO.getByID(selectedAccountID);
//                session.setAttribute("selectedUser", selectedUser);
//                url = RPLPage.ADMIN_MODIFY_USER.relativeAddress;
//            } else if (cancel != null) {
//                url = RPLPage.ADMIN_HOME.relativeAddress;
//            }
            
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