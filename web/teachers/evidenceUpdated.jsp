<%--
    Document   : viewEvidence
    Created on : 11/06/2011, 6:56:16 PM
    Author     : David
--%>

<%@page import="java.util.*" %>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>
<%! RPLPage thisPage = RPLPage.VIEW_EVIDENCE_PAGE; %>
<jsp:useBean id="user" scope="session" class="domain.User" />
<jsp:useBean id="claimedModule" scope="request" class="domain.ClaimedModule"/>
<jsp:useBean id="message" class="java.lang.String"/>

<% boolean approved; %>
<c:if test="${claimedModule == null}">
    <c:redirect url="<%= RPLServlet.VIEW_TEACHER_CLAIM_SERVLET.relativeAddress %>" />
</c:if>
<script type="text/javascript" src="<%= RPLPage.ROOT %>/scripts/selectAll.js"></script>
<h1><%=thisPage.title%></h1>
<div class="body">
    <form action="<%= RPLServlet.ASSESS_CLAIM_RPL_SERVLET.relativeAddress %>" method="post">
        <div style="text-align:center">
            ${message}<br/><br/>
            <input type="submit" value="OK" name="ok" />
            <input type="hidden" name="rpath" value="<%= RPLPage.VIEW_EVIDENCE_PAGE.relativeAddress %>"/>
            <input type="hidden" name="rpath" value=""/>
        </div>
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer.jspf" %>