<%-- @author     Adam Shortall, Todd Wiggins
	 @version    1.2
	 Created:    09/05/2011, 6:46:17 PM
	 Modified:   03/04/2013
	 Change Log: 1.1: TW: Added our usernames into the drop down box to match the DB create script we are using.
	             1.2: TW: Removed default Username and Password (was a user that does not have access in our DB) and changed default value in drop down box to 'Select a User'. Added auto focus on page load to drop down box. Minor code clean up.
	 Purpose:    This is the "HOME" page for a non-logged in user. The first/index page when a vistor navigates to the domain.
--%>
<%@page import="util.RPLPage" %>
<%! RPLPage thisPage = RPLPage.HOME; %>
<jsp:useBean id="loginError" scope="request" class="util.RPLError"/>

<%@include file="WEB-INF/jspf/header.jspf" %>


<p></p>
<form name="login" id="login" action="home" method="post">
<table border="0">
    <tbody>
        <tr>
            <td>Username:</td>
            <td><input class="textbox" size="25" type="text" name="userID" id="userID" value=""/></td>
            <td rowspan="2">
                <select id="userInfo" onchange="fn_Auto();" autofocus="autofocus">
                    <option value=";">Select a User</option>
                    <option value="374371959;password">STUDENT: Todd</option>
                    <option value="365044651;password">STUDENT: Mitch</option>
                    <option value="366796436;password">STUDENT: Bryce</option>
                    <option value="355273971;password">STUDENT: Ryan</option>
                    <option value="366688315;password">STUDENT: Kelly</option>
                    <option value="teacher;password">TEACHER</option>
                    <option value="assessor;password">ASSESSOR</option>
                    <option value="admin;password">ADMIN</option>
                </select>

            </td>
        </tr>
        <tr>
            <td>Password:</td>
            <td><input class="textbox" size="25" type="password" name="password" id="password" value=""/></td>
        </tr>
        <tr>
            <td colspan="3" height="55" style="background-color: white" ><b>${loginError.message}</b>&nbsp;</td>
        </tr>
        <tr>
            <td style="background-color: white" ></td>
            <td style="background-color: white" colspan="2">
                <a class="button" href="#" onclick="document.getElementById('login').submit();"><span>Login</span></a>
                <a class="button" href="register"><span>Register</span></a>
             </td>
        </tr>
    </tbody>
</table>
</form>

<script>
    function fn_Auto() {
        var userInfo = new Array();
        userInfo = document.getElementById("userInfo").value.split(";");
        document.getElementById("userID").value = userInfo[0];
        document.getElementById("password").value = userInfo[1];
    }
</script>


<%@include file="WEB-INF/jspf/footer.jspf" %>
