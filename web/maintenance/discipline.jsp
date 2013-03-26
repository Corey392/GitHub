<%-- 
    Document   : discipline
    Created on : 28/05/2011, 2:24:29 PM
    Author     : Adam Shortall
--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_DISCIPLINE; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>

<%@include file="../WEB-INF/jspf/maintenanceOptions.jspf" %>

<jsp:useBean id="disciplines" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="invalidNameError" scope="request" class="util.RPLError"/>
<jsp:useBean id="disciplineUpdatedMessage" scope ="request" class="java.lang.String"/>

<div class="body">
    
    <h2>Update Disciplines</h2>
    
    <b>${invalidNameError}${disciplineUpdatedMessage}</b>
    <form method="post" action="<%= RPLServlet.MAINTAIN_DISCIPLINE_SERVLET.absoluteAddress %>">
    <table class="inputtable">
        <thead>
            <tr>
                <th>Name</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="discipline" items="${disciplines}">
                <tr>
                    <td>
                        <input type="hidden" name="disciplineID[]" value="${discipline.disciplineID}" />

                        <input required type="text" name="disciplineName[]" style="width:400px" value="${discipline.name}" />
                    </td>
                </tr>
            </c:forEach>
            <tr class="last_row">
                <td><input type="text" name="newDisciplineName" value="" /><input type="submit" name="addDiscipline" style="width:150px" value="Add New Discipline" /></td>      
            </tr>
        </tbody>
    </table>
    <input type="submit" name="saveDisciplines" value="Save Disciplines" />
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer.jspf" %>

