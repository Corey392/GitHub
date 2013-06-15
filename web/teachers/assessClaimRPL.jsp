<%--Purpose:    This page is for the assessment of a Claim for RPL.
 *  @author     David, Todd Wiggins
 *  @version    1.00.01
 *  Created:    20/05/2011, 6:11:47 PM
 *	Change Log: 15/06/2013: TW: Added error message handling, improved visuals, added Set Claim Status ability, added Status explanations, updated to show names instead of id's for Campus, Discipline and Course.
--%>

<%! RPLPage thisPage = RPLPage.ASSESS_CLAIM_RPL; %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.lang.Enum" %>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<jsp:useBean id="claim" scope="request" class="domain.Claim"/>
<% int index = 0; %>
<c:if test="${claim == null || claim.claimedModules == null}">
    <c:redirect url="<%= RPLServlet.ASSESS_CLAIM_RPL_SERVLET.relativeAddress %>" />
</c:if>
<h1><%=thisPage.title%></h1>
<div class="body">
<form name="assessClaim" action="<%= RPLServlet.ASSESS_CLAIM_RPL_SERVLET %>" method="post">
    <table cellpadding="6">
		<c:if test="${error.length() > 0}">
			<td colspan="6" id="errorMessage">${error}</td>
		</c:if>
        <tr>
            <td align="center" colspan="4"><h2>Claim Details</h2></td>
        </tr>
        <tr>
            <td>Student:</td>
            <td><b>${claim.studentID}</b></td>
            <td>Claim Status</td>
            <td><b>${claim.getStatus().desc}</b></td>
        </tr>
        <tr>
            <td>Campus:</td>
            <td><b>${claim.campus.name}</b></td>
            <td>Discipline:</td>
            <td><b>${claim.discipline.name}</b></td>
            <td>Course:</td>
            <td><b>${claim.course.name}</b></td>
        </tr>
    </table>
        <table cellpadding="6" class="datatable">
            <thead>
                <tr>
                    <th>Module ID</th>
                    <th>Functional Unit Code</th>
                    <th>Evidence</th>
                    <th>Arrangement Number</th>
                    <th>Recognition</th>
                    <th>Previous Provider Code</th>
                    <th>Approval</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${claim.claimedModules == null}"><tr><td>No Claimed Modules!</td></tr></c:if>
            <% index = 0; %>
                <c:forEach var="module" items="${claim.claimedModules}">
                    <tr>
                        <td>${module.moduleID}</td>
                        <td>${module.functionalCode}</td>
                        <td><input type="submit"  name="evid:${module.moduleID}" value="View Evidence" /></td>
                        <td>${module.arrangementNo}</td>
                        <td align="center">${module.recognition}</td>
                        <td>${module.providers[0].name}</td>
                        <td align="center">
                            <input type="checkbox" name="approved<%//=index%>" value="${module.moduleID}"></input>
                        </td>
                    </tr>
                    <% index++; %>
                </c:forEach>
            </tbody>
        </table>
        <input type="hidden" name="claimID" value="${claim.claimID}"/> <%-- Values should be encrypted --%>
        <input type="hidden" name="studentID" value="${claim.studentID}"/>
        <input type="hidden" name="rpath" value="<%= RPLPage.ASSESS_CLAIM_RPL.relativeAddress %>"/>
        <div>
			Set Claim Status to:
			<select name="newStatus">
            <c:forEach var="status" items="${statuses}">
				<option value="${status.name()}"
				<c:if test="${claim.getStatus() == status}">
					selected="selected"
				</c:if>>${status.desc}</option>
			</c:forEach>
			</select>
            <input type="submit" name="cmd" value="Set Claim Status" />
            <input type="submit" name="cmd" value="Approve Selected Modules" />
            <input type="submit" name="cmd" value="Print Claim" />
            <input type="submit" name="cmd" value="Back" />
		</div>
		<p><br/><br/></p>
		<div>
		<h2>Explanation of Statuses:</h2>
		<table class="datatable">
			<tr><thead>
				<th>Status</th>
				<th>Editable By</th>
				<th>Description</th>
			</thead></tr>
			<tbody>
				<tr>
					<td>Draft</td>
					<td>Student</td>
					<td>A Student has not submitted their claim yet, partially completed. A Student can add/remove modules, provide evidence.</td>
				</tr>
				<tr>
					<td>Preliminary</td>
					<td>Assessor</td>
					<td>The Assessor needs to determine if further evidence is required. A Student has submitted their claim for review.</td>
				</tr>
				<tr>
					<td>Attach Evidence</td>
					<td>Student</td>
					<td>The Assessor has determined that more Evidence is required, notably documented proof such as Certificates. Students are directed to see notes in claim from Assessor.</td>
				</tr>
				<tr>
					<td>Awaiting Assessment</td>
					<td>Assessor</td>
					<td>The Assessor needs to review the additional Evidence provided, and most likely need to have the Student attend for further details.</td>
				</tr>
				<tr>
					<td>Awaiting Approval</td>
					<td>Assessor, Delegate</td>
					<td>The Assessor has approved the claim and now needs to be reviewed by a Delegate.</td>
				</tr>
				<tr>
					<td>Submitted</td>
					<td>Delegate</td>
					<td>The claim has been forwarded to the Recognition Centre and approval is pending.</td>
				</tr>
				<tr>
					<td>Approved</td>
					<td>View Only</td>
					<td>Has been accepted by Recognition Centre and no further actions required.</td>
				</tr>
				<tr>
					<td>Declined</td>
					<td>View Only</td>
					<td>The claim has not been accepted, Students are directed to contact the Assessor if they have further queries. Students should be contacted directly.</td>
				</tr>
			</tbody>
		</table>
    </form>
</div>
<%@include file="../WEB-INF/jspf/footer.jspf" %>