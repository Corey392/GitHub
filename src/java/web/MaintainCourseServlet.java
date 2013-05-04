package web;

import data.CourseIO;
import data.ModuleIO;
import data.PostgreError;
import domain.Course;
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
import util.FieldError;
import util.RPLError;
import util.RPLPage;
import util.RPLServlet;
import util.Util;

/**
 *
 * @author Adam Shortall, Bryce Carr
 * @version 1.02
 * <b>Created:</b> Unknown <br/>
 * <b>Modified:</b> 24/04/2013 <br/>
 * <b>Change Log:</b>  08/04/2013:  Bryce Carr: Made small changes to incorporate guideFileAddress DB field.<br/>
 *                  24/04/2013: Bryce Carr: Added header comments to match code conventions.
 *                  
 * <b>Purpose:</b>  
 */
public class MaintainCourseServlet extends HttpServlet {
    
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
            String url = RPLPage.CLERICAL_COURSE.relativeAddress;
            String updateCourseID = Util.getPageStringID(request, "updateCourse");

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            session.removeAttribute("selectedCampus");
            session.removeAttribute("selectedDiscipline");
            
            CourseIO courseIO = new CourseIO(user.role);
            ModuleIO moduleIO = new ModuleIO(user.role);
            
            // Have either pressed 'Add Course', 'Save Courses', 'Update Modules' or 'Back'
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
     * @author James Lee Chin
     * @param request 
     */
    
    private void saveCourses(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        CourseIO courseIO = new CourseIO(user.role);
        
        
        String[] courseIDs = request.getParameterValues("courseID[]");
        String[] courseNames = request.getParameterValues("courseName[]");
        String[] guideFileAddresses = request.getParameterValues("guideFileAddress[]");
        
        for(int i = 0; i < courseIDs.length; i++) {
            Course course = new Course(courseIDs[i], courseNames[i], guideFileAddresses[i]);

            if(course.validate().isEmpty()) {
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
     * @param request 
     */
    private void addCourse(HttpServletRequest request) {
        String courseID = request.getParameter("newCourseID");
        String name = request.getParameter("newCourseName");
        String guideFileAddress = request.getParameter("newCourseGuideFileAddress");

        Course course = new Course(courseID, name, guideFileAddress);
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
