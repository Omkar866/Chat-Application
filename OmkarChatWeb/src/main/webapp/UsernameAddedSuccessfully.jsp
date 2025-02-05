<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.chatApp.*" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="css/UsernameAddedSuccessfully.css"></link>
</head>
<body>
	<div id="userAdded">
		<h1>User with username <%=request.getParameter("friendName") %> added in your chats !</h1>
		<a href="HomePage.jsp">Back to Chats</a>
		
		<%WebSocketServer.updateDatabase((String)session.getAttribute("username"),request.getParameter("friendName"),"Hi there!"); %>
		<%FriendsMapping.adjList.get((String)session.getAttribute("username")).add(request.getParameter("friendName")); %>
		<%FriendsMapping.adjList.get(request.getParameter("friendName")).add((String)session.getAttribute("username")); %>
	
		
		
	</div>
</body>
</html>