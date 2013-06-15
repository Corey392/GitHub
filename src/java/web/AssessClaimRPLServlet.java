package web;

import data.ClaimIO;
import domain.*;
import domain.Claim.Status;
import domain.User.Role;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.SingleThreadModel;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.RPLError;
import util.RPLPage;
import util.RPLServlet;
import util.Util;

/**
 * @author David, Mitchell Carr, Todd Wiggins
 * Change Log: 06/05/2013 MC: Updated approveClaim to update claim status
 *             07/05/2013 MC: Updated approveClaim to reflect changes to ClaimedModule.getEvidence() method
 *             07/05/2013 TW: Updated approveClaim() to handle ArrayList<Evidence>.
 *             16/05/2013 MC: Updated 'processRequest' to reflect changes made to Util class
 *             18/05/2013 MC: Removed unnecessary studentID fields pertaining to ClaimedModule calls
 *             19/05/2013 MC: Removed unused parameters and updated affected method calls
 *             15/06/2013 TW: Updated to handle new statuses, added ability to set status to selected status, additional buttons, added pushing errors back, improved efficiency of approveClaim method.
 */
public class AssessClaimRPLServlet extends HttpServlet implements SingleThreadModel {

    HttpSession session;
    User user;
	Claim claim;

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        session = request.getSession();
        user = (User)session.getAttribute("user");
        String url;

        String rpath = request.getParameter("rpath");
		Status[] claimStatuses = Claim.Status.getValidStatuses();
		session.setAttribute("statuses", claimStatuses);

