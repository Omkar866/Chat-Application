<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="css/SideBar.css"></link>
</head>
<body id="sideBarBody">
	<header id="sideHead">
		<button id="AddFriend" onclick="addF()">Add Friend</button>
		<h1 id="senderName"><%=(String)session.getAttribute("username")%></h1>
	</header>
	<main id="userList">
	<%
	String jdbcURL = "jdbc:oracle:thin:@localhost:1521:orcl"; // Replace 'xe' with your SID if different
	String username = "Chatdb"; // Replace with your Oracle username
	String password = "Chatdb"; // Replace with your Oracle password


	String selectQuery = "SELECT COUNT(*) FROM chats where sendername = ? or recievername = ?";


	Connection connection = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

try {
    // 1. Load Oracle JDBC Driver
    

    Class.forName("oracle.jdbc.driver.OracleDriver");

    // 2. Establish a connection
    connection = DriverManager.getConnection(jdbcURL, username, password);
    
  

    // 3. Insert data into the database
    pstmt = connection.prepareStatement(selectQuery);
   	
    pstmt.setString(1,(String)session.getAttribute("username"));
    pstmt.setString(2,(String)session.getAttribute("username")); 
   
    rs = pstmt.executeQuery();
    rs.next();
    
    if(rs.getInt(1)==0)
    {
    
    %>
    <h1 id="NoChats">No chats uptill now</h1>
    <%
    	
    }
    else
    {
    	%>
    <jsp:include page = "Chats.jsp"/>
    	<%
    }
    
  
} catch (Exception e) {
    e.printStackTrace();
} finally {
    // 5. Close all resources
    try {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (connection != null) connection.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

}
	
	
	
	%>
	</main>
	<script>
		function addF()
		{
			uname=prompt("Enter username to be added")
			if(uname!=null)
			{
				window.location.href="AddFriend.jsp?friendName="+uname;
			}
		}
	</script>

</body>
</html>