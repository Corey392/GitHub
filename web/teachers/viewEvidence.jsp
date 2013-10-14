<%--Purpose:    viewEvidence
 *  @author     David, Mitch Carr, Todd Wiggins
 *  Created:    11/06/2011, 6:56:16 PM
 *  @version    1.11
 *  Change Log: 18/05/2013: MC: Updated studentID fields to reflect changes to database and ClaimedModule class
 *              15/06/2013: TW: Visual improvements
 *				18/06/2013: MC/TW: Implemented viewing Students uploaded files.
--%>

<%@page import="domain.ClaimFile"%>
<%@page import="data.ClaimIO"%>
<%@page import="data.ClaimedModuleIO"%>
<%@page import="java.util.*" %>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<script src="<%= RPLPage.ROOT %>/scripts/jquery-1.9.1.js"></script>
<%! RPLPage thisPage = RPLPage.VIEW_EVIDENCE_PAGE; %>
<jsp:useBean id="claimedModule" scope="request" class="domain.ClaimedModule"/>
<jsp:useBean id="empt" class="java.lang.String"/>
<jsp:useBean id="prevtype" class="java.lang.String"/>

<%
    boolean approved;
    ClaimIO claimIO = new ClaimIO(Role.TEACHER);
    String studentID = claimIO.getByID(claimedModule.getClaimID()).getStudentID();
%>
<c:if test="${claimedModule == null}">
    <c:redirect url="<%= RPLServlet.VIEW_TEACHER_CLAIM_SERVLET.relativeAddress %>" />
</c:if>
<script type="text/javascript" src="<%= RPLPage.ROOT %>/scripts/selectAll.js"></script>
<h1><%=thisPage.title%></h1>
<div class="body">
    <form action="<%= RPLServlet.VIEW_EVIDENCE_SERVLET.absoluteAddress %>" method="post">
    <div>
        <p>     <i>For RPL Claims you may view the details of the evidence that has been submitted.
                For Previous Studies claims, you may view and approve the evidence displayed, which is usually in the form of
                previously studied modules.</i><br/><br/>
                Claim ID: <b>${claimedModule.claimID}</b><br/>
           Evidence for Module <b>${claimedModule.moduleID}</b><br/>
           Student ID: <b><%=studentID%></b><br/>
           <input type="hidden" name="claimID" value="${claimedModule.claimID}" />
           <input type="hidden" name="moduleID" value="${claimedModule.moduleID}" />
           <input type="hidden" name="studentID" value="<%=studentID%>" />
        </p>
    </div>
        <div>
            <table width="900" cellpadding="6" class="datatable">
                <thead>
                    <tr>
                        <th>Element</th>
                        <th>Criterion</th>
                        <th>Evidence Provided</th>
                        <th>
                            Approval<br/>
                            (Check All) <input type="checkbox" value="on" name="allbox" onclick="checkAll();"/>
                        </th>
                    </tr>
                </thead>
                <tbody>
                <c:choose>
                <c:when test="${empt != null}">
                    <c:forEach var="el" items="${claimedModule.elements}">
                        <tr>
                            <td>${el.elementID}</td>
                            <td>
                                <c:if test="${empty el.criteria}">(none)</c:if>
                                <c:forEach var="crit" items="${el.criteria}">
                                    <b>Criterion ID:</b> ${crit.criterionID}.<br/>
                                    <b>Description: </b>${crit.description}<br/>
                                </c:forEach>
                            </td>
                            <td>
                                <c:forEach var="ev" items="${claimedModule.evidence}">
                                    <c:choose>
                                        <c:when test="${ev.elementID == 0}">
                                            ${ev.description}
                                        </c:when>
                                        <c:otherwise>
                                            <c:if test="${el.elementID == ev.elementID}">
                                                ${ev.description}
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </td>
                            <td>
                                <% approved = false; %>
                                <c:forEach var="ev" items="${claimedModule.evidence}">
                                    <c:if test="${ev.elementID == el.elementID || ev.elementID == 0}">
                                        <c:if test="${ev.approved == true}">
                                            <% approved = true; %>
                                        </c:if>
                                    </c:if>
                                </c:forEach>
                                <% if (approved == true){ %>
                                    Approved
                                <% } else { %>
                                    <input type="checkbox" name="approved" value="${el.elementID}"></input>
                                <% } %>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td align="center" colspan="4"><b>No Evidence to display</b></td></tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
		<p> </p>
		<h2>Files Uploaded by Student</h2>
	<% ArrayList<ClaimFile> claimFiles = (ArrayList<ClaimFile>) session.getAttribute("claimFiles");
	if (claimFiles != null && claimFiles.size() > 0) {
		if (request.getAttribute("error") != null) { %>
			<div id="errorMessage">${error}</div>
		<% } %>
	<form action="attachEvidence" method="post" name="attachEvidenceForm">
		<table id="evidence_tbl">
			<thead>
				<tr>
					<th>Filename</th>
					<th>Select</th>
				</tr>
			</thead>
			<tbody>
				<% for (ClaimFile claimFile : claimFiles) {
					out.print("<tr><td>"+claimFile.getFilename()+"</td><td><input type=\"radio\" value=\""+claimFile.getFileID()+"\" name=\"selected\"></td></td>");
				} %>
			</tbody>
		</table>
		<input type="button" id="view" value="View File">
	</form>
	<% } %>
        <div style="text-align:center">
            <br/>
            <c:if test="${empt == '0'}">
                <input type="submit" value="Approve Evidence" name="btn"/></input>
            </c:if>
            <input type="submit" value="Back" name="btn" />
            <input type="hidden" name="rpath" value="<%= RPLPage.VIEW_EVIDENCE_PAGE.relativeAddress %>"/>
        </div>
    </div>

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>
<script src="<%= RPLPage.ROOT %>/scripts/attachEvidence.js"></script>