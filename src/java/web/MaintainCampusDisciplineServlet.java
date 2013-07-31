package web;

import data.CampusIO;
import data.DisciplineIO;
import domain.Campus;
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
import util.RPLPage;
import util.RPLServlet;

/**
 *  Clerical Admin page for adding/removing Disciplines from Campus'.
 * @author Adam Shortall, Bryce Carr
 * @version 1.011
 *  Created:</b>  Unknown<br/>
 *  Modified:</b> 24/04/2013<br/>
 *  Change Log:	23/04/2013: Bryce Carr: Implemented removal of Disciplines from Campus'.
 *		24/04/2013: Bryce Carr: Added header comments to match code conventions.
 *		04/05/2013: Bryce Carr:	Moved test for 'back' value into other if block for optimisation purposes.
 */
public class MaintainCampusDisciplineServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws SQLException if a removeDiscipline call fails
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String url = RPLPage.CLERICAL_CAMPUS_DISCIPLINE.relativeAddress;
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            DisciplineIO disciplineIO = new DisciplineIO(user.role);
            CampusIO campusIO = new CampusIO(user.role);
            Campus selectedCampus = (Campus) session.getAttribute("selectedCampus");
            Discipline selectedDiscipline = (Discipline) request.getAttribute("selectedDiscipline");
            ArrayList<Discipline> disciplines = (ArrayList<Discipline>) request.getAttribute("disciplines");

            String disciplineID = request.getParameter("disciplineID");

            String removeDisciplineID = request.getParameter("removeDiscipline");

            String back = request.getParameter("back");
	    

            if (request.getParameter("addDisciplineToCampus") != null) {
                String selectedDisciplineID = request.getParameter("selectedDiscipline");
                selectedDiscipline = disciplineIO.getByID(Integer.parseInt(selectedDisciplineID));
            } else if (removeDisciplineID != null) {
                Discipline remove = disciplineIO.getByID(Integer.parseInt(removeDisciplineID));
                int index = selectedCampus.getDisciplines().indexOf(remove);
                campusIO.removeDiscipline(selectedCampus.getCampusID(), Integer.parseInt(removeDisciplineID));
                selectedCampus.getDisciplines().remove(index);
                disciplines = disciplineIO.getListNotInCampus(selectedCampus.getCampusID());
            } else if (back != null) {
                url = RPLPage.CLERICAL_CAMPUS.relativeAddress;
            } else {
                selectedDiscipline = null;
            }

            // Check that a campus has been selected from maintain campus page:
            if (selectedCampus != null) {
                // Fill list of disciplines for drop-down box on jsp:
                disciplines = disciplineIO.getListNotInCampus(selectedCampus.getCampusID());

                // Handle events on the jsp:
                if (selectedDiscipline != null) {   // Selected a discipline from the drop-down box
                    try {
                        campusIO.addDiscipline(selectedCampus.getCampusID(), selectedDiscipline.getDisciplineID());
                        selectedCampus.getDisciplines().add(selectedDiscipline);
                    } catch (SQLException ex) {
                        Logger.getLogger(MaintainCampusDisciplineServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                    disciplines = disciplineIO.getListNotInCampus(selectedCampus.getCampusID());
                } else if (disciplineID != null) {
                    selectedDiscipline = disciplineIO.getByID(Integer.parseInt(disciplineID));
                    session.setAttribute("selectedDiscipline", selectedDiscipline);
                    url = RPLServlet.MAINTAIN_DISCIPLINE_COURSES_SERVLET.relativeAddress;
                }
            }

            request.setAttribute("disciplines", disciplines);
            request.setAttribute("selectedCampus", selectedCampus);
            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        } finally {
            out.close();
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
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(MaintainCampusDisciplineServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
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
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(MaintainCampusDisciplineServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
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