<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" href="css/InvalidUsernameToAdd.css">
<title>Insert title here</title>
</head>
<body>
	<div id="invalidUsername">
		<h1>User with username <%=request.getParameter("friendName") %> does not exists</h1>
		<a href="HomePage.jsp">Back to Chats</a>
	</div>
</body>
</html>