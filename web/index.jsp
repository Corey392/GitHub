<%-- @author     Adam Shortall, Todd Wiggins
	 @version    1.013
	 Created:    09/05/2011, 6:46:17 PM
	 Change Log: 1.010: TW: Added our usernames into the drop down box to match the DB create script we are using.
	             1.011: TW: Removed default Username and Password (was a user that does not have access in our DB) and changed default value in drop down box to 'Select a User'. Added auto focus on page load to drop down box. Minor code clean up.
                 1.012: BC: Changed names of "Assessor" and "ADMIN" to match their actual user level.
                 02/06/2013: TW: Added information about the system.
	 Purpose:    This is the "HOME" page for a non-logged in user. The first/index page when a vistor navigates to the domain.
EXTRA LINE FOR GIT HUB PURPOSES!
--%>
<%@page import="util.RPLPage" %>
<%! RPLPage thisPage = RPLPage.HOME; %>
<jsp:useBean id="loginError" scope="request" class="util.RPLError"/>

<%@include file="WEB-INF/jspf/header.jspf" %>

<%
//<p></p>
//<!--BEGIN: Remove this section when the site is ready to go live -->
//<form name="login" id="login" action="home" method="post">
//<table border="0">
//    <tbody>
//        <tr>
//            <td>Username:</td>
//            <td><input class="textbox" size="25" type="text" name="userID" id="userID" value=""/></td>
//            <td rowspan="2">
//                <select id="userInfo" onchange="fn_Auto();" autofocus="autofocus">
//                    <option value=";">Select a User</option>
//                    <option value="374371959;password">STUDENT: Todd</option>
//                    <option value="365044651;password">STUDENT: Mitch</option>
//                    <option value="366796436;password">STUDENT: Bryce</option>
//                    <option value="355273971;password">STUDENT: Ryan</option>
//                    <option value="366688315;password">STUDENT: Kelly</option>
//                    <option value="teacher;password">ASSESSOR / TEACHER</option>
//                    <option value="assessor;password">DELEGATE</option>
//                    <option value="admin;password">ADMIN / CLERICAL</option>
//                </select>
//
//            </td>
//        </tr>
//        <tr>
//            <td>Password:</td>
//            <td><input class="textbox" size="25" type="password" name="password" id="password" value=""/></td>
//        </tr>
//        <tr>
//            <td colspan="3" height="55" style="background-color: white" ><b>${loginError.message}</b>&nbsp;</td>
//        </tr>
//        <tr>
//            <td style="background-color: white" ></td>
//            <td style="background-color: white" colspan="2">
//                <a class="button" href="#" onclick="document.getElementById('login').submit();"><span>Login</span></a>
//                <a class="button" href="register"><span>Register</span></a>
//             </td>
//        </tr>
//    </tbody>
//</table>
//</form>
//
//<script>
//    function fn_Auto() {
//        var userInfo = new Array();
//        userInfo = document.getElementById("userInfo").value.split(";");
//        document.getElementById("userID").value = userInfo[0];
//        document.getElementById("password").value = userInfo[1];
//    }
//</script>
//<!--END Remove this section when the site is ready to go live -->
%>
<h2>Credit for previous learning and experience</h2>
<!--Source: https://www.tafensw.edu.au/courses/rpl/#.UarZ2kBmiSo -->

<h4>What is RPL Assist?</h4>
<p>RPL Assist is a system currently in development and being used on a testing and trial basis designed to improve the existing paper based process.</p>
<p>Students must register separately for access to the RPL Assist system as an account is not automatically created upon registering with the TAFE.</p>
<p>For a Student to make a claim, they will then need to choose the campus they are attending, and the discipline and course they want credit for. From there, modules are selected that they want recognition for, and a description of the evidence they can provide for a module (or elements of a module) is entered.</p>
<p>Once the application is made the course coordinator will be notified, the details about the evidence that the Student is able to provide is reviewed and potentially requested to upload that evidence into the RPL Assist system. After this evidence is reviewed the Student will later be contacted to set an appointment in order to finalize their claim and provide any additional proof that may be required.</p>
<p>Once the assessor has confirmed that the proof is satisfactory the appropriate delegate is notified that performs a final review of all the evidence.</p>
<p>With all data entered into the system the delegate prints out the claim along with any evidence and these items are signed by the Delegate, Assessor and Student. The form is then sent to Newcastle for processing.</p>

<h4>What is credit?</h4>
<p>If you already have skills and knowledge that are relevant to your course, you may be able to apply for credit.</p>

