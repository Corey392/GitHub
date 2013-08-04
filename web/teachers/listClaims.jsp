<%-- 
    Document   : listClaims 
    Created on : 15/05/2011, 2:53:20 PM
    Author     : David
--%>

<%! RPLPage thisPage = RPLPage.LIST_CLAIMS_TEACHER; %>
<jsp:useBean id="claims" scope="request" class="java.util.ArrayList" />
<jsp:useBean id="selectedField" scope="request" class="java.lang.String" />
<jsp:useBean id="listError" scope="request" class="util.RPLError"/>
<jsp:useBean id="len" scope="request" class="java.lang.String"/>
<% int index = 0; %>
<%@include file="../WEB-INF/jspf/header.jspf" %>

<h1><%=thisPage.title%></h1>
<h5>Claims Relevant to you:</h5>
<c:choose>
    <c:when test="${claims == null && listError != null}"><p>${listError.message}</p></c:when>
    <c:when test="${claims == null && listError == null}">
        <c:redirect url="<%= RPLServlet.ASSESS_CLAIM_RPL_SERVLET.relativeAddress %>" />
    </c:when>
    <c:otherwise>

    <form name="viewClaims" action="<%= RPLServlet.ASSESS_CLAIM_RPL_SERVLET %>" method="post" >
        <div class="tablecontrols">Search By: 
            <select name="searchBy">
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
                    <th>Claim ID</th>
                    <th>Student ID</th>
                    <th>Date Made</th>
                    <th>Date Resolved</th>
                    <th>Status</th>
                    <th>Course ID</th>
                    <th>Discipline ID</th>
                    <th>Campus ID</th>
                    <th>Delegate Approved</th>
                    <th>Assessor Approved</th>
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

        <input type="hidden" name="rpath" value="<%= RPLPage.LIST_CLAIMS_TEACHER.relativeAddress %>"/>

        <b>${listError.message}</b><br/>
        <input type="submit" value="View Claim" name="ccmd" />
        <input type="submit" value="Delete Claim" name="ccmd" />
    </form>

    </c:otherwise>
</c:choose>

<%@include file="../WEB-INF/jspf/footer.jspf" %>
