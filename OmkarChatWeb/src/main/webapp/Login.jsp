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


	String selectQuery = "SELECT * FROM users where username = ? and password = ?";


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
   	
    pstmt.setString(1,request.getParameter("un"));
    pstmt.setString(2,request.getParameter("pass"));
    
   
    rs = pstmt.executeQuery();
    
    if(rs.next()==false)
    {
    	response.sendRedirect("InvalidCredentials.html");
    }
    else
    {
    	session.setAttribute("username",request.getParameter("un"));
    	RequestDispatcher dispatcher = request.getRequestDispatcher("HomePage.jsp");
    	dispatcher.forward(request, response);
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