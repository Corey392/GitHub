<%--Purpose:    Allows a student to update their account details.
 *  @author     James Lee Chin, Todd Wiggins
 *  @version    1.10
 *  Created:    18/05/2011, 4:11:01 PM
 *	Modified:	05/05/2013: TW: Added 'National Module Code' as per Story Boards, Removed 'Evidence' as this is for another page after first review.
--%>
<%@page import="domain.Claim"%>
<jsp:useBean id="claim" scope="session" class="domain.Claim"/>
<jsp:useBean id="modules" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="providers" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="selectedModule" scope="request" class="domain.Module"/>
<jsp:useBean id="moduleError" scope="request" class="util.RPLError"/>
<jsp:useBean id="selectError" scope="request" class="util.RPLError"/>
<% int index = 0; %>

<%@include file="../WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.REVIEW_CLAIM_PREV; %>
<%
    boolean unsubmitted = (claim.getStatus() == Claim.Status.DRAFT);
%>

<h2 class="center">Recognition of Previous Studies</h2>


<c:if test="${!moduleError.toString().trim().equals('')}">
    <div class="warning">${moduleError}</div>
</c:if>

<form action="updatePrevClaim" method="post" name="updateClaimForm">
    <table border="0" class="datatable">
        <tr>
            <th>Module / Unit Code</th>
            <th>National Module Code</th>
            <th>Module / Unit Name</th>
            <th>Actions</th>
        </tr>
        <c:choose>
            <c:when test="${claim.claimedModules != null && claim.claimedModules.size() != 0}">
                <c:forEach var="claimedModule" items="${claim.claimedModules}">
                    <tr class="highlight_row" name="highlight_row">
                        <td>${claimedModule.moduleID}</td>
						<td>${claimedModule.getNationalModuleID()}</td>
                        <td>${claimedModule.getName()}</td>
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
	</table>
	<table class="datatable">
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
                    <b>${selectError.message}</b>
                </c:if>

                <input type="submit" value="Save Draft Claim" name="draftClaim" />
                <input type="submit" value="Submit Claim" name="submitClaim" />

            </c:when>
            <c:otherwise>
                <input type="submit" value="Back" name="back" />
            </c:otherwise>
        </c:choose>
</form>

<%@include file="../WEB-INF/jspf/footer.jspf" %>
