<%-- @author     James, David, Todd Wiggins
     @version    1.1
	 Created:    14/05/2011, 9:41:41 AM
	 Modified:   03/04/2013
	 Change Log: 1.1: TW: Removed user level navigation, moved to header. Removed unnecessary import.
				      TW: Removed excess divs/wrappers (already in header/footer).
	 Purpose:    Welcome page for 'Teacher' once logged in.
--%>
<%! RPLPage thisPage = RPLPage.TEACHER_HOME;
    String title = RPLPage.TEACHER_HOME.title; %>

<%@include file="../WEB-INF/jspf/header_1.jspf" %>


<h1>Teacher Home Page</h1>
<p>Welcome to ${user.firstName} ${user.lastName}</p>


<%@include file="../WEB-INF/jspf/footer.jspf" %>
