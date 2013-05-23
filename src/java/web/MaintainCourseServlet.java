package web;

import data.CourseIO;
import data.FileIO;
import data.ModuleIO;
import data.PostgreError;
import domain.Course;
import domain.GuideFile;
import domain.User;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileItemFactory;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import util.FieldError;
import util.RPLError;
import util.RPLPage;
import util.RPLServlet;
//import util.Util;

/**
 *
 * @author Adam Shortall, Bryce Carr, Mitchell Carr
 * @version 1.031
 * Created:	Unknown
 * Modified:	23/05/2013
 * Change Log:	08/04/2013: Bryce Carr:	Made small changes to incorporate guideFileAddress DB field.
 *		24/04/2013: Bryce Carr:	Added header comments to match code conventions.
 *		07/05/2013: Bryce Carr:	Implemented Course deletion.
 *		15/05/2013: MC: Removed guideFileAddress fields to match Course
 *		23/05/2013: Bryce Carr: Attempted to implement Guide File uploading. It doesn't work yet - something to do with the content type of the request.
 */
public class MaintainCourseServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
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
	    String url = RPLPage.CLERICAL_COURSE.relativeAddress;
	    //String updateCourseID = Util.getPageStringID(request, "updateCourse");

	    HttpSession session = request.getSession();
	    User user = (User) session.getAttribute("user");
	    session.removeAttribute("selectedCampus");
	    session.removeAttribute("selectedDiscipline");

	    CourseIO courseIO = new CourseIO(user.role);
	    ModuleIO moduleIO = new ModuleIO(user.role);

	    // Have either pressed 'Add Course', 'Save Courses', 'Update Modules', 'Attach GuideFile' or 'Back'
	    if (request.getParameter("addCourse") != null) {
		this.addCourse(request);
	    } else if (request.getParameter("saveCourses") != null) {
		this.saveCourses(request);
	    } else if (request.getParameter("updateModules") != null) {
		String id = request.getParameter("updateModules");

		// Load course into session
		Course course = courseIO.getByID(id);
		course.setCoreModules(moduleIO.getListOfCores(id));
		session.setAttribute("selectedCourse", course);
		url = RPLServlet.MAINTAIN_CORE_MODULES_SERVLET.relativeAddress;
	    } else if (request.getParameter("deleteCourse") != null) {
		this.deleteCourse(request);
	    } else if (request.getParameter("uploadGuideFile") != null) {
		this.uploadGuideFile(request);
	    }

	    courseIO = new CourseIO(user.role);
	    ArrayList<Course> courses = courseIO.getList();
	    Collections.sort(courses);
	    request.setAttribute("courses", courses);

	    RequestDispatcher dispatcher = request.getRequestDispatcher(url);
	    dispatcher.forward(request, response);
	} finally {
	    out.close();
	}
    }

    /**
     * Deletes a Course from the database, modifies the request.
     *
     * @author Bryce Carr
     * @param request HTTP request containing within it the ID of the Course to
     * delete
     */
    private void deleteCourse(HttpServletRequest request) {
	HttpSession session = request.getSession();
	User user = (User) session.getAttribute("user");

	String ID = request.getParameter("deleteCourse");

	if (ID != null) {
	    CourseIO courseIO = new CourseIO(user.role);
	    try {
		Course deleteCourse = courseIO.getByID(ID);
		courseIO.delete(deleteCourse);
		request.setAttribute("deleteSuccess", deleteCourse.getName() + " (ID: " + deleteCourse.getCourseID() + ") deleted successfully.");
	    } catch (SQLException ex) {
		Logger.getLogger(MaintainCourseServlet.class.getName()).log(Level.SEVERE, null, ex);
	    }
	} else {
	    request.setAttribute("deleteError", "Error: Course not deleted.");
	}
    }

    /**
     * Updates a list of Courses in the DB
     *
     * @author James Lee Chin
     * @param request HTTP request containing within it the IDs and names of
     * Courses to update
     */
    private void saveCourses(HttpServletRequest request) {
	HttpSession session = request.getSession();
	User user = (User) session.getAttribute("user");
	CourseIO courseIO = new CourseIO(user.role);


	String[] courseIDs = request.getParameterValues("courseID[]");
	String[] courseNames = request.getParameterValues("courseName[]");

	for (int i = 0; i < courseIDs.length; i++) {
	    Course course = new Course(courseIDs[i], courseNames[i]);

	    if (course.validate().isEmpty()) {
		try {
		    courseIO.update(course, courseIDs[i]);
		    request.setAttribute("updateSuccess", "Update Successful");
		} catch (SQLException ex) {
		    if (ex.getSQLState().equals(PostgreError.UNIQUE_VIOLATION.code)) {
			request.setAttribute("courseIDError", new RPLError(FieldError.COURSE_UNIQUE));
		    }
		    Logger.getLogger(MaintainCourseServlet.class.getName()).log(Level.SEVERE, null, ex);
		}
	    } else {
		request.setAttribute("courseIDError", new RPLError("Course ID invalid!"));
		request.setAttribute("courseNameError", new RPLError("Course Name invalid!"));
	    }
	}

    }

    /**
     * Adds a new course to the database, modifies the request.
     *
     * @param request HTTP request containing within it the name and ID of a
     * Course to add
     */
    private void addCourse(HttpServletRequest request) {
	String courseID = request.getParameter("newCourseID");
	String name = request.getParameter("newCourseName");

	Course course = new Course(courseID, name);
	ArrayList<FieldError> errors = course.validate();

	HttpSession session = request.getSession();
	User user = (User) session.getAttribute("user");
	CourseIO courseIO = new CourseIO(user.role);

	if (errors.isEmpty()) {
	    try {
		courseIO.insert(course);
		request.setAttribute("updateSuccess", "New Course added Successfully");
	    } catch (SQLException ex) {
		if (ex.getSQLState().equals(PostgreError.UNIQUE_VIOLATION.code)) {
		    request.setAttribute("courseIDError", new RPLError(FieldError.COURSE_UNIQUE));
		}
		Logger.getLogger(MaintainCourseServlet.class.getName()).log(Level.SEVERE, null, ex);
	    }
	} else {
	    RPLError courseIDError = new RPLError();
	    RPLError courseNameError = new RPLError();
	    for (FieldError err : errors) {
		if (err == FieldError.COURSE_ID) {
		    courseIDError = new RPLError(err);
		} else {
		    courseNameError = new RPLError(err);
		}
	    }
	    request.setAttribute("courseIDError", courseIDError);
	    request.setAttribute("courseNameError", courseNameError);
	}
    }

    /**
     * Uploads a Guide File for a Course.
     *
     * @param request HTTP request containing within it the ID of a Course and a
     * Guide File
     */
    private void uploadGuideFile(HttpServletRequest request) {
	HttpSession session = request.getSession();
	User user = (User) session.getAttribute("user");
	String courseID = request.getParameter("uploadGuideFile");
	GuideFile guideFile = null;
	String message = "";
	//Get ready for database activity
	FileIO fileIO = new FileIO(user.role);
	//Delete the previous Guide File if it exists
	try {
	    if (fileIO.deleteGuideFile(courseID)) { //there was a previous Guide File and it has been deleted
		message = message.concat("Previous guide file for Course ID '" + courseID + "' deleted.");
	    } else { //no previous Guide File
		message = message.concat("No previous guide file for Course ID '" + courseID + "'.");
	    }
	} catch (SQLException ex) {
	    Logger.getLogger(MaintainCourseServlet.class.getName()).log(Level.SEVERE, null, ex);
	    guideFile = null;
	}

	String fileFolder = courseID + "/";
	File fileFolderLocation = new File(GuideFile.DIRECTORY_GUIDE_FILES + fileFolder);

	FileItemFactory factory = new DiskFileItemFactory();
	ServletFileUpload upload = new ServletFileUpload(factory);
	try {
	    //Get the files
	    List<FileItem> files = upload.parseRequest(request);
	    Iterator<FileItem> it = files.iterator();

	    while (it.hasNext()) {
		FileItem fileItem = it.next();
		if (!fileItem.isFormField()) {
		    if (fileItem.getContentType().equalsIgnoreCase("text/plain")) {
			//Ensure the folder for the files exists otherwise create it.
			fileFolderLocation.mkdirs();
			//Generate the file name and location to save the files uploaded.
			File fileSaveLocation = new File(GuideFile.DIRECTORY_GUIDE_FILES + fileFolder + GuideFile.FILE_NAME);
			//Save the file to the new loaction.
			fileItem.write(fileSaveLocation);

			//Add the file references to the database.
			guideFile = (new GuideFile(courseID, GuideFile.FILE_NAME));
			System.out.println("File Uploaded to: " + fileSaveLocation.getAbsolutePath());
		    } else {
			request.setAttribute("uploadError", "The file '" + fileItem.getName() + "' is not a valid text file.");
		    }
		}
	    }
	    //Update the database
	    fileIO.insert(guideFile);
	} catch (FileUploadException ex) {
	    Logger.getLogger(MaintainCourseServlet.class.getName()).log(Level.SEVERE, null, ex);
	} catch (Exception e) {
	    Logger.getLogger(MaintainCourseServlet.class.getName()).log(Level.SEVERE, null, e);
	}

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
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
     * Handles the HTTP
     * <code>POST</code> method.
     *
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
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
	return "Short description";
    }// </editor-fold>
}