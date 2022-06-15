<%@include file="include/lib.jsp"%>
<%
// Only localhost access allowed.
if(!request.getRemoteAddr().startsWith("127.0.0.1")){
	out.println(request.getRemoteAddr());
	return;
}

// Get params.
String type = paramString("type");

ServerInfoDao dao = new ServerInfoDao();

if(type.equals("startTime")){
	out.print(dao.getStartTime());
}
else if(type.equals("uptime")){
	out.print(dao.getUptime());
}
else if(type.equals("lastLoad")){
	out.print(dao.getLastLoad());
}
else if(type.equals("curver")){
	out.print(GlobalDao.getNxVersion());
}
else if(type.equals("newver")){
	out.print(GlobalDao.getNewVersion());
}
%>
