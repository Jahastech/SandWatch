<%@include file="include/lib.jsp"%>
<%
//-----------------------------------------------
// Create data access object.
UserLoginDao dao = new UserLoginDao(request);
boolean failFlag = false;

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("logout")){
	dao.logout();
}
if(actionFlag.equals("login")){
	if(dao.login(paramString("uname"), paramString("passwd"))){
		response.sendRedirect("block,welcome.jsp");
		return;
	}
	else{
		//errList.add(translate("Login failed."));
		failFlag = true;
	}
}

// Get login-page.
BlockPageDao bpDao = new BlockPageDao();
BlockPageData data = bpDao.selectOneLocal();
String loginPage = data.loginPage;

// Replace params.
loginPage = loginPage.replaceAll("#\\{nx_name\\}", getNxName());
loginPage = loginPage.replaceAll("#\\{fail_flag\\}", String.valueOf(failFlag));

out.print(loginPage);
%>
