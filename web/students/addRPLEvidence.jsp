<%--
    Document   : addRPLEvidence
    Created on : 19/05/2011, 6:02:35 PM
    Author     : James Purves, Mitch Carr
 *              Modified:   05/08/2013: CW: Changed header/footer imports.
--%>

<%@page import="domain.Module"%>
<%@page import="domain.Evidence"%>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<%! RPLPage thisPage = RPLPage.ADD_RPL_EVIDENCE; %>
<jsp:useBean id="claim" scope="session" class="domain.Claim"/>
<jsp:useBean id="selectedModule" scope="request" class="domain.Module"/>
<jsp:useBean id="modules" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="evidence" scope="request" class="java.util.ArrayList"/>

<table style="width:600px">
    <tr>
        <td>Module Name: ${selectedModule.name}</td>
        <td>Module ID: ${selectedModule.moduleID}</td>
    </tr>
    <c:if test="${modules.size() == 0}">
        <tr>
            <td colspan="2">
                This module has no elements listed in our database. For a full
                recognition guide please visit this link:<br />
                <a href="www.tafensw.edu.au">www.tafensw.edu.au</a>
            </td>
        </tr>
    </c:if>
</table>
<form action="addEvidence" method="post" name="addRPLEvidenceForm">
<input type="hidden" name="moduleID" value="${selectedModule.moduleID}"/>
<table style="width:800px; border:1px">
    <c:choose>
        <c:when test="${modules.size() != 0}">
            <tr>
                <th>Elements</th>
                <th>Criteria</th>
                <th>Evidence</th>
            </tr>
            <c:forEach var="element" items="${module.getElements()}">
                <tr>
                    <td>${element.getDescription()}</td>
                    <td>
                        <ul>
                            <c:forEach var="criterion" items="${element.criteria}">
                                <li>${criterion.description}</li>
                            </c:forEach>
                        </ul>
                    </td>
                    <td>
                        <c:forEach var="evidenceItem" items="${evidence}">
                            <c:if test="${evidenceItem.elementID == element.elementID}">
                                <jsp:setProperty name="evidence" property="description" value="${evidenceItem.description}"/>
                            </c:if>
                        </c:forEach>
                        <textarea name="${element.elementID}" style="width:200px; height:50px">${evidence.description}</textarea>
                    </td>
                </tr>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <tr>
                <th colspan="3">Evidence</th>
            </tr>
            <tr>
                <c:if test="${evidence.size() > 0}">
                    <jsp:setProperty name="evidence" property="description" value="${evidence.get(0).description}"/>
                </c:if>
                <td colspan="3">
                    <%-- <input type="text" name="evidence" value="${evidence.description}"/> --%>
                    <textarea name="evidence" style="width:800px; height:400px">${evidence.description}</textarea>
                </td>
            </tr>
        </c:otherwise>
    </c:choose>
    <tr>
        <td colspan="3">
            <c:choose>
                <c:when test="${evidence.size() == 0}">
                    <input type="submit" value="Add Evidence" name="addEvidence"/>
                </c:when>
                <c:otherwise>
                    <input type="submit" value="Save Changes" name="saveEvidence"/>
                </c:otherwise>
            </c:choose>
            <input type="submit" value="Cancel" name="cancel"/>
        </td>
    </tr>
</table>
</form>

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>