        // If User came from ListClaims Page
        if (rpath.equalsIgnoreCase(RPLPage.LIST_CLAIMS_TEACHER.relativeAddress)) {
            String ccmd = request.getParameter("ccmd");
            if(ccmd != null) {
                if (ccmd.equalsIgnoreCase("Back")) {
                    url = RPLPage.TEACHER_HOME.relativeAddress;
                    RequestDispatcher dispatcher = request.getRequestDispatcher(url);
                    dispatcher.forward(request, response);
                }

                String selectedClaimID = request.getParameter("selectedClaim");

                if (selectedClaimID == null) {
                    url = RPLServlet.VIEW_TEACHER_CLAIM_SERVLET.relativeAddress;

                    RPLError listError = new RPLError("Please select a Module");
                    request.setAttribute("listError", listError);
                    RequestDispatcher dispatcher = request.getRequestDispatcher(url);
                    dispatcher.forward(request, response);
                } else {
                    int claimID = -1;
                    try {
                        claimID = Integer.parseInt(selectedClaimID);
                    } catch (Exception e){
                        e.getMessage();
                    }

                    Claim claim = Util.getCompleteClaim(claimID, user.role);
                    url = getForwardURLForClaimType(claim);
                    request.setAttribute("claim", claim);
                    RequestDispatcher dispatcher = request.getRequestDispatcher(url);
                    dispatcher.forward(request, response);
                }

            }
//            int claimID = Integer.parseInt(request.getParameter("claimID"));
//            String studentID = request.getParameter("studentID");
//            Claim claim = Util.getCompleteClaim(studentID, claimID, user.role);
//            url = getForwardURLForClaimType(claim);
//            request.setAttribute("claim", claim);
//            request.setAttribute("r", listError);
//            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
//            dispatcher.forward(request, response);
        } else if (rpath.equalsIgnoreCase(RPLPage.VIEW_EVIDENCE_PAGE.relativeAddress)) {
         //User Came from ViewEvidenceServlet
            String selectedClaimID = request.getParameter("selectedClaim");
            if (selectedClaimID == null) {

                int claimID = Integer.parseInt(request.getParameter("claimID"));

                Claim claim = Util.getCompleteClaim(claimID, user.role);
                url = getForwardURLForClaimType(claim);
                request.setAttribute("claim", claim);
                RequestDispatcher dispatcher = request.getRequestDispatcher(url);
                dispatcher.forward(request, response);
            } else {
                // TODO: Implement Search Method here


                //User Came from ListClaims Page

            }

        } else if (rpath.equalsIgnoreCase(RPLPage.ASSESS_CLAIM_PREV.relativeAddress)
                    || rpath.equalsIgnoreCase(RPLPage.ASSESS_CLAIM_RPL.relativeAddress)){
            String cmd = request.getParameter("cmd");
        // If User came from assessClaimPrev or assessClaimRPL Page
			if (cmd == null) {	//View Evidence was pressed
				String moduleID = Util.getPageStringID(request, "evid");
				if (moduleID == null || moduleID.isEmpty()) {
					request.setAttribute("error", "The module you selected was invalid");
				} else {	//A valid module was selected
					request.removeAttribute("rpath");
					String claimID = request.getParameter("claimID");
					//rpath = RPLServlet.ASSESS_CLAIM_RPL_SERVLET.relativeAddress;

					url = RPLServlet.VIEW_EVIDENCE_SERVLET.relativeAddress;
					request.setAttribute("claimID", claimID);
					request.setAttribute("moduleID", moduleID);
					request.setAttribute("rpath", moduleID);
					RequestDispatcher dispatcher = request.getRequestDispatcher(url);
					dispatcher.forward(request, response);
				}
				return;
			}

            int claimID = Integer.parseInt(request.getParameter("claimID"));
            Claim claim = Util.getCompleteClaim(claimID, user.role);
            url = getForwardURLForClaimType(claim);

			if (cmd.equals("Set Claim Status")) {
                approveClaim(claim, request);
			} else if (cmd.equals("Approve Selected Modules")) {
				approveSelected(request, claim);
			} else if (cmd.equals("Print Claim")) {
				printClaim(request, response, claim);
			} else {	//Only other option is "Back"
                url = RPLServlet.VIEW_TEACHER_CLAIM_SERVLET.relativeAddress;
            }
            request.setAttribute("claim", claim);
            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        } else if (rpath.equalsIgnoreCase(RPLPage.EVIDENCE_UPDATED_PAGE.relativeAddress)) {

            int claimID = Integer.parseInt(request.getParameter("claimID"));

            Claim claim = Util.getCompleteClaim(claimID, user.role);
            url = getForwardURLForClaimType(claim);
            request.setAttribute("claim", claim);
            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        }
    }

    /**
     * Method is called when an Assessor or Delegate wishes to approve a claim.
     * The claim's 'Assessor Approved' and 'Delegate Approved' fields will
     * be set depending on the User's ID and whether they are the designated Assessor,
     * Delegate, or both. Each of the claimed modules are then set then set to approved.
     * @param claim The Claim to approve
     */
    public HttpServletRequest approveClaim(Claim claim, HttpServletRequest request) {
        String userID = user.getUserID();
        if (user.role == Role.TEACHER) {
            if (claim.getAssessorID() != null && claim.getAssessorID().equals(userID)) {
                claim.setAssessorApproved(Boolean.TRUE);
            }
        } else if (user.role == Role.ADMIN) {
            if (claim.getDelegateID() != null && claim.getDelegateID().equals(userID)) {
				claim.setDelegateApproved(Boolean.TRUE);
            }
        } else {
			request.setAttribute("error", "You are not authorised to perform this function.");
			return request;
		}

        for (ClaimedModule claimedModule: claim.getClaimedModules()) {
            claimedModule.setApproved(true);
            ArrayList<Evidence> evi = claimedModule.getEvidence();
            for (Evidence e : evi) {
				e.setApproved(true);
            }
        }

		String newStatus = request.getParameter("newStatus");
		if (newStatus == null && newStatus.isEmpty()) {
			request.setAttribute("error", "You must select a status before trying to set the status on this claim");
		} else {
			try {
				claim.setStatus(Claim.Status.valueOf(newStatus));
				System.out.println("CLAIM STATUS: "+claim.getStatus());
			} catch (IllegalArgumentException iae) {
				request.setAttribute("error", "The status specified for the claim was invalid.");
				return request;
			}
		}

        try {
			new ClaimIO(user.role).update(claim);
        } catch(SQLException SQLex) {
            System.out.println("AssessClaimRPLServlet: SQLException: "+SQLex.getMessage());
			request.setAttribute("error", "This claim was unable to be updated due to a database failure. Please see the system administrator if the issue persists.");
        }
		return request;
    }

    /**
     * Approves the ClaimedModules for the Claim passed in.
     * @param request HTTP request containing the IDs of Modules to approve
     * @param claim Claim for which to approve ClaimedModules
     */
    public HttpServletRequest approveSelected(HttpServletRequest request, Claim claim) {
        String[] selectedValues = request.getParameterValues("approved");
        ClaimIO cIO = new ClaimIO(user.role);
        if(selectedValues != null) {
            if (selectedValues.length > 0) {
                for (int i = 0; i < selectedValues.length; i++) {
                    for (ClaimedModule claimedModule: claim.getClaimedModules()) {
                        if (selectedValues[i].equals(claimedModule.getModuleID())) {
                            claimedModule.setApproved(true);
                        }
                    }
                }
            }
        }
        try {
            cIO.update(claim);
        }catch(SQLException SQLex) {
            SQLex.getMessage();
        }
		return request;
    }

    public HttpServletRequest printClaim(HttpServletRequest request, HttpServletResponse response, Claim claim) {
        //TODO: Print Claim Method
		return request;
    }

    /**
     * Returns a URL based on Claim Type.
     * @param claim Claim for which to check the Claim type
     * @return URL corresponding to the type of Claim passed in
     */
    private String getForwardURLForClaimType(Claim claim) {

        if (claim.getClaimType().RPL.value) {
            return RPLPage.ASSESS_CLAIM_RPL.relativeAddress;
        } else {
            return RPLPage.ASSESS_CLAIM_PREV.relativeAddress;
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