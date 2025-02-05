<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="css/UsernameAlreadyAdded.css"></link>
</head>
<body>
	<div id="AlreadyAdded">
		<h1>User with username <%=request.getParameter("friendName") %> is already added in your chats</h1>
		<a href="HomePage.jsp">Back to Chats</a>
	</div>
</body>
</html>