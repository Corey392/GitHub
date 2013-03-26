/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import data.ModuleIO;
import domain.Campus;
import domain.Course;
import domain.Discipline;
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
 * Maintenance/Data entry page for a campus' discipline's courses.
 * @author Adam Shortall
 */
public class MaintainCourseElectivesServlet extends HttpServlet {

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
            String url = RPLPage.CLERICAL_COURSE_ELECTIVES.relativeAddress;
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            ModuleIO moduleIO = new ModuleIO(user.role);
            
            String back = request.getParameter("backToDisciplineCourse");
            
            Campus selectedCampus = (Campus) session.getAttribute("selectedCampus");
            Discipline selectedDiscipline = (Discipline) session.getAttribute("selectedDiscipline");
            Course selectedCourse = (Course) session.getAttribute("selectedCourse");
                        
            String addElectiveModule = request.getParameter("addElectiveModule");
            String addElectiveModuleID = request.getParameter("selectedModule");
            String removeElectiveModuleID = Util.getPageStringID(request, "removeModuleAsElective");
                        
            String campusID = null;
            String courseID = null;
            Integer disciplineID = null;
                        
            if (selectedCampus == null || selectedDiscipline == null || selectedCourse == null) {
                url = RPLServlet.MAINTAIN_TABLE_SERVLET.relativeAddress;
            } else {
                campusID = selectedCampus.getCampusID();
                disciplineID = selectedDiscipline.getDisciplineID();
                courseID = selectedCourse.getCourseID();
            }
            
            // Event handling:
            if (campusID != null) {
                if (addElectiveModule != null) {
                    try {
                        moduleIO.addElective(campusID, disciplineID, courseID, addElectiveModuleID);                        
                    } catch (SQLException ex) {
                        Logger.getLogger(MaintainCoreModulesServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else if (removeElectiveModuleID != null) {
                    try {
                        moduleIO.removeElective(campusID, disciplineID, courseID, removeElectiveModuleID);                    
                    } catch (SQLException ex) {
                        Logger.getLogger(MaintainCoreModulesServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else if (back != null) {
                    url = RPLServlet.MAINTAIN_DISCIPLINE_COURSES_SERVLET.relativeAddress;
                }
            }
            
            selectedCourse = Util.getCourseWithModules(campusID, disciplineID, courseID, user.role);
            session.setAttribute("selectedCourse", selectedCourse);
                        
            ArrayList<Module> modules = moduleIO.getListNotInCourse(selectedCourse.getCourseID());
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
