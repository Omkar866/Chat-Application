<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import = "com.chatApp.FriendsMapping" %>
    <%@ page import = "java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="css/RegisterStatus.css"></link>
</head>
<body>
	<main>
	<%
		if(request.getAttribute("ErrorCause")!=null)
		{
	%>
	<div id="fail">
		<h1>Your account could not be created due to the following reason</h1>
		<h2><%= request.getAttribute("ErrorCause") %></h2>
		<a href="Register.html">Register</a>
		<a href="index.html">Login</a>
	</div>	
		<%
		}
		else
		{
		%>
		
		<div id="success">
			<h1>Account created successfully</h1>
			<%FriendsMapping.adjList.put(request.getParameter("un"),new ArrayList <String>());%>
			<a href="index.html">Login</a>
		</div>
		
		
		<%} %>
		
	
	</main>
	
</body>
</html>