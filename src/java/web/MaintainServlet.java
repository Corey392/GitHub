package web;

import data.DisciplineIO;
import domain.Discipline;
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
import util.RPLError;
import util.RPLPage;

/**
 *  Handles requests for the Clerical Admin's Discipline maintenance page.
 * @author Adam Shortall, Bryce Carr
 * @version 1.010
 * Created:	Unknown
 * Modified:	06/05/2013
 * Changelog:	06/05/2013: Bryce Carr:	Added deleteDiscipline(), successfully implementing Discipline deletion.
 */
public class MaintainServlet extends HttpServlet {
    
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
            
            String url = RPLPage.CLERICAL_DISCIPLINE.relativeAddress;
            
            //Integer updateID = Util.getPageIntID(request, "updateDiscipline");           
            
            // Have either pressed 'Add New Campus' or 'Update Campus' or 'Back'
            if (request.getParameter("addDiscipline") != null) {
                this.addDiscipline(request);
            } else if (request.getParameter("saveDisciplines") != null) {
                this.saveDisciplines(request);
            } else if (request.getParameter("deleteDiscipline") != null)    {
		this.deleteDiscipline(request);
	    }
            
            DisciplineIO disciplineIO = new DisciplineIO(user.role);
            ArrayList<Discipline> disciplines = disciplineIO.getList();
//            Collections.sort(disciplines);
            request.setAttribute("disciplines", disciplines);
                    
            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        } finally {
            out.close();
        }
    }
    
    /**
     * Updates a set of Disciplines and their DB entries
     * @param request HTTP request containing within it the IDs and names of Disciplines to update
     */
    private void saveDisciplines(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String[] disciplineIDs = request.getParameterValues("disciplineID[]");
        String[] disciplineNames = request.getParameterValues("disciplineName[]");

        boolean invalid = false;
        
        for(int i = 0; i < disciplineIDs.length; i++) {
            int disciplineID = Integer.parseInt(disciplineIDs[i]);

            Discipline discipline = new Discipline(disciplineID, disciplineNames[i]);
            
            if(discipline.validate() == null) {
                DisciplineIO disciplineIO = new DisciplineIO(user.role);
                try {
                    disciplineIO.update(discipline);
                } catch (SQLException ex) {
                    System.out.println(ex);
                    Logger.getLogger(MaintainServlet.class.getName()).log(Level.SEVERE, null, ex);
                }            
            } else {
                RPLError invalidNameError = new RPLError(discipline.validate());
                request.setAttribute("invalidNameError", invalidNameError);
                invalid = true;
            }
        }
        if(!invalid) {
            request.setAttribute("disciplineUpdatedMessage", "Discipline successfully updated");
        }
        
    }
        
    /**
     * Adds a discipline to the database, modifies the request.
     * @param request HTTP request containing within it the Discipline to add
     */
    private void addDiscipline(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String name = request.getParameter("newDisciplineName");
        Discipline discipline = new Discipline(name);
        
        if (discipline.validate() == null) {
            DisciplineIO disciplineIO = new DisciplineIO(user.role);
            try {
                disciplineIO.insert(discipline);
                request.setAttribute("disciplineUpdatedMessage", "Discipline added successfully");
            } catch (SQLException ex) {
                Logger.getLogger(MaintainServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            RPLError invalidNameError = new RPLError(discipline.validate());
            request.setAttribute("invalidNameError", invalidNameError);
        }
    }
    
    /**
     * Deletes a discipline from the database, modifies the request.
     * @param request HTTP request containing within it the Discipline to delete
     */
    private void deleteDiscipline(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String ID = request.getParameter("deleteDiscipline");
	Discipline deleteDiscipline;
        
        if (ID != null) {
            DisciplineIO disciplineIO = new DisciplineIO(user.role);
            try {
		deleteDiscipline = disciplineIO.getByID(Integer.valueOf(ID));
                disciplineIO.delete(deleteDiscipline);
                request.setAttribute("disciplineUpdatedMessage", deleteDiscipline.getName() + " (ID: " + deleteDiscipline.getDisciplineID() + ") deleted successfully.");
            } catch (SQLException ex) {
                Logger.getLogger(MaintainServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            request.setAttribute("disciplineUpdatedMessage", "Error: Discipline not deleted.");
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
