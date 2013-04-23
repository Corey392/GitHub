<%-- 
    Document   : dataMaintenanceSelect
    Created on : 23/04/2013, 12:16:31 PM
    Author     : Bryce
--%>

<%! RPLPage thisPage = RPLPage.CLERICAL_MAINTENANCE_SELECT; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<%@include file="../WEB-INF/jspf/sidebar.jspf" %>

<%@include file="../WEB-INF/jspf/maintenanceOptions.jspf" %>

<div class="body">
        
    <form method="post" action="<%= RPLServlet.MAINTAIN_COURSE_MODULES_SERVLET.absoluteAddress %>" name="form" id="form">
        <p>Please select an area to maintain:<br></p>
    <table cellspacing="5" cellpadding="5" border="1">
        <tr>
            <td align="center"><a href="<%= RPLServlet.MAINTAIN_CAMPUS_SERVLET %>">Campus</a></td>
            <td align="center"><a href="<%= RPLServlet.MAINTAIN_CAMPUS_DISCIPLINE_SERVLET %>">CampusDiscipline</a></td>
            <td align="center"><a href="<%= RPLServlet.MAINTAIN_DISCIPLINE_COURSES_SERVLET %>">CampusDisciplineCourse</a></td>
        </tr>
        <tr>
            <td align="center"><a href="#">ClaimedModule</a></td>
            <td align="center"><a href="#">ClaimedModuleProvider</a></td>
            <td align="center"><a href="<%= RPLServlet.MAINTAIN_COURSE_SERVLET %>">Course</a></td>
        </tr>
        <tr>
            <td align="center"><a href="#">Criterion</a></td>
            <td align="center"><a href="<%= RPLServlet.MAINTAIN_DISCIPLINE_SERVLET %>">Discipline</a></td>
            <td align="center"><a href="#">Element</a></td>
        </tr>
        <tr>
            <td align="center"><a href="<%= RPLServlet.MAINTAIN_MODULE_SERVLET %>">Module</a></td>
            <td align="center"><a href="#">Provider</a></td>
        </tr>
    </table>
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer.jspf" %>