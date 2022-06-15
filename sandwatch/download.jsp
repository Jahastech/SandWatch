<%@page import="java.io.*,nxd.dao.*"%><%
String filename = request.getParameter("filename");
String contentType = request.getParameter("contentType");

if(contentType == null || contentType.length() == 0){
	contentType = "application/octet-stream";
}

if(filename == null){
	out.println("Invalid filename!");
}
else{
	// Remove directory part for preventing illegal access.
	filename = filename.replaceAll(".*/", "");

	OutputStream outx = null;
	FileInputStream fis = null;
	try{
		response.setContentType(contentType);
		response.setHeader("content-disposition","attachment; filename=\"" + filename + "\"");

		outx = response.getOutputStream();
		fis = new FileInputStream(GlobalDao.getWwwTmpPath() + "/" + filename);
		int i = 0;
		while((i = fis.read()) != -1){
			outx.write(i);
		} 
		fis.close();
	}
	catch(Exception e){}
	finally{
		if(outx != null){
			outx.close();
		}
		if(fis != null){
			fis.close();
		}
	}
}
%>