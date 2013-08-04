<%-- 
    Document:	discipline.jsp
    Created on:	28/05/2011, 2:24:29 PM
    Modified:	06/05/2013
    Author:	Adam Shortall, Bryce Carr
    Version:	1.010
    Changelog:	06/05/2013: Bryce Carr:	Added 'delete' button to Discipline rows. Expanded bottom row for UI prettiness.
--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_DISCIPLINE;%>
<%@include file="../WEB-INF/jspf/header.jspf" %>


<jsp:useBean id="disciplines" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="invalidNameError" scope="request" class="util.RPLError"/>
<jsp:useBean id="disciplineUpdatedMessage" scope ="request" class="java.lang.String"/>

<div class="body">

    <h2>Update Disciplines</h2>

    <b>${invalidNameError}${disciplineUpdatedMessage}</b>
    <form method="post" action="<%= RPLServlet.MAINTAIN_DISCIPLINE_SERVLET.absoluteAddress%>">
	<table class="inputtable">
	    <thead>
		<tr>
		    <th>Name</th>
		    <th>Delete</th>
		</tr>
	    </thead>
	    <tbody>
		<c:forEach var="discipline" items="${disciplines}">
		    <tr>
			<td>
			    <input type="hidden" name="disciplineID[]" value="${discipline.disciplineID}" />
			    <input required type="text" name="disciplineName[]" style="width:400px" value="${discipline.name}" />
			</td>
			<td><button type="submit" name="deleteDiscipline" style="width:130px;" value="${discipline.disciplineID}">Delete Discipline</button></td>
		    </tr>
		</c:forEach>
		<tr class="last_row">
		    <td><input type="text" name="newDisciplineName" value="" /><input type="submit" name="addDiscipline" style="width:150px" value="Add New Discipline" /></td>
		    <td></td>
		</tr>
	    </tbody>
	</table>
	<input type="submit" name="saveDisciplines" value="Save Disciplines" />
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer.jspf" %>

