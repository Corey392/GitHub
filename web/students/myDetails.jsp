<%--Purpose:    Allows a Student to update their personal details.
 *  @author     Adam Shortall, Todd Wiggins, Mitch Carr
 *  @version    1.011
 *  Created:    ?
 *	Modified:	12/04/2013: TW: Added additonal fields for user details.
 *                      15/05/2013: TW: Improving display of errors to be consistent across site.
 *                      16/05/2013: MC: Fixed error in password error check; changed invalid String length property to length() method
 *                      05/08/2013: CW: Changed header/footer imports.
--%>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>
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
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="3">
 <TR>
		<td>TAFE Student Number:</td> <td>${user.userID}</td>
                <td><input type="hidden" name="userID" value="${user.userID}"></td>
	</TR>
    <TR>
		<td><label for="firstName">First Name:</label></td>
		<td><input type="text" name="firstName" size="30" value="${user.firstName}"/></td>
	</TR>
    <TR>
		<td><label for="otherName">Other Name:</label></td>
		<td><input type="text" name="otherName" size="30" value="${user.otherName}"/></td>
	</TR>
    <TR>
		<td><label for="lastName">Last Name:</label></td>
		<td><input type="text" name="lastName" size="30" value="${user.lastName}"/></td>
	</TR>
    <TR>
        <td><label>TAFE email address:</label></td> <td> ${user.email}</td>
	</TR>
    <TR>
		<td><label for="address1">Address Line 1:</label></td>
		<td><input type="text" name="address1" size="40" value="${user.address[0]}"/></td>
	</TR>
    <TR>
		<td><label for="address2">Address Line 2:</label></td>
		<td><input type="text" name="address2" size="40" value="${user.address[1]}"/></td>
	</TR>
    <TR>
		<td><label for="town">Town:</label></td>
		<td><input type="text" name="town" size="30" value="${user.town}"/></td>
	</TR>
    <TR>
		<td><label for="state">State:</label></td>
		<td><select name="state">
				<option value="NSW"${user.state.equals("NSW") ? " selected=\"selected\"" : ""}>New South Wales</option>
				<option value="ACT"${user.state.equals("ACT") ? " selected=\"selected\"" : ""}>Australian Capital Territory</option>
				<option value="NT"${user.state.equals("NT") ? " selected=\"selected\"" : ""}>Northern Territory</option>
				<option value="QLD"${user.state.equals("QLD") ? " selected=\"selected\"" : ""}>Queensland</option>
				<option value="SA"${user.state.equals("SA") ? " selected=\"selected\"" : ""}>South Australia</option>
				<option value="TAS"${user.state.equals("TAS") ? " selected=\"selected\"" : ""}>Tasmania</option>
				<option value="VIC"${user.state.equals("VIC") ? " selected=\"selected\"" : ""}>Victoria</option>
				<option value="WA"${user.state.equals("WA") ? " selected=\"selected\"" : ""}>Western Australia</option>
			</select></td>
	</TR>
    <TR>
		<td><label for="postCode">Post Code:</label></td>
		<td><input type="text" name="postCode" maxlength="4" size="4" value="${user.postCode}"/></td>
	</TR>
    <TR>
		<td><label for="phone">Phone Number:</label></td>
		<td><input type="tel" name="phone" maxlength="16" size="20" value="${user.phoneNumber}"/></td>
	</TR>
	<TR>
		<p>Your current password is required to update your details.</p>
	</TR>
    <TR>
		<td><label for="password">Current password:</label></td>
		<td><input type="password" name="password" size="20"/></td>
	</TR>
        </table>
	<c:if test="${passwordError.message.length() > 0 || firstNameError.message.length() > 0 || lastNameError.message.length() > 0 || userIDError.message.length() > 0}">
		<div id="errorMessage">${userIDError.message}<br/>${passwordError.message}<br/>${firstNameError.message}<br/>${lastNameError.message}</div>
	</c:if>
    <div>
		<input type="submit" value="Submit"/> <a href="../home">Cancel</a>
	</div>
	<c:if test="${successfulMSG.message.length() > 0}">
		<div id="successMessage">${successfulMSG.message}</div>
	</c:if>
</div>
</form>

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>
