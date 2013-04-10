<%--@author     Adam Shortall, Todd Wiggins
 *  @version    1.1
 *    Created:    09/05/2011, 7:19:54 PM
 *	Modified:   10/04/2013
 *	Change Log: 1.1: TW: Updated to the current version of the database. Added fields, changed from table layout to divs, spans and labels. Added Terms and Privacy checkboxes.
 *				1.2: TW: (NOT DONE YET) Data Validation update: User now selects a state instead of manual input.
 *	Purpose:    A simple student user registration form.
--%>
<%@include file="WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.REGISTER; %>

<%@page import="domain.User"%>
<jsp:useBean id="userIDError" scope="request" class="util.RPLError"/>
<jsp:useBean id="firstNameError" scope="request" class="util.RPLError"/>
<jsp:useBean id="lastNameError" scope="request" class="util.RPLError"/>
<jsp:useBean id="emailError" scope="request" class="util.RPLError"/>
<jsp:useBean id="passwordError" scope="request" class="util.RPLError"/>
<jsp:useBean id="passwordConfirmError" scope="request" class="util.RPLError"/>

<form action="register" method="post" name="studentForm">
<h3>Enter your details:</h3>
<p>${studentUniqueError.message}</p>
<div>
    <div>
		<span><label for="userID">TAFE Student Number:</label></span>
		<span><input type="text" name="userID" maxlength="9" size="40" value="${user.userID}"/></span>
		<span>${userIDError.message}</span>
	</div>
    <div>
		<span><label for="firstName">First Name:</label></span>
		<span><input type="text" name="firstName" size="40" value="${user.firstName}"/></span>
		<span>${firstNameError.message}</span>
	</div>
    <div>
		<span><label for="otherName">Other Name:</label></span>
		<span><input type="text" name="otherName" size="40" value="${user.otherName}"/></span>
	</div>
    <div>
		<span><label for="lastName">Last Name:</label></span>
		<span><input type="text" name="lastName" size="40" value="${user.lastName}"/></span>
		<span>${lastNameError.message}</span>
	</div>
    <div>
		<span><label for="email">TAFE email address:</label></span>
		<span><input type="text" name="email" maxlength="60" size="40" value="${user.email}"/></span>
		<span>${emailError.message}</span>
	</div>
    <div>
		<span><label for="address1">Address Line 1:</label></span>
		<span><input type="text" name="address1" size="40" value="${user.address[0]}"/></span>
	</div>
    <div>
		<span><label for="address2">Address Line 2:</label></span>
		<span><input type="text" name="address2" size="40" value="${user.address[1]}"/></span>
	</div>
    <div>
		<span><label for="town">Town:</label></span>
		<span><input type="text" name="town" size="40" value="${user.town}"/></span>
	</div>
    <div>
		<span><label for="state">State:</label></span>
		<span><input type="text" name="state" size="40" value="${user.state}"/></span>
	</div>
    <div>
		<span><label for="postCode">Post Code:</label></span>
		<span><input type="text" name="postCode" maxlength="4" size="4" value="${user.postCode}"/></span>
	</div>
    <div>
		<span><label for="phone">Phone Number:</label></span>
		<span><input type="text" name="phone" maxlength="16" size="40" value="${user.phoneNumber}"/></span>
	</div>
    <div>
		<span><label for="email">Choose a password:</label></span><%-- TODO: password encryption, challenge/response authentication --%>
		<span><input type="password" name="password" size="40"/></span>
		<span>${passwordError.message}</span>
	</div>
    <div>
		<span><label for="email">Confirm password:</label></span><%-- TODO: password encryption, challenge/response authentication --%>
		<span><input type="password" name="passwordConfirm" size="40"/></span>
		<span>${passwordConfirmError.message}</span>
	</div>
    <div>
		<span><input type="checkbox" name="staff" value="staff" ${user.staff ? "checked=\"checked\"" : ""}/>Are you a TAFE Staff Member?</span>
	</div>
    <div>
		<span><input type="checkbox" name="acceptTerms" value="terms"/>Do you accept the <a href="<%= RPLPage.ROOT %>/legal/terms.jsp">Terms &amp; Conditions</a>?</span><br/>
		<span><input type="checkbox" name="acceptTerms" value="privacy"/>Do you accept the <a href="<%= RPLPage.ROOT %>/legal/privacy.jsp">Privacy Policy</a>?</span>
	</div>
    <div>
    <%-- http://download.oracle.com/docs/cd/E12840_01/wls/docs103/dvspisec/servlet.html --%>
        <input type="submit" value="Submit"/> <a href="home">Cancel</a>
	</div>
</div>
</form>

<%@include file="WEB-INF/jspf/footer.jspf" %>
