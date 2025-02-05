package com.chatApp;
import javax.websocket.*;
import java.sql.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.HashMap;

@ServerEndpoint("/websocket")
public class WebSocketServer 
{
	
	static enum code {
        CHAT_MSG(0), ONLINE_STATUS(1),SEEN_STATUS(2);

        private final int value;

        code(int value) {
            this.value = value;
        }

        public int getValue() {
            return this.value;
        }
    }

	static HashMap <String,javax.websocket.Session> hmp = new HashMap<String, javax.websocket.Session>();
    @OnOpen
    public void onOpen(Session session) throws IOException 
    {
        System.out.println("Connection opened: " + session.getId());
        System.out.println(FriendsMapping.adjList);
        
        String username = session.getRequestParameterMap().get("username").get(0);
        System.out.println("hi"+username);
        hmp.put(username, session);
        
        for(String friend:FriendsMapping.adjList.get(username))
        {
        	if(hmp.get(friend)!=null)
        	{
        		hmp.get(friend).getBasicRemote().sendText(code.ONLINE_STATUS.value +" "+ username+ " online");
        		hmp.get(username).getBasicRemote().sendText(code.ONLINE_STATUS.value+" "+friend+" online");
        		System.out.println("Following msg sent to  "+friend+ " "+code.ONLINE_STATUS.value +" "+ username+ " online");
        		System.out.println("Following msg sent to  "+username+ " "+code.ONLINE_STATUS.value +" "+ friend+ " online");
        	}
        }
        
        
        
        
        
    }

    @OnMessage
    public void onMessage(String message, Session session) throws IOException {
        System.out.println("Received: " + message);
        
        String [] l = message.split(" ");
        
        if(l[0].equals(Integer.toString(code.CHAT_MSG.getValue())))        	
        {
	        String msg=l[2];
	        for(int i=3;i<l.length;i++)
	        	msg=msg+" "+l[i];
	        
	        updateDatabase(session.getRequestParameterMap().get("username").get(0),l[1],msg);
	        
	        if(hmp.get(l[1])!=null)
	        {
	        	hmp.get(l[1]).getBasicRemote().sendText(code.CHAT_MSG.value+" "+session.getRequestParameterMap().get("username").get(0)+" "+msg);
	        	System.out.println("following message sent");
	        	System.out.println(code.CHAT_MSG.value+" "+session.getRequestParameterMap().get("username").get(0)+" "+msg);
	        }
        }
        else if(l[0].equals(Integer.toString(code.SEEN_STATUS.getValue())))
        {
        	
        	setSeen(l[1],session.getRequestParameterMap().get("username").get(0));	
        }
    }

    @OnClose
    public void onClose(Session session) throws IOException 
    {
    	String username = session.getRequestParameterMap().get("username").get(0);
        hmp.remove(username);
    	
        System.out.println("Connection closed: " + session.getId());
        
        
        for(String friend:FriendsMapping.adjList.get(username))
        {
        	if(hmp.get(friend)!=null)
        	{
        		hmp.get(friend).getBasicRemote().sendText(code.ONLINE_STATUS.value +" "+ username+ " offline");
        		System.out.println("Following msg sent to  "+friend+ " "+code.ONLINE_STATUS.value +" "+ username+ " offline");
        	}
        }
        
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.out.println("Error: " + throwable.getMessage());
    }
    
    public static void updateDatabase(String sender,String reciever,String msg)
    {
    	String jdbcURL = "jdbc:oracle:thin:@localhost:1521:orcl"; // Replace 'xe' with your SID if different
    	String username = "Chatdb"; // Replace with your Oracle username
    	String password = "Chatdb"; // Replace with your Oracle password


    	String insertQuery = "INSERT INTO chats VALUES (?,?,?,systimestamp,0)";


    	Connection connection = null;
    	PreparedStatement pstmt = null;
   		ResultSet rs = null;

    try {
        // 1. Load Oracle JDBC Driver
        

        Class.forName("oracle.jdbc.driver.OracleDriver");

        // 2. Establish a connection
        connection = DriverManager.getConnection(jdbcURL, username, password);
        
      

        // 3. Insert data into the database
        pstmt = connection.prepareStatement(insertQuery);
       	
        pstmt.setString(1,sender);
        pstmt.setString(2,reciever);
        pstmt.setString(3,msg);
        
       
        rs = pstmt.executeQuery();
        
       
        
      	
      	
      
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
    }
    
    public static void setSeen(String senderName,String recieverName)
    {
    	String jdbcURL = "jdbc:oracle:thin:@localhost:1521:orcl"; // Replace 'xe' with your SID if different
    	String username = "Chatdb"; // Replace with your Oracle username
    	String password = "Chatdb"; // Replace with your Oracle password


    	String insertQuery = "UPDATE CHATS SET SEEN = 1 Where sendername=? And recievername=? and seen=0 ";


    	Connection connection = null;
    	PreparedStatement pstmt = null;
   		ResultSet rs = null;

    try {
        // 1. Load Oracle JDBC Driver
        

        Class.forName("oracle.jdbc.driver.OracleDriver");

        // 2. Establish a connection
        connection = DriverManager.getConnection(jdbcURL, username, password);
        
      

        // 3. Insert data into the database
        pstmt = connection.prepareStatement(insertQuery);
       	
        pstmt.setString(1,senderName);
        pstmt.setString(2,recieverName);
        
       
        int rows=pstmt.executeUpdate();
        
        System.out.println(rows+" rows updated");
        
       
        
      	
      	
      
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
    }
    
    
    
}
