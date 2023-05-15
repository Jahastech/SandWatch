<%@include file="include/lib.jsp"%>
<%
//-----------------------------------------------
boolean succFlag = false;
boolean failFlag1 = false;
boolean failFlag2 = false;
boolean failFlag3 = false;
boolean failFlag4 = false;
boolean failFlag5 = false;

// Create data access object.
UserTestDao utDao = new UserTestDao();
String uname = utDao.findUser(request.getRemoteAddr());
if(isEmpty(uname)){
	response.sendRedirect("block,login.jsp");
	return;
}

UserDao uDao = new UserDao();
UserData uData = uDao.selectOneByName(uname);

if(isEmpty(uData.passwd)){
	response.sendRedirect("block,login.jsp");
	return;
}

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("chgPw")){
	String oldPw = paramString("oldPw");
	String newPw1 = paramString("newPw1");
	String newPw2 = paramString("newPw2");

	if(uDao.selectOneByNameAndPassword(uname, oldPw) == null){
		failFlag2 = true;
	}
	else if(!newPw1.equals(newPw2)){
		failFlag3 = true;
	}
	else if (newPw1.length() < 4 || !ParamTest.isValidPasswdLen(newPw1)) {
		failFlag4 = true;
	}
	else if (!ParamTest.isValidPasswdChar(newPw1)) {
		failFlag5 = true;
	}
	else if(!uDao.updatePw(uname, newPw1)){
		failFlag1 = true;
	}
	else{
		succFlag = true;
	}
}

// Get login-page.
BlockPageDao bpDao = new BlockPageDao();
BlockPageData bpData = bpDao.selectOneLocal();
String passwordPage = bpData.passwordPage;

// Replace params.
passwordPage = passwordPage.replaceAll("#\\{nx_name\\}", getNxName());
passwordPage = passwordPage.replaceAll("#\\{user\\}", uname);
passwordPage = passwordPage.replaceAll("#\\{succ_flag\\}", String.valueOf(succFlag));
passwordPage = passwordPage.replaceAll("#\\{fail_flag1\\}", String.valueOf(failFlag1));
passwordPage = passwordPage.replaceAll("#\\{fail_flag2\\}", String.valueOf(failFlag2));
passwordPage = passwordPage.replaceAll("#\\{fail_flag3\\}", String.valueOf(failFlag3));
passwordPage = passwordPage.replaceAll("#\\{fail_flag4\\}", String.valueOf(failFlag4));
passwordPage = passwordPage.replaceAll("#\\{fail_flag5\\}", String.valueOf(failFlag5));

out.print(passwordPage);
%>
