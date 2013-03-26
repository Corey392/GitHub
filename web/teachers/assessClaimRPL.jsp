<%-- 
    Document   : assessClaim - This page is for the assessment of a Claim for RPL
    Created on : 20/05/2011, 6:11:47 PM
    Author     : David
--%>

<%! RPLPage thisPage = RPLPage.ASSESS_CLAIM_RPL; %>
<%@page import="java.util.ArrayList" %>
<%@include file="../WEB-INF/jspf/header.jspf" %>
<jsp:useBean id="claim" scope="request" class="domain.Claim"/>
<% int index = 0; %>
<c:if test="${claim == null || claim.claimedModules == null}">
    <c:redirect url="<%= RPLServlet.ASSESS_CLAIM_RPL_SERVLET.relativeAddress %>" />
</c:if>
<h1><%=thisPage.title%></h1>
<div class="body">
<form name="assessClaim" action="<%= RPLServlet.ASSESS_CLAIM_RPL_SERVLET %>" method="post">
    <table cellpadding="6">
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
        <table border="1" cellpadding="6">
            <thead>
                <tr>
                    <th>Module ID</th>
                    <th>Functional Unit Code</th>
                    <th>Evidence</th>
                    <th>Arrangement Number</th>
                    <th>Recognition</th>
                    <th>Previous Provider Code</th>
                    <th>Approval</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${claim.claimedModules == null}"><tr><td>No Claimed Modules!</td></tr></c:if>
            <% index = 0; %>
                <c:forEach var="module" items="${claim.claimedModules}">
                    <tr>
                        <td>${module.moduleID}</td>
                        <td>${module.functionalCode}</td>
                        <td><input type="submit"  name="evid:${module.moduleID}" value="View Evidence" /></td>
                        <td>${module.arrangementNo}</td>
                        <td align="center">${module.recognition}</td>
                        <td>
                            <c:forEach var="provider" items="${module.providers}">
                                ${provider.name}<br />
                            </c:forEach>
                        </td>
                        <td align="center">
                            <input type="checkbox" name="approved<%//=index%>" value="${module.moduleID}"></input>
                        </td>
                    </tr>
                    <% index++; %>
                </c:forEach>
            </tbody>
        </table>
        <input type="hidden" name="claimID" value="${claim.claimID}"/> <%-- Values should be encrypted --%>
        <input type="hidden" name="studentID" value="${claim.studentID}"/>
        <input type="hidden" name="rpath" value="<%= RPLPage.ASSESS_CLAIM_RPL.relativeAddress %>"/>
        <table>
            <tr>
                <td>
                    <input type="submit" name="cmd" value="Approve Claim" />
                    <input type="submit" name="cmd" value="Approve Selected" />
                    <input type="submit" name="cmd" value="Print Claim" />
                    <input type="submit" name="cmd" value="Back" />
                </td>
            </tr>
        </table>
    </form>
</div>
<%@include file="../WEB-INF/jspf/footer.jspf" %>