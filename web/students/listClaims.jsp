<%-- 
    Document   : listClaims for a Student
    Created on : 15/05/2011, 3:53:01 PM
    Author     : David Gibbins, James Purves
--%>

<%@include file="../WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.LIST_CLAIMS_STUDENT; %>
<jsp:useBean id="claims" scope="session" class="java.util.ArrayList" />
<jsp:useBean id="error" scope="request" class="util.RPLError"/>
<div class="body">
    <center>
    <h2>Your Claims</h2>
    <c:if test="${error.message.length() > 0}">
        <td><b>${error.message}</b></td>
    </c:if>
    </center>
    <form name="listClaims" action="<%= RPLServlet.LIST_CLAIMS_STUDENT_SERVLET.absoluteAddress %>" method="post" >
        <table border="0" class="datatable">
            <tr>
                <th>Claim ID</th>
                <th>Claim Type</th>
                <th>Date Made</th>
                <th>Date Resolved</th>
                <th>Status</th>
                <th>Course</th>
                <th>Campus</th>
                <th>Select Claim</th>
            </tr>
            <c:choose>
                <c:when test="${claims != null && claims.size() != 0}">
                    <c:forEach var="claim" items="${claims}">
                    <tr>
                        <td>${claim.claimID}</td>
                        <td>${claim.claimType.desc}</td>
                        <td>${claim.dateMade}</td>
                        <td>${claim.dateResolved}</td>
                        <td>${claim.status.desc}</td>
                        <td>${claim.course}</td>
                        <td>${claim.campus.name}</td>
                        <td><input type="radio" name="selectedClaim" value="${claim.claimID}" /> </td>
                    </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="8">You have no claims.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </table>
        
        <div class="bottomButton">
            <input type="submit" value="Delete Draft Claim" name="delete" />
            <input type="submit" value="View Claim" name="view" />
        </div>
    </form>
</div>
<%@include file="../WEB-INF/jspf/footer.jspf" %>
