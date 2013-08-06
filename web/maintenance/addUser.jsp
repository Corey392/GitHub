<%-- 
    Document   : AddUser
    Created on : 07/05/2013
    Author     : Ryan Donaldson, Mitch Carr
    Changelog:  18/05/2013: MC: Changed "home" to "index.jsp"; home refers to /maintanence/home rather than /home. 
                            The former does not exist, the latter points to /maintenance/index.jsp anyway.
                            This change prevents "Cancel" from taking the user to a non-existent page.
--%>


<%@page import="domain.User"%>
<%@page import="web.FormAddTeacher"%>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<%! RPLPage thisPage = RPLPage.REGISTER_USER; %>

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
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="3">
 <TR>
		<td><label for="userID">User Name:</label></td>
		<td><input type="text" name="userID" maxlength="9" size="10"/></td>
		<td>${userIDError.message}</td>
	</TR>
    <TR>
		<td><label for="role">Role:</label></td>
		<td><select name="role">
				<option value="T"${user.role.equals("T") ? " selected=\"selected\"" : ""}>Teacher</option>
				<option value="A"${user.role.equals("A") ? " selected=\"selected\"" : ""}>Assessor</option>
				<option value="C"${user.role.equals("C") ? " selected=\"selected\"" : ""}>Clerical Admin</option>
			</select></td>
	</TR>
    <TR>
		<td><label for="firstName">First Name:</label></td>
		<td><input type="text" name="firstName" size="30" value="${user.firstName}"/></td>
		<td>${firstNameError.message}</td>
	</TR>
    <TR>
		<td><label for="otherName">Other Name:</label></td>
		<td><input type="text" name="otherName" size="30" value="${user.otherName}"/></td>
	</TR>
    <TR>
		<td><label for="lastName">Last Name:</label></td>
		<td><input type="text" name="lastName" size="30" value="${user.lastName}"/></td>
		<td>${lastNameError.message}</td>
	</TR>
    <TR>
		<td><label for="email">TAFE email address:</label></td>
		<td><input type="email" name="email" maxlength="60" size="40" value="${user.email}"/></td>
		<td>${emailError.message}</td>
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
        </table>
    <div>
		<span><input type="checkbox" name="acceptTerms" value="yes"/>Do you accept the <a href="<%= RPLPage.ROOT %>/legal/terms.jsp">Terms &amp; Conditions</a>?</span><br/>
		<span><input type="checkbox" name="acceptPrivacy" value="yes"/>Do you accept the <a href="<%= RPLPage.ROOT %>/legal/privacy.jsp">Privacy Policy</a>?</span>
		<div>${termsAndCondError.message}</div>
	</div>
    <div>
    <%-- http://download.oracle.com/docs/cd/E12840_01/wls/docs103/dvspisec/servlet.html --%>
        <input type="submit" value="Submit"/> <a href="index.jsp">Cancel</a>
	</div>
</div>
</form>

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>