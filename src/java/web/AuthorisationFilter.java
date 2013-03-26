/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package web;

import domain.User;
import domain.User.Role;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.RPLPage;
import util.RPLServlet;

/**
 * Checks whether a user is authorised for the page
 * that they are trying to visit, before allowing them
 * through. Sends the user to the login page if they
 * are not.
 * 
 * @author Adam Shortall
 */
public class AuthorisationFilter implements Filter {
    
    private FilterConfig filterConfig = null;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig = filterConfig;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        if(this.filterConfig == null) {
            return;
        }
        boolean authorised = false;
        HttpServletRequest httpRequest = (HttpServletRequest)request;
        String uri = httpRequest.getRequestURI();
        HttpSession session = httpRequest.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || user.getStatus() == User.Status.NOT_LOGGED_IN) { 
            authorised = uri.equals(RPLPage.HOME.absoluteAddress);
        } else if (user.role == Role.STUDENT) {
            authorised = uri.matches("^" + RPLPage.ROOT+"/students.*$");
        } else if (user.role == Role.TEACHER) {
            authorised = uri.matches("^"+RPLPage.ROOT+"/teachers.*$");
        } else if (user.role == Role.CLERICAL) {
            authorised = uri.matches("^"+RPLPage.ROOT+"/maintenance.*$");
        } else if (user.role == Role.ADMIN) {
            authorised = !uri.matches("^"+RPLPage.ROOT+"/students.*$");    // Admins can access everything except student pages
        }
        if (authorised) { // TODO: set this back to if (authorised), set to true only for debugging purposes
            chain.doFilter(request, response);         
        } else {    // User is not authorised for the page they were going to
            // Send them back to either their user role's homepage, or the website homepage
            ((HttpServletResponse)response).sendRedirect(RPLServlet.LOGIN_SERVLET.absoluteAddress);
        }
    }

    @Override
    public void destroy() {
        this.filterConfig = null;
    }
    
}