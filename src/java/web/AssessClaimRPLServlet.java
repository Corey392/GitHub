package web;

import data.ClaimIO;
import domain.*;
import domain.User.Role;
import java.io.IOException;
import java.sql.SQLException;
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
 *
 * @author David, Mitchell Carr
 * Changelog:   06/05/2013 MC: updated approveClaim to update claim status
 */
public class AssessClaimRPLServlet extends HttpServlet implements SingleThreadModel {

    HttpSession session;
    User user;
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
       
        // If User came from ListClaims Page
        if (rpath.equalsIgnoreCase(RPLPage.LIST_CLAIMS_TEACHER.relativeAddress)) {
            String ccmd = request.getParameter("ccmd");
 System.out.println("ccmd=" + ccmd);            
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

                    String[] studentIDArray = request.getParameterValues("studentID");
                    String studentID = "";
                    for (int i = 0; i < studentIDArray.length; i++) {
                        String delim = ":";
                        String[] temp = studentIDArray[i].split(delim);
                        if (temp[1].equalsIgnoreCase(selectedClaimID)) {
                            studentID = temp[0];
                        }

                    }
                    Claim claim = Util.getCompleteClaim(studentID, claimID, user.role);
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
                String studentID = request.getParameter("studentID");
                Claim claim = Util.getCompleteClaim(studentID, claimID, user.role);
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
        // If User came from assessClaimPrev or assessClaimRPL Page    
            String moduleID = Util.getPageStringID(request, "evid");
            // If "View Evidence" Button clicked
            if (!(moduleID == null || moduleID.isEmpty())) {
                
                request.removeAttribute("rpath");
                String claimID = request.getParameter("claimID");
                String studentID = request.getParameter("studentID");
                //rpath = RPLServlet.ASSESS_CLAIM_RPL_SERVLET.relativeAddress;
                //Mitchell: I can't see any reason for the above statement to exist,
                //so I've commented it out for the time being
                
                url = RPLServlet.VIEW_EVIDENCE_SERVLET.relativeAddress;
                request.setAttribute("claimID", claimID);
                request.setAttribute("studentID", studentID);
                request.setAttribute("moduleID", moduleID);
                request.setAttribute("rpath", moduleID);
                RequestDispatcher dispatcher = request.getRequestDispatcher(url);
                dispatcher.forward(request, response);
            } else {
            // else "Approve Claim", "Approve Selected" or "Back" button clicked
                String action = request.getParameter("cmd");
                request.getParameterValues(action);

                int claimID = Integer.parseInt(request.getParameter("claimID"));
                String studentID = request.getParameter("studentID");
                Claim claim = Util.getCompleteClaim(studentID, claimID, user.role);

                url = getForwardURLForClaimType(claim);

                if (action.equals("Approve Claim")) {
                    approveClaim(request, response, claim);
                } else if (action.equals("Approve Selected")) {
                    approveSelected(request, response, claim);
                } else if (action.equals("Print Claim")) {
                    printClaim(request, response, claim);
                } else if (action.equals("Back")) {
                    url = RPLServlet.VIEW_TEACHER_CLAIM_SERVLET.relativeAddress;
                } else {
                    throw new ServletException("Cannot process Action.");
                }
                request.setAttribute("claim", claim);
                RequestDispatcher dispatcher = request.getRequestDispatcher(url);
                dispatcher.forward(request, response);
            }
        } else if (rpath.equalsIgnoreCase(RPLPage.EVIDENCE_UPDATED_PAGE.relativeAddress)) {
            String studentID = request.getParameter("studentID");
            int claimID = Integer.parseInt(request.getParameter("claimID"));
            
            Claim claim = Util.getCompleteClaim(studentID, claimID, user.role);
            url = getForwardURLForClaimType(claim);
            request.setAttribute("claim", claim);
            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        }
    }
    
    /**
     * approveClaim Method is called when an Assessor or Delegate wishes to approve
     * a claim. The claim's 'Assessor Approved' and 'Delegate Approved' fields will
     * be set depending on the User's ID and whether they are the designated Assessor,
     * Delegate, or both. Each of the claimed modules are then set then set to approved.
     * @param request
     * @param response
     * @param url the url to forward to after processing
     */
    public void approveClaim(HttpServletRequest request, HttpServletResponse response, Claim claim) {
        ClaimIO cIO = new ClaimIO(Role.TEACHER);
        String userID = user.getUserID();
        if (claim.getAssessorID() != null) {
            if (claim.getAssessorID().equals(userID)) {
                claim.setAssessorApproved(Boolean.TRUE);
            }
        }
        if (claim.getDelegateID() != null) {
            if (claim.getDelegateID().equals(userID)) {
            claim.setDelegateApproved(Boolean.TRUE);
            }
        }
        
        for (ClaimedModule claimedModule: claim.getClaimedModules()) {
            claimedModule.setApproved(true);
            for (Evidence e: claimedModule.getEvidence()) {
                e.setApproved(true);
            }
        }
        claim.setStatus(Claim.Status.APPROVED);
        try {
            cIO.update(claim);
        }
        catch(SQLException SQLex) {
            SQLex.getMessage();
        }
    }
    
    public void approveSelected(HttpServletRequest request, HttpServletResponse response, Claim claim) {
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
        }
        catch(SQLException SQLex) {
            SQLex.getMessage();
        }
    }
    
    public void printClaim(HttpServletRequest request, HttpServletResponse response, Claim claim) {
        //TODO: Print Claim Method
    }
    
    /**
     * Sets and gets URL based on Claim Type.
     * @param url
     * @return 
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
