package web;

import data.ModuleIO;
import domain.Course;
import domain.Module;
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
* Handles the Maintenance/Data-entry page for a course's core modules.
* @author Adam Shortall, Bryce Carr
* Created:	Unknown
* Modified:	04/05/2013
* Version:	1.010
* Changelog:	04/05/2013: Bryce Carr:	Deleted/modified code to fit its new context (as an extension to Maintain Course).
*					Implemented Core adding/removal.
*		05/05/2013: Bryce Carr:	Edited initialise() to reduce calls to database.
*/
public class MaintainCoreModulesServlet extends HttpServlet {
private HttpSession session;
    private User user;
    private ModuleIO moduleIO;
    Module selectedModule;
    Course selectedCourse;
    
    /**
     * Sets variables for every processRequest
     */
    private void initialise(HttpServletRequest request, HttpServletResponse response) {
        session = request.getSession();
        user = (User) session.getAttribute("user");

        moduleIO = new ModuleIO(user.role);
	// Assign moduleID to local variable before querying database (saves performing unnecessary database I/O)
	String selectedModuleID = request.getParameter("selectedModule");
	if (selectedModuleID == null)	{
	    selectedModuleID = Util.getPageStringID(request, "removeCore");
	}
	if (selectedModuleID != null)	{
	    selectedModule = moduleIO.getByID(selectedModuleID);
	} else	{
	    selectedModule = null;
	}
	selectedCourse = (Course)session.getAttribute("selectedCourse");
    }
    
    private void deInitialise()	{
	session = null;
	user = null;
	moduleIO = null;
	selectedModule = null;
	selectedCourse = null;
    }
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
            String url = RPLPage.CLERICAL_CORE_MODULES.relativeAddress;
            this.initialise(request, response);
            
            String backToCourse = request.getParameter("backToCourse");
            
            String addCoreModule = request.getParameter("addCoreModule");
            String removeAsCoreIndex = Util.getPageStringID(request, "removeAsCore");
                        
            // Event handling:
            if (addCoreModule != null) {
                String selectedCoreModuleID = request.getParameter("selectedCoreModule");
                try {
                    moduleIO.addCore(selectedCourse.getCourseID(), selectedCoreModuleID);
                    selectedCourse.getCoreModules().add(moduleIO.getByID(selectedCoreModuleID));
                    session.setAttribute("selectedCourse", selectedCourse);
                } catch (SQLException ex) {
                    Logger.getLogger(MaintainCoreModulesServlet.class.getName()).log(Level.SEVERE, null, ex);
		    //TODO: BRYCE: How to handle elective/core collisions? Trying to add a core when it's already an elective will be an issue when this is big.
                }
            } else if (removeAsCoreIndex != null) {
                Module module = selectedCourse.getCoreModules().get(Integer.parseInt(removeAsCoreIndex));
                try {
                    moduleIO.removeCore(selectedCourse.getCourseID(), module.getModuleID());
                    selectedCourse.getCoreModules().remove(module);
                } catch (SQLException ex) {
                    Logger.getLogger(MaintainCoreModulesServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else if (backToCourse != null) {
                url = RPLServlet.MAINTAIN_COURSE_SERVLET.relativeAddress;
            }
            
            ArrayList<Module> modules = moduleIO.getListNotCoreInCourse(selectedCourse.getCourseID());
            request.setAttribute("modules", modules);
            session.setAttribute("selectedCourse", selectedCourse);
            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
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