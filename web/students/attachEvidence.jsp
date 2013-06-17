<%--Purpose:    Allows a student upload evidence to a claim.
 *  @author     Todd Wiggins, Mitch Carr
 *  @version    1.012
 *  Created:    13/05/2013
 *	Modified:	13/05/2013: Added list of files attached to claim, added Javascript code.
 *              13/05/2013: MC: Changed "images/*" to "image/*"; untested, but should fix the filetype selection issue
 *              15/05/2013: TW: Improving display of errors to be consistent across site.
 *              02/06/2013: TW: Improved instructions.
 *				02/06/2013: TW: Fixed the 'thisPage' variable to point to the correct one.
 *				18/06/2013: TW: Added Submit and Back Buttons
--%>
<%@page import="domain.ClaimFile"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="domain.Claim"%>
<jsp:useBean id="claim" scope="session" class="domain.Claim"/>

<%@include file="../WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.ATTACH_EVIDENCE; %>
<script src="<%= RPLPage.ROOT %>/scripts/jquery-1.9.1.js"></script>

<h2 class="center">Attach Evidence to Claim</h2>

<form action="attachEvidence" method="post" name="attachEvidenceForm" enctype="multipart/form-data">
    <div>
		<h3>Instructions:</h3>
		<p>Please upload any files relating to your claim, ensure that you have read the Assessor Notes in the 'Add Evidence' screen as they may have explained to you what you will or will not need to upload.</p>
		<p>You may upload multiple files at once if supported by your browser, after an upload request has completed, your files will be displayed below.</p>
		<p>Files being uploaded must an <strong>Image</strong> (for scanned documents) or <strong>Adobe PDF format</strong>.</p>
		<p>Most items can be freely converted to PDF format through online web sites, please use a search engine such as Google with a term such as "Convert Word to PDF online free", there are also a number of freely available "Print to PDF" applications available.
		<div id="upload">
			<input type="file" name="files" accept="image/*|application/pdf" multiple>
			<br/>
			<div id="buttons">
				<input type="submit" name="submitFiles" value="Upload Files to Claim">
			</div>
		</div>
	</div>
</form>
<p></p>
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
		<input type="submit" name="remove" value="Remove File">
	</form>
<% } %>

<form action="attachEvidence" method="post" name="attachEvidence">
	<div id="buttons">
		<input type="submit" value="Submit Claim" name="submitClaim" />
		<input type="submit" name="back" value="Back">
	</div>
</form>
<%@include file="../WEB-INF/jspf/footer.jspf" %>
<script src="<%= RPLPage.ROOT %>/scripts/attachEvidence.js"></script>