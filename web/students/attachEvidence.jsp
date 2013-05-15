<%--Purpose:    Allows a student upload evidence to a claim.
 *  @author     Todd Wiggins, Mitch Carr
 *  @version    1.011
 *  Created:    13/05/2013
 *	Modified:	13/05/2013: Added list of files attached to claim, added Javascript code.
 *              13/05/2013: MC: Changed "images/*" to "image/*"; untested, but should fix the filetype selection issue
 *              15/05/2013: TW: Improving display of errors to be consistent across site.
--%>
<%@page import="domain.ClaimFile"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="domain.Claim"%>
<jsp:useBean id="claim" scope="session" class="domain.Claim"/>

<%@include file="../WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.ADD_EVIDENCE_PREV; %>
<script src="<%= RPLPage.ROOT %>/scripts/jquery-1.9.1.js"></script>

<h2 class="center">Attach Evidence to Claim</h2>

<form action="attachEvidence" method="post" name="attachEvidenceForm" enctype="multipart/form-data">
    <div>
		<p>Please upload any files relating to your claim, please ensure you have read
		the Assessor Notes in the 'Add Evidence' screen as they may have told you what
		you will or will not need to upload.</p>
		<p>You may upload multiple files at once if supported by your browser, after an
		upload has completed, your files will be displayed below.</p>
		<p>Files being uploaded must an Image (for scanned documents) or Adobe PDF format</p>
		<div id="upload">
			<input type="file" name="files" accept="images/*|application/pdf" multiple>
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
<%@include file="../WEB-INF/jspf/footer.jspf" %>
<script>
var attachEvidence = function() {
	var addOnClick = function() {
		$('#view').click(function() {
			if ($("input:radio[name='selected']:checked").val() !== undefined) {
				window.open('<%= RPLPage.ROOT %>/students/getFile?id='+$("input:radio[name='selected']:checked").val());
			} else {
				alert("Please select a file with the Radio Buttons.");
			}
		});
	};
	return {
		register : addOnClick
	};
}();
attachEvidence.register();
</script>