
<%-- 
    Document   : index
    Created on : 14/05/2011, 9:41:41 AM
    Author     : James
--%>

<%! RPLPage thisPage = RPLPage.STUDENT_HOME; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>

<h1>Student Home Page</h1>
<p>Welcome ${user.firstName} ${user.lastName}</p>

<ul>
    <li><a href="<%= RPLServlet.CREATE_CLAIM_SERVLET %>?createClaim=true">Create Claim</a></li>
    <li><a href="<%= RPLServlet.LIST_CLAIMS_STUDENT_SERVLET %>?List%20Claims=true">List Claims</a></li>
    <li><a href="<%= RPLServlet.STUDENT_LIST_CLAIM_RECORDS %>?view=View%20Claim%20Status">View Claim Status</a></li>
    <li><a href="<%= RPLServlet.LOGOUT_SERVLET %>?Logout=true">Logout</a></li>
</ul>

<%@include file="../WEB-INF/jspf/footer.jspf" %>