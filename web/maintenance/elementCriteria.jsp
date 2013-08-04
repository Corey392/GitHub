<%--
    Document   : elementCriteria
    Created on : 16/06/2011, 10:59:17 PM
    Author     : Adam Shortall
--%>
<%! RPLPage thisPage = RPLPage.MAINTAIN_ELEMENT_CRITERIA; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>


<c:if test="${sessionScope.selectedElement == null}">
    <c:redirect url="<%= RPLServlet.MAINTAIN_MODULE_ELEMENTS_SERVLET.relativeAddress %>"/>
</c:if>

<jsp:useBean id="selectedElement" scope="session" class="domain.Element"/>
<jsp:useBean id="criterionUpdateMessage" scope="request" class="java.lang.String"/> <%-- "Criterion was successfully updated" --%>

<div class="body">
    <form method="post" action="<%= RPLServlet.MAINTAIN_ELEMENT_CRITERIA_SERVLET %>">
    <table>
        <thead>
            <tr>
                <td colspan="2"><h2>${selectedModule}</h2></td>
                <td><input type="submit" value="Back" name="backToModuleElementsServlet" /></td>
            </tr>
            <tr>
                <td>Element: ${selectedElement.elementID}</td>
                <td colspan="2"><textarea disabled="true" readonly="true" rows="4" cols="60">${selectedElement}</textarea></td>
            </tr>
            <tr>
                <td colspan="3"><b>${criterionUpdateMessage}</b></td>
            </tr>
            <tr>
                <th>Criterion ID</th>
                <th>Text</th>
                <th>Select to update</th>
                <th>Select to remove</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>New:</td>
                <td><textarea rows="4" cols="60" name="newCriterionText"></textarea></td>
                <td align="center"><input style="width:150px" type="submit" name="addNewCriterion" value="Add New Criterion"/></td>
            </tr>
            <c:forEach var="criterion" items="${selectedElement.criteria}">
                <tr>
                    <td>${criterion.criterionID}</td>
                    <td>
                        <textarea rows="4" cols="60" name="updateCriterionText:${criterion.criterionID}">${criterion}</textarea>
                    </td>
                    <td align="center"><input style="width:150px" type="submit" name="updateCriterionID:${criterion.criterionID}" value="Update Criterion" /></td>
                    <td align="center"><input style="width:150px" type="submit" name="removeCriterionID:${criterion.criterionID}" value="Remove Criterion" /></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer.jspf" %>
