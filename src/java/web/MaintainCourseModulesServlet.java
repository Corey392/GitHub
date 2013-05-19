package web;

import data.CourseIO;
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
import util.Util;

/**
 * @author Adam Shortall, Bryce Carr, Mitch Carr
 * @version 1.020
 * Created:	Unknown
 * Modified:	03/05/2013
 * 
 * Changelog:	28/04/2013: BC:	Re-implemented file in project by uncommenting it, fixed a couple of minor things like a servlet address and a method call
 *		29/04/2013: BC:	Fixed session.getAttribute() call for selectedCourse. Requests the right attribute now. Might be worth using enums for that kind of thing.
 *				Fixed 'back' button.
 *		30/04/2013: BC:	Actually properly fixed 'back' button.
 *		03/05/2013: BC:	Really fixed it this time.
 *		04/05/2013: BC:	Module addition now implemented.
 *				Module removal now implemented.
 *				Removed unnecessary imports.
 *				Changed signature on deInitialise() (didn't actually need arguments)
 *		05/05/2013: BC:	Edited initialise() to reduce calls to database.
 *		19/05/2013: MC:	Updated initialise(); removed second parameter, since it was never used.
 */
public class MaintainCourseModulesServlet extends HttpServlet {
    private HttpSession session;
    private User user;
    private CourseIO courseIO;
    private ModuleIO moduleIO;
    Module selectedModule;
    Campus selectedCampus;
    Course selectedCourse;
    Discipline selectedDiscipline;
    
    /**
     * Sets variables for every processRequest.
     * @param request HTTP request containing properties needed to perform a subsequent operation in this class
     */
    private void initialise(HttpServletRequest request) {
        session = request.getSession();
        user = (User) session.getAttribute("user");

        courseIO = new CourseIO(user.role);
        moduleIO = new ModuleIO(user.role);
	// Assign moduleID to local variable before querying database (saves performing unnecessary database I/O)
	String selectedModuleID = request.getParameter("selectedModule");
	if (selectedModuleID == null)	{
	    selectedModuleID = Util.getPageStringID(request, "removeCore");
	    if (selectedModuleID == null)	{
		selectedModuleID = Util.getPageStringID(request, "removeElective");
	    }
	}
	if (selectedModuleID != null)	{
	    selectedModule = moduleIO.getByID(selectedModuleID);
	} else	{
	    selectedModule = null;
	}
	
	selectedCampus = (Campus)session.getAttribute("selectedCampus");
	selectedDiscipline = (Discipline)session.getAttribute("selectedDiscipline");
	selectedCourse = (Course)session.getAttribute("selectedCourse");
    }
    
    /**
     * Sets all of the servlet's field to null. Called after initialise and a subsequent call have executed.
     */
    private void deInitialise()	{
	session = null;
	user = null;
	courseIO = null;
	moduleIO = null;
	selectedModule = null;
	selectedCampus = null;
	selectedDiscipline = null;
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
            this.initialise(request);
            
            String url;            
            
            // Get selectedCampusID, selectedModuleID & selectedDisciplineID from jsp
            String selectedCampusID = selectedCampus.getCampusID();
            int selectedDisciplineID = selectedDiscipline.getDisciplineID();
	    String selectedModuleID = null;
	    if (selectedModule != null)	{
		selectedModuleID = selectedModule.getModuleID();
	    }
            
            // Now get electives & cores for the selected course
            selectedCourse = Util.getCourseWithModules(selectedCampusID, selectedDisciplineID, selectedCourse.getCourseID(), User.Role.ADMIN);
            request.setAttribute("course", selectedCourse);
            
            
	    // Now get IDs of modules to remove (if any)
            String removeCoreID = Util.getPageStringID(request, "removeCore");
            String removeElectiveID = Util.getPageStringID(request, "removeElective");
	    // Now get IDs of modules to add (if any)
	    String addCoreID = null;
	    String addElectiveID = null;

	    if (request.getParameter("addCore") != null)    {
		addCoreID = selectedModuleID;
	    } else if (request.getParameter("addElective") != null) {
		addElectiveID = selectedModuleID;
	    }
	    if (request.getParameter("back") != null)	{
		url = RPLPage.CLERICAL_DISCIPLINE_COURSES.relativeAddress;
		request.setAttribute("courses", courseIO.getList(selectedCampusID, selectedDisciplineID));
	    } else  {
		url = RPLPage.CLERICAL_COURSE_MODULES.relativeAddress;
	    }
            
	    // Now remove/add cores/electives
            if (addCoreID != null) {
                request = this.addCoreModule(request);
            } else if (addElectiveID != null) {
                request = this.addElectiveModule(request);
            } else if (removeCoreID != null) {
		request = this.removeCoreModule(request);
            } else if (removeElectiveID != null) {
		request = this.removeElectiveModule(request);
            }
            
	    // Set variables for displaying data on page
            request.setAttribute("selectedCampus", selectedCampus);
            request.setAttribute("selectedDiscipline", selectedDiscipline);
	    request.setAttribute("course", selectedCourse);
            // Now get/set the list of modules to display
            ArrayList<Module> modules = moduleIO.getListNotInCourse(selectedCourse.getCourseID());
            request.setAttribute("modules", modules);

            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        } catch (SQLException ex) {
	    Logger.getLogger(MaintainCourseModulesServlet.class.getName()).log(Level.SEVERE, null, ex);
	} finally {
            out.close();
	    this.deInitialise();
        }
    }

    /**
     * A core module can be added so long as a module has been selected
     * from the drop-down list.
     * @param request HTTP request to initialise
     * @return initialised HTTP request
     * @throws SQLException if the Core Module couldn't be added
     */
    private HttpServletRequest addCoreModule(HttpServletRequest request) throws SQLException {
        this.initialise(request);
	moduleIO.addCore(selectedCourse.getCourseID(), selectedModule.getModuleID());
	selectedCourse.getCoreModules().add(selectedModule);
        return request;
    }

    /**
     * An elective module can be added so long as a module has been selected
     * from the drop-down list.
     * @param request HTTP request to initialise
     * @return initialised HTTP request
     * @throws SQLException if the Elective Module couldn't be added
     */
    private HttpServletRequest addElectiveModule(HttpServletRequest request) throws SQLException {
	this.initialise(request);
	moduleIO.addElective(selectedCampus.getCampusID(), selectedDiscipline.getDisciplineID(), selectedCourse.getCourseID(), selectedModule.getModuleID());
	selectedCourse.getElectiveModules().add(selectedModule);
	
        return request;
    }
    
    /**
     * A core module can be to be removed.
     * @param request HTTP request to initialise
     * @return initialised HTTP request
     * @throws SQLException if the Core Module couldn't be removed
     */
    private HttpServletRequest removeCoreModule(HttpServletRequest request) throws SQLException {
        this.initialise(request);
	moduleIO.removeCore(selectedCourse.getCourseID(), selectedModule.getModuleID());
	selectedCourse.getCoreModules().remove(selectedModule);
        return request;
    }

    /**
     * An elective module can be to be removed.
     * @param request HTTP request to initialise
     * @return initialised HTTP request
     * @throws SQLException if the Elective Module couldn't be removed
     */
    private HttpServletRequest removeElectiveModule(HttpServletRequest request) throws SQLException {
	this.initialise(request);
	moduleIO.removeElective(selectedCampus.getCampusID(), selectedDiscipline.getDisciplineID(), selectedCourse.getCourseID(), selectedModule.getModuleID());
	selectedCourse.getElectiveModules().remove(selectedModule);
	
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