<%--Create Claim page where you select Campus, Disciple, Course and Claim type.
 *  @author     James Purves, Todd Wiggins
 *  @version    1.11
 *  Created:    14/05/2011, 5:06:19 PM
 *	Change Log: 1.01: TW: Added error messages from servlet.
 *              1.02: TW: Moved error messages to central location. Team decision.
 *              29/04/2013: 1.10: TW: Added AJAX queries to get Discipline and Courses instead of a full page refresh.
 *              15/05/2013: 1.11: TW: Improving display of errors to be consistent across site.
--%>

<%@include file="..\WEB-INF\jspf\header.jspf" %>
<%! RPLPage thisPage = RPLPage.CREATE_CLAIM; %>
<%@page import="java.util.*" %>
<jsp:useBean id="claim" scope="session" class="domain.Claim"/>
<jsp:useBean id="campuses" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="disciplines" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="courses" scope="request" class="java.util.ArrayList"/>

<script src="<%= RPLPage.ROOT %>/scripts/jquery-1.9.1.js"></script>
<script>
	var blank = {"id":0,"desc":""};
	function getDisciplines() {
		$.getJSON('<%= RPLPage.ROOT %>/AJAX?type=claim&sub=discipline&campus='+document.getElementById("campus").value, function(data) {
			document.getElementById("ajaxDiscipline").innerHTML = buildSelect("discipline",data.discipline);
			document.getElementById("ajaxCourse").innerHTML = buildSelect("course",blank);
		}).fail(function() {
			alert("Error getting Discipline information.");
		});
	}
	function getCourses() {
		$.getJSON('<%= RPLPage.ROOT %>/AJAX?type=claim&sub=course&discipline='+document.getElementById("discipline").value, function(data) {
			document.getElementById("ajaxCourse").innerHTML = buildSelect("course",data.course);
		}).fail(function() {
			alert("Error getting Course information.");
		});
	}
	function buildSelect(id, items) {
		var html = "<select name=\""+id+"\" id=\""+id+"\" " + (id === "discipline" ? "onchange=\"javascript:getCourses();\"" : "")+">";
		for (var i = 0; i < items.length; i++) {
			html+= "<option value=\""+items[i].id+"\">"+items[i].desc+"</option>";
		}
		return (html+= "</select>");
	}
	buildSelect("discipline",blank);
	buildSelect("course",blank);
</script>
<h2 class="center">Create Claim</h2>

<form action="createClaim" method="post" name="createClaimForm" id="createClaimForm">
    <table>

        <tr>
            <th>Campus:</th>
            <td colspan="2">
        <select name="campus" id="campus" onchange="javascript:getDisciplines();">
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
            </td>
        </tr>
        <tr>
            <th>Discipline:</th>
            <td colspan="2" id="ajaxDiscipline">
            </td>
         </tr>
         <tr>
            <th>Course:</th>
            <td colspan="2" id="ajaxCourse">
            </td>
    </tr>
    <tr>
        <%-- Changed to radio buttons, JLC  --%>
        <th>Claim Type:</th>
        <td><input type="radio" name="claimType" value="prevStudies" />Previous Studies</td>
        <td><input type="radio" name="claimType" value="rpl" />Recognition of Prior Learning</td>
    </tr>
    <tr>
        <td><input type="submit" value="Create Claim" /></td>
    </tr>
    </table>
	<c:if test="${errorCampusID.message.length() > 0 || errorDisciplineID.message.length() > 0 || errorCourseID.message.length() > 0 || errorClaimType.message.length > 0}">
		<div id="errorMessage">${errorCampusID.message}${errorDisciplineID.message}${errorCourseID.message}${errorClaimType.message}</div>
	</c:if>
</form>

<%@include file="..\WEB-INF\jspf\footer.jspf" %>