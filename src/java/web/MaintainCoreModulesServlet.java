/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
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
 * @author Adam Shortall
 */
public class MaintainCoreModulesServlet extends HttpServlet {

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
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            ModuleIO moduleIO = new ModuleIO(user.role);
            
            String backToDisciplineCourse = request.getParameter("backToDisciplineCourse");
            String backToCourse = request.getParameter("backToCourse");
            
            Course selectedCourse = (Course) request.getAttribute("selectedCourse");
            
            String addCoreModule = request.getParameter("addCoreModule");
            String removeAsCoreIndex = Util.getPageStringID(request, "removeAsCore");
            
            selectedCourse = (Course) session.getAttribute("selectedCourse");
                        
            // Event handling:
            if (addCoreModule != null) {
                String selectedCoreModuleID = request.getParameter("selectedCoreModule");
                try {
                    moduleIO.addCore(selectedCourse.getCourseID(), selectedCoreModuleID);
                    selectedCourse.getCoreModules().add(moduleIO.getByID(selectedCoreModuleID));
                    session.setAttribute("selectedCourse", selectedCourse);
                } catch (SQLException ex) {
                    Logger.getLogger(MaintainCoreModulesServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else if (removeAsCoreIndex != null) {
                Module module = selectedCourse.getCoreModules().get(Integer.parseInt(removeAsCoreIndex));
                try {
                    moduleIO.removeCore(selectedCourse.getCourseID(), module.getModuleID());                    
                    selectedCourse.getCoreModules().remove(module);
                } catch (SQLException ex) {
                    Logger.getLogger(MaintainCoreModulesServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else if (backToDisciplineCourse != null) {
                url = RPLServlet.MAINTAIN_DISCIPLINE_COURSES_SERVLET.relativeAddress;
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
