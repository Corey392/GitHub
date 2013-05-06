<%--Purpose:    Allows a student add text based evidence to a claim.
 *  @author     Todd Wiggins
 *  @version    1.000
 *  Created:    06/05/2013
 *	Modified:
--%>
<%@page import="domain.Claim"%>
<jsp:useBean id="claim" scope="session" class="domain.Claim"/>
<jsp:useBean id="modules" scope="request" class="java.util.ArrayList"/>

<%@include file="../WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.ADD_EVIDENCE_PREV; %>

<h2 class="center">Add Evidence to Previous Studies Claim</h2>
<p>Describe the evidence you are able to provide that demonstrates your knowledge for each element within each module.</p>
<p>If you have any documents as evidence, these can be uploaded after you have submitted the claim and a preliminary review been made by an assessor.</p>

<form action="addEvidencePrevClaim" method="post" name="addEvidenceForm">
	<p id="evidence_mod">
		<span id="evidence_mod_mod">Module: </span>
		<span id="evidence_mod_desc">BSBOHS407A - Monitor A Safe Workplace</span><br/>
		Further information that is specific about this module.
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
			<tr>
				<td>
					Provide information to the workgroup about OHS policies and procedures
				</td><td>
					1. Accurately explain relevant provisions of OHS legislation and codes of practice to the workgroup.<br/>
					2. Provide information to the workgroup on the organizations OHS policies, procedures and programs, ensuring it is readily accessible by the workgroup.<br/>
					3. Regularly provide and clearly explain information about identified hazards and the outcomes of risk assessment and control to the workgroup.
				</td><td>
					<textarea id="evidence_textarea" name="e_BSBOHS407A_1" placeholder="Enter the types evidence you can provide in here."></textarea>
				</td>
			</tr>
		</tbody>
	</table>
	<div id="buttons">
		<input type="submit" name="saveEvidence" value="Save Evidence">
		<input type="reset" name="reset" value="Reset Text">
	</div>
</form>

<%@include file="../WEB-INF/jspf/footer.jspf" %>