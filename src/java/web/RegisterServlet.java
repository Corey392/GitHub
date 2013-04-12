package web;

import data.PostgreError;
import data.UserIO;
import domain.User;
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
 *	Purpose:    Sends user to the student registration page. When
 *				a user has attempted to register there, this servlet
 *				receives the form data and attempts to create a
 *				student in the database.
 */
public class RegisterServlet extends HttpServlet implements SingleThreadModel {

	HttpSession session;
    String url;
    User student;

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
        student = new User();
        try {
            url = RPLPage.REGISTER.relativeAddress; // Address of next jsp to load, by default return the register page, if successful change URL
            session = request.getSession();
            // Check to see if there is any form data, then validate:
            request = this.registerStudent(request);

            session.setAttribute("user", student);
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
		if (request.getParameter("userID") != null) {
			String passwordConfirm;
			student = (User) session.getAttribute("user");
			if (student == null) {
				student = new User();
			}
			student.setUserID(request.getParameter("userID"));
			student.setStudentID(request.getParameter("userID"));
			student.setFirstName(request.getParameter("firstName"));
			student.setOtherName(request.getParameter("otherName"));
			student.setLastName(request.getParameter("lastName"));
			student.setEmail(request.getParameter("email"));
			student.setAddress(request.getParameter("address1"),request.getParameter("address2"));
			student.setTown(request.getParameter("town"));
			student.setState(request.getParameter("state"));
			student.setPostCode(Integer.parseInt(request.getParameter("postCode")));
			student.setPhoneNumber(request.getParameter("phone"));
			student.setPassword(request.getParameter("password"));
			passwordConfirm = request.getParameter("passwordConfirm");
			student.setStaff(request.getParameter("staff") != null && request.getParameter("staff").equals("yes") ? true : false);
			boolean isValid = true;
			if (!student.validateField(User.Field.EMAIL)) {
				request.setAttribute("emailError", new RPLError(FieldError.STUDENT_EMAIL));
				isValid = false;
			}
			if (!student.validateField(User.Field.USER_ID)) {
				request.setAttribute("userIDError", new RPLError(FieldError.STUDENT_ID));
				isValid = false;
			}
			if (!student.validateField(User.Field.FIRST_NAME)) {
				request.setAttribute("firstNameError", new RPLError(FieldError.NAME));
				isValid = false;
			}
			if (!student.validateField(User.Field.LAST_NAME)) {
				request.setAttribute("lastNameError", new RPLError(FieldError.NAME));
				isValid = false;
			}
			if (!student.validateField(User.Field.PASSWORD)) {
				request.setAttribute("passwordError", new RPLError(FieldError.PASSWORD_COMPLEXITY));
				isValid = false;
			}
			if (!student.getPassword().equals(passwordConfirm)) {
				request.setAttribute("passwordConfirmError", new RPLError(FieldError.PASSWORD_CONFIRM));
				isValid = false;
			}
			if ((request.getParameter("acceptTerms") == null || !request.getParameter("acceptTerms").equals("yes")) && (request.getParameter("acceptPrivacy") == null || !request.getParameter("acceptPrivacy").equals("yes"))) {
				request.setAttribute("termsAndCondError", new RPLError(FieldError.TERMS_AND_COND));
				isValid = false;
			}
			if(isValid) {
				try {
					new UserIO(student.role).insert(student);
					student.logIn();
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
