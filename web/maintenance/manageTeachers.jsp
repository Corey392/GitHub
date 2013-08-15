<%-- 
    Author     : Vince Lombardo
    Document   : manageTeachers
    Purpose    : allows delegate users to set which assessors can assess specific displine
    Created on : 02/08/2013, 8:27:03 PM
--%>

<%@page import="web.FormManageTeachers"%>

<meta http-equiv="refresh" content="10" >
<%! RPLPage thisPage = RPLPage.ADMIN_MANAGE_TEACHERS;%>
<jsp:useBean id="claim" class="domain.Claim" scope="request"/>
<jsp:useBean id="listError" scope="request" class="util.RPLError"/>
<jsp:useBean id="disciplines" scope="request" class="java.util.ArrayList"/>

<% int index = 0;%>

<script type="text/javascript">
    $(document).ready(function() {
// Add the "focus" value to class attribute 
//  $('ul.checkbox li').focusin( function() {
//    $(this).addClass('focus');
//  }
//  );
//
//  // Remove the "focus" value to class attribute 
//  $('ul.checkbox li').focusout( function() {
//    $(this).removeClass('focus');
//  }
//  );
    
//        $('#searchBy').change(function() {
//            var username = $('#searchBy').val();
//            alert(username);
//        });
//        $(function(){
//                // Variable to get ids for the checkboxes
//                var idCounter=1;
//            $("#btn1").click(function(){
//                var val = $("#txtAdd").val();
//                $("#divContainer").append ( "<label for='chk_" + idCounter + "'>" + val + "</label><input id='chk_" + idCounter + "' type='checkbox' value='" + val + "' />" );
//                idCounter ++;
//            });
//        });
        
//        $('#addCheckbox').click(function() {
//            var text = $('#discipline').val();
//            alert(text);
//            $('#checkboxes').append('<input type="checkbox" /> ' + text + '<br />');
//        });
    });
</script>
<style type="text/css">
    fieldset.group  { 
      border: solid;
      border-color: #0575f4;
      margin: 0; 
      padding: 0; 
      margin-bottom: 1.25em; 
      padding: .125em;
    } 

    fieldset.group legend { 
      margin: 0; 
      padding: 5; 
      font-weight: bold;
      font-size: large;
      margin-left: 20px; 
      /*font-size: 100%;*/ 
      color: #0575f4; 
    } 
    ul.checkbox  { 
      margin: 0; 
      padding: 0; 
      margin-left: 20px; 
      list-style: none;
    } 

    ul.checkbox li input { 
      margin-right: .25em; 
    } 

    ul.checkbox li { 
      border: 1px transparent solid; 
    } 

    ul.checkbox li label { 
      margin-left: .25em;
    } 
/*    ul.checkbox li:hover,
    ul.checkbox li.focus  { 
      background-color: lightyellow; 
      border: 1px gray solid; 
      width: 12em; 
    }*/
</style>
    <%@include file="../WEB-INF/jspf/header_1.jspf" %>
<!--</div>-->
        <div>
            <div class="">
                <h1>Manage Teachers</h1>
                <!--<p>Welcome ${user.firstName} ${user.lastName}</p>-->
            </div>
            
            <form name="<%= FormManageTeachers.NAME%>" action="<%= FormManageTeachers.ACTION%>" method="post">
                <fieldset form="" class="group"> 
                <legend>Disciplines Maintained</legend> 
                <ul class="checkbox"> 
                    <li><input type="checkbox" id="cb1" value="IT" /><label for="cb1">IT</label></li> 
                    <li><input type="checkbox" id="cb2" value="Business" /><label for="cb2">Business</label></li> 
                    <li><input type="checkbox" id="cb3" value="Accounting" /><label for="cb3">Accounting</label></li> 
                    <li><input type="checkbox" id="cb4" value="Science" /><label for="cb4">Science</label></li> 
                    <li><input type="checkbox" id="cb5" value="Cooking" /><label for="cb5">Cooking</label></li> 
                    <li><input type="checkbox" id="cb6" value="Administration" /><label for="cb6">Administration</label></li> 
                </ul> 
            </fieldset>
    <!--            <div id="cblist">
                        <input type="checkbox" value="first checkbox" id="cb1" /> <label for="cb1">first checkbox</label>
                    </div>
    <!--            <div id="checkboxes">

                </div>
                <select name="searchBy" id="discipline">
                        <option value="" selected>Technology</option>
                </select>
                <input type="text" id="newCheckText" /> <button id="addCheckbox">Add Discipline</button>-->

    <!--            <div id='divContainer'></div>
                <input type="text" id="txtAdd" /> 
                <button id="btn1">Click</button>-->

    <!--            <div class="userinput">
                    <input style="text-align:right; width:75px" required maxlength="3" type="text" value="${campus.campusID}" name="campusID[]" />
                </div>-->


                <div class="tablecontrols">Search By: 
                    <select name="searchBy" id="searchBy">
                        <option value="" selected></option>
                        <option value="claimID" selected="${selectedField == 'claimID'}"> Claim ID</option>
                        <option value="studentID" selected="${selectedField == 'studentID'}">Student ID</option>
                        <option value="dateMade" selected="${selectedField == 'dateMade'}">Date Made</option>
                        <option value="dateResolved" selected="${selectedField == 'dateResolved'}">Date Resolved</option>
                        <option value="status" selected="${selectedField == 'status'}">Status</option>
                        <option value="courseID" selected="${selectedField == 'courseID'}">Course ID</option>
                        <option value="disciplineID" selected="${selectedField == 'disciplineID'}">Discipline ID</option>
                        <option value="campusID" selected="${selectedField == 'campusID'}">Campus ID</option>
                        <option value="dateResolved" selected="${selectedField == 'dateResolved'}">Date Resolved</option>
                        <option value="delegateApproved" selected="${selectedField == 'delegateApproved'}">Delegate Approved</option>
                        <option value="assessorApproved" selected="${selectedField == 'assessorApproved'}">Assessor Approved</option>
                    </select>
                    Search Term: <input type="text" name="searchTerm" /> <input type="submit" name="go" value="Go" />
                    <input type="submit" name="reset" value="Reset" />
                </div>

                <table border="0" class="datatable">
                    <thead>
                        <tr>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Claims Assigned</th>
                            <th>Claims Pending</th>
                            <th>Claim Assessed</th>
                            <th>(Select)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${len == '0'}">
                                <tr>
                                    <td align="center" colspan="11">
                                        <b>No Teachers to Display</b>
                                    </td>
                                </tr>
                            </c:when>
                    </c:choose>
                    </tbody>
                </table>

            </form>
        </div>
    <%@include file="../WEB-INF/jspf/footer_1.jspf" %>