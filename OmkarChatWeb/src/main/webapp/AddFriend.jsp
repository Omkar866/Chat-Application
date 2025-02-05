<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	
	<%
	
	String jdbcURL = "jdbc:oracle:thin:@localhost:1521:orcl"; // Replace 'xe' with your SID if different
	String username = "Chatdb"; // Replace with your Oracle username
	String password = "Chatdb"; // Replace with your Oracle password


	


		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

try {
    // 1. Load Oracle JDBC Driver
    

    Class.forName("oracle.jdbc.driver.OracleDriver");

    // 2. Establish a connection
    connection = DriverManager.getConnection(jdbcURL, username, password);
    
    
    String selectQuery = "select username from users where username = ?";
  

  
    pstmt = connection.prepareStatement(selectQuery);
   	
    pstmt.setString(1,request.getParameter("friendName"));
    
   
    rs = pstmt.executeQuery();
    
    if(rs.next()==false || rs.getString(1).equals((String)session.getAttribute("username")))
    {
    	response.sendRedirect("InvalidUsernameToAdd.jsp?friendName="+request.getParameter("friendName"));
    }
    else
    {
    	selectQuery = "select * from (select * from chats where sendername=? and recievername=? union select * from chats where sendername=? and recievername=?)";
    	pstmt.close();
    	pstmt=connection.prepareStatement(selectQuery);
    	
    	pstmt.setString(1,(String)session.getAttribute("username"));
    	pstmt.setString(4,(String)session.getAttribute("username"));
    	pstmt.setString(2,request.getParameter("friendName"));
    	pstmt.setString(3,request.getParameter("friendName"));
    	
    	
    	rs.close();
    	rs = pstmt.executeQuery();
    	
    	if(rs.next()==false)
    	{	
    		response.sendRedirect("UsernameAddedSuccessfully.jsp?friendName="+request.getParameter("friendName"));
    	}
    	else
    	{
    		response.sendRedirect("UsernameAlreadyAdded.jsp?friendName="+request.getParameter("friendName"));
    	}	
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
	
	
</body>
</html>