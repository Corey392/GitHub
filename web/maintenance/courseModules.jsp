<%-- 
    Document   : courseModules
    Created on : 28/05/2011, 10:47:14 PM
    Author     : Adam Shortall
--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_COURSE_MODULES; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>

<%@include file="../WEB-INF/jspf/maintenanceOptions.jspf" %>

<jsp:useBean id="course" scope="request" class="domain.Course"/>
<jsp:useBean id="campuses" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="modules" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="selectedCampus" scope="request" class="domain.Campus"/>
<jsp:useBean id="selectedDiscipline" scope="request" class="domain.Discipline"/>

<div class="body">
    
    <h2>${course.courseID}: ${course.name}</h2>    
    
    <form method="post" action="<%= RPLServlet.MAINTAIN_COURSE_MODULES_SERVLET.absoluteAddress %>" name="form" id="form">
    <table>
        <thead>
            <tr>
                <td colspan="3">
                    Select module:
                    <select name="selectedModule">
                    <c:forEach var="module" items="${modules}">                                            
                        <option value="${module.moduleID}">${module}</option>
                    </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    Select campus:
                    <select name="selectedCampus">
                    <c:forEach var="campus" items="${campuses}">                                           
                        <c:choose>
                            <c:when test="${campus == selectedCampus}">
                                <option selected onchange="form.submit()" value="${campus.campusID}">${campus}</option>
                            </c:when>
                            <c:otherwise>
                                <option onchange="form.submit()" value="${campus.campusID}">${campus}</option>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    </select>
                    Select discipline:
                    <select name="selectedDiscipline">
                    <c:forEach var="discipline" items="${selectedCampus.disciplines}">                                            
                        <c:choose>
                            <c:when test="${discipline == selectedDiscipline}">
                                <option selected onchange="form.submit()" value="${discipline.disciplineID}">${discipline}</option>
                            </c:when>
                            <c:otherwise>
                                <option onchange="form.submit()" value="${discipline.disciplineID}">${discipline}</option>
                            </c:otherwise>
                        </c:choose>                        
                    </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td width="50"><input type="submit" value="Add as Core" name="addCore" /></td>
                <td width="500"><input type="submit" value="Add as Elective" name="addElective" /></td>
                <td><input type="submit" value="Back" name="backHome" /></td>
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