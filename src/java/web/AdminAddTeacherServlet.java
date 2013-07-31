package web;

import data.PostgreError;
import data.UserIO;
import domain.User;
import domain.User.Role;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.FieldError;
import util.RPLError;
import util.RPLPage;

/**
 * Gets user data from the 'add teacher account' page, adds a teacher
 * user and/or sets what the page should display, or directs to a 
 * confirmation page. Also handles adding clerical and admin users.
 * 
 * @author Adam Shortall
 */
public class AdminAddTeacherServlet extends HttpServlet {

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
            String url = RPLPage.ADMIN_ADD_USER.relativeAddress;
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            User newUser = (User) session.getAttribute("newUser");
            
            // This page can add teachers, clerical users and admin users,
            // the role is set via a request attribute:
            String role = request.getParameter(FormAddTeacher.ROLE);
            
            // Check whether teacher has been previously set, if not set
            // from the role that was selected by the user
            if (role != null) {   
                if (role.equals(FormAddTeacher.adminRole)) {
                    newUser = new User(Role.ADMIN);
                } else if (role.equals(FormAddTeacher.clericalRole)) {
                    newUser = new User(Role.CLERICAL);
                } else if (role.equals(FormAddTeacher.teacherRole)) {
                    newUser = new User(Role.TEACHER);
                }
                session.setAttribute("newUser", newUser);
            } else {
                url = RPLPage.ADMIN_HOME.relativeAddress;
            }
            
            // Get user input:
            String teacherID = request.getParameter(FormAddTeacher.TEACHER_ID);
            String firstName = request.getParameter(FormAddTeacher.F_NAME);
            String lastName = request.getParameter(FormAddTeacher.L_NAME);
            String cancel = request.getParameter(FormAddTeacher.CANCEL);
            String submit = request.getParameter(FormAddTeacher.SUBMIT);
            
            // Set teacher object with values:
            newUser.setEmail(teacherID);
            newUser.setUserID(teacherID);
            newUser.setFirstName(firstName);
            newUser.setLastName(lastName);            
            
            // Event handling:
            if (cancel != null) {
                url = RPLPage.ADMIN_HOME.relativeAddress;
            } else if (submit != null) {
                // Validate teacher account details:
                boolean isValid = true;
                
                if (!newUser.validateField(User.Field.USER_ID)) {
                    request.setAttribute(FormAddTeacher.errID, new RPLError(FieldError.TEACHER_ID));
                    isValid = false;
                }
                if (newUser.role != Role.CLERICAL && !newUser.validateField(User.Field.FIRST_NAME)) {
                    request.setAttribute(FormAddTeacher.errFirstName, new RPLError(FieldError.NAME));
                    isValid = false;
                }
                if (newUser.role != Role.CLERICAL && !newUser.validateField(User.Field.LAST_NAME)) {
                    request.setAttribute(FormAddTeacher.errLastName, new RPLError(FieldError.NAME));
                    isValid = false;
                }
                
                // If all data entered is valid, enter user account into database:
                if (isValid) {
                    UserIO userIO = new UserIO(user.role);
                    try {
                        userIO.insert(newUser);
                        // Confirmation message has a mailto link that creates an email with details about
                        // the teacher's/clerical user's newly created account:
                        request.setAttribute(FormAddTeacher.confirmSuccess, new RPLError(
                                "Successfully added user with password: " + newUser.getPassword() + "<br/>"
                                + "<a href=\"mailto:" + newUser.getEmail() + "?Subject=Your RPL Account"
                                + "&body=An account has been created for you for the RPL system. %0A%0A"
                                + "Your user id: " + newUser.getUserID() + "%0A"
                                + "Your password: " + newUser.getPassword() + "%0A%0A"
                                + "You should change your password on the system after you log in.%0A"
                                + "Log in here: " + RPLPage.URL + "\">"
                                + "Send email with account details</a>"));
                        session.setAttribute("newUser", new User(newUser.role)); // Reset session to forget teacher values that have been entered
                    } catch (SQLException ex) {
                        if (ex.getSQLState().equals(PostgreError.UNIQUE_VIOLATION.code)) {
                            request.setAttribute(FormAddTeacher.errUnique, new RPLError(FieldError.TEACHER_UNIQUE));
                        } else {
                            System.err.println(ex.getMessage());
                        }
                    }
                }
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