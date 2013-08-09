<%-- 
    Author     : Vince Lombardo
    Document   : manageTeachers
    Purpose    : allows delegate users to set which assessors can assess specific displine
    Created on : 02/08/2013, 8:27:03 PM
--%>

<%@page import="web.FormManageTeachers"%>

<meta http-equiv="refresh" content="10" >
<%! RPLPage thisPage = RPLPage.ADMIN_MANAGE_TEACHERS;%>
<jsp:useBean id="claim" class="domain.Claim" scope="request"/>
<jsp:useBean id="listError" scope="request" class="util.RPLError"/>

<% int index = 0;%>

<script type="text/javascript">
    $(document).ready(function() {
        $('[data-slidepanel]').slidepanel({
                  orientation: 'top',
                  mode: 'push'
        });
//                $('#submit').click(function(event) {  
//                    var username=$('#user').val();
//                 $.get('ActionServlet',{user:username},function(responseText) { 
//                        $('#welcometext').text(responseText);         
//                    });
//                });
    
//        $('#searchBy').change(function() {
//            var username = $('#searchBy').val();
//            alert(username);
//        });
    });
</script>
<%-- See more at: http://www.programming-free.com/2012/08/ajax-with-jsp-and-servlet-using-jquery.html#.Uf8-XZLI3jI--%>

<!-- right help panel  
    <div data-role="panel" id="rightHelpPanel" data-position="right" data-display="overlay" data-dismissible="true" data-theme="b">
        <h3>Right Panel: Overlay</h3>
        <p>This panel is positioned on the right with the overlay display mode. The panel markup is <em>after</em> the header, content and footer in the source order.</p>
        <p>To close, click off the panel, swipe left or right, hit the Esc key, or use the button below:</p>
        <a href="#" data-rel="close" data-role="button" data-theme="c" data-icon="delete" data-inline="true">Close panel</a>
    </div> /rightpanel3 -->
<!--    <div data-role="page" class="ui-responsive-panel">-->
<!--<div data-role="page" class="ui-responsive-panel">-->
    <%@include file="../WEB-INF/jspf/header_1.jspf" %>
<!--</div>-->
        <div data-role="content">
<!--            <div class="">
                <h1>Manage Teachers Form</h1>
                <p>Welcome ${user.firstName} ${user.lastName}</p>
                <h3>Instructions:</h3>
            </div>-->
            <h2>Panel</h2>
            <!--<a href="#rightHelpPanel" data-role="button" data-inline="true" data-mini="true">Overlay</a>-->
            <a href="<%= RPLPage.ROOT%>/maintenance/test.html" data-slidepanel="panel" id="showpanel">Show Panel</a>
            
            
        <!--<form name="<%= FormManageTeachers.NAME%>" action="<%= FormManageTeachers.ACTION%>" method="post">-->
<!--            <fieldset>
                <legend>Personal information:</legend>
                Name: <input type="text" size="30"><br>
                E-mail: <input type="text" size="30"><br>
                Date of birth: <input type="text" size="10">
            </fieldset>-->              
        
        
        <!--</form>-->
<!--        <p>To make the page work alongside the open panel, it needs to re-flow to a narrower width so it will fit next to the panel. This can be done purely with CSS by adding a left or right margin equal to the panel width (17em) to the page contents to force a re-flow. Second, the invisible layer placed over the page for the click out to dismiss behavior is hidden with CSS so you can click on the page and not close the menu. </p>
			<p>Here is an example of these rules wrapped in a media query to only apply this behavior above 35em (560px):</p>
			
			<pre><code>-->

        </div>
<!--<div data-role="footer" id="footer" class="footer" data-theme="c">-->
    <%@include file="../WEB-INF/jspf/footer_1.jspf" %>    
<!--</div>-->
<!--</div>-->