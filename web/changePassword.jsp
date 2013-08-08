<%--Purpose:    Allows a user to change their password.
 *  @author     Todd Wiggins
 *  @version    1.002
 *  Created:    12/04/2013
 *	Change Log: 15/05/2013: TW: Improving display of errors to be consistent across site.
 *	            02/06/2013: TW: Added some basic instructions.
--%>
<%@include file="WEB-INF/jspf/header_1.jspf" %>
<%! RPLPage thisPage = RPLPage.CHANGE_PW;%>

<%@page import="domain.User"%>
<jsp:useBean id="passwordError" scope="request" class="util.RPLError"/>
<jsp:useBean id="passwordConfirmError" scope="request" class="util.RPLError"/>

<h1>Change Password</h1>

<form action="ChangePassword" method="post" name="changePwForm">
    <fieldset>
        <p><label>User Name:</label><input type="text" value="${user.userID}" disabled="true" /></p>

        <p><label>Old Password:</label><input type="password" name="password" size="20"/></p>

        <p><label>New Password:</label><input type="password" name="passwordNew" size="20"/></p>

        <p><label>Confirm Password:</label><input type="password" name="passwordConfirm" size="20"/></p>

        <c:if test="${passwordError.message.length() > 0 || passwordNewError.message.length() > 0 || passwordConfirmError.message.length() > 0}">
            <div id="errorMessage">${passwordError.message}<br/>${passwordNewError.message}<br/>${passwordConfirmError.message}
            </c:if>

            <p> <label>&nbsp;</label><input type="submit" value="Submit"/></p>

            <c:if test="${successfulMSG.message.length() > 0}">
                <div id="successMessage">${successfulMSG.message}</div>
            </c:if>
    </fieldset>
</form>

<%@include file="WEB-INF/jspf/footer_1.jspf" %>