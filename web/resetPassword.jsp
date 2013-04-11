<%--@author     Todd Wiggins
 *  @version    1.00
 *  Created:    11/04/2013
 *	Modified:
 *	Change Log:
 *	Purpose:    Allows a Student and other Users to request a password reset.
--%>
<%@include file="WEB-INF/jspf/header.jspf" %>
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
		<span>${userIDError.message}</span>
	</div>
    <div>
		<span><label for="email">TAFE email address:</label></span>
		<span><input type="email" name="email" maxlength="60" size="40" value="${user.email}"/></span>
		<span>${emailError.message}</span>
	</div>
    <div>
    <%-- http://download.oracle.com/docs/cd/E12840_01/wls/docs103/dvspisec/servlet.html --%>
        <input type="submit" value="Submit"/> <a href="home">Cancel</a>
	</div>
	<p>${ status.message }</p>
</div>
<p>If you have not previously registered for the RPL Assist web site, you will need to register for this site separately as being a TAFE student does not automatically provide you with access to this tool.</p>
</form>

<%@include file="WEB-INF/jspf/footer.jspf" %>