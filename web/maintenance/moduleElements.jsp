<%-- 
    Document   : moduleElements
    Created on : 16/06/2011, 12:12:04 PM
    Author     : Adam Shortall
--%>
<%! RPLPage thisPage = RPLPage.MAINTAIN_MODULE_ELEMENTS; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>


<c:if test="${sessionScope.selectedModule.elements == null}">
    <c:redirect url="<%= RPLServlet.MAINTAIN_MODULE_SERVLET.relativeAddress %>"/>
</c:if>

<jsp:useBean id="selectedModule" scope="session" class="domain.Module"/>
<jsp:useBean id="elementUpdateMessage" scope="request" class="java.lang.String"/> <%-- "Element was successfully updated" --%>

<div class="body">
    <form method="post" action="<%= RPLServlet.MAINTAIN_MODULE_ELEMENTS_SERVLET %>">
    <table>
        <thead>
            <tr>
                <td colspan="2"><h2>${selectedModule}</h2></td>
                <td><input type="submit" value="Back" name="backToMaintainModuleServlet" /></td>
            </tr>
            <tr>
                <td colspan="3"><b>${elementUpdateMessage}</b></td>                
            </tr>
            <tr>
                <th>Element ID</th>
                <th>Text</th>
                <th>Select to update</th>
                <th>Select to remove</th>
                <th>Select to add criteria</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>New:</td>
                <td><textarea rows="4" cols="60" name="newElementText"></textarea></td>
                <td align="center"><input style="width:150px" type="submit" name="addNewElement" value="Add New Element"/></td>
            </tr>
            <c:forEach var="element" items="${selectedModule.elements}">
                <tr>
                    <td>${element.elementID}</td>
                    <td>
                        <textarea rows="4" cols="60" name="updateElementText:${element.elementID}">${element}</textarea>
                    </td>
                    <td align="center"><input style="width:150px" type="submit" name="updateElementID:${element.elementID}" value="Update Element" /></td>
                    <td align="center"><input style="width:150px" type="submit" name="removeElementID:${element.elementID}" value="Remove Element" /></td>
                    <td align="center"><input style="width:150px" type="submit" name="addCriteriaElementID:${element.elementID}" value="Add Criteria" /></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer.jspf" %>