<%-- @author     James, Todd Wiggins
     @version    1.101
	 Created:    14/05/2011, 9:41:41 AM
	 Change Log:        1.1: TW: Removed user level navigation, moved to header.
	             02/06/2013: TW: Added instructions.
	 Purpose:    Welcome page for 'Student' once logged in.
--%>

<%! RPLPage thisPage = RPLPage.STUDENT_HOME; %>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>


<h1>Student Home Page</h1>
<p>Welcome ${user.firstName} ${user.lastName}</p>

<h3>Instructions:</h3>
<h4>To Make a Claim (Initial):</h4>
<ul>
	<li>Click "Create Claim" from the menu on the left.</li>
	<li>You will then need to choose the campus your attending.</li>
	<li>Then choose the discipline and course you want credit for.</li>
	<li>From there you need to select the modules you want recognition for.</li>
	<li>You will then need to describe the evidence you can provide for each element within each module.</li>
	<li>You can now submit your claim for initial review.</li>
</ul>
<h5>What Happens Now?:</h5>
<p>Your claim will be reviewed and you will be contacted advising you of the next step.</p>

<h4>To Make a Claim (1st Review):</h4>
<ul>
	<li>You should receive an email or phone call advising you that further information is required.</li>
	<li>You will need to re-open your existing claim through the 'List Claims' menu item on the left.</li>
	<li>Choose the claim that requires further information (status should read "Attach Evidence").</li>
	<li>Open the claim.</li>
	<li>Click "Add Evidence".</li>
	<li>Review the "Assessor Notes" in regards to the evidence you stated you could supply.</li>
	<li>Check that the information you stated is correct and in line with what the "Assessor Notes" say.</li>
	<li>Upload your evidence through the "Attach Evidence" button at the bottom of the page. (Note: Your evidence must be in PDF or Image format to be uploaded).</li>
</ul>
<h5>What Happens Now?:</h5>
<p>Your claim will be reviewed again with your evidence by the Assessor assigned to your claim, you will need be contacted by the Assessor as you will need to attend the TAFE Campus and meet with your Assessor to complete your claim.</p>

<h4>What happens if I cannot finish my Claim?:</h4>
<p>You can save your Claim as a Draft at anytime and return to it through the "List Claims" menu item.</p>

<h4>I submitted my claim, but I forgot to add something?:</h4>
<p>That's Okay, you will have another chance to update your Claim. You will be contacted by email or phone once each stage has been completed. If you have been contacted by your Assessor, please contact them directly if you have progressed passed the "Attach Evidence" stage.</p>

<h4>My Claim has not updated for sometime?:</h4>
<p>The Claim process is not quick, the evidence needs to be manually reviewed by an Assessor. If it has been more than 1 week and you have not had any feedback, it is recommended that you contact the TAFE directly, if you don't know your Assessor yet, contact the Head Teacher for the Discipline at the Campus.</p>

<%@include file="../WEB-INF/jspf/footer.jspf" %>
