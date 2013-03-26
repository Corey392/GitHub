/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import data.ModuleIO;
import data.PostgreError;
import domain.Module;
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
 * Hanles the maintenance/data-entry page for modules.
 * 
 * @author Adam Shortall
 */
public class MaintainModuleServlet extends HttpServlet {
    
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
            String url = RPLPage.CLERICAL_MODULE.relativeAddress;
            
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            ModuleIO moduleIO = new ModuleIO(user.role);
            ArrayList<Module> modules;
            
            String addNewModule = request.getParameter("addNewModule");
            
            if (addNewModule != null) {
                this.addNewModule(request);
            } else if (request.getParameter("saveModules") != null) {
                this.saveModules(request);
            } else if (request.getParameter("addElementsToModule") != null) {
                String addElementsToModuleID = request.getParameter("addElementsToModule");
                
                url = RPLServlet.MAINTAIN_MODULE_ELEMENTS_SERVLET.relativeAddress;
                session.setAttribute("selectedModule", moduleIO.getByID(addElementsToModuleID));
            }
            
            modules = moduleIO.getList();
            Collections.sort(modules);
            request.setAttribute("modules", modules);
            RequestDispatcher dispatcher = request.getRequestDispatcher(url);
            dispatcher.forward(request, response);
        } finally {            
            out.close();
        }
    }
    
    
    
    /**
     * Adds a new module to the database, modifies request.
     * @param request 
     */
    private void addNewModule(HttpServletRequest request) {
        String newModuleID = request.getParameter("newModuleID");
        String newModuleName = request.getParameter("newModuleName");
        Module newModule = new Module(newModuleID, newModuleName);

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        ModuleIO moduleIO = new ModuleIO(user.role);
        
        try {
            ArrayList<FieldError> errors = newModule.validate();
            if (errors.isEmpty()) {
                moduleIO.insert(newModule);
                request.setAttribute("moduleUpdateMessage", "Module added successfully");
            } else {
                for (FieldError e : errors) {
                    if (e == e.MODULE_ID) {
                        RPLError moduleInvalidIDError = new RPLError(e);
                        request.setAttribute("moduleInvalidIDError", moduleInvalidIDError);
                    }
                }
            }
        } catch (SQLException ex) {
            if (ex.getSQLState().equals(PostgreError.UNIQUE_VIOLATION.code)) {
                RPLError uniqueError = new RPLError(FieldError.MODULE_UNIQUE);
                request.setAttribute("moduleUniqueError", uniqueError);
            }
            Logger.getLogger(MaintainModuleServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
     }
    
        
    private void saveModules(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        ModuleIO moduleIO = new ModuleIO(user.role);
        
        
        String[] moduleIDs = request.getParameterValues("moduleID[]");
        String[] moduleNames = request.getParameterValues("moduleName[]");
        
        for(int i = 0; i < moduleIDs.length; i++) {
            Module moduleToUpdate = moduleIO.getByID(moduleIDs[i]);
            moduleToUpdate.setName(moduleNames[i]);
            moduleToUpdate.setModuleID(moduleIDs[i]);
            try {
                moduleIO.update(moduleToUpdate, moduleIDs[i]);
                request.setAttribute("moduleUpdateMessage", "Module updated successfully");
            } catch (SQLException ex) {
                if (ex.getSQLState().equals(PostgreError.UNIQUE_VIOLATION.code)) {
                    RPLError uniqueError = new RPLError(FieldError.MODULE_UNIQUE);
                    request.setAttribute("moduleUniqueError", uniqueError);
                }
                Logger.getLogger(MaintainModuleServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
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
