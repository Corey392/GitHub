package web;

import data.CampusIO;
import data.PostgreError;
import domain.Campus;
import domain.User;
import domain.User.Role;
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
import util.FieldError;
import util.RPLError;
import util.RPLPage;
import util.RPLServlet;
import util.Util;

/**
 * @author Adam Shortall, Bryce Carr
 * @version 1.010
 * <b>Created:</b>  Unknown<br/>
 * <b>Modified:</b> 27/04/2013<br/>
 * <b>Change Log:</b>	27/04/2013: Bryce Carr:	Begun implementation of Campus deletion. Fixed update and add campus messages so that they display.
 *			30/04/2013: Bryce Carr:	Added return statements after method calls in processRequest() to prevent double request-forwarding.
 * <b>Purpose:</b>  Handles requests from Data Maintenance: Campus page.
 */
public class MaintainCampusServlet extends HttpServlet {

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
            String url = RPLPage.CLERICAL_CAMPUS.relativeAddress;
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            
            // Have either pressed 'Save Campuses', 'Add New Campus', 'Delete Campus' or 'View or Modify Disciplines'
            if (request.getParameter("saveCampuses") != null)	{
                saveCampuses(request, response);
		return;
            } else if (request.getParameter("addNewCampus") != null)	{
                this.addNewCampus(request, response);
		return;
            } else if (request.getParameter("deleteCampus") != null)	{		
                this.deleteCampus(request, response);
		return;
            } else if (request.getParameter("viewDisciplines") != null)	{
                String campusID = request.getParameter("viewDisciplines");
                
                Campus selectedCampus = Util.getCampusWithDisciplinesAndCourses(campusID, user.role);
                session.setAttribute("selectedCampus", selectedCampus);
                url = RPLServlet.MAINTAIN_CAMPUS_DISCIPLINE_SERVLET.relativeAddress;
            }
            this.fillCampusList(request, user.role);
            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        } finally {            
            out.close();
        }
    }
    
    /**
     * Takes request and user role, fills the list of campuses sorted, puts in request.
     * @param request HTTP request to fill with data
     * @param role Role of the current User
     */
    private void fillCampusList(HttpServletRequest request, Role role) {
        CampusIO campusIO = new CampusIO(role); 
        ArrayList<Campus> campuses = campusIO.getList();
//        Collections.sort(campuses);
        request.setAttribute("campuses", campuses);
    }
    
    /**
     * Writes a campus to the DB, updates request
     * @param request HTTP request to retrieve the details of the Campus to add
     * @param response HTTP request to forward
     * @throws ServletException if forwarded request throws a ServletException
     * @throws IOException if forwarded request throws an IOException
     */
    private void addNewCampus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String campusID = request.getParameter("newCampusID");
        String name = request.getParameter("newCampusName");
        Campus campus = new Campus(campusID, name);
        ArrayList<Campus.Field> invalidFields = campus.validate();
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String url = RPLPage.CLERICAL_CAMPUS.relativeAddress;
        
        if (invalidFields.isEmpty()) {
            try {
                CampusIO campusIO = new CampusIO(user.role);
                campusIO.insert(campus);
                request.setAttribute("campusUpdatedMessage", "Campus successfully added");
            } catch (SQLException e) {
                if (e.getSQLState().equals(PostgreError.UNIQUE_VIOLATION.code)) {
                    request.setAttribute("uniqueIDMessage", new RPLError(FieldError.CAMPUS_UNIQUE));
                } else {
                    Logger.getLogger(MaintainCampusServlet.class.getName()).log(Level.SEVERE, null, e);
                }
            }
        } else {    // User did not type in valid data
            for (Campus.Field invalidField : invalidFields) {
                RPLError message = new RPLError(invalidField.fieldError);
                if (invalidField == Campus.Field.ID) {
                    request.setAttribute("invalidIDMessage", message);
                } else {
                    request.setAttribute("invalidNameMessage", message);
                }
            }
        }
        this.fillCampusList(request, user.role);
        RequestDispatcher dispatcher = request.getRequestDispatcher(url);
        dispatcher.forward(request, response);
    }
    
    /**
     * Writes a campus to the DB, updates request
     * @param request HTTP request to retrieve the details of the Campus to remove
     * @param response HTTP request to forward
     * @throws ServletException if forwarded request throws a ServletException
     * @throws IOException if forwarded request throws an IOException
     */
    private void deleteCampus(HttpServletRequest request, HttpServletResponse response)	throws ServletException, IOException	{
	//TODO: BRYCE: Give warning if Campus has disciplines assigned to it
	
	HttpSession session = request.getSession();
	User user = (User)session.getAttribute("user");
	String url = RPLPage.CLERICAL_CAMPUS.relativeAddress;
	
	String campusID = request.getParameter("deleteCampus");		
	Campus deleteCampus = Util.getCampusWithDisciplinesAndCourses(campusID, user.role);
	
	CampusIO campusIO = new CampusIO(user.role);
	try {
	    campusIO.delete(deleteCampus);
	    request.setAttribute("campusUpdatedMessage", "Campus successfully deleted");
	} catch (SQLException e) {
	    Logger.getLogger(MaintainCampusServlet.class.getName()).log(Level.SEVERE, null, e);
	}
        
        this.fillCampusList(request, user.role);
        RequestDispatcher dispatcher = request.getRequestDispatcher(url);
        dispatcher.forward(request, response);
    }
    
    /**
     * Writes a campus to the DB, updates request
     * @param request HTTP request to retrieve the details of the Campuses to update
     * @param response HTTP request to forward
     * @throws ServletException if forwarded request throws a ServletException
     * @throws IOException if forwarded request throws an IOException
     */
    private void saveCampuses(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String url = RPLPage.CLERICAL_CAMPUS.relativeAddress;
        CampusIO campusIO = new CampusIO(user.role);
        
        String[] campusIDs = request.getParameterValues("campusID[]");
        String[] campusNames = request.getParameterValues("campusNames[]");
        
        boolean invalid = false;
        
        for(int i = 0; i < campusIDs.length; i++) {
            if(campusIDs[i].trim().equals("") || campusNames[i].trim().equals("")) {
                continue; //NO BLANKS
            }
            Campus campus = new Campus(campusIDs[i], campusNames[i]);
            
            if(campus.validate().isEmpty()) { //WTF
                try {
                    campusIO.update(campus, campusIDs[i]);
                    
                    request.setAttribute("campusUpdatedMessage", "Campus successfully updated");
                } catch (SQLException e) {
                    if (e.getSQLState().equals(PostgreError.UNIQUE_VIOLATION.code)) {
                        request.setAttribute("uniqueIDMessage", new RPLError(FieldError.CAMPUS_UNIQUE));
                    } else {
                        Logger.getLogger(MaintainCampusServlet.class.getName()).log(Level.SEVERE, null, e);
                    }
                }
            } else {
                invalid = true;
            }
        }
        if(invalid) {
            request.setAttribute("invalidIDMessage", new RPLError("Error fields invalid!"));
        }
        
        this.fillCampusList(request, user.role);
        RequestDispatcher dispatcher = request.getRequestDispatcher(url);
        dispatcher.forward(request, response);
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