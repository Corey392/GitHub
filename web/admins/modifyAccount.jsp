<%-- 
    Document   : modifyAccount
    Purpose    : allows admin users to set other teachers as admins,
                 teachers or delete the account.
    Created on : 08/07/2011, 5:10:22 PM
    Author     : Adam Shortall
--%>
<%@page import="domain.User"%>
<%@page import="web.FormAdminModifyAccount"%>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.ADMIN_MODIFY_USER; %>

<c:if test="${sessionScope.selectedUser == null}">
    <c:redirect url="<%= RPLPage.ADMIN_HOME.relativeAddress %>" />
</c:if>

<jsp:useBean id="selectedUser"   scope="session" class="domain.User"/>
<jsp:useBean id="errID"          scope="request" class="util.RPLError"/>
<jsp:useBean id="errLastName"    scope="request" class="util.RPLError"/>
<jsp:useBean id="errUnique"      scope="request" class="util.RPLError"/>
<jsp:useBean id="passwordReset" scope="request" class="util.RPLError"/>

<form action="<%= FormAdminModifyAccount.ACTION %>" method="post" name="<%= FormAdminModifyAccount.NAME %>">
<table>
    <thead align="left">
        <tr><th colspan="2">Modify User account</th></tr>
        <tr><th colspan="2">User ID: ${selectedUser.userID}</th></tr>
        <tr><th colspan="2">${passwordReset.message}</th></tr>
    </thead>
    <tbody>
        <tr>
            <td>
                Is admin:
            </td>
            <td>
                <input type="checkbox" name="<%= FormAdminModifyAccount.IS_ADMIN %>" 
                       value="<%= FormAdminModifyAccount.IS_ADMIN %>" 
                       <% if(selectedUser.role == domain.User.Role.ADMIN){ %> checked <% } %> 
                />
            </td>
        </tr>
        <tr>
            <td>User ID/Email: </td>
            <td><input type="text" name="<%= FormAdminModifyAccount.USER_ID%>" value="${selectedUser.userID}" /></td>
        </tr>
        <tr>
            <td>First Name:</td>
            <td><input type="text" name="<%= FormAdminModifyAccount.F_NAME%>" value="${selectedUser.firstName}" /></td>
        </tr>
        <tr>
            <td>Last Name:</td>
            <td><input type="text" name="<%= FormAdminModifyAccount.L_NAME%>" value="${selectedUser.lastName}" /></td>
        </tr>
        <tr>
            <td>Reset password to a new random password?</td>
            <td>
                <input type="checkbox" name="<%= FormAdminModifyAccount.RESET_PW%>" 
                       value="<%= FormAdminModifyAccount.RESET_PW%>" 
                />
            </td>
        </tr>        
        <tr>
            <td colspan="2">
                <input type="submit" value="Submit" name="<%= FormAdminModifyAccount.SUBMIT %>" />
                <input type="submit" value="Cancel" name="<%= FormAdminModifyAccount.CANCEL %>" />
            </td>      
        </tr>
    </tbody>
</table>
</form>

<%@include file="../WEB-INF/jspf/footer.jspf" %>