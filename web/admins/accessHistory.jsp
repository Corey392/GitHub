<%-- 
    Document   : accessHistory
    Created on : Jun 13, 2012, 1:42:47 PM
    Author     : James
--%>

<%@include file="../WEB-INF/jspf/header.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>
<%! RPLPage thisPage = RPLPage.ADMIN_ACCESS_HISTORY; %>

<%@page language="java" import="domain.*"%>
<%@page language="java" import="data.*"%>
<%@page language="java" import="util.*"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Access History</title>
    </head>
    <body>
        <div class="body">
        <center><h2>View Access History</h2></center>
        <table cellpadding="6" align="center">
            <tr>
                <th>Access ID</th>
                <th>User ID</th>
                <th>Access Date</th>
                <th>Access Type</th>
            </tr>    
        <%
        
        User user = (User) session.getAttribute("user");
        AccessHistoryIO accessIO = new AccessHistoryIO(user.role);
        
        for(AccessHistory ac : accessIO.getList()) {
        %>
            <tr>
                <td><%= ac.getAccessID() %></td>
                <td><%= ac.getUserID() %></td>
                <td><%= ac.getAccessTime() %></td>
                <td><%= ac.getAccessType().equals("I") ? "Log in" : "Log out" %></td>
            </tr>
        <%
        }
        %>
        </table>
        </div>
    </body>
</html>
