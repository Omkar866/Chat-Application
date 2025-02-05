/**
 * 
 */
 
 let WebSocketUrl="ws://192.168.0.102:8081/OmkarChatWeb/websocket?username="+localStorage.getItem("username");
 const socket = new WebSocket(WebSocketUrl);
 
const Code = Object.freeze({
    CHAT_MSG: 0,
    ONLINE_STAT: 1,
    SEEN_STAT:2
});


function getCurrDate() {
    const currentDate = new Date();
    const day = currentDate.getDate().toString().padStart(2, '0'); // Pads the day with leading zero if needed
    const month = currentDate.toLocaleString('default', { month: 'long' });
    const year = currentDate.getFullYear();

    // Pads the month name to ensure it doesn't have extra spaces
    return `${day} ${month.padEnd(9)} ${year}`;
}


function getCurrentTime() {
    const currentDate = new Date();
    const hours = currentDate.getHours().toString().padStart(2, '0'); // Get hours and pad if needed
    const minutes = currentDate.getMinutes().toString().padStart(2, '0'); // Get minutes and pad if needed
    return `${hours}:${minutes}`;
}

// Event: Connection opened
socket.onopen = () => {
    console.log("Connected to the server");
};

// Event: Message received
socket.onmessage = (event) => 
{
	
	if(event.data.split(" ")[0]==Code.CHAT_MSG)
	{
    console.log("Message from server:", event.data);
    let msg=event.data.split(" ");
    let temp=document.createElement("div")
	temp.setAttribute("class","reciever")
	
	wholeMsg=(msg.length>2)?msg[2]:"";
	for(let i=3;i<msg.length;i++)
		wholeMsg=wholeMsg+" "+msg[i];
		
	temp.innerHTML=wholeMsg
	
	let container=document.getElementById(msg[1])
	if(!container)
	{
		let par=document.createElement("div")
		par.innerHTML=msg[1]
		par.setAttribute("id","parent"+msg[1])
		document.getElementById("userList").appendChild(par);
		
		let y=document.createElement("div")
		
		document.getElementById(msg[1]).setAttribute("lastDay",getCurrDate())
		
		tempDateDiv=document.createElement("div")
		tempDateDiv.setAttribute("class","lastDay")
		tempDateDiv.innerText=getCurrDate();
		document.getElementById(msg[1]).appendChild(tempDateDiv)	
		
   		
   	
				
		
		
		
		y.appendChild(temp)
		
		tempTimeDiv= document.createElement("div")
    	tempTimeDiv.innerText=getCurrentTime();
   		tempTimeDiv.setAttribute("class","receiverTime") 
   		y.appendChild(tempTimeDiv)
		
		
		
		y.setAttribute("id",msg[1])
		y.style.display="none";
		document.getElementsByTagName("body")[0].appendChild(y)	
	}
	else
	{
		tempFlag=true;
		if(container.getAttribute("lastDay")!=getCurrDate())
		{
			tempFlag=false;
			tempDateDiv=document.createElement("div")
			tempDateDiv.setAttribute("class","lastDay")
			tempDateDiv.innerText=getCurrDate();
			
			container.appendChild(tempDateDiv)	
			container.setAttribute("lastDay",getCurrDate());
			
			
		}
		
		
		
		container.appendChild(temp);
		tempTimeDiv= document.createElement("div")
    	tempTimeDiv.innerText=getCurrentTime();
   		tempTimeDiv.setAttribute("class","receiverTime") 
   		container.appendChild(tempTimeDiv)
		
		
		
		
		
		if(document.getElementById("userHeader").innerText==msg[1])
		{
			
			if(!tempFlag)
			{
				
				tempDateDiv=document.createElement("div")
				tempDateDiv.setAttribute("class","lastDay")
				tempDateDiv.innerText=getCurrDate();
			
				document.getElementById("ChattingSection").appendChild(tempDateDiv)	
				
			}
			
			document.getElementById("ChattingSection").appendChild(temp)
			
			tempTimeDiv= document.createElement("div")
    		tempTimeDiv.innerText=getCurrentTime();
   			tempTimeDiv.setAttribute("class","receiverTime") 
   			document.getElementById("ChattingSection").appendChild(tempTimeDiv)	
			
			
			socket.send(Code.SEEN_STAT+" "+document.getElementById("userHeader").innerText)
		}
		else
		{
			document.getElementById("parent"+msg[1]).setAttribute("status","unread")
		}
		
	}	
	
	let newRef=document.getElementById("parent"+msg[1])
	
	
	if(!(document.getElementById("chats").querySelector("div")==newRef))
	{
	document.getElementById("chats").removeChild(newRef)
	
	document.getElementById("chats").insertBefore(newRef,document.getElementById("chats").querySelector("div"))
	}
	
	if(document.getElementById("userHeader").innerText==msg[1])
	{
		let chattingSection = document.getElementById('ChattingSection');
   		chattingSection.scrollTop = chattingSection.scrollHeight;
	}
	
	if(document.getElementById("userHeader").innerText!=msg[1])
	{
		newRef.setAttribute("status","unread");
	}
	
	}
	
	else if(event.data.split(" ")[0]==Code.ONLINE_STAT)
	{
		document.getElementById("parent"+event.data.split(" ")[1]).setAttribute("onlineStatus",event.data.split(" ")[2])
	}
	
	
	
	
		

};

