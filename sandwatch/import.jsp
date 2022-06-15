<%@include file="../include/lib.jsp"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%
//-----------------------------------------------
// Set permission for this page.
permission.addAdmin();
permission.addSubAdmin();

//Check permission.
if(!checkPermission()){
	return;
}

//-----------------------------------------------
int maxSize  = 1024 * 1024 * 100;
String uploadPath = GlobalDao.getWwwTmpPath();
try{
	MultipartRequest mreq = new MultipartRequest(request, uploadPath, maxSize, "UTF-8", new DefaultFileRenamePolicy());

	String actionFlag = null2str(mreq.getParameter("actionFlag"));
	String originPage = null2str(mreq.getParameter("originPage"));

	// File name.
	String file1 = mreq.getFilesystemName("file1");

	// If we have an uploaded file.
	int importCount = 0;
	if(isNotEmpty(file1)){

		// Full path to the file.
		String filepath = GlobalDao.getWwwTmpPath() + "/" + file1;

		if(actionFlag.equals("ruleset")){
			importCount = new ClassifierRulesetDao().importFile(filepath);
		}
		else if(actionFlag.equals("jahaslist")){
			importCount = new JahaslistDao().importFile(filepath);
		}
		else if(actionFlag.equals("catsystem")){
			importCount = new CategorySystemDao().importFile(filepath);
		}
	}

	response.sendRedirect(originPage + "?importCount=" + importCount + "&actionFlag=" + actionFlag);
}
catch(Exception e){
//	e.printStackTrace();
}
%>
