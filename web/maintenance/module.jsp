<%-- 
    Document   : module
    Created on : 01/06/2011, 3:42:51 PM
    Author     : Adam Shortall
--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_MODULE; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>


<c:if test="${requestScope.modules == null}">
    <c:redirect url="<%= RPLServlet.MAINTAIN_TABLE_SERVLET.relativeAddress %>"/>
</c:if>

<jsp:useBean id="modules" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="moduleUpdateMessage" scope="request" class="java.lang.String"/>
<jsp:useBean id="moduleUniqueError" scope="request" class="util.RPLError"/>

<h2>Update Modules</h2>

${moduleUpdateMessage}${moduleUniqueError}${moduleInvalidIDError}${moduleInvalidNameMessage}

<form method="post" action="<%= RPLServlet.MAINTAIN_MODULE_SERVLET %>">
<table class="inputtable">
    <thead>
        <tr>
            <th>Module ID</th>
            <th>Name</th>
            <th>Select to update</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="module" items="${modules}">
        <tr>
            <td><input style="width:120px" required readonly maxlength="10" type="text" name="moduleID[]" value="${module.moduleID}" /></td>
            <td><input style="width:500px" required type="text" name="moduleName[]" value="${module.name}" /></td>
            <td><button style="width:150px" type="submit" name="addElementsToModule" value="${module.moduleID}">Add Elements</button></td>
        </tr>
        </c:forEach>
        <tr class="last_row">
            <td><input style="width:120px" type="text" name="newModuleID" maxlength="10"/></td>
            <td><input style="width:500px" type="text" name="newModuleName"/></td>
            <td align="center"><input style="width:150px" type="submit" name="addNewModule" value="Add New Module"/></td>
        </tr>
    </tbody>
</table>
<input style="width:150px" type="submit" name="saveModules" value="Save Module" />
</form>


<%@include file="../WEB-INF/jspf/footer.jspf" %>