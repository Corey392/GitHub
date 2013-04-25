package web;

import data.*;
import domain.*;
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
import util.*;

/**
 * Handles the adding and removing of modules from a Previous Studies claim as 
 * well as the adding and editing of evidence for the modules.
 * @author James Purves
 */
public class UpdatePrevClaimServlet extends HttpServlet {
    
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Gets the session and the current user.
        String url;
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Gets the current claim from the session.
        Claim claim = (Claim) session.getAttribute("claim");
        
        // Initialises the module and provider lists, as well as retrieveing the
        // selectedModule and the evidence for each claimed module.
        ArrayList<Module> modules = this.initialiseModuleList(user, claim);
        ArrayList<Provider> providers = this.initialiseProviderList(user);
        Module selectedModule = this.getSelectedModule(request, user, modules);
        ArrayList<Evidence> evidence = this.getEvidence(request, user, claim, selectedModule); 

        // If the request came from the reviewClaimPrev jsp page then depending
        // on the button pressed new or updated evidence will be saved, the 
        // claim will be submitted, or a module will be added or removed. The 
        // url is set to point back to the reviewClaimPrev page unless the claim
        // was submitted or the user clicked back, in which case the url is set 
        // to the ListClaimsServlet.
        if (request.getParameter("saveEvidence") != null) {
            claim = this.setEvidence(request, user, claim);
            url = RPLPage.REVIEW_CLAIM_PREV.relativeAddress;
        } else if (request.getParameter("submitClaim") != null) {
            claim = this.setEvidence(request, user, claim);
            claim = this.submitClaim(user, claim);
            url = RPLServlet.LIST_CLAIMS_STUDENT_SERVLET.relativeAddress;
        } else if (request.getParameter("addModule") != null) {
            ArrayList<Provider> selectedProviders = this.getSelectedProviders(request, providers);
            if (selectedProviders.size() < 1 || selectedProviders.size() > 3){
                request.setAttribute("moduleError", 
                        new RPLError("Please select 1-3 providers"));
                url = RPLPage.REVIEW_CLAIM_PREV.relativeAddress;
            } else {
                claim = this.addModule(claim, user, selectedModule, evidence, 
                    selectedProviders);
                modules = this.initialiseModuleList(user, claim);
                url = RPLPage.REVIEW_CLAIM_PREV.relativeAddress;
            }
        } else if (request.getParameter("removeModule") != null) {
            String remove = request.getParameter("removeModule");

            if (remove != null){
                claim = this.removeModule(claim, user, Integer.valueOf(remove));
            } else {
                request.setAttribute("selectError", 
                        new RPLError("Please select a module using the radio "
                        + "button beside it."));
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
     * @param evidence the evidence provided for the selected module
     * @param selectedProviders the providers for the module
     * @return the updated claim
     */
    private Claim addModule(Claim claim, User user, Module selectedModule, 
            ArrayList<Evidence> evidence, 
            ArrayList<Provider> selectedProviders){
        ClaimedModuleIO claimedModuleIO = new ClaimedModuleIO(user.role);
        EvidenceIO evidenceIO = new EvidenceIO(user.role);
        ClaimedModule claimedModule = new ClaimedModule();
        claimedModule.setClaimID(claim.getClaimID());
        claimedModule.setStudentID(user.getUserID());
        claimedModule.setModuleID(selectedModule.getModuleID());
        claimedModule.setName(selectedModule.getName());
        claimedModule.setElements(selectedModule.getElements());
        claimedModule.setEvidence(evidence);
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
            evidenceIO.insert(evidence.get(0));
        } catch (SQLException ex) {
            Logger.getLogger(UpdatePrevClaimServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return claim;
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
        ClaimRecordIO claimRecordIO = new ClaimRecordIO(user.getRole());    // Kyoungho Lee
        ArrayList<ClaimedModule> claimedModules = claim.getClaimedModules();
        ClaimedModule removed = claimedModules.remove(selectedModule.intValue());
        try {
            claimedModuleIO.delete(removed);
        } catch (SQLException ex) {
            Logger.getLogger(UpdatePrevClaimServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        try {
            claimRecordIO.insert(new ClaimRecord(claim.getClaimID(), claim.getStudentID(), 0, user.getUserID(), "", 2, 0, claim.getCampusID(), claim.getCourseID(), claim.getClaimType().desc)); //  Update - Kyoungho Lee
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
    private Module getSelectedModule(HttpServletRequest request, User user, 
            ArrayList<Module> modules) {
        Module selectedModule;
        String moduleIDX = request.getParameter("module");
        if (moduleIDX == null){
            selectedModule = new Module();
        } else {
            int index = Integer.valueOf(moduleIDX);
            Module module = modules.get(index);
            selectedModule = Util.getCompleteModule(module.getModuleID(), 
                    user.getRole());
        }
        return selectedModule;
    }
    
    /**
     * Gets the providers selected by the user.
     * @param request the request
     * @param providers the list of providers to get the selected providers from
     * @return the selected providers
     */
    private ArrayList<Provider> getSelectedProviders(HttpServletRequest request, 
            ArrayList<Provider> providers) {
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
     * Gets the evidence for the module to be added to the claim.
     * @param request the request
     * @param user the current user
     * @param claim the current claim
     * @param selectedModule the selected module
     * @return the evidence array
     */
    private ArrayList<Evidence> getEvidence(HttpServletRequest request, 
            User user, Claim claim, Module selectedModule) {
        ArrayList<Evidence> evidence;
        String evidenceDesc = request.getParameter("evidence");
        if (evidenceDesc == null){
            evidence = new ArrayList<Evidence>();
        } else {
            evidence = new ArrayList<Evidence>();
            evidence.add(new Evidence(claim.getClaimID(), 
                    selectedModule.getModuleID(), evidenceDesc));
        }
        return evidence;
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
        
        if ((campusID == null || campusID.equals("")) || disciplineID == 0 
                || (courseID == null || courseID.equals(""))){
            modules = new ArrayList<Module>();
        } else {
            Course currentCourse = Util.getCompleteCourse(courseID, 
                    user.getRole(), campusID, disciplineID);
            modules = currentCourse.getAllModules();
            ArrayList<ClaimedModule> claimedModules = claim.getClaimedModules();
            for (ClaimedModule cm : claimedModules){
                for (int i = 0; i < modules.size(); i++){
                    if (modules.get(i).getModuleID().equals(cm.getModuleID())){
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
     * Saves the evidence for all claimed modules to the database. Only used
     * when the user clicks the saveEvidence button.
     * @param request the request
     * @param user the current user
     * @param claim the current claim
     * @return the updated claim
     */
    private Claim setEvidence(HttpServletRequest request, User user, Claim claim) {
        EvidenceIO evidenceIO = new EvidenceIO(user.role);
        ClaimRecordIO claimRecordIO = new ClaimRecordIO(user.getRole());    // Kyoungho Lee
        ArrayList<ClaimedModule> claimedModules = claim.getClaimedModules();
        ArrayList<ClaimedModule> newClaimedModules = new ArrayList<ClaimedModule>();
        ArrayList<Evidence> newEvidence = new ArrayList<Evidence>();
        for (ClaimedModule cm : claimedModules){
            String evidenceDesc = request.getParameter(cm.getModuleID());
            if (evidenceDesc != null){
                newEvidence.add(  
                        new Evidence( 
                            claim.getClaimID(), 
                            cm.getModuleID(), 
                            evidenceDesc));
                cm.setEvidence(newEvidence);
                try {
                    evidenceIO.update(newEvidence.get(0));
                } catch (SQLException ex) {
                    Logger.getLogger(UpdatePrevClaimServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            newClaimedModules.add(cm);
        }
        /*try {
            claimRecordIO.insert(new ClaimRecord(claim.getClaimID(), claim.getStudentID(), 0, user.getUserID(), "", 2, 0, claim.getCampusID(), claim.getCourseID(), claim.getClaimType().desc)); //  Update - Kyoungho Lee
        } catch (SQLException ex) {
            Logger.getLogger(UpdatePrevClaimServlet.class.getName()).log(Level.SEVERE, null, ex);
        }*/
        //TODO: The above should be uncommented when ClaimRecordIO has been updated, assuming it will be implemented
        claim.setClaimedModules(newClaimedModules);
        return claim;
    }
    
    /**
     * Changes the status of the claim in the database to submitted. Which flags
     * it as ready to be assessed by a teacher.
     * @param user the current user
     * @param claim the current claim
     * @return the modified claim
     */
    private Claim submitClaim(User user, Claim claim) {
        ClaimIO claimIO = new ClaimIO(user.getRole());
        //ClaimRecordIO claimRecordIO = new ClaimRecordIO(user.getRole());    // Kyoungho Lee
        claim.setStatus(Claim.Status.SUBMITTED);
        try {
            claimIO.update(claim);
            //claimRecordIO.insert(new ClaimRecord(claim.getClaimID(), claim.getStudentID(), 0, user.getUserID(), "", 2, 0, claim.getCampusID(), claim.getCourseID(), claim.getClaimType().desc)); // Update - Kyoungho Lee
            //TODO: The above should be uncommented when ClaimRecordIO has been updated, assuming it will be implemented
            Email.send(user.getEmail(), "Cliam#:" + claim.getClaimID(), "This claim is successfully updated!!");
        } catch (SQLException ex) {
            Logger.getLogger(UpdatePrevClaimServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return claim;
    }
}
