/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import data.CriterionIO;
import domain.Criterion;
import domain.Element;
import domain.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
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
 * @author Adam Shortall
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
                c.setModuleID(selectedElement.getModuleID());
                c.setDescription(updateCriterionText);
                try {
                    criterionIO.update(c);
                    request.setAttribute("criterionUpdateMessage", "Criterion successfully updated");
                } catch (SQLException ex) {
                    Logger.getLogger(MaintainElementCriteria.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else if (deleteCriterionID != null) {
                // TODO: delete criterion
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
