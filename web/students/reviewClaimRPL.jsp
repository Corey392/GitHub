<%--Purpose:    Allows a Student to Add Modules to a Claim
 *  @author     James Purves, Todd Wiggins
 *  @version    1.001
 *  Created:    18/05/2011, 4:10:44 PM
 *	Modified:	15/05/2013: TW: Improving display of errors to be consistent across site.
 *                      05/08/2013: CW: Changed header/footer imports.
--%>

<%@page import="domain.Claim"%>
<jsp:useBean id="claim" scope="session" class="domain.Claim"/>
<jsp:useBean id="modules" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="providers" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="selectedModule" scope="request" class="domain.Module"/>
<jsp:useBean id="moduleError" scope="request" class="util.RPLError"/>
<jsp:useBean id="selectError" scope="request" class="util.RPLError"/>
<% int index = 0; %>

<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<%! RPLPage thisPage = RPLPage.REVIEW_CLAIM_RPL; %>
<%
    boolean unsubmitted = (claim.getStatus() == Claim.Status.DRAFT);
%>

<h2 class="center">Recognition of Prior Learning</h2>

<c:if test="${!moduleError.toString().trim().equals('')}">
    <div id="errorMessage">${moduleError}</div>
</c:if>

<form action="updateRPLClaim"" method="post" name="updateClaimForm">
    <table border="0" class="datatable" style="min-width:700px">
        <tr>
            <th>Module ID</th>
            <th>Module Name</th>
            <th>Evidence</th>
            <th></th>
        </tr>
        <c:choose>
            <c:when test="${claim.claimedModules != null && claim.claimedModules.size() != 0}">
                <c:forEach var="claimedModule" items="${claim.claimedModules}">
                    <tr>
                        <td>${claimedModule.moduleID}</td>
                        <td>${claimedModule.name}</td>
                        <c:choose>
                            <c:when test="<%= unsubmitted %>">
                                <c:choose>
                                    <c:when test="${claimedModule.evidence.size() == 0}">
                                        <td><input type="text" name="${claimedModule.moduleID}"/></td>
                                    </c:when>
                                    <c:otherwise>
                                        <td><input type="text" name="${claimedModule.moduleID}" value="${claimedModule.evidence.get(0).description}"/></td>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <td>${claimedModule.evidence.get(0).description}</td>
                            </c:otherwise>
                        </c:choose>
                        <td><button type="submit" name="removeModule" value="<%= index %>">Remove Module</button></td>
                    </tr>
                    <% index = index + 1; %>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="4">You have not added any modules</td>
                </tr>
            </c:otherwise>
        </c:choose>
        <% index = 0; %>
        <tbody class="last_row">
        <tr>
            <td colspan="2">
                <select name="module" style="width:100%">
                    <% index = 0; %>
                    <c:forEach var="module" items="${modules}">
                        <c:choose>
                            <c:when test="${module.moduleID == selectedModule.moduleID}">
                                <option value="<%= index %>" selected="true">
                                    ${module}
                                </option>
                            </c:when>
                            <c:otherwise>
                                <option value="<%= index %>">
                                    ${module}
                                </option>
                            </c:otherwise>
                        </c:choose>
                        <% index += 1; %>
                    </c:forEach>

                </select>
            </td>

            <td><input type="text" name="evidence" /></td>
            <td><input type="submit" value="Add Module" name="addModule" /></td>

        </tr>
        <tr>
            <td colspan="4">
                <b>Select 1 - 3 Providers:</b><br />
            <% index = 0; %>
            <c:forEach var="provider" items="${providers}">
                <input type="checkbox" name="provider" value="<%= index %>">${provider.name}
                <c:if test="<%= (index + 1) % 3 == 0 %>">
                    <br />
                </c:if>
                <% index += 1; %>
            </c:forEach>
            </td>
        </tr>
        </tbody>
    </table>
    <br />
        <c:choose>
            <c:when test="<%= unsubmitted %>">
                <c:if test="${selectError.message.length() > 0}">
                    <div id="errorMessage">${selectError.message}</div>
                </c:if>
                <input type="submit" value="Submit Claim" name="submitClaim" />
            </c:when>
            <c:otherwise>
                        <input type="submit" value="Back" name="back" />
            </c:otherwise>
        </c:choose>
</form>

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>