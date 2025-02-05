<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="css/HomePage.css">
</head>
<body>
	<main>
	<script>
	localStorage.setItem("username","<%=(String)session.getAttribute("username")%>");
	</script>
		<header id="homePageHeading">Omkar's Chat website</header>
		<section id="homePageContent">
			<aside>
				<jsp:include page="SideBar.jsp"></jsp:include>
			</aside>
			<div>
			<header id="userHeader"></header>
				
			<section id="ChattingSection" >
				<jsp:include page="Chats.jsp" ></jsp:include>
			</section>
			<section id="comm" >
				<jsp:include page="Communicate.jsp" ></jsp:include>
			</section>
			</div>
		</section>
	</main>
	
	

	
</body>
</html>