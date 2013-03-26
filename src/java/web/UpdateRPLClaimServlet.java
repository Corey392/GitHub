package web;

import data.ClaimIO;
import data.ClaimRecordIO;
import data.ClaimedModuleIO;
import data.ProviderIO;
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
 * Handles the adding and removing of modules from a RPL claim.
 * @author Adam Shortall, James Purves
 */
public class UpdateRPLClaimServlet extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Initialises all variables as null.
        Claim claim = null;
        ArrayList<Module> modules = null;
        ArrayList<Provider> providers = null;
        Module selectedModule = null;
        ArrayList<Provider> selectedProviders = null;
        Integer addEvidenceTo = null;
        Integer remove = null;
        
        // Initialises the url for the next page as an empty string, and gets 
        // the session and the current user.
        String url = "";
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Gets the current claim from the session.
        claim = (Claim) session.getAttribute("claim");
        
        // Initialises the module and provider lists, as well as retrieveing the
        // selectedModule.
        modules = this.initialiseModuleList(user, claim);
        providers = this.initialiseProviderList(user);
        selectedModule = this.getSelectedModule(request, user, modules);

        // If the request came from the reviewClaimRPL page then depending on 
        // the button pressed the claim will be submitted, a module will be 
        // added or removed, or the request will be sent to the 
        // AddEvidenceServlet with the selected module as an attribute.
        if (request.getParameter("submitClaim") != null) {
            claim = this.submitClaim(user, claim);
            url = RPLServlet.LIST_CLAIMS_STUDENT_SERVLET.relativeAddress;
        } else if (request.getParameter("addModule") != null) {
            selectedProviders = this.getSelectedProviders(request, providers);
            if (selectedProviders.size() < 1 || selectedProviders.size() > 3){
                request.setAttribute("moduleError", 
                        new RPLError("Please select 1-3 providers"));
                url = RPLPage.REVIEW_CLAIM_RPL.relativeAddress;
            } else {
                claim = this.addModule(claim, user, selectedModule, 
                    selectedProviders);
                modules = this.initialiseModuleList(user, claim);
                url = RPLPage.REVIEW_CLAIM_RPL.relativeAddress;
            }
        } else if (request.getParameter("removeModule") != null) {
            remove = this.getSelectedRadioButton(request);
            if (remove != null){
                claim = this.removeModule(claim, user, remove);
            } else {
                request.setAttribute("selectError", 
                        new RPLError("Please select a module using the radio "
                        + "button beside it."));
            }
            modules = this.initialiseModuleList(user, claim);
            url = RPLPage.REVIEW_CLAIM_RPL.relativeAddress;
        } else if (request.getParameter("editEvidence") != null) {
            addEvidenceTo = this.getSelectedRadioButton(request);
            if (addEvidenceTo != null){
                request.setAttribute("addEvidenceTo", addEvidenceTo);
            } else {
                request.setAttribute("selectError", 
                        new RPLError("Please select a module using the radio "
                        + "button beside it."));
            }
            url = RPLServlet.ADD_EVIDENCE_SERVLET.relativeAddress;
        } else if (request.getParameter("back") != null) {
            url = RPLServlet.LIST_CLAIMS_STUDENT_SERVLET.relativeAddress;
        } else {
            RPLError error = (RPLError) request.getAttribute("moduleError");
            if (error != null){
                request.setAttribute("moduleError", error);
            }
            url = RPLPage.REVIEW_CLAIM_RPL.relativeAddress;
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
     * @param selectedProviders the providers for the module
     * @return the updated claim
     */
    private Claim addModule(Claim claim, User user, Module selectedModule, 
            ArrayList<Provider> selectedProviders){
        ClaimedModuleIO claimedModuleIO = new ClaimedModuleIO(user.role);
        ClaimRecordIO claimRecordIO = new ClaimRecordIO(user.getRole());    // Kyoungho Lee
        ClaimedModule claimedModule = new ClaimedModule();
        claimedModule.setClaimID(claim.getClaimID());
        claimedModule.setStudentID(user.getUserID());
        claimedModule.setModuleID(selectedModule.getModuleID());
        claimedModule.setName(selectedModule.getName());
        claimedModule.setElements(selectedModule.getElements());
        claimedModule.setProviders(selectedProviders);
        ArrayList<ClaimedModule> claimedModules = claim.getClaimedModules();
        claimedModules.add(claimedModule);
        claim.setClaimedModules(claimedModules);
        try {
            claimedModuleIO.insert(claimedModule);
            for (Provider provider : selectedProviders){
                claimedModuleIO.addProvider(user.getUserID(), 
                        claim.getClaimID(), claimedModule.getModuleID(), 
                        provider.getProviderID());
            }
        } catch (SQLException ex) {
            Logger.getLogger(UpdateRPLClaimServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        try {
            claimRecordIO.insert(new ClaimRecord(claim.getClaimID(), claim.getStudentID(), 0, user.getUserID(), "", 2, 0, claim.getCampusID(), claim.getCourseID(), claim.getClaimType().desc)); //  Update - Kyoungho Lee
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
            Logger.getLogger(UpdateRPLClaimServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        claim.setClaimedModules(claimedModules);
        
        try {
            claimRecordIO.insert(new ClaimRecord(claim.getClaimID(), claim.getStudentID(), 0, user.getUserID(), "", 2, 0, claim.getCampusID(), claim.getCourseID(), claim.getClaimType().desc)); //  Update - Kyoungho Lee
        } catch (SQLException ex) {
            Logger.getLogger(UpdatePrevClaimServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
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
     * Gets the radio button that is selected on the form. This is used to 
     * determine which module the user wants to remove or add/edit evidence for.
     * @param request the request
     * @return the selected radio button
     */
    private Integer getSelectedRadioButton(HttpServletRequest request) {
        Integer selectedRadioButton;
        String selectedRadioButtonIDX = request.getParameter("radio");
        if (selectedRadioButtonIDX == null){
            selectedRadioButton = null;
        } else {
            int index = Integer.valueOf(selectedRadioButtonIDX);
            selectedRadioButton = new Integer(index);
        }
        return selectedRadioButton;
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
     * Changes the status of the claim in the database to submitted. Which flags
     * it as ready to be assessed by a teacher.
     * @param user the current user
     * @param claim the current claim
     * @return the modified claim
     */
    private Claim submitClaim(User user, Claim claim) {
        ClaimIO claimIO = new ClaimIO(user.getRole());
        ClaimRecordIO claimRecordIO = new ClaimRecordIO(user.getRole());    // Kyoungho Lee
        claim.setStatus(Claim.Status.SUBMITTED);
        try {
            claimIO.update(claim);
            claimRecordIO.insert(new ClaimRecord(claim.getClaimID(), claim.getStudentID(), 0, user.getUserID(), "", 2, 0, claim.getCampusID(), claim.getCourseID(), claim.getClaimType().desc)); // Kyoungho Lee
            Email.send(user.getEmail(), "Cliam#:" + claim.getClaimID(), "This claim is successfully updated!!");
        } catch (SQLException ex) {
            Logger.getLogger(UpdateRPLClaimServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        return claim;
    }
}
