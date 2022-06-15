<%@include file="include/lib.jsp"%>
<%
//-----------------------------------------------
// Create data access object.
UserLoginDao dao = new UserLoginDao(request);

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
		errList.add(translate("Login failed."));
	}
}

// Get login-page.
BlockPageDao bpDao = new BlockPageDao();
BlockPageData data = bpDao.selectOneLocal();
String loginPage = data.loginPage;

// nx_name.
loginPage = loginPage.replaceAll("#\\{nx_name\\}", getNxName());

out.print(loginPage);
%>