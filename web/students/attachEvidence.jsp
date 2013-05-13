<%--Purpose:    Allows a student upload evidence to a claim.
 *  @author     Todd Wiggins, Mitch Carr
 *  @version    1.010
 *  Created:    13/05/2013
 *	Modified:
 *  Changelog:	1.010: MC: Changed "images/*" to "image/*"; untested, but should fix the filetype selection issue
--%>
<%@page import="domain.Claim"%>
<jsp:useBean id="claim" scope="session" class="domain.Claim"/>

<%@include file="../WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.ADD_EVIDENCE_PREV; %>

<h2 class="center">Attach Evidence to Claim</h2>

<form action="attachEvidence" method="post" name="attachEvidenceForm" enctype="multipart/form-data">
    <div>
		<p>Please upload any files relating to your claim, please ensure you have read
		the Assessor Notes in the 'Add Evidence' screen as they may have told you what
		you will or will not need to upload.</p>
		<p>Files being uploaded must an Image (for scanned documents) or Adobe PDF format</p>
		<input type="file" name="files" accept="image/*|application/pdf" multiple>
	</div>
	<div id="buttons">
		<input type="submit" name="submitFiles" value="Upload Files to Claim">
	</div>
</form>

<%@include file="../WEB-INF/jspf/footer.jspf" %>