<h4>Credit may be granted through a number of processes:</h4>
<p>Articulation allows you to progress from one completed qualfication to another in a defined pathway (such as from school to TAFE, or from TAFE to university).</p>
<p>Credit Transfer allows you to receive an agreed amount of credit for previous learning which is considered to be equivalent in content and learning outcomes to your nominated course.</p>
<p>Recognition of Prior Learning (RPL) allows you to be granted credit based on an assessment of your previous learning and unique experience, if there are equivalent outcomes.</p>
<p>If your application is successful, you will have your skills and knowledge recognised and you may receive your qualification faster because the study required to achieve your qualification may be reduced.</p>
<p>If you can clearly show you have already gained the equivalent skills or knowledge, you may be given an exemption for a unit of study or, in some cases, a full course.</p>

<h4>Who may apply for credit?</h4>
<p>You may apply for credit if you have:
<ul>
	<li>completed previous training at TAFE NSW</li>
	<li>qualifications from previous studies in Australia</li>
	<li>qualifications from previous studies overseas</li>
	<li>relevant work or life experience.</li>
</ul>
<h5>Previous training at TAFE NSW</h5>
<p>You may get credit for a TAFE NSW unit or module you have already completed in another TAFE NSW qualification, provided the unit or module has the same or similar content and learning outcomes. This is an example of TAFE NSW Credit Transfer.</p>

<h5>Previous studies in Australia</h5>
<p>TAFE NSW recognises that certain courses from other education and training providers are equivalent to its own qualifications, or units or modules within its courses. Universities, NSW schools, adult and community education (ACE) colleges and some private education and training providers have transfer arrangements with TAFE NSW for the amount of credit that may be granted towards a TAFE NSW qualification. This is an example of credit transfer.</p>

<h5>Qualifications gained overseas</h5>
<p>If you have overseas qualifications in a field of study the same as or related to your TAFE NSW qualification, TAFE NSW will undertake an assessment to determine the amount of credit you will be eligible for in your course, or if your studies meet the entry requirements for the course. This is an example of Recognition of Prior Learning (RPL).</p>

<h5>Relevant work or life experience</h5>
<p>TAFE NSW may recognise relevant skills gained through your part-time, full-time or casual job. You may also gain credit for work experience completed as part of previous training.</p>
<p>You may have gained skills through community or volunteer work, sports team management, domestic responsibilities or even your hobbies and leisure activities. These skills may be recognised if relevant to your course. This is an example of Recognition of Prior Learning (RPL).</p>
<p>An example of articulation is where you have achieved a whole qualification (such as a Certificate II) with another education and training provider, and you are granted credit for these studies towards a higher level qualification at TAFE NSW (such as a Certificate III).</p>

<h4>How to apply for credit</h4>
<p>You should apply for credit at your chosen campus when you enrol or as soon as possible after you start classes.</p>
<p>For more information about how to submit your application for credit, speak to a course information officer at your chosen campus.</p>

<h4>Evidence and assessment requirements</h4>
<p>You will need to provide evidence to the assessor at your local TAFE campus to demonstrate that you have the knowledge and skills required to be granted credit. The evidence that you provide needs to map to the unit(s) of competency in your course. Staff at your local TAFE NSW campus can assist you with information relevant to your course.</p>
<p>Your evidence for applications for credit transfer and articulation may include:</p>
<ul>
	<li>formal and informal qualifications</li>
	<li>certificates</li>
	<li>qualifications</li>
	<li>course transcripts</li>
	<li>statements of results</li>
</ul>

<p>Your evidence for applications for Recognition of Prior Learning (RPL) may include:</p>
<ul>
	<li>resume, work history or job description</li>
	<li>letters and references, including confirmations from your employers, clients or community groups</li>
	<li>references from your paid or unpaid work experience</li>
	<li>samples of your work, including reports, articles or publications.</li>
</ul>
<p>Your evidence must confirm that your skills and knowledge are current. When you apply for RPL you may also be asked questions by the assessor relating to your skills and knowledge, or be required to undertake an interview, practical assessment or challenge task to demonstrate that your skills and knowledge are current.</p>
<p>Copies of original certificates or other documents must be certified by a Justice of the Peace (JP). Alternatively, you may bring the original documentation to be sighted by the assessor who can then certify your copies.</p>
<p>If you are seeking credit for your overseas qualifications, you should provide certified translations of any qualifications or documents. If you need to translate documents, you may call the NSW Community Relations Commission. The Commonwealth Department of Immigration and Citizenship has a free translation service for certain documents, for migrants who have been Australian permanent residents for less than two years. You may also apply for free translations from providers of the Adult Migrant English Program (AMEP).</p>
<p>National Translating and Interpreting Service (TIS)</p>

<h4>Find out more</h4>
<p>More information about credit processes and how to arrange an assessment is available from your local TAFE NSW Institute</p>


<%@include file="WEB-INF/jspf/footer.jspf" %>
