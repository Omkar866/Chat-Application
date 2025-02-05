package com.chatApp;
//graph ds
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

public class FriendsMapping 
{
	public static HashMap <String,ArrayList<String>> adjList = new HashMap <String,ArrayList<String>> ();

	static
	{
		String jdbcURL = "jdbc:oracle:thin:@localhost:1521:orcl"; // Replace 'xe' with your SID if different
		String username = "Chatdb"; // Replace with your Oracle username
		String password = "Chatdb"; // Replace with your Oracle password



		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try 
		{
		   
		    Class.forName("oracle.jdbc.driver.OracleDriver");
	
		    connection = DriverManager.getConnection(jdbcURL, username, password);
		    
		    String selectQuery = "SELECT username from users";
		   
		    pstmt = connection.prepareStatement(selectQuery);
		    
		    rs = pstmt.executeQuery();
		    
		    while(rs.next())
		    	adjList.put(rs.getString(1),new ArrayList<String>());
		    	
		    pstmt.close();
		    rs.close();
		    selectQuery ="select username from\r\n"
		    		+ "(\r\n"
		    		+ "(select recievername username \r\n"
		    		+ "from chats where sendername = ?)\r\n"
		    		+ "union\r\n"
		    		+ "(\r\n"
		    		+ "select sendername username\r\n"
		    		+ "from chats where recievername=?\r\n"
		    		+ ")\r\n"
		    		+ ")";

		    
		    pstmt=connection.prepareStatement(selectQuery);
		    
		    for(String user:adjList.keySet())
		    {
		    	pstmt.setString(1, user);
		    	pstmt.setString(2, user);
		    	
		    	rs=pstmt.executeQuery();
		    	
		    	while(rs.next())
		    	{
		    		adjList.get(user).add(rs.getString(1));
		    		
		    	}
		    }
		    
		    System.out.println(adjList);
		  
		}
		catch (Exception e) 
		{
		    e.printStackTrace();
		} finally 
		{
		    // 5. Close all resources
		    try 
		    {
		        if (rs != null) rs.close();
		        if (pstmt != null) pstmt.close();
		        if (connection != null) connection.close();
		    } 
		    catch (Exception e) 
		    {
		        e.printStackTrace();
		    }
	
		}
	}
	
	

}
