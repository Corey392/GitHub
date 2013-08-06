<%-- 
    Document:	courseElectives
    Created on:	03/06/2011, 1:51:17 PM
    Modified:	28/04/2013
    Authors:	Adam Shortall, Bryce Carr
    Version:	1.001
    Changelog:	28/04/2013: BC:	Moved test for null variables so that it comes after the assignment of said variables.
--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_COURSE_ELECTIVES; %>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>



<jsp:useBean id="selectedCampus" scope="session" class="domain.Campus"/>
<jsp:useBean id="selectedDiscipline" scope="session" class="domain.Discipline"/>
<jsp:useBean id="selectedCourse" scope="session" class="domain.Course"/>
<jsp:useBean id="modules" scope="request" class="java.util.ArrayList"/>

<c:if test="${requestScope.modules == null || sessionScope.selectedCourse == null 
              || sessionScope.selectedDiscipline == null || sessionScope.selectedCampus == null}">
    <c:redirect url="<%= RPLServlet.MAINTAIN_TABLE_SERVLET.relativeAddress %>" />
</c:if>

<c:if var="noModulesLeft" scope="page" test="${fn:length(modules) == 0}"/>

<div class="body">
    <form method="post" action="<%= RPLServlet.MAINTAIN_COURSE_ELECTIVES_SERVLET %>">
    <table>
        <thead>
            <tr>
                <td colspan="2"><h2>${selectedCampus}</h2></td>
                <td><input type="submit" value="Back" name="backToDisciplineCourse" /></td>
            </tr>
            <tr>
                <td colspan="3"><h3>${selectedDiscipline}</h3></td>
            </tr>
            <tr>
                <td colspan="3"><h4>${selectedCourse}</h4></td>
            </tr>
            <tr>
                <c:choose>
                    <c:when test="${noModulesLeft}">
                        <td colspan="3">There are no more modules to add to this course</td>
                    </c:when>
                    <c:otherwise>
                        <td>
                            Select Module:
                            <select name="selectedModule">
                                <c:forEach var="module" items="${modules}">
                                    <option value="${module.moduleID}">
                                        ${module}
                                    </option>
                                </c:forEach>
                            </select>
                        </td>
                        <td>
                            <input type="submit" value="Add this as an Elective" name="addElectiveModule" />
                        </td>
                    </c:otherwise>        
                </c:choose>
            </tr>
            <tr>
            <c:choose>
            <c:when test="${fn:length(selectedCourse.electiveModules) == 0}">
                <td colspan="3">
                    <h4>There are no elective modules in this course yet</h4>
                </td>
            </tr>
            </c:when>
            <c:otherwise>
                <td colspan="3">
                    <h4>Elective modules in this course:</h4>
                </td>
            </tr>
            <c:forEach var="module" items="${selectedCourse.electiveModules}">
                <tr>
                    <td>${module}</td>
                    <td><input type="submit" value="Remove as Elective" name="removeModuleAsElective:${module.moduleID}" /></td>
                </tr>
            </c:forEach>
            </c:otherwise>
            </c:choose>
        </thead>
    </table>
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>