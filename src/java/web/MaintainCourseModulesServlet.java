package web;

import data.CampusIO;
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
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.RPLPage;
import util.Util;

/**
 *
 * @author Adam Shortall, Bryce Carr
 * @version 1.001
 * Created:	Unknown
 * Modified:	28/04/2013
 * 
 * Changelog:	28/04/2013: BC:	Re-implemented file in project by uncommenting it, fixed a couple of minor things like a servlet address and a method call
 */
public class MaintainCourseModulesServlet extends HttpServlet {

    
    
//    /**
//     * Sets variables for every processRequest
//     */
//    private void initialise() {
//        session = request.getSession();
//        user = (User) session.getAttribute("user");
//
//        campusIO = new CampusIO(user.role);
//        disciplineIO = new DisciplineIO(user.role);
//        courseIO = new CourseIO(user.role);
//        moduleIO = new ModuleIO(user.role);
//
//        // Initialize list of campuses
//        campuses = campusIO.getList();
//        campuses.add(0, new Campus());
//        request.setAttribute("campuses", campuses);
//    }
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
            
            CampusIO campusIO = new CampusIO(user.role);
            DisciplineIO disciplineIO = new DisciplineIO(user.role);
            CourseIO courseIO = new CourseIO(user.role);
            ModuleIO moduleIO = new ModuleIO(user.role);
            
            String url = RPLPage.CLERICAL_COURSE_MODULES.relativeAddress;
            ArrayList<Campus> campuses = campusIO.getList();
            campuses.add(0, new Campus());
            ArrayList<Module> modules;
            Campus selectedCampus;
            Discipline selectedDiscipline;
            Course selectedCourse;
            
            // Get selectedCampusID & selectedDisciplineID from jsp
            String selectedCampusID = request.getParameter("selectedCampus");
            String selectedDisciplineID = request.getParameter("selectedDiscipline");
            
            // Handle changing of campus drop-down box
            if (selectedCampusID != null) {
                selectedCampus = Util.getCampusWithDisciplinesAndCourses(selectedCampusID, user.role);
                selectedDiscipline = selectedCampus.getDisciplines().get(0);
            } else if (request.getAttribute("selectedCampus") != null) {
                selectedCampus = (Campus) request.getAttribute("selectedCampus");
            } else {    // Have never selected a campus in this request
                selectedCampus = campuses.get(0);
                selectedDiscipline = new Discipline();
            }
            
            // Handle changing of discipline drop-down box
            if (selectedDisciplineID != null) {
                int disciplineID = Integer.parseInt(selectedDisciplineID);
                selectedDiscipline = disciplineIO.getByID(disciplineID);
                request.setAttribute("selectedDiscipline", selectedDiscipline);
            } else {
                selectedDiscipline = selectedCampus.getDisciplines().get(0);       
            }
                        
            // Set the course that was selected for this page. If no course was
            // selected, send back to MaintainTableServlet
            selectedCourse = (Course) request.getAttribute("course");
            if (selectedCourse == null) {
                url = RPLPage.CLERICAL_MAINTENANCE_SELECT.relativeAddress;
                RequestDispatcher dispatcher = request.getRequestDispatcher(url);
                dispatcher.forward(request, response);
            }
            
            // Now get electives & cores for the selected course
            selectedCourse = Util.getCourseWithModules(selectedCampus.getCampusID(), selectedDiscipline.getDisciplineID(), url, User.Role.ADMIN);
            request.setAttribute("course", selectedCourse);
            
            // Now get/set the list of modules to display
            modules = moduleIO.getListNotInCourse(selectedCourse.getCourseID());
            request.setAttribute("modules", modules);
            
            String removeCoreID = Util.getPageStringID(request, "removeCore");
            String removeElectiveID = Util.getPageStringID(request, "removeElective");

            url = RPLPage.CLERICAL_COURSE_MODULES.relativeAddress;

            /**
             * Request parameters that can get here:
             * selectedCampus (drop down list)
             * selectedDiscipline (drop down list)
             * addCore (button)
             * addElective (button)
             * removeCore:${moduleID} (button)
             * removeElective:${moduleID} (button)
             */
            if (request.getParameter("addCore") != null) {
                request = this.addCoreModule(request);
            }

            if (request.getParameter("addElective") != null) {
                request = this.addElectiveModule(request);
            }
            if (removeCoreID != null) {
            }
            if (removeElectiveID != null) {
            }
            
            request.setAttribute("selectedCampus", selectedCampus);
            request.setAttribute("selectedDiscipline", selectedDiscipline);

            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        } finally {
            out.close();
        }
    }

    /**
     * A core module can be added so long as a module has been selected
     * from the drop-down list.
     * @param request
     * @return 
     */
    private HttpServletRequest addCoreModule(HttpServletRequest request) {
        String selectedModuleID = request.getParameter("selectedModule");

        return request;
    }

    private HttpServletRequest addElectiveModule(HttpServletRequest request) {

        return request;
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
