package web;

import data.CriterionIO;
import data.ElementIO;
import data.EvidenceIO;
import domain.Claim;
import domain.ClaimedModule;
import domain.Element;
import domain.Evidence;
import domain.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.RPLPage;
import util.RPLServlet;

/** Purpose: Processes a request to add evidence to an Previous Studies claim.
 * <p/>
 * @author Todd Wiggins
 * @version 1.001
 * Created: 07/05/2013
 * Change Log: 08/05/2013: TW: Finished: Processes the evidence to the database. Added reading existing evidence data.
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

		if (request.getParameter("saveEvidence") == null) {	//Process the data required to build the form
			//Read all the element, criterion and evidence data for each claimed module
			CriterionIO criterionIO = new CriterionIO(user.getRole());
			ElementIO elementIO = new ElementIO(user.getRole());
			EvidenceIO evidenceIO = new EvidenceIO(user.getRole());
			for (ClaimedModule cm : claimedMods) {
				ArrayList<Element> elements = elementIO.getList(cm.getModuleID());
				for (Element element : elements) {
					element.setCriteria(criterionIO.getList(element.getElementID(), element.getModuleID()));
					if (element.getCriteria().size() > 0) {
					}
				}
				//Check if any evidence has already been submitted (eg. if saved as draft).
				cm.setEvidence(evidenceIO.getEvidence(claim.getClaimID(), cm.getModuleID()));
				cm.setElements(elements);
			}
			claim.setClaimedModules(claimedMods);
		} else {	//Process the form ("saveEvidence" != null)
			//Get the Evidence data for each Module -> Element
			ArrayList<Evidence> evidences = new ArrayList<Evidence>();
			for (ClaimedModule claimedModule : claimedMods) {
				ArrayList<Evidence> existingEvidence = claimedModule.getEvidence();

				for (Element element : claimedModule.getElements()) {
					System.out.println("request.getParameter(element.getModuleID()+\"|\"+element.getElementID(): "+request.getParameter(element.getModuleID()+"|"+element.getElementID()));
					Evidence evidence = new Evidence(claim.getClaimID(), claimedModule.getModuleID(), element.getElementID(), request.getParameter(element.getModuleID()+"|"+element.getElementID()));
					if (existingEvidence != null) {
						for (int i = 0; i < existingEvidence.size(); i++) {
							if (existingEvidence.get(i).getElementID().equals(element.getElementID())) {
								if (!existingEvidence.get(i).getDescription().equals(evidence.getDescription())) {
									//UPDATE Evidence
									evidence.setUpdated(true);
									evidences.add(evidence);
								} //ELSE No update needed.
							}
						}
					} else { //Insert Evidence
						evidences.add(evidence); //By default, update is false (meaning insert)
					}
				}
			}

			try {
				//Commit the changes to the database
				new EvidenceIO(user.getRole()).insertAndOrUpdate(evidences);
				//TODO: Implement logging update to database (probably do in the evidenceIO module to reduce coupling).
			} catch (SQLException ex) {
				Logger.getLogger(AddEvidencePrevServlet.class.getName()).log(Level.SEVERE, null, ex);
			}
			url = RPLServlet.UPDATE_PREV_CLAIM_SERVLET.relativeAddress;
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