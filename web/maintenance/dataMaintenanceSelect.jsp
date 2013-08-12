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

<%! RPLPage thisPage = RPLPage.CLERICAL_MAINTENANCE_SELECT;%>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>

    <ul class="basictab">   
        <li class="tab" id="tab"><a href="#campusArea">Campus</a></li>
        <li class="inactiveTab"><a href="#disciplineArea" target="_parent" >Discipline</a></li>
        <li class="inactiveTab"  ><a href="#courseArea">Course</a></li>
        <li class="inactiveTab"><a href="#moduleArea">Module</a></li>
    </ul>


    <div id="displayArea" >
        <div id="scrollingArea" >
            <div class="displayItem" id="campusArea" >
                <p>Campus</p>
            </div>
            <div class="displayItem" id="disciplineArea" >
                <p>Discipline</p>
            </div>
            <div class="displayItem" id="courseArea" >
                <p>Course</p>
            </div>
            <div class="displayItem" id="moduleArea" >
                <p>Module</p>
            </div>
        </div>
    </div>

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>
