package web;

import data.CriterionIO;
import data.ElementIO;
import data.EvidenceIO;
import data.FileIO;
import domain.Claim;
import domain.Claim.Status;
import domain.ClaimedModule;
import domain.Element;
import domain.Evidence;
import domain.GuideFile;
import domain.User;
import domain.User.Role;
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
 * @author Todd Wiggins
 * @version 1.003
 * Created: 07/05/2013
 * Change Log: 08/05/2013: TW: Finished: Processes the evidence to the database. Added reading existing evidence data.
 *			   12/05/2013: TW: Added handling if adding/modifying evidence is possible based on claim status and user role. Moved 'Submit Claim' and 'Save Draft Claim' buttons to this page and added handling them here, removed 'Save Evidence' button and moved code to a 'saveEvidence()' method.
 *			   13/05/2013: TW: Moved 'AttachEvidence' button and handling to here. Added attribute to request for 'attachEvidence' based on Claim Status and User Type.
 *			   15/05/2013: TW: Fixed qualification of "Attach Evidence".
 *			   26/05/2013: TW: Added checking if a GuideFile is available for this course.
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
		System.out.println("claimedMods.size() "+ claimedMods.size());

		boolean editable = false;
		boolean attachEvidence = false;
		if (user.role.name().equals(Role.STUDENT.name())) {
			if (claim.getStatus().code == Status.DRAFT.code || claim.getStatus().code == Status.EVIDENCE.code) {
				editable = true;
			}
			if (claim.getStatus().code != Status.EMPTY_DRAFT.code && claim.getStatus().code != Status.DRAFT.code && claim.getStatus().code != Status.PRELIMINARY.code) {
				attachEvidence = true;
			}
		} else if (user.role.name().equals(Role.TEACHER.name()) || user.role.name().equals(Role.ADMIN.name())) {
			if (claim.getStatus().code == Status.PRELIMINARY.code || claim.getStatus().code == Status.ASSESSMENT.code || claim.getStatus().code == Status.APPROVAL.code) {
				editable = true;
			}
			if (claim.getStatus().code != Status.EMPTY_DRAFT.code && claim.getStatus().code != Status.DRAFT.code && claim.getStatus().code != Status.PRELIMINARY.code) {
				attachEvidence = true;
			}
		}
		//Check if this course has a Guide File.
		GuideFile courseGuideFile = null;
		try {
			courseGuideFile = new FileIO(user.role).getGuideFileByID(claim.getCourseID());
		} catch (SQLException ex) {
			Logger.getLogger(AddEvidencePrevServlet.class.getName()).log(Level.SEVERE, null, ex);
		}

		request.setAttribute("editable", editable?"true":"false");
		request.setAttribute("attachEvidence", attachEvidence?"true":"false");
		request.setAttribute("guideFile", courseGuideFile);

		if (request.getParameter("submitClaim") != null) {
			if (!claim.getClaimedModules().isEmpty()) {
				saveEvidence(user,claim,claimedMods,request);
				claim = UpdatePrevClaimServlet.submitClaim(user, claim, true);
				url = RPLServlet.LIST_CLAIMS_STUDENT_SERVLET.relativeAddress;
			}
		} else if (request.getParameter("draftClaim") != null) {
			saveEvidence(user,claim,claimedMods,request);
			claim = UpdatePrevClaimServlet.submitClaim(user, claim, false);
			url = RPLServlet.LIST_CLAIMS_STUDENT_SERVLET.relativeAddress;
		} else if (request.getParameter("back") != null) {
			url = RPLServlet.UPDATE_PREV_CLAIM_SERVLET.relativeAddress;
		} else if (request.getParameter("AttachEvidence") != null) {
			url = RPLServlet.ATTACH_EVIDENCE.relativeAddress;
		} else if (request.getParameter("saveEvidence") == null) {	//Process the data required to build the form
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
		}
		session.setAttribute("claim", claim);

		RequestDispatcher dispatcher = request.getRequestDispatcher(url);
		dispatcher.forward(request, response);
	}

	/**
         * Updates evidence attached to a Claim
         * @param user User processing Evidence
         * @param claim Claim to add Evidence for
         * @param claimedMods List of ClaimedModules to get Evidence from
         * @param request HTTP request containing within it Element data to set
         */
        private void saveEvidence(User user, Claim claim, ArrayList<ClaimedModule> claimedMods, HttpServletRequest request) {
		//Get the Evidence data for each Module -> Element
			ArrayList<Evidence> evidences = new ArrayList<Evidence>();
			for (ClaimedModule claimedModule : claimedMods) {
				ArrayList<Evidence> existingEvidence = claimedModule.getEvidence();

				for (Element element : claimedModule.getElements()) {
					Evidence evidence = new Evidence(claim.getClaimID(), claimedModule.getModuleID(), element.getElementID(), request.getParameter(element.getModuleID()+"|"+element.getElementID()));
					if (existingEvidence != null && existingEvidence.size() > 0) {
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