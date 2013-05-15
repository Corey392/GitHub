<%--Purpose:    Allows a user to change their password.
 *  @author     Todd Wiggins
 *  @version    1.001
 *  Created:    12/04/2013
 *	Change Log: 15/05/2013: TW: Improving display of errors to be consistent across site.
--%>
<%@include file="WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.CHANGE_PW; %>

<%@page import="domain.User"%>
<jsp:useBean id="passwordError" scope="request" class="util.RPLError"/>
<jsp:useBean id="passwordConfirmError" scope="request" class="util.RPLError"/>

<form action="ChangePassword" method="post" name="changePwForm">
<h3>Change your password:</h3>
<div>
    <div>
		<span><label for="userID">User ID:</label> ${user.userID}</span>
	</div>
    <div>
		<span><label for="password">Current password:</label></span>
		<span><input type="password" name="password" size="20"/></span>
	</div>
    <div>
		<span><label for="passwordNew">New password:</label></span>
		<span><input type="password" name="passwordNew" size="20"/></span>
	</div>
    <div>
		<span><label for="passwordConfirm">Confirm new password:</label></span>
		<span><input type="password" name="passwordConfirm" size="20"/></span>
	</div>
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