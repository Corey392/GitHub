<%-- 
    Purpose:    Displays links to data maintenance pages for Clerical Admin.
    Document:	dataMaintenanceSelect
    Created on:	23/04/2013, 12:16:31 PM
    Author:	Bryce
    Version:    1.003
    Modified:   05/05/2013
    Change Log: 23/04/2013: Bryce Carr: Created page, added links to servlets that exist (even if they don't actually work).
                24/04/2013: Bryce Carr: Added header comments to (sort of) match code conventions.
                26/04/2013: Bryce Carr: Commented out ClaimedModule and ClaimedModuleProvider awaiting decision regarding removal from Deb Spindler.
                                        Removed CampusDiscipline and CampusDisciplineCourse in favour of a more intuitive means of managing them (drilling down through Campus' maintenance page).
                                        Centered table. UI prettiness isn't a concern at the moment but this was a trivial change and it's slightly more appealing.
		05/05/2013: Bryce Carr:	Removed Element from list. Elements are have a 1:N relationship with Modules, thus they will be incorporated into Module maintenance.
		08/05/2013: Bryce Carr:	Removed Provider from the list following discussion with Todd Wiggins.
--%>
<script>
    $(document).ready(function() {                        
//                $('#submit').click(function(event) {  
//                    var username=$('#user').val();
//                 $.get('ActionServlet',{user:username},function(responseText) { 
//                        $('#welcometext').text(responseText);         
//                    });
//                });

        $('#maintainarea').change(function() {
            var area=$('#maintainarea').val();
            alert(area);
        });
    });
</script>
    
<%! RPLPage thisPage = RPLPage.CLERICAL_MAINTENANCE_SELECT; %>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>
<div class="body">
      
    <form method="post" action="<%= RPLServlet.MAINTAIN_COURSE_MODULES_SERVLET.absoluteAddress %>" name="form" id="form">
        <div class="tablecontrols">Select an area to maintain: 
        <select name="maintainarea" id="maintainArea">
            <option value="" selected></option>
            <option value="discipline" selected="${selectedField == 'discipline'}">Discipline</option>
            <option value="course" selected="${selectedField == 'course'}">Course</option>
            <option value="campus" selected="${selectedField == 'campus'}">Campus</option>
            <option value="module" selected="${selectedField == 'module'}">Module</option>
        </select>
        
        <input list="options">

        <datalist id="options">
          <option value="Discipline">
          <option value="Course">
          <option value="Campus">
          <option value="Module">
        </datalist>
<!--                Search Term: <input type="text" name="searchTerm" /> <input type="submit" name="go" value="Go" />
                <input type="submit" name="reset" value="Reset" />-->
            </div>  
        <div>
            <p>Campus<a href="<%= RPLServlet.MAINTAIN_CAMPUS_SERVLET %>"><img src="<%= RPLPage.ROOT %>/images/left_grey.png" alt="No picture found" style="float:left" width="32" height="32"></a></p>
        </div>
        <div>
            <p>Course<a href="<%= RPLServlet.MAINTAIN_COURSE_SERVLET %>"><img src="<%= RPLPage.ROOT %>/images/left_grey.png" alt="No picture found" style="float:left" width="32" height="32"></a></p>
        </div>
        <div>
            <p>Discipline<a href="<%= RPLServlet.MAINTAIN_DISCIPLINE_SERVLET %>"><img src="<%= RPLPage.ROOT %>/images/left_grey.png" alt="No picture found" style="float:left" width="32" height="32"></a></p>
        </div>
        <div>
            <p>Module<a href="<%= RPLServlet.MAINTAIN_MODULE_SERVLET %>"><img src="<%= RPLPage.ROOT %>/images/left_grey.png" alt="No picture found" style="float:left" width="32" height="32"></a></p>
        </div>
        <!--Start of table-->
        <% int index = 0; %>
        
        <div></div>
    <table border="0" class="datatable">
                <thead>
                    <tr>
                        <th>Claim ID</th>
                        <th>Student ID</th>
                        <th>Date Made</th>
                        <th>Date Resolved</th>
                        <th>Status</th>
                        <th>(Select)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${len == '0'}">
                            <tr>
                                <td align="center" colspan="11">
                                    <b>No Claims to Display</b>
                                </td>
                            </tr>
                        </c:when>
                    <c:otherwise>
                    <% index = 0; %>
                        <c:forEach var="claim" items="${claims}">
                            <tr>
                                <td>${claim.claimID}</td>
                                <td>${claim.studentID}</td>
                                <td>${claim.dateMade}</td>
                                <td><c:choose>
                                        <c:when test="${empty claim.dateResolved}">Unresolved</c:when>
                                        <c:otherwise>${claim.dateResolved}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${claim.status}</td>
                                <td>${claim.courseID}</td>
                                <td>${claim.disciplineID}</td>
                                <td>${claim.campusID}</td>
                                <td>${claim.delegateApproved}</td>
                                <td>${claim.assessorApproved}</td>
                                <td align="center"><input type="radio" name="selectedClaim" value="${claim.claimID}" /></td>
                                <input type="hidden" name="studentID" value="${claim.studentID}:${claim.claimID}"/>
                            </tr>
                            <% index++; %>
                            </c:forEach>
                     </c:otherwise>
                </c:choose>
                </tbody>
            </table>
         
        <ul class="basictab">   
            <li class="tab" id="tab"><a href="<%= RPLServlet.MAINTAIN_CAMPUS_SERVLET %>">Campus</a></li>
            <li class="inactiveTab"><a href="<%= RPLServlet.MAINTAIN_DISCIPLINE_SERVLET %>">Discipline</a></li>
            <li class="inactiveTab"  ><a href="<%= RPLServlet.MAINTAIN_COURSE_SERVLET %>">Course</a></li>
            <li class="inactiveTab"><a href="<%= RPLServlet.MAINTAIN_MODULE_SERVLET %>">Module</a></li>
        </ul>
        
        <div id="displayArea" >
            <div id="scrollingArea" >
                <div id="campusArea" >
                    
                </div>
                <div id="disciplineArea" >
                    
                </div>
                <div id="courseArea" >
                    
                </div>
                <div id="moduleArea" >
                    
                </div>
            </div>
        </div>
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>
