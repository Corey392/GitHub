package web;

import data.ClaimIO;
//import data.ClaimRecordIO;
import domain.Claim;
//import domain.ClaimRecord;
import domain.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.RequestDispatcher;
import util.FieldError;
import util.RPLError;
import util.RPLPage;
import util.RPLServlet;
import util.Util;

/** Populates the list of claims for the student's listClaims page and redirects any requests from that page.
 *  @author     James Purves, Todd Wiggins
 *  @version    1.02
 *	Created:    ?
 *	Modified:   29/04/2013
 *	Change Log: 1.01: TW: Updated URL when deleting to return to the list of claims instead of a 404.
 *	            1.02: TW: Now claim is removed from the list of claims displayed on page.
 */
public class ListClaimsServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Initialises the list of claims and error as null and the url as an
        // empty string.
        RPLError error;
        String url;

        // Gets the session and the current user.
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Gets the list of claims for the current user.
        ArrayList<Claim> claims = this.populateClaimList(user);

        // Sets the url to the next page and sets the error if there was any.
        if (request.getParameter("view") != null){
            Claim selectedClaim = this.setSelectedClaim(request, user);
            if (selectedClaim == null){
                url = RPLPage.LIST_CLAIMS_STUDENT.relativeAddress;
                error = new RPLError("Please select a module using the radio "
                        + "button beside it.");
                request.setAttribute("error", error);
            } else {
                if (selectedClaim.getClaimType() == Claim.ClaimType.RPL){
                    url = RPLServlet.UPDATE_RPL_CLAIM_SERVLET.relativeAddress;
                } else if (selectedClaim.getClaimType() == Claim.ClaimType.PREVIOUS_STUDIES) {
                    url = RPLServlet.UPDATE_PREV_CLAIM_SERVLET.relativeAddress;
                } else {
                    url = RPLPage.LIST_CLAIMS_STUDENT.relativeAddress;
                    error = new RPLError("Invalid Claim Type - Contact Admin");
                    request.setAttribute("error", error);
                }
                session.setAttribute("claim", selectedClaim);
            }
        } else if (request.getParameter("delete") != null) {
            request = this.deleteClaim(request, user, claims);
            url = RPLPage.LIST_CLAIMS_STUDENT.relativeAddress;
			int claimID = Integer.parseInt(request.getParameter("selectedClaim"));
			for (int i = 0; i < claims.size(); i++) {
				if (claims.get(i).getClaimID() == claimID) {
					claims.remove(i);
				}
			}
        } else if (request.getParameter("back") != null){
            url = RPLPage.STUDENT_HOME.relativeAddress;
        } else {
            url = RPLPage.LIST_CLAIMS_STUDENT.relativeAddress;
        }

        // Sets the claims attribute to the list of claims and forwards the
        // request.
        session.setAttribute("claims", claims);
        RequestDispatcher dispatcher = request.getRequestDispatcher(url);
        dispatcher.forward(request, response);
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

    /**
     * Gets a list of claims for the current user.
     * @param request the request
     * @param user the current user
     * @return a list of complete claims
     */
    private ArrayList<Claim> populateClaimList(User user){
        ClaimIO claimIO = new ClaimIO(user.getRole());
        ArrayList<Claim> completeClaims = new ArrayList<Claim>();
        try {
            ArrayList<Claim> claims = claimIO.getList(user);
            for (Claim claim : claims){
                Claim c = Util.getCompleteClaim(user.getUserID(),
                        claim.getClaimID(), user.role);
                completeClaims.add(c);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ListClaimsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return completeClaims;
    }

    /**
     * Gets the claim that the user has selected from the list.
     * @param request the request
     * @param user the current user
     * @return the selected claim
     */
    private Claim setSelectedClaim(HttpServletRequest request, User user){
        String claimID = request.getParameter("selectedClaim");
        Claim selectedClaim = null;
        if (claimID != null){
            int id = Integer.valueOf(claimID);
            selectedClaim = Util.getCompleteClaim(user.getUserID(), id, user.getRole());
        }
        return selectedClaim;
    }

    /**
     * Deletes the currently selected "DRAFT" claim. Raises an error if the user tries to delete a claim that is not a draft.
     * @param request the request
     * @param user the current user
     * @return the updated request
     */
    private HttpServletRequest deleteClaim(HttpServletRequest request, User user, ArrayList<Claim> claims){
        ClaimIO claimIO = new ClaimIO(user.getRole());
        //ClaimRecordIO claimRecordIO = new ClaimRecordIO(user.getRole());    // Kyoungho Lee
        //TODO: uncomment line above when ClaimRecordIO has been updated
		String claimID = request.getParameter("selectedClaim");
		if (claimID != null) {
			Claim selectedClaim = new Claim(Integer.valueOf(claimID),user.getStudentID());
			for (Claim claim : claims) {
				if (claim.getClaimID() == selectedClaim.getClaimID()) {
					if (claim.getStatus() == Claim.Status.DRAFT){
						try {
							claimIO.deleteDraft(selectedClaim);
						} catch (SQLException ex) {
							Logger.getLogger(ListClaimsServlet.class.getName()).log(Level.SEVERE, null, ex);
							//Should be thrown if the claim is not in draft status in database.
							RPLError error = new RPLError(FieldError.CLAIM_DELETE_NOT_DRAFT);
							request.setAttribute("error", error);
						} catch (Exception e) {
							Logger.getLogger(ListClaimsServlet.class.getName()).log(Level.SEVERE, null, e);
						}
					 } else {
						RPLError error = new RPLError(FieldError.CLAIM_DELETE_NOT_DRAFT);
						request.setAttribute("error", error);
					}
					break;
				}
			}
		}
        this.populateClaimList(user);
        return request;
    }
}
