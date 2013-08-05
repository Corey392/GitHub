<%--
    Document   : assessClaim - This page is for the assessment of a Claim for RPL
    Created on : 20/05/2011, 6:11:47 PM
    Author     : David
--%>

<%! RPLPage thisPage = RPLPage.ASSESS_CLAIM_PREV; %>
<%@page import="java.util.ArrayList" %>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<jsp:useBean id="claim" scope="request" class="domain.Claim"/>
<c:if test="${claim.claimedModules == null || claim == null}">
    <c:redirect url="<%= RPLServlet.ASSESS_CLAIM_RPL_SERVLET.relativeAddress %>" />
</c:if> 
<script type="text/javascript" src="<%= RPLPage.ROOT %>/scripts/selectAll.js"></script>
<h1><%=thisPage.title%></h1>
<div class="body">
    <table>
        <tr>
            <td align="center" colspan="4"><b>CLAIM DETAILS</b></td>
        </tr>
        <tr>
            <td>Student:</td>
            <td><b>${claim.studentID}</b></td>
            <td>Campus:</td>
            <td><b>${claim.campus.campusID}</b></td>
        </tr>
        <tr>
            <td>Discipline:</td>
            <td><b>${claim.discipline.disciplineID}</b></td>
            <td>Course:</td>
            <td><b>${claim.course.courseID}</b></td>
        </tr>
    </table>
        <form name="assessClaim" action="<%= RPLServlet.ASSESS_CLAIM_RPL_SERVLET %>" method="post">
            <table border="1">
                <thead>
                    <tr>
                        <th>Module ID</th>
                        <th>Modules</th>
                        <th>Evidence</th>
                        <th>Arrangement Number</th>
                        <th>Recognition Type</th>
                        <th>Previous Provider Code</th>
                        <th>
                            Approve All<br />
                            <input type="checkbox" value="on" name="allbox" onclick="checkAll();"/>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="module" items="${claim.claimedModules}">
                        <tr>
                            <td>${module.moduleID}</td>
                            <td>${module.functionalUnitCode}</td>
                            <td><c:forEach var="ev" items="${module.evidence}">
                                    ${ev.description}
                                </c:forEach>
                            </td>
                            <td>${module.arrangementNumber}</td>
                            <td>${module.recognitionType}</td>
                            <td>
                                <c:forEach var="provider" items="${module.providers}">
                                    ${provider.name}<br />
                                </c:forEach>
                            </td>
                            <td><input type="checkbox" id="approved" name="approved" value="${module.moduleID}"></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <input type="hidden" name="claimID" value="${claim.claimID}"/> <%-- Values should be encrypted --%>
            <input type="hidden" name="studentID" value="${claim.studentID}"/>
            <input type="hidden" name="rpath" value="<%= RPLPage.ASSESS_CLAIM_PREV.relativeAddress %>"/>
            <input type="submit" name="cmd" value="Approve Claim" />
            <input type="submit" name="cmd" value="Approve Selected" />
            <input type="submit" name="cmd" value="Print Claim" />
            <input type="submit" name="cmd" value="Back" />
        </form>
</div>
<%@include file="../WEB-INF/jspf/footer.jspf" %>