<%-- 
    Document   : listErrorss for a Student
    Created on : 09/05/2012, 3:53:01 PM
    Author     : Kyoungho Lee
--%>

<%@include file="../WEB-INF/jspf/header.jspf" %>
<%! RPLPage thisPage = RPLPage.LIST_ERRORS; %>
<%--<jsp:useBean id="user" scope="session" class="domain.User" />--%>
<jsp:useBean id="errors" scope="request" class="java.util.ArrayList" />
<jsp:useBean id="errorsCount" scope="request" class="java.lang.String" />
<jsp:useBean id="error" scope="request" class="util.RPLError"/>
<div class="body">
     
    <table>
        <tr>
            <td><h2> Error List</h2></td>
        </tr>
        <tr>
            <c:if test="${error.message.length() > 0}">
                <td><b>${error.message}</b></td>
            </c:if>
        </tr>
    </table>
    <form name="listErrorss" action="<%= RPLServlet.LIST_ERRORS.absoluteAddress %>" method="post" >
        
        
        <table border="1" cellpadding="3px">
            <tr>
                <td style="text-align:left" colspan="3">
                   # of Pages
                   
                   <select name="pageNo" id="pageNo">
                       <c:forEach var="x" begin="1" end="${errorsCount}" step="1">
                           <option value="${x}">${x}</option>
                       </c:forEach>
                   </select>
                   &nbsp;<input type="submit" value="View Records" name="view" />
                   &nbsp;<input type="submit" value="Back" name="back" />
                   code : <input type="text" name="errorID" id="errorID" value="" />
                   message : <input type="text" name="errorMessage" id="errorMessage" value="" />
                   <input type="submit" value="Insert" name="insert" />
                </td>
            </tr>
            <tr>
                <td width="20%">Error Codes</td>
                <td>Error Messages</td>
                <td width="10%">&nbsp;</td>
            </tr>
            <c:set var="i" scope="page" >0</c:set>
            <c:choose>
                <c:when test="${errors != null && errors.size() != 0}">
                    <c:forEach var="er" items="${errors}">
                    <tr>
                        <td><input type="text" id="errorID${i}" name="errorID${i}" value="${er.errorID}"/></td>
                        <td><input style="width:100%" type="text" id="errorMessage${i}" name="errorMessage${i}" value="${er.errorMessage}" /></td>
                        <td><input style="width:100%" type="button" name="btnUpdate" value="Update" onclick="js_Update('${i}')"/></td>
                    </tr>
                    
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="3">You have no error records.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </table>
        
        <div class="bottomButton">
            <table>
                <tr>
                    <td>
                        
                        
                    </td>
                </tr>
            </table>
        </div>
        
        
    </form>
</div>
        
<%@include file="../WEB-INF/jspf/footer.jspf" %>
