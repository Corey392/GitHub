<%-- @author     James, Todd Wiggins
     @version    1.101
	 Created:    14/05/2011, 9:41:41 AM
	 Change Log:        1.1: TW: Removed user level navigation, moved to header.
	             02/06/2013: TW: Added instructions.
                     05/08/2013: CW: Added drop downs for instructions.
                                     Changed footer imports.
                     05/08/2013: VL: Moved jQuery script tag to header file making it accessible to all pages 
	 Purpose:    Welcome page for 'Student' once logged in.
--%>

<%! RPLPage thisPage = RPLPage.STUDENT_HOME; %>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>

<script>
    $(document).ready(function() {
        $(".heading").click(function() {
            var contentPanelId = $(this).attr("id");
            //        alert(contentPanelId);
            switch (contentPanelId) {
                case 'heading1' :
                    $(".panel1").slideToggle("fast");
                    break;
                case 'heading2' :
                    $(".panel2").slideToggle("fast");
                    break;
                case 'heading3' :
                    $(".panel3").slideToggle("fast");
                    break;
                case 'heading4' :
                    $(".panel4").slideToggle("fast");
                    break;
                case 'heading5' :
                    $(".panel5").slideToggle("fast");
                    break;
                default :
                    alert('This content is unavailable!.');
            }
        });
    });
</script>

<h1>Student Home Page</h1>
<p>Welcome ${user.firstName} ${user.lastName}</p>

<h3>Instructions:</h3>
<div id="heading1" class="heading">To Make a Claim (Initial)<img src="images/1-navigation-expand.png" style="float:right" alt="" height="16" width="16" /></div>
<div id="panel" class="panel1">
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
</div>

<div id="heading2" class="heading">To Make a Claim (1st Review)<img src="images/1-navigation-expand.png" style="float:right" alt="" height="16" width="16" /></div>
<div id="panel" class="panel2">
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
</div>

<div id="heading3" class="heading">What happens if I cannot finish my Claim?<img src="images/1-navigation-expand.png" style="float:right" alt="" height="16" width="16" /></div>
<div id="panel" class="panel3">
    <p>You can save your Claim as a Draft at anytime and return to it through the "List Claims" menu item.</p>
</div>

<div id="heading4" class="heading">I submitted my claim, but I forgot to add something?<img src="images/1-navigation-expand.png" style="float:right" alt="" height="16" width="16" /></div>
<div id="panel" class="panel4">
    <p>That's Okay, you will have another chance to update your Claim. You will be contacted by email or phone once each stage has been completed. If you have been contacted by your Assessor, please contact them directly if you have progressed passed the "Attach Evidence" stage.</p>
</div>

<div id="heading5" class="heading">My Claim has not updated for sometime?<img src="images/1-navigation-expand.png" style="float:right" alt="" height="16" width="16" /></div>
<div id="panel" class="panel5">
    <p>The Claim process is not quick, the evidence needs to be manually reviewed by an Assessor. If it has been more than 1 week and you have not had any feedback, it is recommended that you contact the TAFE directly, if you don't know your Assessor yet, contact the Head Teacher for the Discipline at the Campus.</p>
</div>

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>
