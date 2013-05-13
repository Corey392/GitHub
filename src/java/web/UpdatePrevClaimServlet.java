package web;

import data.*;
import domain.*;
import java.io.IOException;
import java.sql.Date;
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
import util.*;

/** @author     James Purves, Todd Wiggins, Mitch Carr
 *  @version    1.032
 *	Created:    ?
 *	Change Log: 25/04/2013: TW: Added handling when a user submits the form without selecting a module. Updated remove module error message.
 *	            30/04/2013: MC: Removed all ClaimRecord calls, methods, etc.
 *				04/05/2013: MC: Updated submitClaim method
 *				05/05/2013: TW: Updated submitClaim method, added boolean Submit for submit or save as draft.
 *				06/05/2013: MC: Updated submitClaim method, moved update call until after claim status has been set.
 *				06/05/2013: MC: Updated submitClaim method to reflect changes to Claim.Status.
 *				06/05/2013: TW: Handles submitting a claim without any modules added. Now returns an error message.
 *				07/05/2013: MC: Added switch and basic IO needed for adding evidence
 *				07/05/2013: TW: Updated to handle ArrayList<Evidence>
 *				12/05/2013: TW: Added handling of 'viewTextEvidence', added changing date of claim to "now / today". Made 'submitClaim()' public static to allow it to be used by AddEvidencePrevServlet. Moved 'Submit Claim' button to 'Add Evidence' page and only shows the 'Add Evidence' button after at least 1 module has been added.
 *				12/05/2013: TW: Added handling of 'AttachEvidence' button.
 *	Purpose:    Handles the adding and removing of modules from a Previous Studies claim as well as the adding and editing of evidence for the modules.
 */
