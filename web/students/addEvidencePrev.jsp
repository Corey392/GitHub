<%--Purpose:    Allows a student add text based evidence to a claim.
 *  @author     Todd Wiggins
 *  @version    1.003
 *  Created:    06/05/2013
 *	Modified:	08/05/2013: TW: Finished: Adds data that has been previously submitted, eg. as a draft.
 *				12/05/2013: TW: Added handling if adding/modifying evidence is possible based on claim status and user role. Moved 'Submit Claim' and 'Save Draft Claim' buttons to this page and added handling them here, removed 'Save Evidence' button.
 *				13/05/2013: TW: Moved "Attach Evidence" button to this page from Review Claim / Module Selection page. Only show 'Attach Evidence' button 'attachEvidence' attribute of request.
 *				26/05/2013: TW: Added ability to get the "Guide File" for the current course.
 *				02/06/2013: TW: Minor improvement to instructions.
 *                              05/08/2013: CW: Changed header/footer imports.
--%>
<%@page import="domain.Claim"%>
<%@page import="domain.ClaimedModule"%>
<%@page import="domain.Criterion"%>
<%@page import="domain.Element"%>
<%@page import="domain.Evidence"%>
<%@page import="domain.GuideFile"%>
<%@page import="java.util.ArrayList"%>
<jsp:useBean id="claim" scope="session" class="domain.Claim"/>

<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<%! RPLPage thisPage = RPLPage.ADD_EVIDENCE_PREV; %>

<h2 class="center">Add Evidence to Previous Studies Claim</h2>
<h3>Instructions:</h3>
<p>Describe the evidence you are able to provide that demonstrates your knowledge for each element within each module.</p>
<p>If you have any documents as evidence, these can be uploaded after you have submitted the claim and a preliminary review been made by an assessor.</p>
<% GuideFile guideFile = (GuideFile) request.getAttribute("guideFile");
	if (guideFile != null && guideFile.getFilename() != null) {
	out.print("<p>For assistance with completing a claim for this course, there is a <a href=\"javascript:addEvidence.getGuide('"+guideFile.getCourseID()+"');\">Guide File available here</a>.</p>");
} %>
<p></p>
<form action="AddEvidencePrev" method="post" name="addEvidenceForm">
	<% ArrayList<ClaimedModule> claimedModules = claim.getClaimedModules();
	for (int i = 0; i < claimedModules.size(); i++) { %>
		<p id="evidence_mod">
			<span id="evidence_mod_mod">Module: </span>
			<span id="evidence_mod_desc"><% out.print(claimedModules.get(i).getModuleID()); %> - <% out.print(claimedModules.get(i).getName()); %></span><br/>
			<% out.print(claimedModules.get(i).getInstructions()); %>
		</p>
		<table id="evidence_tbl">
			<thead>
				<tr>
					<th id="evidence_tbl_1">Element</th>
					<th id="evidence_tbl_2">Performance Criteria</th>
					<th id="evidence_tbl_3">Evidence</th>
				</tr>
			</thead>
			<tbody>
				<% ArrayList<Element> elements = claimedModules.get(i).getElements();
				for (int j = 0; j < elements.size(); j++) { %>
					<tr>
						<td>
							<% out.print(elements.get(j).getDescription()); %>
						</td><td>
							<% ArrayList<Criterion> criterion = elements.get(j).getCriteria();
							for (Criterion c : criterion) {
								out.print("- "+c.getDescription()+"<br/>");
							} %>
						</td><td>
							<% if (request.getAttribute("editable") != null && request.getAttribute("editable").equals("true")) { %>
								<textarea id="evidence_textarea" name="<% out.print(claimedModules.get(i).getModuleID()+"|"+elements.get(j).getElementID()); %>" placeholder="Enter the types of evidence you can provide in here."><%
							}
							if (request.getParameter(claimedModules.get(i).getModuleID()+"|"+elements.get(j).getElementID()) != null) {
								out.print(request.getParameter(claimedModules.get(i).getModuleID()+"|"+elements.get(j).getElementID()));
							} else {
								ArrayList<Evidence> evidence = claimedModules.get(i).getEvidence();
								if (evidence != null) {
									for (int k = 0; k < evidence.size(); k++) {
										if (evidence.get(k).getElementID().equals(elements.get(j).getElementID())) {
											out.print(evidence.get(k).getDescription());
										}
									}
								}
							}
							if (request.getAttribute("editable") != null && request.getAttribute("editable").equals("true")) { %></textarea><% } %>
						</td>
					</tr>
				<% } %>
			</tbody>
		</table>
	<% } %>
	<div id="buttons">
		<% if (request.getAttribute("editable") != null && request.getAttribute("editable").equals("true")) {
			if (request.getAttribute("attachEvidence") != null && request.getAttribute("attachEvidence").equals("true")) { %>
				<input type="submit" value="Attach Evidence" name="AttachEvidence" />
			<% } %>
			<input type="submit" value="Save Draft Claim" name="draftClaim" />
			<input type="submit" value="Submit Claim" name="submitClaim" />
			<input type="reset" name="reset" value="Reset Text">
		<% } %>
		<input type="submit" name="back" value="Back">
	</div>
</form>

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>
<script src="<%= RPLPage.ROOT %>/scripts/addEvidence.js"></script>