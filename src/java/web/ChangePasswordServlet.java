package web;

import data.UserIO;
import domain.User;
import domain.User.Role;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.FieldError;
import util.RPLError;
import util.RPLPage;

/**@author     Todd Wiggins
 * @version    1.00
 * Created:    12/04/2013
 * Modified:
 * Change Log:
 * Purpose:    Processes a change password request for all user types.
 */
public class ChangePasswordServlet extends HttpServlet {
	/**Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
	 * @param request  servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		String url = RPLPage.CHANGE_PW.relativeAddress;

		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");
		if (user.getUserID().length() > 0) {	//Checks if not logged in and has submitted form.
			if (request.getParameter("password").length() > 0) {	//Checks if old password was supplied.
				user.setPassword(request.getParameter("password")); //Existing Password
				String newPW = request.getParameter("passwordNew");
				String confirmNewPW = request.getParameter("passwordConfirm");

				if (newPW.equals(confirmNewPW)) {
					User temp = new User(Role.STUDENT);
					temp.setPassword(newPW);
					if (!user.validateField(User.Field.PASSWORD)) {	//Validate new PW
						request.setAttribute("passwordNewError", new RPLError(FieldError.PASSWORD_COMPLEXITY));
					} else {
						try {
							UserIO userIO = new UserIO(user.getRole());
							if (userIO.changePassword(user, newPW)) {
								request.setAttribute("successfulMSG", new RPLError(FieldError.SUCCESSFUL_UPDATE));
								user.setPassword(newPW);
							} else {
								request.setAttribute("passwordError", new RPLError(FieldError.PASSWORD_INCORRECT));
							}
						} catch (Exception e) {
							System.out.println("UpdateStudentServlet: processRequest: Exception: "+e.getMessage());
						}
					}
				} else {
					request.setAttribute("passwordConfirmError", new RPLError(FieldError.PASSWORD_CONFIRM));
				}
			} else {
				request.setAttribute("passwordError", new RPLError(FieldError.PASSWORD_INCORRECT));
			}
		} else {
			url = RPLPage.HOME.relativeAddress;
		}

        RequestDispatcher dispatcher = request.getRequestDispatcher(url);
        dispatcher.forward(request, response);
	}

	// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
	/**Handles the HTTP<code>GET</code> method.
	 * @param request  servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processRequest(request, response);
	}

	/**Handles the HTTP<code>POST</code> method.
	 * @param request  servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processRequest(request, response);
	}

	/**Returns a short description of the servlet.
	 * @return a String containing servlet description
	 */
	@Override
	public String getServletInfo() {
		return "Change Password [All User Types]";
	}// </editor-fold>
}