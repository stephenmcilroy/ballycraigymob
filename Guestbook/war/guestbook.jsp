<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>

<html>
  <head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
    <title>Ballycraigy Mob Website</title>
  </head>

  <body>
	<div id="page">
	<div id="page-header">
			<img src="/images/Edel.jpg" width="100" height="100" alt="" class="alignright border" />	
			<p> </p>
			<h1>Ballycraigy Mob</h1>
			<h2>The Mcilroys and friends</h2>
			
	</div>
	<!-- end #header -->
	<div id="page-left">
<%
    String guestbookName = request.getParameter("guestbookName");
    if (guestbookName == null) {
        guestbookName = "default";
    }
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
%>
<p>Hello, <%= user.getNickname() %>! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
    } else {
%>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>
to include your name with greetings you post.</p>
<%
    }
%>

<%
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key guestbookKey = KeyFactory.createKey("Guestbook", guestbookName);
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    Query query = new Query("Greeting", guestbookKey).addSort("date", Query.SortDirection.DESCENDING);
    List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
    if (greetings.isEmpty()) {
        %>
        <p>Guestbook '<%= guestbookName %>' has no messages.</p>
        <%
    } else {
        %>
        <p>Messages in Guestbook '<%= guestbookName %>'.</p>
        <%
        for (Entity greeting : greetings) {
            if (greeting.getProperty("user") == null) {
                %>
                <p>An anonymous person wrote:</p>
                <%
            } else {
                %>
                <p><b><%= ((User) greeting.getProperty("user")).getNickname() %></b> wrote:</p>
                <%
            }
            %>
            <blockquote><%= greeting.getProperty("content") %></blockquote>
            <%
        }
    }
%>

    <form action="/sign" method="post">
      <div><textarea name="content" rows="3" cols="60"></textarea></div>
      <div><input type="submit" value="Post Greeting" /></div>
      <input type="hidden" name="guestbookName" value="<%= guestbookName %>"/>
    </form>
	<!-- end #page -->
	</div>
	<div id="page-right">
	<p></p>
	<p>Our Interests</p>
	<p></p>
	<ul>
		<li>Our School</li>
		<li>Our Friends</li>
		<li><a href="http://www.bt.com">Our Dad's work</a></li>
	</ul>
	<hr>
	<p></p>
	<p>Our Sponsers</p>
	<p></p>
	<a href="http://www.rtu.co.uk">
	<img src="/images/rtu.jpg" height="30" alt="" class="alignleft" />
	</a>
	</div>
	<div id="page-footer">
		<p>Copyright (c) 2012 ballycraigymob.appspot.com. All rights reserved.
		<img class="alignright" src="http://code.google.com/appengine/images/appengine-noborder-120x30.gif" 
alt="Powered by Google App Engine"/></p>
	</div>
	<!-- end #footer -->
	</div>
  </body>
</html>