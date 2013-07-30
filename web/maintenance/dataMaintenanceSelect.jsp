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

<%! RPLPage thisPage = RPLPage.CLERICAL_MAINTENANCE_SELECT; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>

<div class="body">
        
    <form method="post" action="<%= RPLServlet.MAINTAIN_COURSE_MODULES_SERVLET.absoluteAddress %>" name="form" id="form">
        <h1><p style="text-align:center">Please select an area to maintain:<br></p></h1>
    <table cellspacing="5" cellpadding="5" border="1" align="center">
        <tr>
            <td align="center"><a href="<%= RPLServlet.MAINTAIN_CAMPUS_SERVLET %>"><img src="<%= RPLPage.ROOT %>/images/left_grey.png" alt="No picture found" style="float:right" width="32" height="32">Campus</a></td>
        </tr>
        <tr>
            <td align="center"><a href="<%= RPLServlet.MAINTAIN_COURSE_SERVLET %>"><img src="<%= RPLPage.ROOT %>/images/left_grey.png" alt="No picture found" style="float:right" width="32" height="32">Course</a></td>
        </tr>
        <tr>
            <td align="center"><a href="<%= RPLServlet.MAINTAIN_DISCIPLINE_SERVLET %>"><img src="<%= RPLPage.ROOT %>/images/left_grey.png" alt="No picture found" style="float:right" width="32" height="32">Discipline</a></td>
        </tr>
        <tr>
            <td align="center"><a href="<%= RPLServlet.MAINTAIN_MODULE_SERVLET %>"><img src="<%= RPLPage.ROOT %>/images/left_grey.png" alt="No picture found" style="float:right" width="32" height="32">Module</a></td>
        </tr>
    </table>
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer.jspf" %>