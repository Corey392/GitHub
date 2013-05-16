package web;

import data.ClaimIO;
import domain.Claim;
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

/** 
 *  Populates the list of claims for the student's listClaims page and redirects any requests from that page.
 *  @author     James Purves, Todd Wiggins, Mitch Carr
 *  @version    1.022
 *	Created:    ?
 *	Change Log: 1.01: TW: Updated URL when deleting to return to the list of claims instead of a 404.
 *	            29/04/2013: TW: Now claim is removed from the list of claims displayed on page.
 *	            12/05/2013: TW: Updated error message to say claim instead of module.
 *	            15/05/2013: TW: Added Handling if No Claim is selected when trying to Delete, no longer throwing exception, improved Error Message handling.
 *                  16/05/2013: MC: Updated 'setSelectedClaim' and 'populateClaimList' to reflect changes made to Util class
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
                error = new RPLError("Please select a claim from the list using the radio button.");
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
			url = RPLPage.LIST_CLAIMS_STUDENT.relativeAddress;
			request = this.deleteClaim(request, user, claims, session);
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
                Claim c = Util.getCompleteClaim(claim.getClaimID(), user.role);
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
            selectedClaim = Util.getCompleteClaim(id, user.getRole());
        }
        return selectedClaim;
    }

    /**
     * Deletes the currently selected "DRAFT" claim. Raises an error if the user tries to delete a claim that is not a draft.
     * @param request the request
     * @param user the current user
     * @return the updated request
     */
    private HttpServletRequest deleteClaim(HttpServletRequest request, User user, ArrayList<Claim> claims, HttpSession session){
        ClaimIO claimIO = new ClaimIO(user.getRole());
		String claimID = request.getParameter("selectedClaim");
		if (claimID != null) {
			Claim selectedClaim = new Claim(Integer.valueOf(claimID),user.getStudentID());
			for (Claim claim : claims) {
				if (claim.getClaimID() == selectedClaim.getClaimID()) {
					if (claim.getStatus() == Claim.Status.DRAFT){
						try {
							claimIO.deleteDraft(selectedClaim);
							claims.remove(claim);
						} catch (SQLException ex) {
							Logger.getLogger(ListClaimsServlet.class.getName()).log(Level.SEVERE, null, ex);
							//Should be thrown if the claim is not in draft status in database.
							request.setAttribute("error", new RPLError(FieldError.CLAIM_DELETE_NOT_DRAFT));
						} catch (Exception e) {
							Logger.getLogger(ListClaimsServlet.class.getName()).log(Level.SEVERE, null, e);
						}
					 } else {
						request.setAttribute("error", new RPLError(FieldError.CLAIM_DELETE_NOT_DRAFT));
					}
					break;
				}
			}
		} else {
			request.setAttribute("error", new RPLError(FieldError.CLAIM_DELETE_NOT_SELECTED));
		}
		session.setAttribute("claims", claims);
        return request;
    }
}
