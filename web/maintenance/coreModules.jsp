<%-- 
    Document:	coreModules
    Created on:	02/06/2011, 7:15:20 PM
    Modified:	04/05/2013
    Authors:	Adam Shortall, Bryce Carr
    Version:	1.010

    Changelog:	04/05/2013: BC:	Removed/modified page code to fit its new context (as an extension of Maintain Course)
--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_CORE_MODULES; %>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>


<c:if test="${sessionScope.selectedCourse == null}">
    <c:redirect url="<%= RPLServlet.MAINTAIN_CAMPUS_SERVLET.relativeAddress %>" />
</c:if>

<jsp:useBean id="selectedCourse" scope="session" class="domain.Course"/>
<jsp:useBean id="modules" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="message" scope="request" class="java.lang.String"/>
<c:set scope="page" var="i" value="0"/>

<div class="body">
    <form method="post" action="<%= RPLServlet.MAINTAIN_CORE_MODULES_SERVLET %>">
    <table>
        <thead>
            <tr>
                <td colspan="3"><h2>${selectedCourse}</h2></td>
            </tr>
            <tr>
                <td colspan="3">
            <c:choose>
                <c:when test="${fn:length(modules) == 0}">
                    There are no more modules to add
                </td>
                </c:when>
            <c:otherwise>
                    Select module:
                    <select name="selectedCoreModule">
                        <c:forEach var="module" items="${modules}">
                            <option value="${module.moduleID}">${module}</option>
                        </c:forEach>
                    </select>
                    <input type="submit" value="Add as Core" name="addCoreModule" />
                </td>
            </c:otherwise>
            </c:choose>
                <td><input type="submit" value="Back" name="backToCourse" /></td>
            </tr>
            <tr>
                <c:choose>
                    <c:when test="${fn:length(selectedCourse.coreModules) == 0}">
                        <td colspan="3">
                            <h3>There are no core modules for this course yet</h3>
                        </td>      
                    </c:when>
                    <c:otherwise>
                        <td colspan="3">
                            <h3>Core modules in this course:</h3>
                        </td> 
                    </c:otherwise>
                </c:choose>             
            </tr>
            <c:forEach var="core" items="${selectedCourse.coreModules}">
            <tr>
                <td>${core.moduleID}</td>
                <td>${core.name}</td>
                <td><input type="submit" value="Remove as Core" name="removeAsCore:${i}" /></td>
            </tr>
            <c:set var="i" value="${i+1}" scope="page" />
            </c:forEach>
        </thead>
    </table>
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>
