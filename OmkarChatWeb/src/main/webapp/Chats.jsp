<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import="java.sql.*" %>
    <%@ page import="java.util.ArrayList,java.util.HashMap" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<main id="chats" >


<%
	String jdbcURL = "jdbc:oracle:thin:@localhost:1521:orcl"; // Replace 'xe' with your SID if different
	String username = "Chatdb"; // Replace with your Oracle username
	String password = "Chatdb"; // Replace with your Oracle password


	String selectQuery = "SELECT distinct sendername FROM chats where recievername = ? union select distinct recievername from chats where sendername = ?";


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
    
    ArrayList<String> ids= new ArrayList<String>();
    
    while(rs.next())
    {
    	ids.add(rs.getString(1)); 
    }
    pstmt.close();
    pstmt=connection.prepareStatement("select SENDERNAME,RECIEVERNAME,MSG,SEEN, to_char(time,'DD Month YYYY') \"DATE\",TO_CHAR(time, 'HH24:MI') \"TIMESENT\" from (select * from chats where sendername = ? and recievername = ? union select * from chats where sendername = ? and recievername = ? ) order by time");
    
    pstmt.setString(1,(String)session.getAttribute("username"));
    pstmt.setString(4,(String)session.getAttribute("username"));
    
    
    
    for(String i:ids)
    {
    	  
    		
    	
    	%>
    	
    	<script>
    		console.log("<%=i%>")
    		temp=document.createElement("div");
    		temp.setAttribute("id","parent<%=i%>");
    		temp.setAttribute("class","userItem")
    		temp.innerHTML="<%=i%>"
    		
    		
    		if (!document.getElementById("parent<%=i%>")) 
    		{
    		      document.getElementById("chats").appendChild(temp);
    		}
    		
    		
    		temp=document.createElement("div");
    		temp.setAttribute("id","<%=i%>");
    		temp.style.display="none"
    		if (!document.getElementById("<%=i%>"))
    		{
    			document.getElementsByTagName("body")[0].append(temp);			
    		}
    		
    		
    		
    	</script>
    	<%
    	
    	
    	pstmt.setString(2,i);
    	pstmt.setString(3,i);
    	
    	rs=pstmt.executeQuery();
    	
    	
    	
    	
    	while(rs.next())
    	{
    		if(rs.getString(1).equals((String)session.getAttribute("username")) )
    		{
    			
    			%>
    			<script>
    			if(!window.flag)
    			{
    				temp=document.createElement("div")
    				temp.setAttribute("class","sender")
    				temp.innerHTML="<%=rs.getString(3)%>" //MESSAGE
    				
   					if(document.getElementById("<%=rs.getString(2)%>").getAttribute("lastDay")!="<%=rs.getString("DATE")%>")
       				{
       					tempDateDiv=document.createElement("div")
       					tempDateDiv.setAttribute("class","lastDay")
       					tempDateDiv.innerText="<%=rs.getString("DATE")%>";
       					document.getElementById("<%=rs.getString(2)%>").appendChild(tempDateDiv)	
       					document.getElementById("<%=rs.getString(2)%>").setAttribute("lastDay","<%=rs.getString("DATE")%>");
       				}
    				
    				
    				document.getElementById("<%=rs.getString(2)%>").appendChild(temp)
    				tempTimeDiv= document.createElement("div")
    				tempTimeDiv.innerText="<%=rs.getString("TIMESENT")%>";
    				tempTimeDiv.setAttribute("class","senderTime")
    				document.getElementById("<%=rs.getString(2)%>").appendChild(tempTimeDiv)
    					
    			}
    			</script>
    			<%
    		}
    		else
    		{
    			%>
    			<script>
    			if(!window.flag)
    			{
				temp=document.createElement("div")
				temp.setAttribute("class","reciever")
				temp.innerHTML="<%=rs.getString(3)%>"
				
				if(document.getElementById("<%=rs.getString(1)%>").getAttribute("lastDay")!="<%=rs.getString("DATE")%>")
   				{
   					tempDateDiv=document.createElement("div")
   					tempDateDiv.setAttribute("class","lastDay")
   					tempDateDiv.innerText="<%=rs.getString("DATE")%>";
   					document.getElementById("<%=rs.getString(1)%>").appendChild(tempDateDiv)	
   					document.getElementById("<%=rs.getString(1)%>").setAttribute("lastDay","<%=rs.getString("DATE")%>");
   				}
				
				
				
				document.getElementById("<%=rs.getString(1)%>").appendChild(temp)
				
				tempTimeDiv= document.createElement("div")
    			tempTimeDiv.innerText="<%=rs.getString("TIMESENT")%>";
    			tempTimeDiv.setAttribute("class","receiverTime")
    			document.getElementById("<%=rs.getString(1)%>").appendChild(tempTimeDiv)
				
				
				
				
				if(<%=rs.getInt("SEEN")%>==0)
   				{
   					document.getElementById("parent<%=rs.getString(1)%>").setAttribute("status","unread");
   				}
    			}
				</script>
				<%
    		}
    		
    	
    	
    	}
    	
    	
    }
    
    
    
    String ordQuery = "SELECT \"user\", MAX(latest_message_time) AS time1 " +
            "FROM ( " +
            "    SELECT sendername AS \"user\", MAX(time) AS latest_message_time " +
            "    FROM chats " +
            "    WHERE recievername = ? " +
            "    GROUP BY sendername " +
            "    UNION " +
            "    SELECT recievername AS \"user\", MAX(time) AS latest_message_time " +
            "    FROM chats " +
            "    WHERE sendername = ? " +
            "    GROUP BY recievername " +
            ") " +
            "GROUP BY \"user\" " +
            "ORDER BY MAX(latest_message_time)";




    
    pstmt=connection.prepareStatement(ordQuery);
    pstmt.setString(1,(String)session.getAttribute("username"));
    pstmt.setString(2,(String)session.getAttribute("username"));
    
    rs.close();
    rs=pstmt.executeQuery();
    
    while(rs.next())
    {
    %>
    	<script>
    	
    		temp=document.getElementById("parent"+"<%=rs.getString(1)%>")
    		document.getElementById("parent"+"<%=rs.getString(1)%>").addEventListener("click",(e)=>
    		{
    			document.getElementById("ChattingSection").innerHTML="";
    			document.getElementById("userHeader").innerHTML=event.target.id.substring(6);
    			document.getElementById("ChattingSection").innerHTML=document.getElementById(event.target.id.substring(6)).innerHTML;    	
    			let chattingSection = document.getElementById('ChattingSection');
    		    chattingSection.scrollTop = chattingSection.scrollHeight;
    		    
    		    if(document.getElementById("parent"+"<%=rs.getString(1)%>").getAttribute("status")=="unread")
    			{
    				sendSeenStatus(event.target.id.substring(6))
    			}
    		    
    		    
    		    document.getElementById("parent"+"<%=rs.getString(1)%>").setAttribute("status","read");
    		    
    		})
    	
    		
    		
    		if(!(document.getElementById("chats").querySelector("div")==temp))
			{
				document.getElementById("chats").removeChild(temp)
				document.getElementById("chats").insertBefore(temp,document.getElementById("chats").querySelector("div"))
			}
    	</script>
    	
    	
    	
    	
    <%	
    }
    rs.close();
    %>
    <script>
    	window.flag=true;
    	
		
    </script>
    <% 
    
    

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

</body>
</html>