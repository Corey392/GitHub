package web;

import data.CourseIO;
import data.DisciplineIO;
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
 * @author Adam Shortall, Bryce Carr
 * @version 1.001
 * Created:	Unknown
 * Modified:	28/04/2013
 * 
 * Changelog:	28/04/2013: BC:	Commented out code relating to separate handling of Core and Elective management.
 *				Added code for unified handling of Module management.
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
            //String modifyElectivesCourseID = request.getParameter("modifyCourseElectives"); //TODO: BRYCE: Remove these lines once Module maintenance is implemented
            //String modifyCoresCourseID = request.getParameter("modifyCourseCores");
	    String modifyModulesCourseID = request.getParameter("modifyCourseModules");
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
            } else if (modifyModulesCourseID != null)	{
		Course course = Util.getCourseWithModules(selectedCampus.getCampusID(), selectedDiscipline.getDisciplineID(), modifyModulesCourseID, user.role);
                session.setAttribute("selectedCourse", course);
                url = RPLServlet.MAINTAIN_COURSE_MODULES_SERVLET.relativeAddress;
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
            
            // Get courses not in selected CampusDiscipline:
            courses = courseIO.getListNotInDiscipline(selectedCampus.getCampusID(), selectedDiscipline.getDisciplineID());
            Collections.sort(courses);
            request.setAttribute("courses", courses);
	    
	    // Get modules not in selected CampusDisciplineCourse:
            ModuleIO moduleIO = new ModuleIO(user.role);
	    if (session.getAttribute("selectedCourse") != null)	{
		String selectedCourseID = ((Course)session.getAttribute("selectedCourse")).getCourseID();
		ArrayList<Module> modules = moduleIO.getListNotInCourse(selectedCourseID);
	    }
	    
	    // Set variables for JSP
	    session.setAttribute("selectedCampus", selectedCampus);
	    session.setAttribute("selectedDiscipline", selectedDiscipline);
	    session.setAttribute("courses", courses);

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
