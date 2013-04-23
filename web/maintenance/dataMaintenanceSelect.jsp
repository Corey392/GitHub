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
    <table cellspacing="5" cellpadding="5" border="1">
        <tr>
            <td align="center">Campus</td>
            <td align="center">CampusDiscipline</td>
            <td align="center">CampusDisciplineCourse</td>
        </tr>
        <tr>
            <td align="center">ClaimedModule</td>
            <td align="center">ClaimedModuleProvider</td>
            <td align="center">Course</td>
        </tr>
        <tr>
            <td align="center">Criterion</td>
            <td align="center">Discipline</td>
            <td align="center">Element</td>
        </tr>
        <tr>
            <td align="center">Module</td>
            <td align="center">Provider</td>
        </tr>
    </table>
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer.jspf" %>