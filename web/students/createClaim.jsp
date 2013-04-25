<%--
    Document   : createClaim
    Created on : 14/05/2011, 5:06:19 PM
    Author     : James Purves
--%>

<%@include file="..\WEB-INF\jspf\header.jspf" %>
<%! RPLPage thisPage = RPLPage.CREATE_CLAIM; %>
<%@page import="java.util.*" %>
<jsp:useBean id="claim" scope="session" class="domain.Claim"/>
<jsp:useBean id="campuses" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="disciplines" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="courses" scope="request" class="java.util.ArrayList"/>

<h2 class="center">Create Claim</h2>

<form action="createClaim" method="post" name="createClaimForm" id="createClaimForm">
    <table style="text-align:left;background:white;border: 2px solid #eee;width:700px;">

        <tr>
            <th>Campus:</th>
            <td colspan="2">
        <select name="campus" id="cmbCampus" style="width: 100%;" onchange="document.createClaimForm.submit();">
        <c:forEach var="aCampus" items="${campuses}">
            <c:choose>
                <c:when test="${aCampus.campusID == claim.campusID}">
                    <option value="${aCampus.campusID}" selected="true">
                        ${aCampus.name}
                    </option>
                </c:when><c:otherwise>
                    <option value="${aCampus.campusID}">
                        ${aCampus.name}
                    </option>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        </select>
		<span>${errorCampusID.message}</span>
            </td>
        </tr>
        <tr>
            <th>Discipline:</th>
            <td colspan="2">
        <select name="discipline" id="cmbDiscipline" style="width: 100%;" onchange="document.createClaimForm.submit();">
        <c:forEach var="aDiscipline" items="${disciplines}">
            <c:choose>
                <c:when test="${aDiscipline.disciplineID == claim.disciplineID}">
                    <option value="${aDiscipline.disciplineID}" selected="true">
                        ${aDiscipline.name}
                    </option>
                </c:when>
                <c:otherwise>
                    <option value="${aDiscipline.disciplineID}">
                        ${aDiscipline.name}
                    </option>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        </select>
		<span>${errorDisciplineID.message}</span>
            </td>
         </tr>
         <tr>
            <th>Course:</th>
            <td colspan="2">
        <select name="course" style="width: 100%;" onchange="document.createClaimForm.submit();" id="cmbCourse">
        <c:forEach var="aCourse" items="${courses}">
            <c:choose>
                <c:when test="${aCourse.courseID == claim.courseID}">
                    <option value="${aCourse.courseID}" selected="true">
                        ${aCourse.name}
                    </option>
                </c:when>
                <c:otherwise>
                    <option value="${aCourse.courseID}">
                        ${aCourse.name}
                    </option>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        </select>
		<span>${errorCourseID.message}</span>
            </td>
    </tr>
    <tr>
        <%-- Changed to radio buttons, JLC  --%>
        <th>Claim Type:</th>
        <td><input type="radio" name="claimType" value="prevStudies" />Previous Studies</td>
        <td><input type="radio" name="claimType" value="rpl" />Recognition of Prior Learning</td>
    </tr>
	<tr>
		<td colspan="3">${errorClaimType.message}</td>
	</tr>
    <tr>
        <td><input type="submit" value="Create Claim" /></td>
    </tr>
    </table>
</form>


<%@include file="..\WEB-INF\jspf\footer.jspf" %>
