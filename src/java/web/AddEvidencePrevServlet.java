package web;

import domain.Claim;
import domain.ClaimedModule;
import domain.User;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.RPLPage;

/** Purpose: Processes a request to add evidence to an Previous Studies claim.
 * <p/>
 * @author Todd Wiggins
 * @version 1.00
 * Created: 07/05/2013
 * Change Log:
 */
public class AddEvidencePrevServlet extends HttpServlet {
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
	protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String url = RPLPage.ADD_EVIDENCE_PREV.relativeAddress;
		//Get session User & Claim.
		HttpSession session = request.getSession();
		User user = (User) session.getAttribute("user");
		Claim claim = (Claim) session.getAttribute("claim");
		//Get the modules that evidence is required for
		ArrayList<ClaimedModule> claimedMods = claim.getClaimedModules();

		request.setAttribute("elements", claimedMods.get(1).getElements());

		if (request.getParameter("saveEvidence") != null) {	//Process the form

		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(url);
		dispatcher.forward(request, response);
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
		return "Processes a request to add evidence to an Previous Studies claim";
	}// </editor-fold>
}