// Event: Connection closed
socket.onclose = () => {
    console.log("Connection closed");
};

// Event: Error occurred
socket.onerror = (error) => {
    console.error("WebSocket error:", error);
};



function sendMessage(msg)
{
	if(msg.split(" ").length>=3);
	{
		let rp=document.getElementById("userHeader").innerText;
		
		if(rp!=null)
		{
			let temp=rp+" "+msg.trim();
			socket.send(Code.CHAT_MSG+" "+temp);
		}
			
	}
}
function fn()
{
	
	if(document.getElementById("userHeader").innerText!="")
	{
		
		if(document.getElementById(document.getElementById("userHeader").innerText).getAttribute("lastDay")!=getCurrDate())
		{
			tempDateDiv=document.createElement("div")
			tempDateDiv.setAttribute("class","lastDay")
			tempDateDiv.innerText=getCurrDate();
			document.getElementById("ChattingSection").appendChild(tempDateDiv);
			document.getElementById(document.getElementById("userHeader").innerText).setAttribute("lastDay",getCurrDate());
			
		}
		
		
		
		sendMessage(document.getElementById("inputBox").value);
		let temp=document.createElement("div")
		temp.setAttribute("class","sender")
		temp.innerText=document.getElementById("inputBox").value;
		document.getElementById("inputBox").value=''
		document.getElementById(document.getElementById("userHeader").innerText).appendChild(temp);
		document.getElementById("ChattingSection").appendChild(temp);
		
		tempTimeDiv= document.createElement("div")
    	tempTimeDiv.innerText=getCurrentTime();
   		tempTimeDiv.setAttribute("class","senderTime") 
   		document.getElementById(document.getElementById("userHeader").innerText).appendChild(tempTimeDiv);
   		document.getElementById("ChattingSection").appendChild(tempTimeDiv)


		let otheruser=document.getElementById("userHeader").innerText;

		let ref=document.getElementById("parent"+otheruser)

		if(!(document.getElementById("chats").querySelector("div")==ref))
		{
		document.getElementById("chats").removeChild(ref)

		document.getElementById("chats").insertBefore(ref,document.getElementById("chats").querySelector("div"))
		}

		let chattingSection = document.getElementById('ChattingSection');
		chattingSection.scrollTop = chattingSection.scrollHeight;

	}
	else
		alert("Select user to chat");
	
}




function sendSeenStatus(userName)
{
	socket.send(Code.SEEN_STAT+" "+userName);
}
