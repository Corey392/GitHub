package web;

import data.ClaimRecordIO;
import domain.ClaimRecord;
import domain.User;
import java.io.IOException;
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
import util.RPLValidator;
import util.Util;

/**
 * This servlet populates the list of claims for the student's listClaims page
 * and redirects any requests from that page.
 * @author James Purves
 */
public class ListClaimRecordServlet extends HttpServlet {

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
        ArrayList<ClaimRecord> claimRecords = null;
        Integer wholeClaimRecordCnt = 0;
        RPLError error = null;
        String url = "";
         
        // Gets the session and the current user.
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Gets the list of claims for the current user.
        claimRecords = this.populateClaimRecordsList(user
                                                   , request.getParameter("workType")
                                                   , request.getParameter("workResult")
                                                   , request.getParameter("pageNo")
                                                   , request.getParameter("claimType"));
         
        // Sets the url to the next page and sets the error if there was any.
        if (request.getParameter("view") != null){

            if(user.role.toString().equals("STUDENT")) {
                url = RPLPage.STUDENT_LIST_CLAIM_RECORDS.relativeAddress;
            } else if(user.role.toString().equals("TEACHER")) {
                url = RPLPage.TEACHER_LIST_CLAIM_RECORDS.relativeAddress;
            }
            request.setAttribute("claimRecords", claimRecords);
           
            // count 
            wholeClaimRecordCnt = populateClaimRecordsListCount(user
                                        , request.getParameter("workType")
                                        , request.getParameter("workResult")
                                        , request.getParameter("claimType"));
            
            wholeClaimRecordCnt = (int)(wholeClaimRecordCnt/10) + 1;
            request.setAttribute("claimRecordsCount", String.valueOf(wholeClaimRecordCnt));
             
        } else if (request.getParameter("back") != null){
            if(user.role.toString().equals("STUDENT"))
                url = RPLPage.STUDENT_HOME.relativeAddress;
            else if(user.role.toString().equals("TEACHER"))
                url = RPLPage.TEACHER_HOME.relativeAddress;
        }
       
        ClaimRecord oClaimRecord = new ClaimRecord();
        oClaimRecord.setWorkType(RPLValidator.fixParseIntEx(request.getParameter("workType"), -1));
        oClaimRecord.setWorkResult(RPLValidator.fixParseIntEx(request.getParameter("workResult"), -1));
        oClaimRecord.setPageNo(RPLValidator.fixParseIntEx(request.getParameter("pageNo"), 1));
        oClaimRecord.setClaimType(RPLValidator.fixParseIntEx(request.getParameter("claimType"), -1));
         
        request.setAttribute("claimRecordParam", oClaimRecord);
//        request.setAttribute("user", user);
        // Sets the claims attribute to the list of claims and forwards the 
        // request.
System.out.println("=============================" + url);       
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
     * Gets a list of claim records for the current user.
     * @param request the request
     * @param user the current user
     * @return a list of complete claims
     */
    private ArrayList<ClaimRecord> populateClaimRecordsList(User user, String workType, String workResult, String pageNo, String claimType){
        ClaimRecordIO claimRecordIO = new ClaimRecordIO(user.getRole());
        ArrayList<ClaimRecord> claimRecords = new ArrayList<ClaimRecord>();
        ArrayList<ClaimRecord> completeClaimRecords = new ArrayList<ClaimRecord>();
        
        try {
            claimRecords = claimRecordIO.getList(new ClaimRecord(user.getUserID()
                                                                , RPLValidator.fixParseIntEx(workType, -1)
                                                                , RPLValidator.fixParseIntEx(workResult, -1)
                                                                , RPLValidator.fixParseIntEx(pageNo, 1)
                                                                , RPLValidator.fixParseIntEx(claimType, -1))
                                                , user.getRole().toString());
            for (ClaimRecord claimRecord : claimRecords){
                ClaimRecord c = Util.getCompleteClaimRecord(claimRecord, user.role);
                completeClaimRecords.add(c);
            }
        } catch (Exception ex) {
            Logger.getLogger(ListClaimsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        return completeClaimRecords;
    }

    /**
     * 
     * @param user
     * @param workType
     * @param workResult
     * @return 
     */
    private Integer populateClaimRecordsListCount(User user, String workType, String workResult, String claimType){
        ClaimRecordIO claimRecordIO = new ClaimRecordIO(user.getRole());
        Integer listCount = 0 ;
        
        try {
            listCount = claimRecordIO.getListCount(new ClaimRecord(user.getUserID()
                                                                , RPLValidator.fixParseIntEx(workType, -1)
                                                                , RPLValidator.fixParseIntEx(workResult, -1)
                                                                , 0
                                                                , RPLValidator.fixParseIntEx(claimType, -1))
                                                                , user.getRole().toString());
        } catch (Exception ex) {
            Logger.getLogger(ListClaimsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        return listCount;
    }    
    
}
