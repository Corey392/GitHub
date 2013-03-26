<%-- 
    Document   : index
    Created on : 26/05/2011, 2:25:45 PM
    Author     : Adam Shortall
--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_HOME; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>

<h1>RPL Data Maintenance</h1>


        <%@include file="../WEB-INF/jspf/maintenanceOptions.jspf" %>
    

<ul>
    <li><a href="<%= RPLServlet.MAINTAIN_TABLE_SERVLET %>?selectedTable=Campus">Add/Modify Campuses or campus-sepcific data</a></li>
    <li><a href="<%= RPLServlet.MAINTAIN_TABLE_SERVLET %>?selectedTable=Discipline">Add/Modify Disciplines (will be available to add to any campus)</a></li>
    <li><a href="<%= RPLServlet.MAINTAIN_TABLE_SERVLET %>?selectedTable=Course">Add/Modify Courses or course core modules</a></li>
    <li><a href="<%= RPLServlet.MAINTAIN_TABLE_SERVLET %>?selectedTable=Module">Add/Modify Modules, Elements and Criteria</a></li>
</ul>


<%@include file="../WEB-INF/jspf/footer.jspf" %>