public class UpdatePrevClaimServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Gets the session and the current user.
        String url;
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Gets the current claim from the session.
        Claim claim = (Claim) session.getAttribute("claim");

        // Initialises the module and provider lists, as well as retrieveing the
        // selectedModule for each claimed module.
        ArrayList<Module> modules = this.initialiseModuleList(user, claim);
        ArrayList<Provider> providers = this.initialiseProviderList(user);
        Module selectedModule = this.getSelectedModule(request, user, modules);
        ArrayList<Evidence> evidence = new ArrayList<Evidence>();

		// If the request came from the reviewClaimPrev jsp page the
		// claim will be submitted, or a module will be added or removed. The
		// url is set to point back to the reviewClaimPrev page unless the claim
		// was submitted or the user clicked back, in which case the url is set
		// to the ListClaimsServlet.
		if (request.getParameter("submitClaim") != null) {
			if (!claim.getClaimedModules().isEmpty()) {
				claim = submitClaim(user, claim, true);
				url = RPLServlet.LIST_CLAIMS_STUDENT_SERVLET.relativeAddress;
			} else {
				request.setAttribute("moduleError", new RPLError("Please add a module before submitting a claim."));
				url = RPLPage.REVIEW_CLAIM_PREV.relativeAddress;
			}
		} else if (request.getParameter("draftClaim") != null) {
			claim = submitClaim(user, claim, false);
			url = RPLServlet.LIST_CLAIMS_STUDENT_SERVLET.relativeAddress;
		} else if (request.getParameter("addTextEvidence") != null || request.getParameter("viewTextEvidence") != null){
		    url = RPLServlet.ADD_EVIDENCE_PREV.relativeAddress;
		} else if (request.getParameter("AttachEvidence") != null) {
			url = RPLServlet.ATTACH_EVIDENCE.relativeAddress;
		} else if (request.getParameter("addModule") != null) {
			if (selectedModule == null) {
				url = RPLPage.REVIEW_CLAIM_PREV.relativeAddress;
				request.setAttribute("moduleError", new RPLError("Please choose a module from the list provided."));
			} else {
				ArrayList<Provider> selectedProviders = this.getSelectedProviders(request, providers);
				if (selectedProviders.size() < 1 || selectedProviders.size() > 3){
					request.setAttribute("moduleError", new RPLError("Please select 1-3 providers"));
					url = RPLPage.REVIEW_CLAIM_PREV.relativeAddress;
				} else {
					this.addModule(claim, user, selectedModule, selectedProviders);
					modules = this.initialiseModuleList(user, claim);
					url = RPLPage.REVIEW_CLAIM_PREV.relativeAddress;
				}
			}
		} else if (request.getParameter("removeModule") != null) {
			String remove = request.getParameter("removeModule");
			if (remove != null){
				claim = this.removeModule(claim, user, Integer.valueOf(remove));
			} else {
				request.setAttribute("selectError", new RPLError("An error has occurred while processing trying to remove this module. Please try again."));
			}
			modules = this.initialiseModuleList(user, claim);
			url = RPLPage.REVIEW_CLAIM_PREV.relativeAddress;
		} else if (request.getParameter("back") != null) {
			url = RPLServlet.LIST_CLAIMS_STUDENT_SERVLET.relativeAddress;
		} else {
			url = RPLPage.REVIEW_CLAIM_PREV.relativeAddress;
		}

		// Sets the required attributes and forwards the request to the given
		// url.
		session.setAttribute("claim", claim);
		request.setAttribute("evidence", evidence);
		request.setAttribute("selectedModule", selectedModule);
		request.setAttribute("modules", modules);
		request.setAttribute("providers", providers);
        RequestDispatcher dispatcher = request.getRequestDispatcher(url);
        dispatcher.forward(request, response);
    }

    /**
     * Adds the selected module to the database as a claimed module.
     * (Claimed modules are modules associated with claims).
     * @param claim the claim to add the module to
     * @param user the current user
     * @param selectedModule the selected module
     * @param selectedProviders the providers for the module
     * @return the updated claim
     */
    private void addModule(Claim claim, User user, Module selectedModule,
            ArrayList<Provider> selectedProviders){
        ClaimedModuleIO claimedModuleIO = new ClaimedModuleIO(user.role);
		ClaimedModule claimedModule = new ClaimedModule(
				claim.getClaimID(),
				user.getUserID(),
				selectedModule.getModuleID(),
				selectedModule.getName());
        claimedModule.setElements(selectedModule.getElements());
        claimedModule.setProviders(selectedProviders);
        ArrayList<ClaimedModule> claimedModules = claim.getClaimedModules();
        claimedModules.add(claimedModule);
        claim.setClaimedModules(claimedModules);
        try {
            if (!claimedModule.getModuleID().equals("")){
                claimedModuleIO.insert(claimedModule);
                for (Provider provider : selectedProviders){
                    claimedModuleIO.addProvider(
                            claim.getClaimID(),
                            claimedModule.getModuleID(),
                            provider.getProviderID());
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(UpdatePrevClaimServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Removes a claimed module from the database and the current claim.
     * @param claim the claim to remove the module from
     * @param user the current user
     * @param selectedModule the module to remove
     * @return the updated claim
     */
    private Claim removeModule(Claim claim, User user, Integer selectedModule){
        ClaimedModuleIO claimedModuleIO = new ClaimedModuleIO(user.getRole());
        ArrayList<ClaimedModule> claimedModules = claim.getClaimedModules();
        ClaimedModule removed = claimedModules.remove(selectedModule.intValue());
        try {
            claimedModuleIO.delete(removed);
        } catch (SQLException ex) {
            Logger.getLogger(UpdatePrevClaimServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        claim.setClaimedModules(claimedModules);
        return claim;
    }

    /**
     * Gets the module selected by the user using the module combobox.
     * @param request the request
     * @param user the current user
     * @param modules the list of modules to get the selected module from
     * @return the selected module
     */
    private Module getSelectedModule(HttpServletRequest request, User user, ArrayList<Module> modules) {
        Module selectedModule;
        String moduleIDX = request.getParameter("module");
        if (moduleIDX == null){
            return new Module();
        } else {
			int index = Integer.valueOf(moduleIDX);
			if (index > 0) {	//The 0'th index is a blank row, 1+ are the actual modules.
				Module module = modules.get(index);
				selectedModule = Util.getCompleteModule(module.getModuleID(), user.getRole());
				return selectedModule;
			} else {
				return null;
			}
	    }
    }

    /**
     * Gets the providers selected by the user.
     * @param request the request
     * @param providers the list of providers to get the selected providers from
     * @return the selected providers
     */
    private ArrayList<Provider> getSelectedProviders(HttpServletRequest request, ArrayList<Provider> providers) {
        ArrayList<Provider> selectedProviders;
        String[] providersIDXArray = request.getParameterValues("provider");
        if (providersIDXArray == null){
            selectedProviders = new ArrayList<Provider>();
        } else {
            selectedProviders = new ArrayList<Provider>();
            for (String providerIDX: providersIDXArray){
                int index = Integer.valueOf(providerIDX);
                Provider provider = providers.get(index);
                selectedProviders.add(provider);
            }
        }
        return selectedProviders;
    }

    /**
     * Gets a list of modules that haven't already been added to the claim. This
     * is used to populate the combobox that the user can use to add modules.
     * @param user the current user
     * @param claim the current claim
     * @return the list of modules
     */
    private ArrayList<Module> initialiseModuleList(User user, Claim claim) {
        ArrayList<Module> modules;
        String campusID = claim.getCampusID();
        int disciplineID = claim.getDisciplineID();
        String courseID = claim.getCourseID();

        if ((campusID == null || campusID.equals("")) || disciplineID == 0 || (courseID == null || courseID.equals(""))){
            modules = new ArrayList<Module>();
        } else {
            Course currentCourse = Util.getCompleteCourse(courseID, user.getRole(), campusID, disciplineID);
            modules = currentCourse.getAllModules();
            ArrayList<ClaimedModule> claimedModules = claim.getClaimedModules();
            for (ClaimedModule cm : claimedModules){
                for (int i = 0; i < modules.size(); i++){
                    if (modules.get(i).getModuleID().equals(cm.getModuleID())){
						cm.setName(modules.get(i).getName());
						cm.setNationalModuleID(modules.get(i).getNationalModuleID());
                        modules.remove(i);
                    }
                }
            }
        }
        modules.add(0, new Module());

        return modules;
    }

    /**
     * Gets a list of possible providers from the database.
     * @param user the current user
     * @return the list of providers
     */
    private ArrayList<Provider> initialiseProviderList(User user){
        ArrayList<Provider> providers;
        ProviderIO providerIO = new ProviderIO(user.role);
        providers = providerIO.getList();
        return providers;
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
     * Changes the status of the claim in the database to submitted. Which flags
     * it as ready to be assessed by a teacher.
     * @param user the current user
     * @param claim the current claim
     * @param submit Should this claim be submitted (true) or saved as a draft (false).
     * @return the modified claim
     */
    public static Claim submitClaim(User user, Claim claim, boolean submit) {
        ClaimIO claimIO = new ClaimIO(user.getRole());
        ClaimedModuleIO moduleIO = new ClaimedModuleIO(user.getRole());
        try {
            for (ClaimedModule m : claim.getClaimedModules()){
                try{
                    moduleIO.insert(m);
                }catch (Exception ex){
                    //ex.printStackTrace();
                }
            }
            if (submit) {
				Email.send(user.getEmail(), "Claim#:" + claim.getClaimID(), "This claim was successfully submitted.");
				claim.setStatus(Claim.Status.PRELIMINARY);
            } else {
				claim.setStatus(Claim.Status.DRAFT);
            }
            claimIO.update(claim);
        } catch (SQLException ex) {
            Logger.getLogger(UpdatePrevClaimServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return claim;
    }
}
