<%-- 
    Document:	course.jsp
    Created on:	28/05/2011, 4:26:26 PM
    Modified:	07/05/2013
    Authors:	Adam Shortall, Bryce Carr
    Version:	1.020
    Changelog:	27/04/2013: BC:	Added header label for Modules.
		07/05/2013: BC:	Added button for Course deletion and message beans to accompany.
--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_COURSE; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>


<c:if test="${requestScope.courses == null}">
    <c:redirect url="<%= RPLServlet.MAINTAIN_TABLE_SERVLET.relativeAddress %>"/>
</c:if>

<jsp:useBean id="courses" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="courseIDError" scope="request" class="util.RPLError"/>
<jsp:useBean id="courseNameError" scope="request" class="util.RPLError"/>
<jsp:useBean id="updateSuccess" scope="request" class="java.lang.String"/>
<jsp:useBean id="deleteSuccess" scope="request" class="java.lang.String"/>
<jsp:useBean id="deleteError" scope="request" class="java.lang.String"/>

<h2>Update Courses</h2>

<form method="post" action="<%= RPLServlet.MAINTAIN_COURSE_SERVLET %>">


${courseIDError}${updateSuccess} ${courseNameError}
${invalidNameError}${disciplineUpdatedMessage}
<table class="inputtable">
    <thead>
        <tr>
            <th>Course ID</th>
            <th>Name</th>
            <th>Modules</th>
            <th>Delete</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="course" items="${courses}">
            <tr class="highlight_row">
                <td><input required style="width:50px" maxlength="5" type="text" name="courseID[]" value="${course.courseID}" /></td>
                <td><input required style="width:500px" type="text" name="courseName[]" value="${course.name}" /></td>
                <td><button type="submit" name="updateModules" value="${course.courseID}">Add/Remove Core Modules</button></td>
		<td><button type="submit" name="deleteCourse" value="${course.courseID}">Delete Course</button></td>
            </tr>
        </c:forEach>  
        <tr class="last_row">
            <td><input style="width:50px" maxlength="5" type="text" value="" name="newCourseID" maxlength="5"/></td>
            <td><input style="width:500px" type="text" value="" name="newCourseName"/></td>
            <td><input type="submit" value="Add New Course" name="addCourse" style="width:150px"/></td>
	    <td></td>
        </tr>
    </tbody>
</table>
<input type="submit" value="Save Courses" name="saveCourses" style="width:150px" />
</form>


<%@include file="../WEB-INF/jspf/footer.jspf" %>