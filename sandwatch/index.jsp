<%@include file="include/lib.jsp"%>
<%!
//-----------------------------------------------
String getLoginPageUrl(int requestPort, String hostPort, boolean logoutFlag) throws Exception{

	String paramStr = "";
	if(logoutFlag){
		paramStr = "?actionFlag=logout";
	}

	// Deal with HTTPS first.
	if(requestPort == 443){
		return "https://" + hostPort + "/block,login.jsp" + paramStr;
	}
	else if(requestPort != 80){
		hostPort += ":" + requestPort;
	}

	return "http://" + hostPort + "/block,login.jsp" + paramStr;
}
%>
<%
// Create data access object.
BlockDao dao = new BlockDao(request);

// See if it's a request for a remote user policy.
String token = paramString("token");
boolean decodeFlag = paramBoolean("decodeFlag");
if(!isEmpty(token)){
	out.print(dao.getRemoteUserPolicy(token, decodeFlag));
	return;
}

// Print out cloudflare IP for NxLocal.
boolean cloudflareFlag = paramBoolean("cloudflareFlag");
if(cloudflareFlag){
	out.print(dao.getCloudflareIp());
	return;
}

// You can't access this page using localhost.
if(dao.isInvalidRequest()){
	return;
}

if(dao.isLogoutDomain()){
	int requestPort = request.getServerPort();
	String hostPort = dao.getLogoutDomain();

	response.sendRedirect(getLoginPageUrl(requestPort, hostPort, true));
	return;
}

// Set reason before we see if it's a request to be redirected.
dao.setReason();

if(dao.isLoginRequired()){
	int requestPort = request.getServerPort();
	String hostPort = dao.getLoginDomain();

	response.sendRedirect(getLoginPageUrl(requestPort, hostPort, false));
	return;
}

String domain = dao.getDomain();
String reason = dao.getReason();
String user = dao.getUser();
String group = dao.getGroup();
String policy = dao.getPolicy();
String category = dao.getCategory();

// Get block-page.
BlockPageDao blockPageDao = new BlockPageDao();
BlockPageData data = blockPageDao.selectOneLocal();
String blockPage = data.blockPage;

// Replace template params.
blockPage = blockPage.replaceAll("#\\{domain\\}", domain);
blockPage = blockPage.replaceAll("#\\{reason\\}", reason);
blockPage = blockPage.replaceAll("#\\{user\\}", user);
blockPage = blockPage.replaceAll("#\\{group\\}", group);
blockPage = blockPage.replaceAll("#\\{policy\\}", policy);
blockPage = blockPage.replaceAll("#\\{category\\}", category);

// nx_name.
blockPage = blockPage.replaceAll("#\\{nx_name\\}", getNxName());

out.print(blockPage);
%>