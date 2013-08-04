package web;

import data.CourseIO;
import domain.Course;
import domain.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.RPLPage;
import util.RPLServlet;

/**
 * @author Adam Shortall
 */
public class MaintainTableServlet extends HttpServlet {

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
            String url = RPLPage.CLERICAL_HOME.relativeAddress;
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            String selectedTable = request.getParameter("selectedTable");
            
            // Handle pressing 'Home' button
            if (request.getParameter("backHome") != null) {
                selectedTable = "";
            }

            if (selectedTable != null) {
                if (selectedTable.isEmpty()) {
                    url = RPLPage.CLERICAL_HOME.relativeAddress;
                } else if (selectedTable.equals("Campus")) {                    
                    url = RPLServlet.MAINTAIN_CAMPUS_SERVLET.relativeAddress;
                } else if (selectedTable.equals("Discipline")) {                    
                    url = RPLServlet.MAINTAIN_DISCIPLINE_SERVLET.relativeAddress;
                } else if (selectedTable.equals("Course")) {
                    CourseIO courseIO = new CourseIO(user.role);
                    ArrayList<Course> courses = courseIO.getList();
                    Collections.sort(courses);
                    request.setAttribute("courses", courses);
                    url = RPLPage.CLERICAL_COURSE.relativeAddress;
                } else if (selectedTable.equals("Module")) {
                    url = RPLServlet.MAINTAIN_MODULE_SERVLET.relativeAddress;
                } else if (selectedTable.equals("Course Modules")) {                
                    url = RPLPage.CLERICAL_COURSE_MODULES.relativeAddress;
                }
            }
            
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