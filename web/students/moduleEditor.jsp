<%-- 
    Document   : moduleEditor
    Created on : 10/10/2012, 9:20:32 PM
    Author     : James Lee Chin :-)
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
<% 
String formAction = "";

if(session.getAttribute("claim") != null) {
    Claim claim = (Claim) session.getAttribute("claim");
    
    if(claim.getClaimType().equals(Claim.ClaimType.PREVIOUS_STUDIES)) { 
        RPLPage thisPage = RPLPage.REVIEW_CLAIM_PREV;
        formAction = "updatePrevClaim";
    } else if(claim.getClaimType().equals(Claim.ClaimType.RPL)) {
        RPLPage thisPage = RPLPage.REVIEW_CLAIM_RPL;
        formAction = "updateRPLClaim";
    }
        
}

%>
<% 
    boolean unsubmitted = (claim.getStatus() == Claim.Status.DRAFT);
%>

<div style="width:70%">
<c:if test="${!moduleError.toString().trim().equals('')}">
    <div class="warning">${moduleError}</div>
</c:if>

<form action="${formAction}" method="post" name="updateClaimForm">
    <table border="0" class="datatable" width="100%">
        <tr>
            <th>Module&nbsp;ID</th>
            <th>Module Name</th>
            <th>Evidence</th>
            <th></th>
        </tr>
        <c:choose>
            <c:when test="${claim.claimedModules != null && claim.claimedModules.size() != 0}">
                <c:forEach var="claimedModule" items="${claim.claimedModules}">
                    <tr onmouseover="document.getElementById('butt<%= index %>').style.visibility='visible';" onmouseout="document.getElementById('butt<%= index %>').style.visibility='hidden';">
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
                        <td><button type="submit" name="removeModule" id="butt<%= index %>" style="visibility:hidden;" value="<%= index %>">Remove Module</button></td>
                    </tr>
                    <% index = index + 1; %>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="4">You&nbsp;have&nbsp;not&nbsp;added&nbsp;any&nbsp;modules</td>
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
                <b>Select&nbsp;1&nbsp;-&nbsp;3&nbsp;Providers:</b><br />
            <% index = 0; %>
            <c:forEach var="provider" items="${providers}">
            
                <input type="checkbox" name="provider" value="<%= index %>">${provider.name}
                &nbsp;&nbsp;
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

                <input type="submit" value="Submit Claim" name="submitClaim" />

            </c:when>
            <c:otherwise>
                        <input type="submit" value="Back" name="back" />
            </c:otherwise>
        </c:choose>
</form>
</div>

        
<%@include file="../WEB-INF/jspf/footer.jspf" %>