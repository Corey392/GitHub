<%-- 
    Document   : index
    Created on : 14/05/2011, 9:41:41 AM
    Author     : James, David
--%>

<%@page import="java.util.*" %>

<%! 
    RPLPage thisPage = RPLPage.TEACHER_HOME;
    String title = RPLPage.TEACHER_HOME.title;
%>

<%@include file="../WEB-INF/jspf/header.jspf" %>
                
<div id="container">

    <div class="sidebar">
        <a class="button" href="<%= RPLServlet.VIEW_TEACHER_CLAIM_SERVLET %>?List%20Claims=true"><span>List Available Claims</span></a>
        <a class="button" href="<%= RPLServlet.TEACHER_LIST_CLAIM_RECORDS %>?view=View%20Claim%20Status"><span>View Claim History</span></a>
        <a class="button" href="<%= RPLServlet.LOGOUT_SERVLET %>?Logout=true"><span>Logout</span></a>
    </div>

    <div class="body">
        <h1>Teacher Home Page</h1>
        <p>Welcome to ${user.firstName} ${user.lastName}</p>
    </div>
</div>                

<%@include file="../WEB-INF/jspf/footer.jspf" %>