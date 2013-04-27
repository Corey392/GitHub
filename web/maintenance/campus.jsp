<%-- 
    Document:	campus.jsp
    Created on:	26/05/2011, 4:47:03 PM
    Modified:	27/04/2013
    Authors:	Adam Shortall, Bryce Carr
    
    Changelog:
	27/04/2013: BC:	Added 'delete' button to table and changed header labels.
--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_CAMPUS; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>


<c:if test="${requestScope.campuses == null}">
    <c:redirect url="<%= RPLServlet.MAINTAIN_CAMPUS_SERVLET.relativeAddress %>" />
</c:if>

<jsp:useBean id="campuses" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="uniqueIDMessage" scope="request" class="util.RPLError"/>
<jsp:useBean id="invalidIDMessage" scope="request" class="util.RPLError"/>
<jsp:useBean id="invalidNameMessage" scope="request" class="util.RPLError"/>
<jsp:useBean id="campusUpdatedMessage" scope ="request" class="java.lang.String"/>


<h2>Update Campuses</h2>

    <b>${campusUpdatedMessage}${uniqueIDMessage}${invalidIDMessage}</b>
    <b>${invalidNameMessage}</b>
    
    <form method="post" action="<%= RPLServlet.MAINTAIN_CAMPUS_SERVLET %>">
    <table class="inputtable">
        <thead>
            <tr>
                <th>Campus ID</th>
                <th>Name</th>
                <th>Disciplines</th>
                <th>Delete</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="campus" items="${campuses}">
            <tr class="highlight_row">
                <td><input style="text-align:right; width:75px" required maxlength="3" type="text" value="${campus.campusID}" name="campusID[]" /></td>
                <td><input required type="text" value="${campus.name}" name="campusNames[]" /></td>
                <td><button type="submit" name="viewDisciplines" style="width:225px;" value="${campus.campusID}">View or Modify Disciplines</button></td>
                <td><button type="submit" name="deleteCampus" style="width:118px;" value="${campus.campusID}">Delete Campus</button></td>
            </tr>
            </c:forEach>
            <tr class="last_row">
                <td>
                    <input style="text-align:right; width:75px" type="text" name="newCampusID" maxlength="3" id="newCampusID"/>
                </td>
                <td>
                    <input type="text" name="newCampusName" id="newCampusName"/>
                </td>
                <td colspan="2">
                    <input style="width:150px" type="submit" name="addNewCampus" value="Add New Campus" id="addNewCampus"/>
                </td>
           </tr>    
        </tbody>
    </table>
    <input type="submit" name="saveCampuses" value="Save Campuses" />
    </form>

<%@include file="../WEB-INF/jspf/footer.jspf" %>
