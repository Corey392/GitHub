<%-- 
    Author     : Vince Lombardo
    Document   : manageUsers
    Purpose    : allows delegate users to set which user
    Created on : 02/08/2013, 8:27:03 PM
--%>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>

<%! RPLPage thisPage = RPLPage.ADMIN_MANAGE_USERS; %>

<%@page import="web.FormAdminManageUsers"%>

<jsp:useBean id="claim" class="domain.Claim" scope="request"/>
<jsp:useBean id="listError" scope="request" class="util.RPLError"/>
<% int index = 0; %>
        <script>
            $(document).ready(function() {                        
    //                $('#submit').click(function(event) {  
    //                    var username=$('#user').val();
    //                 $.get('ActionServlet',{user:username},function(responseText) { 
    //                        $('#welcometext').text(responseText);         
    //                    });
    //                });

                $('#searchBy').change(function() {
                    var username=$('#searchBy').val();
                    alert(username);
                });
            });
        </script>
    <%-- See more at: http://www.programming-free.com/2012/08/ajax-with-jsp-and-servlet-using-jquery.html#.Uf8-XZLI3jI--%>
    
    <body>
        
        <div class="title">
            <h1>Manage Users Form</h1>
            <p>Welcome ${user.firstName} ${user.lastName}</p>
            <h3>Instructions:</h3>
        </div>
            
        <form name="<%= FormAdminManageUsers.NAME %>" action="<%= FormAdminManageUsers.ACTION %>" method="post">
            <div class="userinput">
                <input style="text-align:right; width:75px" required maxlength="3" type="text" value="${campus.campusID}" name="campusID[]" />
            </div>
            <div class="tablecontrols">Search By: 
                <select name="searchBy" id="searchBy">
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
        </form>
    </body>
    
<%@include file="../WEB-INF/jspf/footer_1.jspf" %>
