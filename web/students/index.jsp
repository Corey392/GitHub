<%-- @author     James, Todd Wiggins
     @version    1.1
	 Created:    14/05/2011, 9:41:41 AM
	 Modified:   03/04/2013
	 Change Log: 1.1: TW: Removed user level navigation, moved to header.
	 Purpose:    Welcome page for 'Student' once logged in.
--%>

<%! RPLPage thisPage = RPLPage.STUDENT_HOME; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>


<h1>Student Home Page</h1>
<p>Welcome ${user.firstName} ${user.lastName}</p>


<%@include file="../WEB-INF/jspf/footer.jspf" %>
