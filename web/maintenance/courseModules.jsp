<%-- 
    Document:	courseModules
    Created on:	28/05/2011, 10:47:14 PM
    Modified:	03/05/2013
    Author:	Adam Shortall, Bryce Carr
    Version:	1.030
    Changelog:	29/04/2013: BC:	Fixed 'back' button.
		03/05/2013: BC:	Removed stuff for campus/discipline/course selection. This isn't a general module maintenance page.
				Added headers showing current Campus and Discipline underneath current Course.
		04/05/2013: BC:	Added check for noModulesLeft - now displays message instead of empty Module select
				Module addition now implemented.

--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_COURSE_MODULES;%>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>


<jsp:useBean id="course" scope="request" class="domain.Course"/>
<jsp:useBean id="campuses" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="modules" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="selectedCampus" scope="request" class="domain.Campus"/>
<jsp:useBean id="selectedDiscipline" scope="request" class="domain.Discipline"/>
<c:if var="noModulesLeft" scope="page" test="${fn:length(modules) == 0}"/>

<div class="body">

    <h2>${course.courseID}: ${course.name}</h2>
    <h3>Campus: ${selectedCampus.name}<br/>
	Discipline: ${selectedDiscipline.name}</h3>

    <form method="post" action="<%= RPLServlet.MAINTAIN_COURSE_MODULES_SERVLET.absoluteAddress%>" name="form" id="form">
	<table>
	    <thead>
		<tr>
		    <c:choose>
			<c:when test="${noModulesLeft}">
			    <td colspan="3">There are no more modules to add to this course</td>
			</c:when>
			<c:otherwise>
			    <td colspan="3">
				Select module:
				<select name="selectedModule">
				    <c:forEach var="module" items="${modules}">                                            
					<option value="${module.moduleID}">${module}</option>
				    </c:forEach>
				</select>
			    </td>
			</c:otherwise>
		    </c:choose>
		</tr>
		<tr>
		    <td width="50"><input type="submit" value="Add as Core" name="addCore" /></td>
		    <td width="500"><input type="submit" value="Add as Elective" name="addElective" /></td>
		    <td><input type="submit" value="Back" name="back" /></td>
		</tr>
		<tr><th colspan="3"><hr/></th></tr>
            <tr><th colspan="3">Core Modules</th></tr>
            <tr><th colspan="3"><hr/></th></tr>
            <tr align="left">
                <th>Module ID</th>
                <th>Name</th>
                <th>Remove</th>
            </tr>
            <tr><th colspan="3"><hr/></th></tr>
	    </thead>
	    <tbody>
		<c:forEach var="coreModule" items="${course.coreModules}">
		    <tr>
			<td>${coreModule.moduleID}</td>
			<td>${coreModule.name}</td>
			<td><input type="submit" value="Remove as Core" name="removeCore:${coreModule.moduleID}" /></td>
		    </tr>                    
		</c:forEach>
	    </tbody>

	    <thead>
		<tr><th colspan="3"><hr/></th></tr>
            <tr><th colspan="3">Elective Modules</th></tr>
            <tr><th colspan="3"><hr/></th></tr>
            <tr align="left">
                <th>Module ID</th>
                <th>Name</th>
                <th>Remove</th>
            </tr>
            <tr><th colspan="3"><hr/></th></tr>
	    </thead>
	    <tbody>
		<c:forEach var="electiveModule" items="${course.electiveModules}">            
		    <tr>
			<td>${electiveModule.moduleID}</td>
			<td>${electiveModule.name}</td>
			<td><input type="submit" value="Remove as Elective" name="removeElective:${electiveModule.moduleID}" /></td>
		    </tr>
		</c:forEach>
		<tr><th colspan="3"><hr/></th></tr>
	    </tbody>
	</table>
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer.jspf" %>