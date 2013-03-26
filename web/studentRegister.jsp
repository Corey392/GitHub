<%-- 
    Document   : studentRegister
    Created on : 09/05/2011, 7:19:54 PM
    Author     : Adam
--%>
<%@page import="domain.User"%>
<%@include file="WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.REGISTER; %>

<jsp:useBean id="userIDError" scope="request" class="util.RPLError"/>
<jsp:useBean id="firstNameError" scope="request" class="util.RPLError"/>
<jsp:useBean id="lastNameError" scope="request" class="util.RPLError"/>
<jsp:useBean id="emailError" scope="request" class="util.RPLError"/>
<jsp:useBean id="passwordError" scope="request" class="util.RPLError"/>
<jsp:useBean id="passwordConfirmError" scope="request" class="util.RPLError"/>
<jsp:useBean id="user" scope="session" class="domain.User" />

<form action="register" method="post" name="studentForm">
<table>
    <thead align="left">
        <tr>
            <th colspan="2">Enter student details</th>
        </tr>
        <tr>
            <th colspan="2">${studentUniqueError.message}</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>TAFE Student Number:</td>
            <td><input type="text" name="userID" maxlength="9" size="40" value="${user.userID}"/>
                ${userIDError.message}
            </td>
        </tr>
        <tr>
            <td>First Name:</td>
            <td><input type="text" name="firstName" maxlength="20" size="40" value="${user.firstName}"/>
                ${firstNameError.message}
            </td>
        </tr>
        <tr>
            <td>Last Name:</td>
            <td><input type="text" name="lastName" maxlength="20" size="40" value="${user.lastName}"/>
                ${lastNameError.message}
            </td>
        </tr>
        <tr>
            <td>TAFE email address:</td>
            <td><input type="text" name="email" maxlength="60" size="40" value="${user.email}"/>
                ${emailError.message}
            </td>
        </tr>
        <tr>
            <td>Choose a password:</td> <%-- TODO: password encryption, challenge/response authentication --%>
            <td><input type="password" name="password" size="40" />
                ${passwordError.message}
            </td>
        </tr>
        <tr>
            <td>Confirm password:</td>
            <td><input type="password" name="passwordConfirm" size="40" />
                ${passwordConfirmError.message}
            </td>
        </tr>
        <%-- http://download.oracle.com/docs/cd/E12840_01/wls/docs103/dvspisec/servlet.html --%>
        <tr>
            <td colspan="2"><input type="submit" value="Submit"/></td>           
        </tr>
        <tr>
            <td><a href="home">Cancel</a></td>
        </tr>
    </tbody>
</table>
</form>

<%@include file="WEB-INF/jspf/footer.jspf" %>
