/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import data.UserIO;
import domain.User;
import domain.User.Role;
import domain.User.Status;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.RPLError;
import util.RPLPage;
import domain.AccessHistory;
import data.AccessHistoryIO;
import java.sql.SQLException;

/**
 * A user can invoke this from the home page. It gets the username and
 * password from the text field inputs and checks with the database
 * to tell whether there is a matching user with matching password. The
 * user is directed to the homepage for the type of user they are (students
 * go to student page, etc.) 
 * @author Adam Shortall, Updated by Ben Morrison
 */
public class LoginServlet extends HttpServlet {

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
            HttpSession session = request.getSession(true);
            User user = (User) session.getAttribute("user");
            
            String url = RPLPage.HOME.relativeAddress;
            String userID;
            String password;
            
            if (user == null) { 
                user = new User();
                session.setAttribute("user", user);
            }
            
            if (user.getStatus() == Status.LOGGED_IN) { // Logged in users should not see the home page
                url = this.getURL(user.role);
            } else { // User has not logged in
                userID = request.getParameter("userID");
                password = request.getParameter("password");
                
                if (userID != null) {   // Tests that user has attempted to log in
                    try {
                        System.out.println("before");
                        user = this.logInUser(user, userID, password, session);
                        System.out.println("after");
                        url = this.getURL(user.role);
                    } catch (IllegalArgumentException e) {
                        RPLError loginError = new RPLError("Username and/or password incorrect");
                        request.setAttribute("loginError", loginError);
                    }
                }
            }
            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }finally {            
            out.close();
        }
    }
    
    /**
     * Helper method to log in a user.
     * @param request
     * @return 
     */
    private User logInUser(User user, String userID, String password, HttpSession session) {
        user.setUserID(userID);
        user.setPassword(password);
        UserIO userIO = new UserIO(user.role);
        Role verifiedUserRole = userIO.verifyLogin(user);
        if (verifiedUserRole != null) {
            userIO = new UserIO(verifiedUserRole);            
            user = userIO.getByID(userID);
            
            user.logIn();
           
            session.setAttribute("user", user);
            
            /*try {
                AccessHistoryIO accessIO = new AccessHistoryIO(user.role); // Ben Morrison
                accessIO.insert(user.getUserID(), "I");
            } catch(SQLException e) { System.out.println("Database Error..."); }*/
            
            return user;
        } else { // User has entered an incorrect username or password
            throw new IllegalArgumentException();
        }
    }
    
    /**
     * For a given role, returns the URL of the homepage for that role.
     * @param userRole
     * @return 
     */
    private String getURL(Role userRole) {
        switch (userRole) {
            case ADMIN:
                return RPLPage.ADMIN_HOME.relativeAddress;
            case CLERICAL:
                return RPLPage.CLERICAL_HOME.relativeAddress;
            case STUDENT:
                return RPLPage.STUDENT_HOME.relativeAddress;
            case TEACHER:
                return RPLPage.TEACHER_HOME.relativeAddress;
            default:
                throw new IllegalArgumentException("Invalid role returned "
                        + "from db.verifyLogin(user) in LoginServlet");
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
