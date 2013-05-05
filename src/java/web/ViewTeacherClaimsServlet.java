package web;

import data.ClaimIO;
import domain.Claim;
import domain.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.RPLPage;

/**
 *
 * @author David, Mitchell Carr
 */
public class ViewTeacherClaimsServlet extends HttpServlet {
    private HttpSession session;
    private User user;
            

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String url = RPLPage.LIST_CLAIMS_TEACHER.relativeAddress;
        session = request.getSession();
        user = (User)session.getAttribute("user");
        
        ArrayList<Claim> claims = new ArrayList<Claim>();
        
        ClaimIO claimIO = new ClaimIO(user.role);
        try {
            claims = claimIO.getList(user);
            request.setAttribute("claims", claims);
        } catch (SQLException sqlex) {
            sqlex.printStackTrace();
            url = RPLPage.HOME.relativeAddress;
        }
        int len = claims.size();
        if (len == 0) {
            request.setAttribute("len", Integer.toString(len));
        }
        
        if(request.getParameter("back") != null) {
            url = RPLPage.TEACHER_HOME.relativeAddress;
        }
        
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
