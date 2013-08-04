<%--
    Document   : registerConfirm
    Created on : 10/05/2011, 9:42:34 PM
    Author     : Adam Shortall
--%>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%--<%@include file="../WEB-INF/jspf/sidebar.jspf" %>--%>
<%! RPLPage thisPage = RPLPage.REGISTER_CONFIRM; %>

<table>
    <thead>
        <tr>
            <th colspan="2">Your account has been created with the following information:</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Student number:</td>
            <td>${user.userID}</td>
        </tr>
        <tr>
            <td>First name:</td>
            <td>${user.firstName}</td>
        </tr>
        <tr>
            <td>Last name:</td>
            <td>${user.lastName}</td>
        </tr>
        <tr>
            <td>Email:</td>
            <td>${user.email}</td>
        </tr>
    </tbody>
    <tfoot>
        <tr>
            <td colspan="2"><a href="<%= RPLPage.HOME.absoluteAddress %>">RPL Home Page</a></td>
        </tr>
    </tfoot>
</table>

<%@include file="../WEB-INF/jspf/footer.jspf" %>