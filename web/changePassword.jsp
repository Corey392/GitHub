<%--Purpose:    Allows a user to change their password.
 *  @author     Todd Wiggins, Added this here as a test for GitHub!
 *  @version    1.002
 *  Created:    12/04/2013
 *	Change Log: 15/05/2013: TW: Improving display of errors to be consistent across site.
 *	            02/06/2013: TW: Added some basic instructions.
--%>
<%@include file="WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.CHANGE_PW; %>

<%@page import="domain.User"%>
<jsp:useBean id="passwordError" scope="request" class="util.RPLError"/>
<jsp:useBean id="passwordConfirmError" scope="request" class="util.RPLError"/>

<form action="ChangePassword" method="post" name="changePwForm">
<h3>Change your password:</h3>
<div>
	<p>To update your password, enter your current password then type in your new password and again to confirm your new password.</p>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="3">
 <TR>
		<td><label for="userID">Your User ID:</label></td> <td>${user.userID}</td>
	</TR>
    <TR>
		<td><label for="password">Your Current password:</label></td>
		<td><input type="password" name="password" size="20"/></td>
	</TR>
    <TR>
		<td><label for="passwordNew">Your New password:</label></td>
		<td><input type="password" name="passwordNew" size="20"/></td>
	</TR>
    <TR>
		<td><label for="passwordConfirm">Confirm your new password:</label></td>
		<td><input type="password" name="passwordConfirm" size="20"/></td>
	</TR>
        </table>
	<c:if test="${passwordError.message.length() > 0 || passwordNewError.message.length() > 0 || passwordConfirmError.message.length() > 0}">
		<div id="errorMessage">${passwordError.message}<br/>${passwordNewError.message}<br/>${passwordConfirmError.message}</div>
	</c:if>
    <div>
        <input type="submit" value="Submit"/> <a href="home">Cancel</a>
	</div>
	<c:if test="${successfulMSG.message.length() > 0}">
		<div id="successMessage">${successfulMSG.message}</div>
	</c:if>
</div>
</form>

<%@include file="WEB-INF/jspf/footer.jspf" %>