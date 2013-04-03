<%-- @author     Adam Shortall, Todd Wiggins
     @version    1.1
	 Created:    7/6/2011
	 Modified:   03/04/2013
	 Change Log: 1.1: TW: Removed user level navigation, moved to header. Modified 'Admin' to 'Assessor'. Removed unnecessary import.
	 Purpose:    Welcome page for 'Assessors' once logged in.
--%>

<%! RPLPage thisPage = RPLPage.ADMIN_HOME; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>


<h1>Assessor Home Page</h1>

<p>Welcome ${user.firstName} ${user.lastName} to the admin page.!!!!!!!!!!</p>


<%@include file="../WEB-INF/jspf/footer.jspf" %>
