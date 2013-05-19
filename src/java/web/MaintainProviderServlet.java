package web;

import data.ProviderIO;
import domain.Provider;
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
import util.Util;

/**
 *  Handles requests for the Clerical Admin's Provider maintenance page.
 * @author Bryce Carr
 * @version 1.000
 * Created:	07/05/2013 6:38 PM
 * Modified:	07/05/2013
 * Changelog:	07/05/2013: Bryce Carr:	Created Servlet. Commented out code for non-rename functions pending team discussion.
 */
public class MaintainProviderServlet extends HttpServlet {
    
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
            
            String url = RPLPage.CLERICAL_PROVIDER.relativeAddress;
            
            if (request.getParameter("addProvider") != null) {
//                this.addProvider(request);
            } else if (request.getParameter("saveProviders") != null) {
                this.saveProviders(request);
            } else if (request.getParameter("deleteProvider") != null)    {
//		this.deleteProvider(request);
	    }
            
            ProviderIO providerIO = new ProviderIO(user.role);
            ArrayList<Provider> providers = providerIO.getList();
            request.setAttribute("providers", providers);
                    
            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        } finally {
            out.close();
        }
    }
    
    /**
     * @param request HTTP request containing the IDs and names of providers to update
     */
    private void saveProviders(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String[] providerIDs = request.getParameterValues("providerID[]");
        String[] providerNames = request.getParameterValues("providerName[]");

        boolean invalid = false;
        
        for(int i = 0; i < providerIDs.length; i++) {
            char providerID = (providerIDs[i]).charAt(0);
            Provider provider = new Provider(providerID, providerNames[i]);            
            ProviderIO providerIO = new ProviderIO(user.role);
	    try {
		providerIO.update(provider);
	    } catch (SQLException ex) {
		System.out.println(ex);
		Logger.getLogger(MaintainProviderServlet.class.getName()).log(Level.SEVERE, null, ex);
	    }
        }
        if(!invalid) {
            request.setAttribute("providerUpdatedMessage", "Provider successfully updated");
        }
        
    }
    
//    
//    /**
//     * Adds a provider to the database, modifies the request.
//     * @param request 
//     */
//    private void addProvider(HttpServletRequest request) {
//        HttpSession session = request.getSession();
//        User user = (User) session.getAttribute("user");
//        
//        String name = request.getParameter("newProviderName");
//	char providerID = ()
//        Provider provider = new Provider(name);
//        
//        if (provider.validate() == null) {
//            ProviderIO providerIO = new ProviderIO(user.role);
//            try {
//                providerIO.insert(provider);
//                request.setAttribute("providerUpdatedMessage", "Provider added successfully");
//            } catch (SQLException ex) {
//                Logger.getLogger(MaintainProviderServlet.class.getName()).log(Level.SEVERE, null, ex);
//            }
//        } else {
//            RPLError invalidNameError = new RPLError(provider.validate());
//            request.setAttribute("invalidNameError", invalidNameError);
//        }
//    }
    
    
//    /**
//     * Deletes a provider from the database, modifies the request.
//     * @param request 
//     */
//    private void deleteProvider(HttpServletRequest request) {
//        HttpSession session = request.getSession();
//        User user = (User) session.getAttribute("user");
//        
//        String ID = request.getParameter("deleteProvider");
//	Provider deleteProvider;
//        
//        if (ID != null) {
//            ProviderIO providerIO = new ProviderIO(user.role);
//            try {
//		deleteProvider = providerIO.getByID(Integer.valueOf(ID));
//                providerIO.delete(deleteProvider);
//                request.setAttribute("providerUpdatedMessage", deleteProvider.getName() + " (ID: " + deleteProvider.getProviderID() + ") deleted successfully.");
//            } catch (SQLException ex) {
//                Logger.getLogger(MaintainProviderServlet.class.getName()).log(Level.SEVERE, null, ex);
//            }
//        } else {
//            request.setAttribute("providerUpdatedMessage", "Error: Provider not deleted.");
//        }
//    }

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
