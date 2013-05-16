package web;

import data.ElementIO;
import data.EvidenceIO;
import domain.Claim;
import domain.ClaimedModule;
import domain.Evidence;
import domain.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.RPLPage;
import util.RPLServlet;
import util.Util;

/** @author     David, Mitch Carr, Todd Wiggins
 *  @version    1.030
 *	Created:    ?
 *	Change Log: 07/05/2013: TW: Updated to handle ArrayList<Evidence>
 *	Change Log: 16/05/2013: MC: Updated 'processRequest' to reflect changes to Util class
 */
public class ViewEvidenceServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User)session.getAttribute("user");
        String url;
        String rpath = request.getParameter("rpath"); // jsp path


        //If user came from AssessPrevClaim Page


        // If user came from viewEvidence Page
        if (rpath.equalsIgnoreCase(RPLPage.VIEW_EVIDENCE_PAGE.relativeAddress)) {
            //Get button pressed
            String action = request.getParameter("btn");

            int claimID = Integer.parseInt(request.getParameter("claimID"));
            String moduleID = request.getParameter("moduleID");
            //String studentID = request.getParameter("studentID");

            //Check button pressed
            if (action.equalsIgnoreCase("Approve Evidence")){
                String[] sv = request.getParameterValues("approved");
                if (sv != null) {
                    if (sv.length != 0) {
                        int[] selectedValues = new int[sv.length];
                        for (int i = 0; i < sv.length; i++) {
                            selectedValues[i] = Integer.parseInt(sv[i]);
                        }

                        EvidenceIO evidenceIO = new EvidenceIO(user.role);

                        for (int i = 0; i < selectedValues.length; i++) {
                            ArrayList<Evidence> evidence = Util.getCompleteEvidence(claimID, moduleID, user.role);
                            for (Evidence e : evidence) {
								e.setApproved(true);
							}
                            try {
                                evidenceIO.update(evidence);
                            } catch (SQLException sqlex) {
                                sqlex.getMessage();
                            }
                        }
                    }
                }
            } else if (action.equalsIgnoreCase("Back")) {
                url = RPLServlet.ASSESS_CLAIM_RPL_SERVLET.relativeAddress;
                RequestDispatcher dispatcher = request.getRequestDispatcher(url);
                dispatcher.forward(request, response);
            }

        } else if (rpath.equalsIgnoreCase(RPLPage.ASSESS_CLAIM_RPL.relativeAddress)) {
        // If user came from AssessRPLClaim Page
            //get request params
            int claimID = Integer.parseInt(request.getParameter("claimID"));
            
            String moduleID = Util.getPageStringID(request, "evid");
            Claim claim = Util.getCompleteClaim(claimID, user.role);

            ElementIO elementIO = new ElementIO(user.role);
            ClaimedModule claimedModule = new ClaimedModule();
            ArrayList<ClaimedModule> claimedModules = Util.getCompleteClaimedModuleList(claimID, user.role);
            for (ClaimedModule cm : claimedModules) {
                if (moduleID.equalsIgnoreCase(cm.getModuleID())) {
                    cm.setElements(elementIO.getList(moduleID));
                    claimedModule = cm;
                    String rpltype;
                    if (claim.getClaimType().desc.equalsIgnoreCase("Previous Studies")){
                        request.setAttribute("prevtype", "prevtype");
                    }

                    request.setAttribute("empt", "1");

                }
            }
            request.getServletContext();
            request.removeAttribute("rpath");
            url = RPLPage.VIEW_EVIDENCE_PAGE.relativeAddress;
            request.setAttribute("claimedModule", claimedModule);
            request.setAttribute("rpath", RPLServlet.VIEW_EVIDENCE_SERVLET.relativeAddress);

            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
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
