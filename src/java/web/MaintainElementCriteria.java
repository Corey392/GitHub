package web;

import data.CriterionIO;
import domain.Criterion;
import domain.Element;
import domain.User;
import java.io.IOException;
import java.io.PrintWriter;
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
import util.Util;

/**
 * Handles Maintenance/Data-entry page for adding criteria to an element.
 * @author Adam Shortall, Bryce Carr
 * @version 1.02
 * <b>Created:</b>  Unknown<br/>
 * <b>Modified:</b> 24/04/2013<br/>
 * <b>Change Log:</b>  08/04/2013:  Bryce Carr: Removed code to account for removal of field moduleID in DB's Criterion table.<br/>
 *                  24/04/2013: Bryce Carr: Added header comments to match code conventions.
 *                  05/05/2013: Mitch Carr: Implemented deleteCriterion segment of processRequest
 *		    07/05/2013:	Bryce Carr: Added arguments to a couple of method calls to use updated methods for adding Criteria.
 */
public class MaintainElementCriteria extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String url = RPLPage.MAINTAIN_ELEMENT_CRITERIA.relativeAddress;
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            Element selectedElement = (Element) session.getAttribute("selectedElement");
            
            CriterionIO criterionIO = new CriterionIO(user.role);
            
            // Parameters from the jsp:
            String addNewCriterion = request.getParameter("addNewCriterion");
            String updateCriterionID = Util.getPageStringID(request, "updateCriterionID");
            String deleteCriterionID = Util.getPageStringID(request, "deleteCriterionID");
            String backToModuleElementsServlet = request.getParameter("backToModuleElementsServlet");
            
            // Event handling:
            if (addNewCriterion != null) {
                String newCriterionText = request.getParameter("newCriterionText");
                Criterion criterion = new Criterion(selectedElement.getElementID(), selectedElement.getModuleID(), newCriterionText);
                try {
                    criterionIO.insert(criterion);
                } catch (SQLException ex) {
                    Logger.getLogger(MaintainElementCriteria.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else if (updateCriterionID != null) {
                String updateCriterionText = request.getParameter("updateCriterionText:" + updateCriterionID);
                Criterion c = new Criterion();
                c.setCriterionID(Integer.parseInt(updateCriterionID));
                c.setElementID(selectedElement.getElementID());
                c.setDescription(updateCriterionText);
                try {
                    criterionIO.update(c);
                    request.setAttribute("criterionUpdateMessage", "Criterion successfully updated");
                } catch (SQLException ex) {
                    Logger.getLogger(MaintainElementCriteria.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else if (deleteCriterionID != null) {
                int deleteID = Integer.parseInt(deleteCriterionID);
                ArrayList<Criterion> criterionArray =  criterionIO.getList(selectedElement.getElementID(), selectedElement.getModuleID());
                for (Criterion c : criterionArray){
                    if (c.getCriterionID() == deleteID){
                        try {
                            criterionIO.delete(c);
                        } catch (SQLException ex) {
                            Logger.getLogger(MaintainElementCriteria.class.getName()).log(Level.SEVERE, null, ex);
                        }
                        break;
                    }
                }
                
            } else if (backToModuleElementsServlet != null) {
                url = RPLServlet.MAINTAIN_MODULE_ELEMENTS_SERVLET.relativeAddress;
            }
            
            selectedElement.setCriteria(criterionIO.getList(selectedElement.getElementID(), selectedElement.getModuleID()));
            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request,response);
        } finally {            
            out.close();
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
