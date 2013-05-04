package web;

import data.UserIO;
import domain.User;
import domain.User.Role;
import java.io.IOException;
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

/** @author     Todd Wiggins
 *  @version    1.00
 *	Created:    11/04/2013
 *	Modified:
 *	Change Log:
 *	Purpose:    Processes a request to reset a users password and sends the new password to the users email address.
 */
public class ResetPasswordServlet extends HttpServlet implements SingleThreadModel {

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
        try {
            url = RPLPage.RESET_PASSWORD.relativeAddress; // Address of next jsp to load
            // Check to see if there is any form data, then validate:

			String userID;
			if (request.getParameter("userID").length() > 0) {
				userID = request.getParameter("userID");
			} else {	//Will use the email address.
				userID = request.getParameter("email");
			}
			if (userID.length() > 0) {
				UserIO userIO = new UserIO(Role.STUDENT);
				//Test to ensure user exists. Need to do this as the reset password function will complete without errors if the user does not exist.
				String email = userIO.validateUserIdOrEmail(userID);
				if (email.length() > 0) {
					//Reset their password
					String newPassword = userIO.resetPassword(userID);

					//TODO: Send new password via email to user for security reasons.
					request.setAttribute("status", new RPLError(FieldError.RESET_SENT));
					System.out.println("New Password: "+newPassword+" (For User: "+email+")");
				} else {
					request.setAttribute("status", new RPLError(FieldError.RESET_FAILED));
				}
			} else {
				request.setAttribute("status", new RPLError(FieldError.RESET_FAILED));
			}

            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        } catch(Exception e) {
            System.out.println("ResetPasswordServlet: processRequest: Exception: "+e.getMessage());
			e.getStackTrace();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods.">
    /**Handles the HTTP <code>GET</code> method.
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

    /**Handles the HTTP <code>POST</code> method.
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
}