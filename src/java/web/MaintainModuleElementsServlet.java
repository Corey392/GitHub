package web;

import data.CriterionIO;
import data.ElementIO;
import domain.Element;
import domain.Module;
import domain.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Collections;
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
 * Process requests for Clerical Admin's ModuleElement maintenance page.
 * @author Adam Shortall, Bryce Carr
 * @version 1.030
 * Created:	Unknown
 * Modified:	24/04/2013
 * Change Log:	08/04/2013: Bryce Carr:	Removed code to account for removal of field moduleID in DB's Criterion table.
 *		24/04/2013: Bryce Carr:	Added header comments to match code conventions.
 *		06/05/2013: Bryce Carr: Implemented element deletion.
 */
public class MaintainModuleElementsServlet extends HttpServlet {

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
            String url = RPLPage.MAINTAIN_MODULE_ELEMENTS.relativeAddress;
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            Module selectedModule = (Module) session.getAttribute("selectedModule");
            
            ElementIO elementIO = new ElementIO(user.role);
            
            // Parameters from jsp:
            String addNewElement = request.getParameter("addNewElement");
            String newElementText = request.getParameter("newElementText");
            String updateElementID = Util.getPageStringID(request, "updateElementID");
            String removeElementID = Util.getPageStringID(request, "removeElementID");
            String addCriteriaElementID = Util.getPageStringID(request, "addCriteriaElementID"); 
            String back = request.getParameter("backToMaintainModuleServlet");
            
            // Event handling:
            if (addNewElement != null) {
                Element newElement = new Element();
                newElement.setDescription(newElementText.trim());
                newElement.setModuleID(selectedModule.getModuleID());
                try {
                    elementIO.insert(newElement);
                } catch (SQLException ex) {
                    Logger.getLogger(MaintainModuleElementsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else if (updateElementID != null) {
                Element elementToUpdate = elementIO.getByID(selectedModule.getModuleID(), Integer.parseInt(updateElementID));
                elementToUpdate.setDescription(request.getParameter("updateElementText:"+updateElementID).trim());
                try {
                    elementIO.update(elementToUpdate);
                } catch (SQLException ex) {
                    Logger.getLogger(MaintainModuleElementsServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                request.setAttribute("elementUpdateMessage", "Element successfully updated");
            } else if (removeElementID != null) {
		try {
		    Element deleteElement = elementIO.getByID(selectedModule.getModuleID(), Integer.valueOf(removeElementID));
		    elementIO.delete(deleteElement);
		} catch (SQLException ex)   {
		    Logger.getLogger(MaintainModuleElementsServlet.class.getName()).log(Level.SEVERE, null, ex);
		}
            } else if (addCriteriaElementID != null) {
                Element selectedElement = elementIO.getByID(selectedModule.getModuleID(), Integer.parseInt(addCriteriaElementID));
                CriterionIO criterionIO = new CriterionIO(user.role);
                selectedElement.setCriteria(criterionIO.getList(selectedElement.getElementID(), selectedModule.getModuleID()));
                session.setAttribute("selectedElement", selectedElement);
                
                url = RPLServlet.MAINTAIN_ELEMENT_CRITERIA_SERVLET.relativeAddress;
            } else if (back != null) {
                url = RPLServlet.MAINTAIN_MODULE_SERVLET.relativeAddress;
            }
            
            selectedModule.setElements(elementIO.getList(selectedModule.getModuleID()));
            Collections.sort(selectedModule.getElements());
            
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
