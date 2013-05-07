package web;

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
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import util.RPLError;
import util.RPLPage;
import util.RPLServlet;

/**
 * This servlet is for the adding and editing of RPL evidence. This only applies
 * to claims for RPL and not claims for Previous Studies. This servlet uses the
 * addRPLEvidence page to get input from the user.
 * @author James Purves, Mitch Carr
 * Changelog:   07/05/2013 MC: Updated setEvidence method to reflect changes to the way ClaimedModule objects hold Evidence
 *				07/05/2013 TW: Updated setEvidence() method to handle ArrayList<Evidence>
 */
public class AddEvidenceServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Initialises all required variables as null, empty or false.
        Claim claim;
        Integer addEvidenceTo;
        ClaimedModule module = null;
        String moduleID;
        ArrayList<ClaimedModule> claimedModules;
        boolean error = false;

        // Initialises the url for the next page as an empty string. Gets the
        // session and the current user.
        String url = "";
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Gets the current claim from the session.
        claim = (Claim) session.getAttribute("claim");
        // addEvidenceTo is the index of the module in the claim's
        // claimedModules ArrayList.
        addEvidenceTo = (Integer) request.getAttribute("addEvidenceTo");
        if (addEvidenceTo != null) {
            claimedModules = claim.getClaimedModules();
            module = claimedModules.get(addEvidenceTo.intValue());
        } else {
            // If addEvidenceTo is null then the servlet has been requested by
            // the addRPLEvidence page and the module's ID has been supplied
            // instead.
            moduleID = request.getParameter("moduleID");
            claimedModules = claim.getClaimedModules();
            if (moduleID != null){
                int index = 0;
                for (ClaimedModule cm : claimedModules){
                    if (cm.getModuleID().equals(moduleID)) {
                        module = cm;
                        addEvidenceTo = index;
                    }
                    index++;
                }
            } else {
                // If moduleID is null then there has been an error.
                error = true;
                request.setAttribute("moduleError", new RPLError("Module Error:"
                        + " Please select a module from your claim to edit "
                        + "evidence for"));
                url = RPLServlet.UPDATE_RPL_CLAIM_SERVLET.relativeAddress;
            }
        }

        // If there wasn't an error then set the url to forward the address to
        // the next servlet or to the addRPLEvidence depending on whether any
        // buttons were pressed. If addEvidence or saveEvidence were pressed
        // call the setEvidence method.
        if (!error){
            if (request.getParameter("addEvidence") != null){
                claim = this.setEvidence(request, user, claim, addEvidenceTo,
                        module, claimedModules);
                url = RPLServlet.UPDATE_RPL_CLAIM_SERVLET.relativeAddress;
            } else if (request.getParameter("saveEvidence") != null) {
                claim = this.setEvidence(request, user, claim, addEvidenceTo,
                        module, claimedModules);
                url = RPLServlet.UPDATE_RPL_CLAIM_SERVLET.relativeAddress;
            } else if (request.getParameter("cancel") != null) {
                url = RPLServlet.UPDATE_RPL_CLAIM_SERVLET.relativeAddress;
            } else {
                url = RPLPage.ADD_RPL_EVIDENCE.relativeAddress;
            }
        }

        // Set the claim and module attribute and forward the claim.
        session.setAttribute("claim", claim);
        request.setAttribute("module", module);
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
     * Saves the evidence to the database or updates it if it is already there.
     * If there aren't any elements for the module then there is only one
     * item of evidence to save, otherwise evidence is saved for each element.
     * @param request the page request to retrieve the evidence from
     * @param user the User who is currently logged in
     * @param claim the Claim that has the ClaimedModule being updated
     * @param addEvidenceTo the index of the ClaimedModule to add evidence to.
     * @param module the Module
     * @param claimedModules the list of ClaimedModules
     * @return the updated Claim
     */
    private Claim setEvidence(HttpServletRequest request, User user, Claim claim, Integer addEvidenceTo, ClaimedModule module, ArrayList<ClaimedModule> claimedModules){
        EvidenceIO evidenceIO = new EvidenceIO(user.role);
        ArrayList<Evidence> evi = new ArrayList<Evidence>();
        if (!module.getElements().isEmpty()){
            for (Element element: module.getElements()){
                String elementID = String.valueOf(element.getElementID());
                String description = request.getParameter(elementID);
                if (description != null){
                    Evidence evidence = new Evidence(
                            claim.getClaimID(),
                            module.getModuleID(),
                            description,
                            element.getElementID());
                    try{
                        if (this.isNewEvidence(module, evidence)){
							evi.add(evidence);
                            evidenceIO.insert(evi);
                        } else {
							evi.add(evidence);
                            evidenceIO.update(evi);
                        }
                    } catch (SQLException ex) {
                        Logger.getLogger(AddEvidenceServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            }
        } else {
            String description = request.getParameter("evidence");
            if (description != null){
				Evidence evidence = new Evidence(
                            claim.getClaimID(),
                            module.getModuleID(),
                            description);
                try{
                    if (this.isNewEvidence(module, evidence)){
						evi.add(evidence);
                        evidenceIO.insert(evi);
                    } else {
						evi.add(evidence);
                        evidenceIO.update(evi);
                    }
                } catch (SQLException ex) {
                    Logger.getLogger(AddEvidenceServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        module.setEvidence(evi);
        claimedModules.set(addEvidenceTo, module);
        claim.setClaimedModules(claimedModules);
        return claim;
    }

    /**
     * Test whether a module already has evidence for a given element.
     * @param m the ClaimedModule the evidence belongs to
     * @param e the Evidence that is being tested
     * @return whether the evidence is new
     */
    private boolean isNewEvidence(ClaimedModule m, Evidence e){
        ArrayList<Evidence> evidence = m.getEvidence();
        boolean isNewEvidence = true;
        if (evidence != null){
			for (Evidence evi : evidence) {
				if (evi.getModuleID().equals(e.getModuleID()) && evi.getElementID() == e.getElementID()){
					isNewEvidence = false;
				}
			}
        }
        return isNewEvidence;
    }
}
