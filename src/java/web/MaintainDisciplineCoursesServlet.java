/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import data.CourseIO;
import data.DisciplineIO;
import domain.Campus;
import domain.Course;
import domain.Discipline;
import domain.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
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
 *
 * @author Adam Shortall
 */
public class MaintainDisciplineCoursesServlet extends HttpServlet {

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
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            String url = RPLPage.CLERICAL_DISCIPLINE_COURSES.relativeAddress;
            
            CourseIO courseIO = new CourseIO(user.role);
                
            Campus selectedCampus = (Campus) session.getAttribute("selectedCampus");
            Discipline selectedDiscipline = (Discipline) session.getAttribute("selectedDiscipline");
            
            if (selectedCampus == null || selectedDiscipline == null) {
                url = RPLServlet.MAINTAIN_TABLE_SERVLET.relativeAddress;
            }
            
            // Get user input:
            String addCourseToDiscipline = request.getParameter("addCourseToDiscipline");
            String modifyElectivesCourseID = Util.getPageStringID(request, "modifyElectivesCourseID");
            String modifyCoresCourseID = Util.getPageStringID(request, "modifyCoresCourseID");
            String removeCourseFromDisciplineID = request.getParameter("removeCourseFromDiscipline");
            String back = request.getParameter("back");
            DisciplineIO disciplineIO = new DisciplineIO(user.role);

            // Event handling:
            if (addCourseToDiscipline != null) {
                String selectedCourseID = request.getParameter("selectedCourse");                
                try {
                    disciplineIO.addCourse(selectedCampus.getCampusID(), selectedDiscipline.getDisciplineID(), selectedCourseID);
                } catch (SQLException ex) {
                    Logger.getLogger(MaintainDisciplineCoursesServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else if (modifyElectivesCourseID != null) {
                Course course = Util.getCourseWithModules(selectedCampus.getCampusID(), selectedDiscipline.getDisciplineID(), modifyElectivesCourseID, user.role);
                session.setAttribute("selectedCourse", course);
                url = RPLServlet.MAINTAIN_COURSE_ELECTIVES_SERVLET.relativeAddress;
            } else if (modifyCoresCourseID != null) {
                Course course = Util.getCourseWithModules(selectedCampus.getCampusID(), selectedDiscipline.getDisciplineID(), modifyCoresCourseID, user.role);
                session.setAttribute("selectedCourse", course);
                url = RPLServlet.MAINTAIN_CORE_MODULES_SERVLET.relativeAddress;
            } else if (removeCourseFromDisciplineID != null) {
                try {
                    disciplineIO.removeCourse(selectedCampus.getCampusID(), selectedDiscipline.getDisciplineID(), removeCourseFromDisciplineID);
                } catch (SQLException ex) {
                    Logger.getLogger(MaintainDisciplineCoursesServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            } else if (back != null) {
                request.setAttribute("selectedDiscipline", selectedDiscipline);
                url = RPLServlet.MAINTAIN_CAMPUS_DISCIPLINE_SERVLET.relativeAddress;          
            }
            
            // Get courses in selected CampusDiscipline:
            courseIO = new CourseIO(user.role);
            ArrayList<Course> courses = courseIO.getList(selectedCampus.getCampusID(), selectedDiscipline.getDisciplineID());
            Collections.sort(courses);
            selectedDiscipline.setCourses(courses);            
            
            // Get courses not in selected CampudDiscipline:
            courses = courseIO.getListNotInDiscipline(selectedCampus.getCampusID(), selectedDiscipline.getDisciplineID());
            Collections.sort(courses);
            request.setAttribute("courses", courses);
            
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
