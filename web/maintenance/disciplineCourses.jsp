<%-- 
    Document:	disciplineCourses.jsp
    Created on:	03/06/2011, 12:58:04 AM
    Modified:	03/05/2013
    Version:	1.002
    Author:	Adam Shortall, Bryce Carr

    Changelog:	28/04/2013: Bryce Carr:	Separated 'name' and 'value' attributes of module buttons.
					Scrapped separate 'Core' and 'Elective' buttons, added 'Module' button.
		30/04/2013: Bryce Carr:	Removed commented code.
		03/05/2013: Bryce Carr:	Moved if block to below variable declaration (it just keeps happening).
--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_DISCIPLINE_COURSES; %>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>


<jsp:useBean id="selectedCampus" scope="session" class="domain.Campus"/>
<jsp:useBean id="selectedDiscipline" scope="session" class="domain.Discipline"/>
<jsp:useBean id="courses" scope="request" class="java.util.ArrayList"/>

<c:if test="${requestScope.courses == null || sessionScope.selectedDiscipline.courses == null}">
    <c:redirect url="<%= RPLServlet.MAINTAIN_TABLE_SERVLET.relativeAddress %>" />
</c:if>

<c:if var="noCoursesLeft" scope="page" test="${fn:length(courses) == 0}"/>
<c:if var="noCoursesInDiscipline" scope="page" test="${fn:length(selectedDiscipline.courses) == 0}" />


<form method="post" action="<%= RPLServlet.MAINTAIN_DISCIPLINE_COURSES_SERVLET %>">
<table>
    <thead>
        <tr>
            <td colspan="1"><h2>${selectedCampus}</h2></td>
            <td align="right"><input type="submit" value="Back" name="back" /></td>
        </tr>
        <tr>
            <td colspan="3"><h3>${selectedDiscipline}</h3></td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <c:choose>
                <c:when test="${noCoursesLeft}">
                    <td colspan="3">There are no more courses to add to this discipline</td>
                </c:when>
                <c:otherwise>
                    <td>
                        Select Course:
                        <select name="selectedCourse">
                            <c:forEach var="course" items="${courses}">
                                <option value="${course.courseID}">
                                    ${course}
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <input type="submit" value="Add this Course" name="addCourseToDiscipline" />
                    </td>
                </c:otherwise>        
            </c:choose>
        </tr>
        <c:choose>
        <c:when test="${noCoursesInDiscipline}">
            <tr>
                <td colspan="3">
                    <h4>There are no courses in this discipline yet</h4>
                </td>
            </tr>
        </c:when>
        <c:otherwise>
            <tr>
                <td colspan="3">
                    <h4>Courses in this Discipline:</h4>
                </td>
            </tr>
        <c:forEach var="course" items="${selectedDiscipline.courses}">
            <tr>
                <td>${course}</td>
		<td><button type="submit" name="modifyCourseModules" value="${course.courseID}">Modify Modules</button></td>
                <td><button type="submit" name="removeCourseFromDiscipline" value="${course.courseID}">Remove from Discipline</button></td>
            </tr>
           </c:forEach>
        </c:otherwise>
        </c:choose>
    </tbody>
</table>
</form>


<%@include file="../WEB-INF/jspf/footer.jspf" %>
