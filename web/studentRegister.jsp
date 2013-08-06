<%--Purpose:    A simple student user registration form.
 *  @author     Adam Shortall, Todd Wiggins
 *  @version    1.111
 *  Created:    09/05/2011, 7:19:54 PM
 *	Change Log: 1.10: TW: Updated to the current version of the database. Added fields, changed from table layout to divs, spans and labels. Added Terms and Privacy checkboxes.
 *				11/04/2013: TW: Data Validation update: User now selects a state instead of manual input.
 *				15/05/2013: TW: Improving display of errors to be consistent across site.
--%>
<%@include file="WEB-INF/jspf/header_1.jspf" %>
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
<div>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="3">
 <TR>
        <td><label for="userID">TAFE Student Number:</label></td>
	<td><input type="text" name="userID" maxlength="9" size="10" value="${user.userID}"/></td>
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
		<td><label for="email">TAFE email address:</label></td>
		<td><input type="email" name="email" maxlength="60" size="40" value="${user.email}"/></td>
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
		<td><label for="state">State:</label>
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
		<td><label for="password">Choose a password:</label></td>
		<td><input type="password" name="password" size="20"/></td>
        </TR>
    <TR> 
		<td><label for="passwordConfirm">Confirm password:</label></td>
                <td><input type="password" name="passwordConfirm" size="20"/></td>
        </TR>
</table>
    <div>
		<input type="checkbox" name="staff" value="yes"${user.staff ? "checked=\"checked\"" : ""}/>Are you a TAFE Staff Member?
	</div>
    <div>
		<input type="checkbox" name="acceptTerms" value="yes"/>Do you accept the <a href="<%= RPLPage.ROOT %>/legal/terms.jsp">Terms &amp; Conditions</a>?<br/>
		<input type="checkbox" name="acceptPrivacy" value="yes"/>Do you accept the <a href="<%= RPLPage.ROOT %>/legal/privacy.jsp">Privacy Policy</a>?
	</div>
	<c:if test="${studentUniqueError.message.length() > 0 ||
					userIDError.message.length() > 0 ||
					firstNameError.message.length() > 0 ||
					lastNameError.message.length() > 0 ||
					emailError.message.length() > 0 ||
					passwordError.message.length() > 0 ||
					passwordConfirmError.message.length() > 0 ||
					termsAndCondError.message.length() > 0}">
		<div id="errorMessage">${studentUniqueError.message}<br/>
					${userIDError.message}<br/>
					${firstNameError.message}<br/>
					${lastNameError.message}<br/>
					${emailError.message}<br/>
					${passwordError.message}<br/>
					${passwordConfirmError.message}<br/>
					${termsAndCondError.message}</div>
	</c:if>
    <div>
        <input type="submit" value="Submit"/> <a href="home">Cancel</a>
	</div>
</div>
</form>

<%@include file="WEB-INF/jspf/footer.jspf" %>