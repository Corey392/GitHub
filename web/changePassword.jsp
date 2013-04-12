<%--@author     Todd Wiggins
 *  @version    1.00
 *  Created:    12/04/2013
 *	Modified:
 *	Change Log:
 *	Purpose:    Allows a user to change their password.
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
		<span><label for="password">Current password:</label></span><%-- TODO: password encryption, challenge/response authentication --%>
		<span><input type="password" name="password" size="20"/></span>
		<span>${passwordError.message}</span>
	</div>
    <div>
		<span><label for="passwordNew">New password:</label></span><%-- TODO: password encryption, challenge/response authentication --%>
		<span><input type="password" name="passwordNew" size="20"/></span>
		<span>${passwordNewError.message}</span>
	</div>
    <div>
		<span><label for="passwordConfirm">Confirm new password:</label></span><%-- TODO: password encryption, challenge/response authentication --%>
		<span><input type="password" name="passwordConfirm" size="20"/></span>
		<span>${passwordConfirmError.message}</span>
	</div>
    <div>
        <input type="submit" value="Submit"/> <a href="home">Cancel</a>
	</div>
	<p>${successfulMSG.message}</p>
</div>
</form>

<%@include file="WEB-INF/jspf/footer.jspf" %>