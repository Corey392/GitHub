<%-- 
    Document   : listAccounts
    Created on : 10/07/2011, 3:27:03 PM
    Author     : Adam Shortall
--%>
<%@page import="web.FormAdminListAccounts"%>
<%@page import="domain.User"%>
<%@page import="web.FormAdminListAccounts"%>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.ADMIN_LIST_USERS; %>

<c:if test="${requestScope.accounts == null}">
    <c:redirect url="<%= RPLPage.ADMIN_HOME.relativeAddress %>" />
</c:if>

<jsp:useBean id="accounts" scope="request" class="java.util.ArrayList" />

<form action="<%= FormAdminListAccounts.ACTION %>" method="post" name="<%= FormAdminListAccounts.NAME %>">
<table>
    <thead align="left">
        <tr>
            <th colspan="2">Select an existing user account to modify permissions</th>
        </tr>
        <tr>  
            <th colspan="2" align="right"><input type="submit" value="Cancel" name="<%= Form.CANCEL %>" /></th>
        </tr>
        <tr>
            <th>Account ID</th><th>Select to modify</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="account" items="${accounts}">
            <tr>
                <td>${account.userID}</td>
                <td><input type="submit" name="<%= FormAdminListAccounts.selectedAccountID %>:${account.userID}" value="Modify Account"/></td>
            </tr>
        </c:forEach>
    </tbody>
</table>
</form>

<%@include file="../WEB-INF/jspf/footer.jspf" %>
