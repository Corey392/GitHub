package web;

import domain.Campus;
import domain.Claim;
import domain.ClaimedModule;
import domain.Course;
import domain.Discipline;
import domain.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.Util;

/** Processes AJAX Requests for data to be returned in JSON format.
 *  @author     Todd Wiggins
 *  @version    1.001
 *	Created:    30/04/2013
 *	Modified:
 */
public class AJAXServlet extends HttpServlet {
	/**
	 * Processes requests for both HTTP
	 * <code>GET</code> and
	 * <code>POST</code> methods.
	 * <p/>
	 * @param request  servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");

		PrintWriter out = response.getWriter();

		//Get the current session data and current user
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");

		String AJAXMessage = "";

		if (request.getParameter("type").equals("claim") && request.getParameter("sub") != null) {
			Claim claim = (Claim) session.getAttribute("claim");
			if (claim == null){
				claim = new Claim();
				claim.setStudentID(user.getUserID());
				claim.setCampus(new Campus());
				claim.setCampusID("");
				claim.setDiscipline(new Discipline());
				claim.setDisciplineID(Util.INT_ID_EMPTY);
				claim.setCourse(new Course());
				claim.setCourseID("");
				claim.setClaimedModules(new ArrayList<ClaimedModule>());
			}
			if (request.getParameter("sub").equals("discipline")) {
				claim.setCampusID(request.getParameter("campus"));
				ArrayList<Discipline> disciplines = CreateClaimServlet.getDisciplineList(user, claim);

				AJAXMessage = "{\"discipline\":[";
				for (int i = 0; i < disciplines.size(); i++) {
					AJAXMessage += "{\"id\":"+disciplines.get(i).getDisciplineID()+",\"desc\":\""+disciplines.get(i).getName()+"\"}";
					if (i < disciplines.size()-1) {
						AJAXMessage += ",";
					}
				}
				AJAXMessage += "]}";
			} else if (request.getParameter("sub").equals("course")) {
				claim.setDisciplineID(Integer.parseInt(request.getParameter("discipline")));
				ArrayList<Course> courses = CreateClaimServlet.getCourseList(user, claim);

				AJAXMessage = "{\"course\":[";
				AJAXMessage += "{\"id\":0,\"desc\":\"\"}";
				if (courses.size() > 1) {
					AJAXMessage += ",";
				}
				for (int i = 1; i < courses.size(); i++) {
					AJAXMessage += "{\"id\":"+courses.get(i).getCourseID()+",\"desc\":\""+courses.get(i).getName()+"\"}";
					if (i < courses.size()-1) {
						AJAXMessage += ",";
					}
				}
				AJAXMessage += "]}";
			}
		}
	out.print(AJAXMessage);
	out.close();
	}

	// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
	/**
	 * Handles the HTTP
	 * <code>GET</code> method.
	 * <p/>
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

	/**
	 * Handles the HTTP
	 * <code>POST</code> method.
	 * <p/>
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

	/**
	 * Returns a short description of the servlet.
	 * <p/>
	 * @return a String containing servlet description
	 */
	@Override
	public String getServletInfo() {
		return "AJAX Request processes servlet.";
	}// </editor-fold>
}
