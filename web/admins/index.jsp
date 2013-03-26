<%-- 
    Document   : index
    Created on : 7/6/2011
    Author     : Adam Shortall
--%>

<%@page import="java.util.*" %>
<%! RPLPage thisPage = RPLPage.ADMIN_HOME; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>

    
<h1>Admin Home Page</h1>

<p>Welcome ${user.firstName} ${user.lastName} to the admin page.!!!!!!!!!!</p>

<li><a href="<%= RPLServlet.ADD_TEACHER %>">Add new Teacher account</a></li>
<li><a href="<%= RPLServlet.ADD_CLERICAL %>">Add new Clerical account</a></li>
<li><a href="<%= RPLServlet.ADD_ADMIN %>">Add new Admin account</a></li>
<li><a href="<%= RPLServlet.ADMIN_LIST_ACCOUNTS %>">Modify permissions for existing account</a></li>
<li><a href="<%= RPLServlet.MAINTAIN_TABLE_SERVLET %>">Data entry/maintenance page</a></li>
<li><a href="<%= RPLPage.TEACHER_HOME %>">Assess or approve claims</a></li>
<li><a href="">Assign assessors to claims</a></li>
<li><a href="">Assign assessors/delegates to courses/disciplines</a></li>
<li><a href="<%= RPLServlet.LIST_ERRORS %>?view=">Manage Error Codes</a></li>
<li><a href="accessHistory.jsp">View Access History</a></li>
<li><a href="<%= RPLServlet.LOGOUT_SERVLET %>">Log out</a></li>
                         
                        
<%@include file="../WEB-INF/jspf/footer.jspf" %>
