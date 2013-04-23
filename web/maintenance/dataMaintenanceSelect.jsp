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
        <p>
            Table names with **asterisks** around them are ones I'm not sure should be maintain-able<br>
            Or, ones I'm not sure should still exist at all (Core and Elective)
        </p>
    <table cellspacing="5" cellpadding="5" border="1">
        <tr>
            <td align="center">**Assessor**</td>
            <td align="center">Campus</td>
            <td align="center">CampusDiscipline</td>
        </tr>
        <tr>
            <td align="center">CampusDisciplineCourse</td>
            <td align="center">**Claim**</td>
            <td align="center">**ClaimedModule**</td>
        </tr>
        <tr>
            <td align="center">**ClaimedModuleProvider**</td>
            <td align="center">Course</td>
            <td align="center">CourseModule</td>
        </tr>
        <tr>
            <td align="center">Criterion</td>
            <td align="center">**Delegate**</td>
            <td align="center">Discipline</td>
        </tr>
        <tr>
            <td align="center">Element</td>
            <td align="center">**Evidence**</td>
            <td align="center">**File**</td>
        </tr>
        <tr>
            <td align="center">Module</td>
            <td align="center">Provider</td>
            <td align="center">Student</td>
        </tr>
        <tr>
            <td align="center">Teacher</td>
            <td align="center">**Update**</td>
            <td align="center">User</td>
        </tr>
    </table>
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer.jspf" %>