<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.sql.*" %>
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


    String selectQuery = "SELECT * FROM users where username = ?";

    // JDBC resources
    Connection connection = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
    	RequestDispatcher dispatcher = request.getRequestDispatcher("RegisterStatus.jsp");
        // 1. Load Oracle JDBC Driver
        

        Class.forName("oracle.jdbc.driver.OracleDriver");

        // 2. Establish a connection
        connection = DriverManager.getConnection(jdbcURL, username, password);
        
      

        // 3. Insert data into the database
        pstmt = connection.prepareStatement(selectQuery);
       	
        pstmt.setString(1,request.getParameter("un"));
      
        rs=pstmt.executeQuery();
        
        
      	if(rs.next()==true)
      	{
      		request.setAttribute("ErrorCause","Username already exists");
      		dispatcher.forward(request,response);
      		return;
      	}
      	
      	pstmt.close();
      	rs.close();
      	pstmt = connection.prepareStatement("select * from users where Mobile = ?");
      	pstmt.setString(1, request.getParameter("mob"));
      	
      	rs = pstmt.executeQuery();
      	
      	if(rs.next()==true)
      	{
      		request.setAttribute("ErrorCause","Mobile No already exists");
      		dispatcher.forward(request,response);
      		return;
      	}
      	
      	pstmt.close();
      	pstmt=connection.prepareStatement("insert into users values (?,?,?,?,?)");
      	pstmt.setString(1,request.getParameter("un"));
      	pstmt.setString(2,request.getParameter("pwd"));
      	pstmt.setString(3,request.getParameter("mob"));
      	pstmt.setString(4,request.getParameter("fn"));
      	pstmt.setString(5,request.getParameter("ln"));
      	
      	pstmt.executeUpdate();
      	
      	dispatcher.forward(request,response);
      	
      	return;
      	
      	
      	
      
      
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