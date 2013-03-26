package web;

import data.ErrorsIO;
import domain.Errors;
import domain.User;
import java.io.IOException;
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

/**
 * This servlet populates the list of claims for the student's listClaims page
 * and redirects any requests from that page.
 * @author James Purves
 */
public class ErrorsServlet extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
     
        // Initialises the list of claims and error as null and the url as an 
        // empty string.
        ArrayList<Errors> errors = null;
        Integer wholeErrorsCnt = 0;
        String url = "";
         
        // Gets the session and the current user.
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Gets the list of claims for the current user.
        errors = this.populateErrorsList(user);
         
        // Sets the url to the next page and sets the error if there was any.
        if (request.getParameter("view") != null){
            url = RPLPage.LIST_ERRORS.relativeAddress;
            request.setAttribute("errors", errors);
           
            // count 
            wholeErrorsCnt = populateErrorsListCount(user);
            
            wholeErrorsCnt = (int)(wholeErrorsCnt/10) + 1;
            request.setAttribute("errorsCount", String.valueOf(wholeErrorsCnt));
             
        } else if (request.getParameter("back") != null){
            if(user.role.toString().equals("STUDENT"))
                url = RPLPage.STUDENT_HOME.relativeAddress;
            else if(user.role.toString().equals("TEACHER"))
                url = RPLPage.TEACHER_HOME.relativeAddress;
            else if(user.role.toString().equals("CLERICAL"))
                url = RPLPage.CLERICAL_HOME.relativeAddress;
            else if(user.role.toString().equals("ADMIN"))
                url = RPLPage.ADMIN_HOME.relativeAddress;
        
        } else if (request.getParameter("insert") != null){
            
            ErrorsIO errorsIO = new ErrorsIO(user.getRole());
            Errors error = new Errors();
            error.setErrorID(request.getParameter("errorID"));
            error.setErrorMessage(request.getParameter("errorMessage"));
            try {
                errorsIO.insert(error);
            } catch (SQLException ex) {
                Logger.getLogger(ErrorsServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        } else if (request.getParameter("update") != null){
            ErrorsIO errorsIO = new ErrorsIO(user.getRole());
            Errors error = new Errors();
            error.setErrorID(request.getParameter("errorID"));
            error.setErrorMessage(request.getParameter("errorMessage"));
            try {
                errorsIO.update(error);
            } catch (SQLException ex) {
                Logger.getLogger(ErrorsServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
       
//        request.setAttribute("user", user);
        // Sets the claims attribute to the list of claims and forwards the 
        // request.
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
    
    /**
     * 
     * @param user
     * @return 
     */
    private ArrayList<Errors> populateErrorsList(User user){
        ErrorsIO errorsIO = new ErrorsIO(user.getRole());
        ArrayList<Errors> errors = new ArrayList<Errors>();
        
        try {
            errors = errorsIO.getList(new Errors());
        } catch (Exception ex) {
            Logger.getLogger(ListClaimsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        return errors;
    }

    /**
     * 
     * @param user
     * @return 
     */
    private Integer populateErrorsListCount(User user){
        ErrorsIO errorsIO = new ErrorsIO(user.getRole());
        Integer listCount = 0 ;
        
        try {
            listCount = errorsIO.getListCount(new Errors());
        } catch (Exception ex) {
            Logger.getLogger(ListClaimsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        return listCount;
    }    
    
}
