<%-- 
    Document   : listClaimRecords for a Student
    Created on : 09/05/2012, 3:53:01 PM
    Author     : Kyoungho Lee
--%>

<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<%! RPLPage thisPage = RPLPage.TEACHER_LIST_CLAIM_RECORDS; %>
<jsp:useBean id="claimRecordParam" scope="request" class="domain.ClaimRecord" />
<jsp:useBean id="claimRecords" scope="request" class="java.util.ArrayList" />
<jsp:useBean id="claimRecordsCount" scope="request" class="java.lang.String" />
<jsp:useBean id="error" scope="request" class="util.RPLError"/>

    <c:if test="${user.role == 'STUDENT'}">
        <c:set var="title" scope="page">
            Claim
        </c:set>
    </c:if>
    <c:if test="${user.role == 'TEACHER'}">
        <c:set var="title" scope="page">
            Claim
        </c:set>
    </c:if>        
    <center><h2> ${title} History for ${user.firstName} ${user.lastName}</h2>

      <c:if test="${error.message.length() > 0}">
           <b>${error.message}</b>
      </c:if>
    </center>
    <form name="listClaimRecords" action="<%= RPLServlet.TEACHER_LIST_CLAIM_RECORDS.absoluteAddress %>?view=View Records" method="post" >
        <div class="tablecontrols">
           Claim Type:&nbsp;
           <select name="claimType" id="cmbClaimType">
                <option value="" >All</option>
                <option value="0" >RPL</option>
                <option value="1" >Previous Studies</option>  
            </select>
            Status:&nbsp;
            <select name="workResult" id="cmbWorkResult">
                <option value="" >All</option>
                <option value="1" >Approved</option>
                <option value="0" >Disapproved</option>
            </select>
            # of Pages
            <select name="pageNo" id="pageNo">
                <c:forEach var="x" begin="1" end="${claimRecordsCount}" step="1">
                    <option value="${x}">${x}</option>
                </c:forEach>
            </select>
            &nbsp;<a class="button" href="#" onclick="listClaimRecords.submit()">Search</a>
        </div>

        <table border="0" class="datatable">
            <tr>
                <th>Claim<br/>Type</th>
                <th>Student ID<br/>/Name</th>
                <th>Course Name</th>
                <th>Campus</th>
                <th>Time</th>
                <th>Assessor</th>
                <th>Status</th>
            </tr>
            <c:choose>
                <c:when test="${claimRecords != null && claimRecords.size() != 0}">
                    <c:forEach var="cr" items="${claimRecords}">
                        <c:set var="result" scope="page" >
                            <c:if test="${cr.workResult == 0}">red</c:if>
                            <c:if test="${cr.workResult == 1}">green</c:if>
                        </c:set>    
                    <tr>
                        <td>
                            <c:if test="${cr.claimType == 0}">
                                RPL
                            </c:if>
                            <c:if test="${cr.claimType == 1}">
                                Previous <br/>Studies
                            </c:if>
                        </td>
                        <td>${cr.studentID}<br/>(${cr.studentName})</td>
                        <td>${cr.courseName}&nbsp;</td>
                        <td>${cr.campusName}</td>
                        <td>${cr.workTime.replace(" ", "&nbsp;")}</td>
                        <td>${cr.workerID}<br />(${cr.workerName})</td>
                        <td style="font-weight: bold;color: ${result}">${cr.workResultName}</td>
                    </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="8">You have no claim records.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </table>
        
        <%// out.print(RPLPaging.printPageNumber("claimRecordsCount", "listClaimRecords", request));%>
    </form>
        <script>
                var claimType = ${claimRecordParam.claimType};
                if(claimType == -1)
                document.listClaimRecords.claimType.value = "";
                else
                document.listClaimRecords.claimType.value = claimType;
            
            /*    var workType = ${claimRecordParam.workType};
                if(workType == -1)
                document.listClaimRecords.workType.value = "";
                else
                document.listClaimRecords.workType.value = workType; */
            
                var workResult = ${claimRecordParam.workResult};
                if(workResult == -1)
                document.listClaimRecords.workResult.value = "";
                else
                document.listClaimRecords.workResult.value = workResult; 
    
                var pageNo = ${claimRecordParam.pageNo};
                document.listClaimRecords.pageNo.value = pageNo; 
        </script>
<%@include file="../WEB-INF/jspf/footer_1.jspf" %>
