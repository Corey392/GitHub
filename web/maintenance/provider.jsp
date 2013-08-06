<%-- 
    Document:	provider.jsp
    Created on:	07/05/2013, 6:29:37 PM
    Modified:	07/05/2013
    Authors:	Bryce Carr
    Version:	1.000
    Changelog:	07/05/2013: Created JSP and removed non-rename code pending team discussion.
--%>
<%! RPLPage thisPage = RPLPage.CLERICAL_PROVIDER;%>
<%@include file="../WEB-INF/jspf/header_1.jspf" %>


<jsp:useBean id="providers" scope="request" class="java.util.ArrayList"/>
<jsp:useBean id="invalidNameError" scope="request" class="util.RPLError"/>
<jsp:useBean id="providerUpdatedMessage" scope ="request" class="java.lang.String"/>

<div class="body">

    <h2>Manage Providers</h2>

    <b>${invalidNameError}${providerUpdatedMessage}</b>
    <form method="post" action="<%= RPLServlet.MAINTAIN_PROVIDER_SERVLET.absoluteAddress%>">
	<table class="inputtable">
	    <thead>
		<tr>
		    <th>Name</th>
		</tr>
	    </thead>
	    <tbody>
		<c:forEach var="provider" items="${providers}">
		    <tr>
			<td>
			    <input type="hidden" name="providerID[]" value="${provider.providerID}" />
			    <input required type="text" name="providerName[]" style="width:400px" value="${provider.name}" />
			</td>
		    </tr>
		</c:forEach>
		<tr class="last_row">
		    <td></td>
		</tr>
	    </tbody>
	</table>
	<input type="submit" name="saveProviders" value="Save Providers" />
    </form>
</div>

<%@include file="../WEB-INF/jspf/footer_1.jspf" %>

