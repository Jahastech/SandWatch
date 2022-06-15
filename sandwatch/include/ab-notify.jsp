<%@page import="java.util.*"%>
<div class="container-fluid" style="margin-top:-30px; margin-bottom:20px;">
<%
// Error message.
for(String msg : errList){
	out.println("<div class=\"ab-notify alert\">");
	out.println("  <span class=\"ab-closebtn\">&times;</span>");
	out.println("<strong>Error!</strong> " + msg);
	out.println("</div>");
}

// Success message.
for(String msg : succList){
	out.println("<div class=\"ab-notify success\">");
	out.println("  <span class=\"ab-closebtn\">&times;</span>");
	out.println("<strong>Success!</strong> " + msg);
	out.println("</div>");
}

// Info message.
for(String msg : infoList){
	out.println("<div class=\"ab-notify info\">");
	out.println("  <span class=\"ab-closebtn\">&times;</span>");
	out.println("<strong>Information!</strong> " + msg);
	out.println("</div>");
}

// Warning message.
for(String msg : warnList){
	out.println("<div class=\"ab-notify warning\">");
	out.println("  <span class=\"ab-closebtn\">&times;</span>");
	out.println("<strong>Warning!</strong> " + msg);
	out.println("</div>");
}
%>
<script>
//-----------------------------------------------
var abClose = document.getElementsByClassName("ab-closebtn");
for(var i = 0; i < abClose.length; i++){
	abClose[i].onclick = function(){
		var div = this.parentElement;
		div.style.opacity = "0";
		setTimeout(function(){
			div.style.display = "none";
		}, 600);
	}
}
</script>
</div>
