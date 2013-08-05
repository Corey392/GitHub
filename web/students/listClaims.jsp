<%--Purpose:    listClaims for a Student
 *  @author     David Gibbins, James Purves, Todd Wiggins
 *  @version    1.001
 *  Created:    15/05/2011, 3:53:01 PM
 *	Modified:	15/05/2013: TW: Added Status Explanations, Changed Error message to be wrapped in <div> #errorMessage.
 *                      05/08/2013: CW: Changed header/footer imports.
--%>

<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<%! RPLPage thisPage = RPLPage.LIST_CLAIMS_STUDENT; %>
<jsp:useBean id="claims" scope="session" class="java.util.ArrayList" />
<jsp:useBean id="error" scope="request" class="util.RPLError"/>
<div class="body">
    <h2>Your Claims</h2>
    <c:if test="${error.message.length() > 0}">
        <div id="errorMessage">${error.message}</div>
    </c:if>
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

	<p id="statuses"><strong>Explanation of Statuses:</strong>
		<ul>
			<li><strong>Draft:</strong> Your claim has not been submitted, you either saved your claim or your session expired.</li>
			<li><strong>Preliminary:</strong> Your claim has been received, an assessor will determine if further evidence is required.</li>
			<li><strong>Attach Evidence:</strong> Your claim has been received, further evidence is required, please see notes in claim from assessor.</li>
			<li><strong>Awaiting Assessment:</strong> Your claim has been received and is being assessed.</li>
			<li><strong>Awaiting Approval:</strong> The Assessor has approved your claim and is being reviewed by a Delegate.</li>
			<li><strong>Submitted:</strong> The claim has been forwarded to the Recognition Centre and approval is pending.</li>
			<li><strong>Approved:</strong> Has been accepted by Recognition Centre and no further actions required.</li>
			<li><strong>Declined:</strong> The claim has not been accepted, contact the Assessor if you have further queries.</li>
		</ul>
	</p>
</div>
<%@include file="../WEB-INF/jspf/footer_1.jspf" %>
