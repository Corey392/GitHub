<%-- 
    Document   : manageUsers
    Purpose    : allows delegate users to set which user
    Created on : 02/08/2013, 8:27:03 PM
    Author     : Vince Lombardo
--%>

<%@page import="web.FormAdminManageUsers"%>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>

<%! RPLPage thisPage = RPLPage.ADMIN_MANAGE_USERS; %>
<jsp:useBean id="claim" class="domain.Claim" scope="request"/>
<jsp:useBean id="listError" scope="request" class="util.RPLError"/>

<form name="<%= FormAdminManageUsers.NAME %>" action="<%= FormAdminManageUsers.ACTION %>" method="post">
    <h1>Manage Users Form</h1>
</form>

<%@include file="../WEB-INF/jspf/footer.jspf" %>
