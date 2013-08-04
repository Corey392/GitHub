<%-- 
    Document   : manageTeachers
    Purpose    : allows delegate users to set which assessors can assess specific displine,
    Created on : 02/08/2013, 8:27:03 PM
    Author     : Vince Lombardo
--%>

<%@page import="web.FormManageTeachers"%>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.ADMIN_MANAGE_TEACHERS; %>

<%--<%@page contentType="text/html" pageEncoding="UTF-8"%>--%>

<%--<c:if test="${sessionScope.selectedUser == null}">
    <c:redirect url="<%= RPLPage.ADMIN_HOME.relativeAddress %>" />
</c:if>--%>

<form action="<%= FormManageTeachers.ACTION %>" method="post" name="<%= FormManageTeachers.NAME %>">
    
<!--<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <select id="cc" class="easyui-combobox" name="dept" style="width:200px;">  
            <option value="aa">aitem1</option>  
            <option>bitem2</option>  
            <option>bitem3</option>  
            <option>ditem4</option>  
            <option>eitem5</option>  
        </select>  
    </body>
</html>-->
<h1>Welcome - Manage Teachers</h1>
</form>

<%@include file="../WEB-INF/jspf/footer.jspf" %>