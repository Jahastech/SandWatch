<%@page trimDirectiveWhitespaces="true"%>
<%!
//-----------------------------------------------
String safeSubstringWithTailingDots(String line, int len){
	if(line.length() <= len){
		return line;
	}

	return wLib.safeSubstring(line, len) + "..";
}

//-----------------------------------------------
int getNxVersionAsInt(){
	String ver = GlobalDao.getNxVersion().replaceAll("\\D", "");
	return wLib.safeParseInt(ver);
}
%>