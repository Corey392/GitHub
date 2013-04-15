<%--@author     Adam Shortall, Todd Wiggins
 *  @version    1.00
 *  Created:    12/04/2013
 *	Modified:
 *	Change Log:
 *	Purpose:    Allows a student to update their account details.
--%>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.STUDENT_DETAILS; %>

<%@page import="domain.User"%>
<jsp:useBean id="userIDError" scope="request" class="util.RPLError"/>
<jsp:useBean id="firstNameError" scope="request" class="util.RPLError"/>
<jsp:useBean id="lastNameError" scope="request" class="util.RPLError"/>
<jsp:useBean id="emailError" scope="request" class="util.RPLError"/>
<jsp:useBean id="passwordError" scope="request" class="util.RPLError"/>

<form action="update" method="post" name="studentUpdateDetails">
<h3>Manage Your Details:</h3>
<div>
    <div>
		<span><label for="userID">TAFE Student Number:</label></span>
		<span><input type="text" name="userID" maxlength="9" size="10" value="${user.userID}"/></span>
		<span>${userIDError.message}</span>
	</div>
    <div>
		<span><label for="firstName">First Name:</label></span>
		<span><input type="text" name="firstName" size="30" value="${user.firstName}"/></span>
		<span>${firstNameError.message}</span>
	</div>
    <div>
		<span><label for="otherName">Other Name:</label></span>
		<span><input type="text" name="otherName" size="30" value="${user.otherName}"/></span>
	</div>
    <div>
		<span><label for="lastName">Last Name:</label></span>
		<span><input type="text" name="lastName" size="30" value="${user.lastName}"/></span>
		<span>${lastNameError.message}</span>
	</div>
    <div>
		<span><label>TAFE email address:</label> ${user.email}</span>
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
		<span><input type="text" name="town" size="30" value="${user.town}"/></span>
	</div>
    <div>
		<span><label for="state">State:</label></span>
		<span><select name="state">
				<option value="NSW"${user.state.equals("NSW") ? " selected=\"selected\"" : ""}>New South Wales</option>
				<option value="ACT"${user.state.equals("ACT") ? " selected=\"selected\"" : ""}>Australian Capital Territory</option>
				<option value="NT"${user.state.equals("NT") ? " selected=\"selected\"" : ""}>Northern Territory</option>
				<option value="QLD"${user.state.equals("QLD") ? " selected=\"selected\"" : ""}>Queensland</option>
				<option value="SA"${user.state.equals("SA") ? " selected=\"selected\"" : ""}>South Australia</option>
				<option value="TAS"${user.state.equals("TAS") ? " selected=\"selected\"" : ""}>Tasmania</option>
				<option value="VIC"${user.state.equals("VIC") ? " selected=\"selected\"" : ""}>Victoria</option>
				<option value="WA"${user.state.equals("WA") ? " selected=\"selected\"" : ""}>Western Australia</option>
			</select></span>
	</div>
    <div>
		<span><label for="postCode">Post Code:</label></span>
		<span><input type="text" name="postCode" maxlength="4" size="4" value="${user.postCode}"/></span>
	</div>
    <div>
		<span><label for="phone">Phone Number:</label></span>
		<span><input type="tel" name="phone" maxlength="16" size="20" value="${user.phoneNumber}"/></span>
	</div>
    <div>
		<span><input type="checkbox" name="staff" value="yes"${user.staff ? "checked=\"checked\"" : ""}/>Are you a TAFE Staff Member?</span>
	</div>
	<div>
		<p>Your current password is required to update your details.</p>
	</div>
    <div>
		<span><label for="password">Current password:</label></span><%-- TODO: password encryption, challenge/response authentication --%>
		<span><input type="password" name="password" size="20"/></span>
		<span>${passwordError.message}</span>
	</div>
    <div>
    <%-- http://download.oracle.com/docs/cd/E12840_01/wls/docs103/dvspisec/servlet.html --%>
        <input type="submit" value="Submit"/> <a href="../home">Cancel</a>
	</div>
	<p>${successfulMSG.message}</p>
</div>
</form>

<%@include file="../WEB-INF/jspf/footer.jspf" %>