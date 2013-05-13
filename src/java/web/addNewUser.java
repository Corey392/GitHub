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
import javax.servlet.SingleThreadModel;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.FieldError;
import util.RPLError;
import util.RPLPage;

/** @author     Adam Shortall, Todd Wiggins
 *  @version    1.11
 *	Created:    ?
 *	Modified:   10/04/2013
 *	Change Log: 1.10: TW: Added meaningful location to exception messages. Made changes to actually allow a user to register with the updates.
 *				1.11: TW: Added remaining input fields from form into the 'student' variable. Validates the user has agreed to T&C and Privacy policy.
 *                              1.12: RD: Modified to only be accesible by admins to registers teachers and other admins to  to register
 *	Purpose:                Sends user to the student registration page. When
 *				a user has attempted to register there, this servlet
 *				receives the form data and attempts to create a
 *				student in the database.
 */
public class addNewUser extends HttpServlet implements SingleThreadModel {

    HttpSession session;
    String url;
    User Teacher;

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
        Teacher = new User();
        try {
            url = RPLPage.REGISTER_USER.relativeAddress; // Address of next jsp to load, by default return the register page, if successful change URL
            session = request.getSession();
            session.setAttribute("user", Teacher);
            // Check to see if there is any form data, then validate:
            request = this.registerStudent(request);

            session.setAttribute("user", Teacher);
            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        } catch(Exception e) {
            System.out.println("RegisterServlet: processRequest: Exception: "+e.getMessage());
        } finally {
            out.close();
        }
    }

    /**
     * Registers a student user with the database. Will set
     * error messages in the request and return the request.
     * @param request
     * @return
     */
	private HttpServletRequest registerStudent(HttpServletRequest request) {
		if (request.getParameter("userID") != null && request.getParameter("role") != null) {
			String passwordConfirm;
			Teacher = (User) session.getAttribute("user");
			if (Teacher == null) {
				Teacher = new User(Role.roleFromChar(request.getParameter("role").charAt(0)));
			}
			Teacher.setUserID(request.getParameter("userID"));
			Teacher.setStudentID(request.getParameter("userID"));
			Teacher.setFirstName(request.getParameter("firstName"));
			Teacher.setOtherName(request.getParameter("otherName"));
			Teacher.setLastName(request.getParameter("lastName"));
			Teacher.setEmail(request.getParameter("email"));
			Teacher.setAddress(request.getParameter("address1"),request.getParameter("address2"));
			Teacher.setTown(request.getParameter("town"));
			Teacher.setState(request.getParameter("state"));
			Teacher.setPostCode(Integer.parseInt(request.getParameter("postCode")));
			Teacher.setPhoneNumber(request.getParameter("phone"));
			Teacher.setPassword(request.getParameter("password"));
			passwordConfirm = request.getParameter("passwordConfirm");
			Teacher.setStaff(request.getParameter("staff") != null && request.getParameter("staff").equals("yes") ? true : false);
			boolean isValid = true;
			if (!Teacher.validateField(User.Field.EMAIL)) {
				request.setAttribute("emailError", new RPLError(FieldError.STUDENT_EMAIL));
				isValid = false;
			}
			if (!Teacher.validateField(User.Field.USER_ID)) {
				request.setAttribute("userIDError", new RPLError(FieldError.STUDENT_ID));
				isValid = false;
			}
			if (!Teacher.validateField(User.Field.FIRST_NAME)) {
				request.setAttribute("firstNameError", new RPLError(FieldError.NAME));
				isValid = false;
			}
			if (!Teacher.validateField(User.Field.LAST_NAME)) {
				request.setAttribute("lastNameError", new RPLError(FieldError.NAME));
				isValid = false;
			}
			if ((request.getParameter("acceptTerms") == null || !request.getParameter("acceptTerms").equals("yes")) && (request.getParameter("acceptPrivacy") == null || !request.getParameter("acceptPrivacy").equals("yes"))) {
				request.setAttribute("termsAndCondError", new RPLError(FieldError.TERMS_AND_COND));
				isValid = false;
			}
			if(isValid) {
				try {
					new UserIO(Teacher.role).insert(Teacher);
					Teacher.logIn();
					url = RPLPage.REGISTER_CONFIRM.relativeAddress;
				} catch (SQLException e) {
					System.out.println("RegisterServlet: registerStudent: SQLException: "+e.getMessage());
					if (e.getSQLState().equals(PostgreError.UNIQUE_VIOLATION.code)) {
						request.setAttribute("studentUniqueError", new RPLError(FieldError.STUDENT_UNIQUE));
					}
				} catch (Exception e) {
					System.out.println("RegisterServlet: registerStudent: Exception: "+e.getMessage());
				}
			}
                        
		}
        return request;
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
