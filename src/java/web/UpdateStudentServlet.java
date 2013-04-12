package web;

import data.UserIO;
import domain.User;
import domain.User.Role;
import java.io.IOException;
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

/**@author     Todd Wiggins
 * @version    1.00
 * Created:    12/04/2013
 * Modified:
 * Change Log:
 * Purpose:    Processes the Update My Details form for Students.
 */
public class UpdateStudentServlet extends HttpServlet {
	/**Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
	 * @param request  servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		String url = RPLPage.STUDENT_DETAILS.relativeAddress;

		HttpSession session = request.getSession();
		User student = (User) session.getAttribute("user");
		String oldId = student.getUserID();

		if (request.getParameter("userID") != null) {
			student = (User) session.getAttribute("user");
			if (student == null) {
				student = new User();
			}
			student.setUserID(request.getParameter("userID"));
			student.setPassword(request.getParameter("password"));

			student.setStudentID(request.getParameter("userID"));
			student.setFirstName(request.getParameter("firstName"));
			student.setOtherName(request.getParameter("otherName"));
			student.setLastName(request.getParameter("lastName"));
			student.setAddress(request.getParameter("address1"),request.getParameter("address2"));
			student.setTown(request.getParameter("town"));
			student.setState(request.getParameter("state"));
			student.setPostCode(Integer.parseInt(request.getParameter("postCode")));
			student.setPhoneNumber(request.getParameter("phone"));
			student.setStaff(request.getParameter("staff") != null && request.getParameter("staff").equals("yes") ? true : false);
			boolean isValid = true;
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
			if(isValid) {
				try {
					UserIO userIO = new UserIO(student.role);
					Role userRole = userIO.verifyLogin(student);
					if (userRole != null && userRole == Role.STUDENT) {
						userIO.update(student, oldId);
						request.setAttribute("successfulMSG", new RPLError(FieldError.SUCCESSFUL_UPDATE));
					} else {
						request.setAttribute("passwordError", new RPLError(FieldError.PASSWORD_INCORRECT));
					}
				} catch (SQLException e) {
					System.out.println("UpdateStudentServlet: processRequest: SQLException: "+e.getMessage());
				} catch (Exception e) {
					System.out.println("UpdateStudentServlet: processRequest: Exception: "+e.getMessage());
				}
			}
		}

        RequestDispatcher dispatcher = request.getRequestDispatcher(url);
        dispatcher.forward(request, response);
	}

	// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
	/**Handles the HTTP <code>GET</code> method.
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

	/**Handles the HTTP <code>POST</code> method.
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
		return "Processes the Update My Details form for Students.";
	}// </editor-fold>
}
