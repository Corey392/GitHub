<%-- 
    Document   : campusDiscipline
    Created on : 02/06/2011, 12:51:59 AM
    Author     : Adam Shortall
--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_CAMPUS_DISCIPLINE; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>


<c:if test="${requestScope.selectedCampus == null || requestScope.disciplines == null}">
    <c:redirect url="<%= RPLServlet.MAINTAIN_TABLE_SERVLET.relativeAddress %>" />
</c:if>

<jsp:useBean id="disciplines" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="selectedCampus" scope="request" class="domain.Campus"/>
<jsp:useBean id="message" scope="request" class="java.lang.String"/>

<c:if var="noDisciplinesLeft" scope="page" test="${fn:length(disciplines) == 0}"/>
<c:if var="campusIsSelected" scope="page" test="${selectedCampus.campusID != ''}" />


<form method="post" action="<%= RPLServlet.MAINTAIN_CAMPUS_DISCIPLINE_SERVLET %>">
<table>
    <thead>
        <tr>
            <td colspan="1">
                <h2>${selectedCampus}</h2>                    
            </td>
        </tr>
    </thead>
    <tbody>
        <tr>
        <c:choose>
            <c:when test="${noDisciplinesLeft}">
                <td colspan="3">There are no more disicplines to add to this campus</td>
            </c:when>
            <c:otherwise>
                <td>
                    Select discipline:
                    <select name="selectedDiscipline">
                        <c:forEach var="discipline" items="${disciplines}">
                            <option value="${discipline.disciplineID}">
                                ${discipline}
                            </option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <input type="submit" value="Add this Discipline" name="addDisciplineToCampus" />
                </td>
            </c:otherwise>        
        </c:choose>
        </tr>
        <c:choose>
            <c:when test="${fn:length(selectedCampus.disciplines) == 0}">
                <tr>
                    <td colspan="3"><h3>There are no disciplines in this campus yet</h3></td>
                </tr>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="3">
                        <h3>Disciplines in this campus:</h3>
                    </td>                
                </tr>
            </c:otherwise>
        </c:choose>         
        <c:forEach var="discipline" items="${selectedCampus.disciplines}">
            <tr class="highlight_row">
                <td><a href="<%= RPLServlet.MAINTAIN_CAMPUS_DISCIPLINE_SERVLET %>?disciplineID=${discipline.disciplineID}">${discipline}</a></td>
                <td><button type="submit" name="removeDiscipline" value="${discipline.disciplineID}">Remove Discipline</button></td>
            </tr>
        </c:forEach>
        
    </tbody>
</table>
</form>


<%@include file="../WEB-INF/jspf/footer.jspf" %>