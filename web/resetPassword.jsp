<%--Purpose:    Allows a Student and other Users to request a password reset.
 *  @author     Todd Wiggins
 *  @version    1.002
 *  Created:    11/04/2013
 *	Change Log: 15/05/2013: TW: Improving display of errors to be consistent across site.
 *	            02/06/2013: TW: Consolidated error messages.
--%>
<%@include file="WEB-INF/jspf/header_1.jspf" %>
<%! RPLPage thisPage = RPLPage.RESET_PASSWORD; %>

<%@page import="domain.User"%>
<jsp:useBean id="userIDError" scope="request" class="util.RPLError"/>
<jsp:useBean id="emailError" scope="request" class="util.RPLError"/>

<form action="ResetPassword" method="post" name="resetPwForm">
<h2>Password Reset:</h2>
<p>Please enter either your TAFE email address or TAFE Student ID and a new password will be sent to your email address.</p>
<div>
    <div>
		<span><label for="userID">TAFE Student Number:</label></span>
		<span><input type="text" name="userID" maxlength="9" size="10" value="${user.userID}"/></span>
	</div>
    <div>
		<span><label for="email">TAFE email address:</label></span>
		<span><input type="email" name="email" maxlength="60" size="40" value="${user.email}"/></span>
	</div>
    <div>
        <input type="submit" value="Submit"/> <a href="home">Cancel</a>
	</div>
	<c:if test="${status.message.length() > 0 || userIDError.message.length() > 0 || emailError.message.length() > 0}">
		<div id="errorMessage">${status.message}<br/>${userIDError.message}<br/>${emailError.message}</div>
	</c:if>
</div>
<p>If you have not previously registered for the RPL Assist web site, you will need to register for this site separately as being a TAFE student does not automatically provide you with access to this tool.</p>
</form>

<%@include file="WEB-INF/jspf/footer.jspf" %>