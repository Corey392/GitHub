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
import util.RPLServlet;
import util.Util;

/**
 *
 * @author Adam Shortall, Bryce Carr
 * @version 1.001
 * Created:	Unknown
 * Modified:	28/04/2013
 * 
 * Changelog:	28/04/2013: BC:	Re-implemented file in project by uncommenting it, fixed a couple of minor things like a servlet address and a method call
 *		29/04/2013: BC:	Fixed session.getAttribute() call for selectedCourse. Requests the right attribute now. Might be worth using enums for that kind of thing.
 *				Fixed 'back' button.
 *		30/04/2013: BC:	Actually properly fixed 'back' button.
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
            ArrayList<Module> modules;
            Campus selectedCampus = (Campus)session.getAttribute("selectedCampus");
            Discipline selectedDiscipline = (Discipline)session.getAttribute("selectedDiscipline");
            Course selectedCourse = (Course)session.getAttribute("selectedCourse");
            
            // Get selectedCampusID & selectedDisciplineID from jsp
            String selectedCampusID = selectedCampus.getCampusID();
            int selectedDisciplineID = selectedDiscipline.getDisciplineID();
            
            
            // Now get electives & cores for the selected course
            selectedCourse = Util.getCourseWithModules(selectedCampusID, selectedDisciplineID, selectedCourse.getCourseID(), User.Role.ADMIN);
            request.setAttribute("course", selectedCourse);
            
            // Now get/set the list of modules to display
            modules = moduleIO.getListNotInCourse(selectedCourse.getCourseID());
            request.setAttribute("modules", modules);
            
	    // Now get IDs of modules to remove (if any)
            String removeCoreID = Util.getPageStringID(request, "removeCore");
            String removeElectiveID = Util.getPageStringID(request, "removeElective");
	    // Now get IDs of modules to add (if any)
	    String addCoreID = Util.getPageStringID(request, "addCore");
	    String addElectiveID = Util.getPageStringID(request, "addElective");
	    
	    if (request.getParameter("back") != null)	{
		url = RPLPage.CLERICAL_DISCIPLINE_COURSES.relativeAddress;
		//request.setAttribute("back", null); // don't know why I have to do this but it persists otherwise and just keeps going back
		request.setAttribute("courses", courseIO.getList(selectedCampusID, selectedDisciplineID));
	    } else  {
		url = RPLPage.CLERICAL_COURSE_MODULES.relativeAddress;
	    }
            /**
             * Request parameters that can get here:
             * addCore (button)
             * addElective (button)
             * removeCore:${moduleID} (button)
             * removeElective:${moduleID} (button)
             */
            if (addCoreID != null) {
                request = this.addCoreModule(request);
            }

            if (addElectiveID != null) {
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
	//TODO: addCoreModule
        return request;
    }

    private HttpServletRequest addElectiveModule(HttpServletRequest request) {
	//TODO: addElectiveModule
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
