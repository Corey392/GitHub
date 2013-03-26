<%--
    Document   : index
    Created on : 09/05/2011, 6:46:17 PM
    Author     : Adam Shortall
--%>
<%@include file="WEB-INF/jspf/header.jspf" %>
<%@page import="util.RPLPage" %>
<%! RPLPage thisPage = RPLPage.HOME; %>


<jsp:useBean id="loginError" scope="request" class="util.RPLError"/>

<form name="login" id="login" action="home" method="post">
 <br/>
<table border="0">
	Hello - I'm RPL2013 in My Docs
    <tbody>
        <tr>
            <td>Username:</td>
            <td><input class="textbox" size="25" type="text" name="userID" id="userID" value="370669520"/></td>
            <td rowspan="2">
                <select id="userInfo" onchange="fn_Auto()">
                    <option value="370669520;abcd1234">STUDENT</option>
                    <option value="123456789;123456789">TEACHER</option>
                    <option value="123456780;abcd1234">CLERICAL</option>
                    <option value="admin1234;abcd1234">ADMIN</option>
                </select>

            </td>
        </tr>
        <tr>
            <td>Password:</td>
            <td><input class="textbox" size="25" type="password" name="password" id="password" value="abcd1234"/></td>
        </tr>
        <tr>
            <td colspan="3" height="55" style="background-color: white" ><b>${loginError.message}</b>&nbsp;</td>
        </tr>
        <tr>
            <td  style="background-color: white" ></td>
            <td style="background-color: white"  colspan="2">
                <a class="button" href="#" onclick="document.getElementById('login').submit()"><span>Login</span></a>
                <a class="button" href="register"><span>Register</span></a>
             </td>
        </tr>
    </tbody>
</table>
</form>

        <SCRIPT>
            function fn_Auto() {
                var userInfo = new Array();
                userInfo = document.getElementById("userInfo").value.split(";");
                document.getElementById("userID").value = userInfo[0];
                document.getElementById("password").value = userInfo[1];
            }
        </SCRIPT>


<%@include file="WEB-INF/jspf/footer.jspf" %>