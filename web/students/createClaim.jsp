<%--Create Claim page where you select Campus, Disciple, Course and Claim type.
 *  @author     James Purves, Todd Wiggins, Mitch Carr
 *  @version    1.21
 *  Created:    14/05/2011, 5:06:19 PM
 *	Change Log: 1.01: TW: Added error messages from servlet.
 *              1.02: TW: Moved error messages to central location. Team decision.
 *              29/04/2013: 1.10: TW: Added AJAX queries to get Discipline and Courses instead of a full page refresh.
 *              15/05/2013: 1.11: TW: Improving display of errors to be consistent across site.
 *		        16/05/2013: 1.20: MC: Fixed error in ClaimType error check; changed invalid String length property to length() method
 *		        02/06/2013: 1.21: TW: Minor improvement to instructions.
 *                      05/08/2013: CW: Changed header/footer imports.
--%>

<%@include file="..\WEB-INF\jspf\header_1.jspf" %>
<%! RPLPage thisPage = RPLPage.CREATE_CLAIM; %>
<%@page import="java.util.*" %>
<jsp:useBean id="claim" scope="session" class="domain.Claim"/>
<jsp:useBean id="campuses" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="disciplines" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="courses" scope="request" class="java.util.ArrayList"/>

<script src="<%= RPLPage.ROOT %>/scripts/jquery-1.9.1.js"></script>
<script>
	var blank = {"id":0,"desc":""};
	function getDisciplines() {
		$.getJSON('<%= RPLPage.ROOT %>/AJAX?type=claim&sub=discipline&campus='+document.getElementById("campus").value, function(data) {
			document.getElementById("ajaxDiscipline").innerHTML = buildSelect("discipline",data.discipline);
			document.getElementById("ajaxCourse").innerHTML = buildSelect("course",blank);
		}).fail(function() {
			alert("Error getting Discipline information.");
		});
	}
	function getCourses() {
		$.getJSON('<%= RPLPage.ROOT %>/AJAX?type=claim&sub=course&discipline='+document.getElementById("discipline").value, function(data) {
			document.getElementById("ajaxCourse").innerHTML = buildSelect("course",data.course);
		}).fail(function() {
			alert("Error getting Course information.");
		});
	}
	function buildSelect(id, items) {
		var html = "<select name=\""+id+"\" id=\""+id+"\" " + (id === "discipline" ? "onchange=\"javascript:getCourses();\"" : "")+">";
		for (var i = 0; i < items.length; i++) {
			html+= "<option value=\""+items[i].id+"\">"+items[i].desc+"</option>";
		}
		return (html+= "</select>");
	}
	buildSelect("discipline",blank);
	buildSelect("course",blank);
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
<div id ="sidePanelRight" >
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
    
    <%--    For non-drop down in sidepanel
<h3>To Make a Claim (Initial)</h3>
<div>
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

<h3>To Make a Claim (1st Review)</h3>
<div>
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

<h3>What happens if I cannot finish my Claim?</h3>
<div>
    <p>You can save your Claim as a Draft at anytime and return to it through the "List Claims" menu item.</p>
</div>

<h1>I submitted my claim, but I forgot to add something?</h1>
<div>
    <p>That's Okay, you will have another chance to update your Claim. You will be contacted by email or phone once each stage has been completed. If you have been contacted by your Assessor, please contact them directly if you have progressed passed the "Attach Evidence" stage.</p>
</div>

<h3>My Claim has not updated for sometime?</h3>
<div>
    <p>The Claim process is not quick, the evidence needs to be manually reviewed by an Assessor. If it has been more than 1 week and you have not had any feedback, it is recommended that you contact the TAFE directly, if you don't know your Assessor yet, contact the Head Teacher for the Discipline at the Campus.</p>
</div>

--%>    
</div>

<h3>Instructions:</h3>
            <p>Please select the Campus, Discipline and Course for which you are making a claim.</p>
            <p>If your experience was at a TAFE institute, select Previous Studies. Otherwise, select Recognition of Prior Learning.</p>

<form action="createClaim" method="post" name="createClaimForm" id="createClaimForm">
    

    <table>

        <tr>
            <th>Campus:</th>
            <td colspan="2">
                <select name="campus" id="campus" onchange="javascript:getDisciplines();">
                <c:forEach var="aCampus" items="${campuses}">
                    <c:choose>
                        <c:when test="${aCampus.campusID == claim.campusID}">
                            <option value="${aCampus.campusID}" selected="true">
                                ${aCampus.name}
                            </option>
                        </c:when><c:otherwise>
                            <option value="${aCampus.campusID}">
                                ${aCampus.name}
                            </option>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                </select>
            </td>
        </tr>
        <tr>
            <th>Discipline:</th>
            <td colspan="2" id="ajaxDiscipline">
            </td>
         </tr>
         <tr>
            <th>Course:</th>
            <td colspan="2" id="ajaxCourse">
            </td>
        </tr>
        <tr>
            <%-- Changed to radio buttons, JLC  --%>
            <th>Claim Type:</th>
            <td><input type="radio" name="claimType" value="prevStudies" />Previous Studies</td>
            <td><input type="radio" name="claimType" value="rpl" />Recognition of Prior Learning</td>
        </tr>
        <tr>
            <td><input type="submit" value="Create Claim" /></td>
        </tr>
        <tr>
            <td></td>
        </tr>
    </table>
			
	<c:if test="${errorCampusID.message.length() > 0 || errorDisciplineID.message.length() > 0 || errorCourseID.message.length() > 0 || errorClaimType.message.length() > 0}">
		<div id="errorMessage">${errorCampusID.message}${errorDisciplineID.message}${errorCourseID.message}${errorClaimType.message}</div>
	</c:if>
</form>

<%@include file="..\WEB-INF\jspf\footer_1.jspf" %>
