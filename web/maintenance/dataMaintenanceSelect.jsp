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

        $(function() {
            $("#example-one").organicTabs();
            $("#example-two").organicTabs({
                "speed": 200
        });

    });
        $('#maintainarea').change(function() {
            var area=$('#maintainarea').val();
            alert(area);
        });
    });
</script>
<%! RPLPage thisPage = RPLPage.CLERICAL_MAINTENANCE_SELECT; %>

<jsp:useBean id="disciplines" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="invalidNameError" scope="request" class="util.RPLError"/>
<jsp:useBean id="disciplineUpdatedMessage" scope ="request" class="java.lang.String"/>

<%@include file="../WEB-INF/jspf/header_1.jspf" %>

    <div id="page-wrap">
            <h1>Organic Tabs</h1>
            <p>the content in tabbed panels are of different heights. 
                When we switch between tabs, the content below is gently moved up or down to accomodate.</p>
            
        <div id="example-one">		
            <ul class="nav">
                <li class="nav-one"><a href="#campus" class="current">Campus</a></li>
                <li class="nav-two"><a href="#discipline">Discipline</a></li>
                <li class="nav-three"><a href="#course">Course</a></li>
                <li class="nav-four last"><a href="#module">Module</a></li>
            </ul>
            <div class="list-wrap">
                    <ul id="campus">
<!--                <li><a href="<%= RPLServlet.MAINTAIN_SERVLET %>">Campus</a></li>
                <li><a href="<%= RPLServlet.MAINTAIN_SERVLET %>">Discipline</a></li>
                <li><a href="<%= RPLServlet.MAINTAIN_SERVLET %>">Course</a></li>
                <li><a href="<%= RPLServlet.MAINTAIN_SERVLET %>">Module</a></li>-->
                        <li><a href="http://google.com">Google1</a></li>
                    </ul>
                    <ul id="discipline" class="hide">
                        <li><a href="http://google.com">Google2</a></li>
                    </ul>
                    <ul id="course" class="hide">
                        <li><a href="http://google.com">Google3</a></li>   
                    </ul>
                    <ul id="module" class="hide">
                        <li><a href="http://google.com">Google4</a></li>     
                    </ul>
             </div> <!-- END List Wrap -->
    </div> <!-- END Tabs -->
    </div> <!-- END page -->
    
    <p>This is a plugin, so you can call it on multiple tabbed areas, which can be styled totally differently</p>
	<div id="example-two">			
    	<ul class="nav">
            <li class="nav-one"><a href="#campus" class="current">Campus</a></li>
            <li class="nav-two"><a href="#discipline">Discipline</a></li>
            <li class="nav-three"><a href="#course">Course</a></li>
            <li class="nav-four last"><a href="#module">module</a></li>
        </ul>
            <div class="list-wrap">
                <ul id="campus">
                    <li><a href="http://google.com">Google1</a></li>
                    
                </ul>

                <ul id="discipline" class="hide">
                   <li><a href="http://google.com">Google2</a></li>
                   
                </ul>

                <ul id="course" class="hide">
                   <li><a href="http://google.com">Google3</a></li>
                   
                </ul>

                <ul id="module" class="hide">
                   <li><a href="http://google.com">Google4</a></li>
                   
                </ul>	 
             </div> <!-- END List Wrap -->
             </div> <!-- END Organic Tabs (Example One) -->
<!--	
        <ul class="basictab">   
            <li class="tab" id="tab"><a href="#campusArea">Campus</a></li>
            <li class="inactiveTab"><a href="#disciplineArea">Discipline</a></li>
            <li class="inactiveTab"  ><a href="#courseArea">Course</a></li>
            <li class="inactiveTab"><a href="#moduleArea">Module</a></li>
        </ul>
        <div id="displayArea" >
            <div id="scrollingArea" >
                <div class="displayItem" id="campusArea" >
                    <%@include file="../WEB-INF/jspf/maintainCampus.jspf" %>
                </div>
                <div class="displayItem" id="disciplineArea" >
                    <%@include file="../WEB-INF/jspf/maintainDiscipline.jspf" %>
                </div>
                <div class="displayItem" id="courseArea" >
                    <%@include file="../WEB-INF/jspf/maintainCourse.jspf" %>
                </div>
                <div class="displayItem" id="moduleArea" >
                   <%-- <%@include file="../WEB-INF/jspf/maintainModule.jspf" %>--%>
                </div>
            </div>
        </div>-->

	<!--	 <p>This is some content below the tabs. It will be moved up or down to accommodate the tabbed area above.</p>
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
                Search Term: <input type="text" name="searchTerm" /> <input type="submit" name="go" value="Go" />
                <input type="submit" name="reset" value="Reset" />
        </div>-->  
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
      
        <!--Start of table
        <% int index = 0; %>
         <!-- the tabs -->
           <!-- <ul class="basictab">   
                <li class="tab" id="tab"><a href="<%= RPLServlet.MAINTAIN_CAMPUS_SERVLET %>">Campus</a></li>
                <li class="inactiveTab"><a href="<%= RPLServlet.MAINTAIN_COURSE_SERVLET %>">Discipline</a></li>
                <li class="inactiveTab"  ><a href="<%= RPLServlet.MAINTAIN_DISCIPLINE_SERVLET %>">Course</a></li>
                <li class="inactiveTab"><a href="<%= RPLServlet.MAINTAIN_MODULE_SERVLET %>">Module</a></li>
                
                <li class="tab" id="tab"><a href="<%= RPLServlet.MAINTAIN_SERVLET %>">Campus</a></li>
                <li class="inactiveTab"><a href="<%= RPLServlet.MAINTAIN_SERVLET %>">Discipline</a></li>
                <li class="inactiveTab"  ><a href="<%= RPLServlet.MAINTAIN_SERVLET %>">Course</a></li>
                <li class="inactiveTab"><a href="<%= RPLServlet.MAINTAIN_SERVLET %>">Module</a></li>
            </ul>
        </div>-->
    <!--</form>-->
<!--</div>-->

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>
