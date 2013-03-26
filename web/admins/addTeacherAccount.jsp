<%-- 
    Document   : addTeacherAccount
    Created on : 04/07/2011, 1:32:38 PM
    Author     : Adam Shortall
--%>
<%@page import="domain.User"%>
<%@page import="web.FormAddTeacher"%>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.ADMIN_ADD_USER; %>

<c:if test="${sessionScope.newUser == null}">
    <c:redirect url="<%= RPLPage.ADMIN_HOME.relativeAddress %>" />
</c:if>

<jsp:useBean id="errFirstName"   scope="request" class="util.RPLError"/>
<jsp:useBean id="errID"          scope="request" class="util.RPLError"/>
<jsp:useBean id="errLastName"    scope="request" class="util.RPLError"/>
<jsp:useBean id="errUnique"      scope="request" class="util.RPLError"/>
<jsp:useBean id="confirmSuccess" scope="request" class="util.RPLError"/>
<jsp:useBean id="newUser"        scope="session" type="domain.User" />

<form action="<%= FormAddTeacher.ACTION %>" method="post" name="<%= FormAddTeacher.NAME %>">
<table>
    <thead align="left">
        <tr>
            <th colspan="2">Enter new user's details</th>
        </tr>
        <tr>
            <th colspan="2">${confirmSuccess.message}</th>
        </tr>
    </thead>
    <tbody>
        <c:choose>
            <c:when test="<%= newUser.role == User.Role.CLERICAL %>">
                <tr>
                    <td>Clerical ID/Email address:</td>
                    <td><input type="text" name="<%= FormAddTeacher.TEACHER_ID %>" maxlength="40" size="40" value="${newUser.userID}"/>
                        ${errID.message}${errUnique.message}
                    </td>
                </tr>
            </c:when>
            <c:otherwise>
                <tr>
                    <td>Teacher DET ID:</td>
                    <td><input type="text" name="<%= FormAddTeacher.TEACHER_ID %>" maxlength="40" size="40" value="${newUser.userID}"/>
                        ${errID.message}${errUnique.message}
                    </td>
                </tr>
                <tr>
                    <td>First Name:</td>
                    <td><input type="text" name="<%= FormAddTeacher.F_NAME %>" maxlength="20" size="40" value="${newUser.firstName}"/>
                        ${errFirstName.message}
                    </td>
                </tr>
                <tr>
                    <td>Last Name:</td>
                    <td><input type="text" name="<%= FormAddTeacher.L_NAME %>" maxlength="20" size="40" value="${newUser.lastName}"/>
                        ${errLastName.message}
                    </td>
                </tr>
            </c:otherwise>
        </c:choose>
        <tr>
            <td colspan="2">
                <input type="submit" value="Submit" name="<%= Form.SUBMIT %>" />
                <input type="submit" value="Cancel" name="<%= Form.CANCEL %>" />             
            </td>      
        </tr>
    </tbody>
</table>
</form>

<%@include file="../WEB-INF/jspf/footer.jspf" %>