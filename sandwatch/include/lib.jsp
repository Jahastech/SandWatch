<%@page trimDirectiveWhitespaces="true"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="nxd.dao.*"%>
<%@page import="nxd.data.*"%>
<%@page import="nxd.www.wLib"%>
<%!
//##################################################################################################
//##################################################################################################
//-----------------------------------------------
// Global.
PageContext pc = null;
HttpServletRequest request = null;
HttpServletResponse response = null;
JspWriter out = null;

PermissionData permission = null;
AdminLoginDao adminLoginDao = null;
LangDao langDao = null;

List<String> errList = null;
List<String> succList = null;
List<String> infoList = null;
List<String> warnList = null;

boolean demoFlag = false;

//##################################################################################################
//##################################################################################################
//-----------------------------------------------
void initLib(PageContext pc){
	this.pc = pc;
	request = (HttpServletRequest)pc.getRequest();
	response = (HttpServletResponse)pc.getResponse();
	out = pc.getOut();

	permission = new PermissionData();
	adminLoginDao = new AdminLoginDao(request);
	langDao = new LangDao();

	errList = new ArrayList<>();
	succList = new ArrayList<>();
	infoList = new ArrayList<>();
	warnList = new ArrayList<>();

	demoFlag = GlobalDao.getDemoFlag();

	writeAdminActivity();
}

//-----------------------------------------------
public void writeAdminActivity(){
	String actionFlag = paramString("actionFlag");
	String adminName = getAdminName();
	if(isNotEmpty(actionFlag) && isNotEmpty(adminName)){
		AdminActivityData aad = new AdminActivityData();
		aad.uname = adminName;
		aad.cltIp = request.getRemoteAddr();
		aad.upage = getPageName();
		aad.action = actionFlag;
		aad.type = getAdminType();

		new AdminActivityDao().insert(aad);
	}
}

//-----------------------------------------------
public String sterilizeHtml(String html) {
	html = html.replace('\'', ' ');
	html = html.replaceAll("<script", "<xcript");
	html = html.replaceAll("<img", "<xmg");
	html = html.replaceAll("</", "[/");
	html = html.replaceAll("%3[Cc]|%3[Ee]", " ");
	return html.trim();
}

//-----------------------------------------------
String paramString(String key, String defaultVal){
	String val = wLib.null2str(request.getParameter(key));
	if(wLib.isEmpty(val)){
		return defaultVal;
	}

	return sterilizeHtml(val);
}

//-----------------------------------------------
String paramString(String key){
	return paramString(key, "");
}

//-----------------------------------------------
int paramInt(String key, int defaultVal){
	String val = wLib.null2str(request.getParameter(key));
	if(wLib.isEmpty(val)){
		return defaultVal;
	}
	return wLib.safeParseInt(val);
}

//-----------------------------------------------
int paramInt(String key){
	return paramInt(key, 0);
}

//-----------------------------------------------
long paramLong(String key, long defaultVal){
	String val = wLib.null2str(request.getParameter(key));
	if(wLib.isEmpty(val)){
		return defaultVal;
	}
	return wLib.safeParseInt(val);
}

//-----------------------------------------------
long paramLong(String key){
	return paramLong(key, 0);
}

//-----------------------------------------------
boolean paramBoolean(String key, boolean defaultVal){
	String val = paramString(key);
	if(wLib.isEmpty(val)){
		return defaultVal;
	}

	// Evaluate it as boolean first.
	if(Boolean.parseBoolean(val)){
		return true;
	}

	// Evaluate it as string then.
	if(val.equals("on")){
		return true;
	}

	return false;
}

//-----------------------------------------------
boolean paramBoolean(String key){
	return paramBoolean(key, false);
}

//-----------------------------------------------
String[] paramArray(String key){
	try {
		return request.getParameterValues(key);
	} catch (Exception e) {
	}
	return null;
}

//-----------------------------------------------
String requestString(String key){
	return wLib.null2str(request.getParameter(key));
}

//-----------------------------------------------
void printf(String fmt, Object... args){
	try{
		out.print(String.format(fmt, args));
	}
	catch(Exception e){}
}

//-----------------------------------------------
void printParams(){
	Map<String, String[]> parameters = request.getParameterMap();
	for(Map.Entry<String, String[]> entry : parameters.entrySet()) {
		String key = entry.getKey();
		String val = "";

		String[] arr = entry.getValue();
		if(arr != null && arr.length > 0){
			val = arr[0];
		}

		System.out.printf("Key = %s, Val = %s\n", key, val);
	}
}

//-----------------------------------------------
//@SuppressWarnings("cast")
static int getPageCount(int count, int listSize){
	if(count % listSize > 0) {
		return (int)(count / listSize) + 1;
	}
	return (int)(count / listSize);
}

//-----------------------------------------------
String getPagination(int count, int listSize, int page){
	int pageCount = getPageCount(count, listSize);

	// Get start page of current page group.
	int currStart = 0;
	if(page % 10 == 0){
		currStart = page - ((page - 1) % 10);
	}
	else{
		currStart = page - (page % 10) + 1;
	}

	// Get previous link.
	int prevStart = 0;
	String prevLink = "";
	if(currStart > 10){	// If there's previous page group.
		prevStart = currStart - 10;
		prevLink = String.format("<a href='javascript:goPage(%s)'>Prev</a> ", prevStart);
	}
	else{
		prevLink = "Prev ";
	}

	// Get page link.
	String pageLink = "";
	int i = currStart;
	while(i < currStart + 10 && i <= pageCount){
		if(page == i){
			pageLink += " <span class='nolink'>" + i + "</span> ";
		}
		else{
			pageLink += String.format(" <a href='javascript:goPage(%s)'>%s</a> ", i, i);
		}
		i++;
	}

	// Get next link.
	int nextStart = 0;
	String nextLink = "";
	if(currStart + 10 <= pageCount){	// If there's next page group.
		nextStart = currStart + 10;
		nextLink = String.format(" <a href='javascript:goPage(%s)'>Next</a>", nextStart);
	}
	else{
		nextLink = " Next";
	}

	// Print link.
	return prevLink + pageLink + nextLink;
}

//-----------------------------------------------
String getPagination2(int count, int listSize, int page){
	int pageCount = getPageCount(count, listSize);

	// Get start page of current page group.
	int currStart = 0;
	if(page % 10 == 0){
		currStart = page - ((page - 1) % 10);
	}
	else{
		currStart = page - (page % 10) + 1;
	}

	// Get previous link.
	int prevStart = 0;
	String prevLink = "";
	if(currStart > 10){	// If there's previous page group.
		prevStart = currStart - 10;
		prevLink = String.format("<a href='javascript:goPage(%s)'>Prev</a>", prevStart);
	}
	else{
		prevLink = "<a class='disabled' href='#'>Prev</a>";
	}

	// Get page link.
	String pageLink = "";
	int i = currStart;
	while(i < currStart + 10 && i <= pageCount){
		if(page == i){
			pageLink += "<a class='active' href='#'>" + i + "</a>";
		}
		else{
			pageLink += String.format("<a href='javascript:goPage(%s)'>%s</a>", i, i);
		}
		i++;
	}

	// Get next link.
	int nextStart = 0;
	String nextLink = "";
	if(currStart + 10 <= pageCount){	// If there's next page group.
		nextStart = currStart + 10;
		nextLink = String.format("<a href='javascript:goPage(%s)'>Next</a>", nextStart);
	}
	else{
		nextLink = "<a class='disabled' href='#'>Next</a>";
	}

	// Print link.
	return prevLink + pageLink + nextLink;
}

//-----------------------------------------------
boolean isSlave(){
	ClusterDao dao = new ClusterDao();
	return dao.isSlave();
}

//-----------------------------------------------
boolean checkEditId(String targetPage){
	if(isEmpty(paramString("id"))){
		try{
			response.sendRedirect(targetPage);
		}
		catch(Exception e){}
		return false;
	}

	return true;
}

//-----------------------------------------------
boolean checkPermission(){
	boolean hasPermission = true;

	// Check admin type permission.
	if(!adminLoginDao.hasPermission(permission)){
		hasPermission = false;
	}

	// Check sub-admin page permission.
	if(hasPermission && isSubAdmin() && !adminLoginDao.hasPagePermission(getPageName())){
		hasPermission = false;
	}

	// Redirect it if it doesn't have permission.
	if(!hasPermission){
		try{
			if(isSubAdmin()){
				response.sendRedirect("help,mypage.jsp?permErrorFlag=true");
			}
			else{
				response.sendRedirect("admin.jsp");
			}
		}
		catch(Exception e){}
		return false;
	}

	// Check if it's a slave node.
	if(isSlave() && request.getRequestURI().indexOf("system,cluster.jsp") == -1){
		try{
			response.sendRedirect("system,cluster.jsp");
		}
		catch(Exception e){}
		return false;
	}

	return true;
}

//-----------------------------------------------
boolean isAllowedIp(){
	if(!adminLoginDao.hasPermission(permission)){
		try{
			response.sendRedirect("admin.jsp");
		}
		catch(Exception e){}
		return false;
	}
	return true;
}

//-----------------------------------------------
List<String> getHhList() {
	List<String> list = new ArrayList<>();
	for (int i = 0; i <= 24; i++) {
		String hh = i + "";
		if (i < 10) {
			hh = "0" + hh;
		}

		list.add(hh);
	}

	return list;
}

//-----------------------------------------------
List<String> getMmList() {
	List<String> list = new ArrayList<>();
	for (int i = 0; i < 60; i++) {
		String mm = i + "";
		if (i < 10) {
			mm = "0" + mm;
		}

		list.add(mm);
	}

	return list;
}

//-----------------------------------------------
String getPageName(){
	try{
		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/") + 1);
		return pageName;
	}
	catch(Exception e){
		//e.printStackTrace();
		System.out.println(e);
	}

	return "";
}

//-----------------------------------------------
boolean isAdmin(){
	return adminLoginDao.isAdmin();
}

//-----------------------------------------------
boolean isSubAdmin(){
	return adminLoginDao.isSubAdmin();
}

//-----------------------------------------------
String getAdminName(){
	return adminLoginDao.getAdminName();
}

//-----------------------------------------------
int getAdminType(){
	return adminLoginDao.getAdminType();
}

//-----------------------------------------------
Map<Integer, String> getLdapPeriodMap(){
	Map<Integer, String> m = new LinkedHashMap<>();
	m.put(0, "No sync");
	m.put(1, "Every minute");
	m.put(15, "Every 15 minutes");
	m.put(60, "Every hour");
	m.put(360, "Every 6 hours");
	m.put(1440, "Once a day");
	return m;
}

//-----------------------------------------------
String getLdapPeriodStr(int period){
	Map<Integer, String> m = getLdapPeriodMap();
	String s = m.get(period);
	return wLib.null2str(s);
}

//-----------------------------------------------
Map<Integer, String> getAlertPeriodMap(){
	Map<Integer, String> m = new LinkedHashMap<>();
	m.put(0, "No alert");
	m.put(5, "Every 5 minutes");
	m.put(15, "Every 15 minutes");
	m.put(30, "Every 30 minutes");
	m.put(60, "Every hour");
	m.put(120, "Every 2 hours");
	return m;
}

//-----------------------------------------------
void checkNewVersion(){
	if(adminLoginDao.hasNewVersion()){
		String text = String.format("New version of %s has been released! The newest version of %s is %s.",
			GlobalDao.getNxName(), GlobalDao.getNxName(), GlobalDao.getNewVersion());
		infoList.add(text);
	}
}

//-----------------------------------------------
void checkNewMessage(){
	String text = adminLoginDao.getNewMessage();
	if(isNotEmpty(text)){
		infoList.add(text);
	}
}

//-----------------------------------------------
boolean isNewLogin(){
	return !adminLoginDao.hasVerChkFlag();
}

//-----------------------------------------------
boolean isFreeJahaslist(){
	CategorySystemDao dao = new CategorySystemDao();
	return dao.getBlacklistType() == 5 && dao.getLicenseMaxUser() == 25;
}

//-----------------------------------------------
boolean isGloblist(){
	return new CategorySystemDao().isGloblist();
}

//-----------------------------------------------
boolean isUserPage(){
	String page = getPageName();
	if(wLib.isEmpty(page)){
		return true;
	}
	if(page.equals("index.jsp")){
		return true;
	}
	if(page.startsWith("block,")){
		return true;
	}
	if(page.startsWith("noacl,")){
		return true;
	}
	if(request.getRequestURI().contains("/example/")){
		return true;
	}

	return false;
}

//-----------------------------------------------
String formatFileSize(long bytes) {
	int unit = 1000;
	if (bytes < unit) {
		return bytes + " B";
	}
	int exp = (int) (Math.log(bytes) / Math.log(unit));
	String pre = "KMGTPE".charAt(exp - 1) + "";
	return String.format("%.1f %sB", bytes / Math.pow(unit, exp), pre);
}

//-----------------------------------------------
String formatLongString(String line, int maxLen) {
	if(line.length() > maxLen){
		return safeSubstring(line, maxLen) + "..";
	}
	return line;
}

//-----------------------------------------------
boolean isMsBrowser() {
	String ua = request.getHeader("User-Agent");
	if(wLib.isEmpty(ua)){
		return false;
	}

	if(ua.contains("Chrome")){
		return false;
	}

	return ua.contains("Edge") || ua.contains("like Gecko");
}

//-----------------------------------------------
String[] getExpYmdArr() {
	String[] ymdArr = wLib.strftimeArr("yyyy-MM-dd", wLib.strftime("yyyy-MM-dd"), 86400, 60);
	return ymdArr;
}

//-----------------------------------------------
String[] getExpHmArr() {
	String[] hmArr = wLib.strftimeArr("HH:mm", "08:00", 60 * 15, 24 * 4);
	return hmArr;
}

//-----------------------------------------------
String getActiveMenu(String menuKey){
	String pageName = getPageName();
	if(pageName.startsWith(menuKey)){
		return "active";
	}
	return "";
}

//-----------------------------------------------
String getVoteSite(){
	String[] arr = new String[]{
		"http://www.softpedia.com/get/Internet/Other-Internet-Related/NxFilter.shtml"
		, "http://www.snapfiles.com/get/nxfilter.html"
		, "http://www.majorgeeks.com/files/details/nxfilter.html"
		, "http://www.freewarefiles.com/NxFilter_program_89816.html"
	};
	int rnd = new Random().nextInt(arr.length);
	return arr[rnd];
}

//-----------------------------------------------
void jsAlert(String msg){
	try{
		out.println("<script type='text/javascript'>");
		out.println("alert('" + msg + "');");
		out.println("</script>");
	}
	catch(Exception e){}
}

//-----------------------------------------------
String translate(String line, int maxLineLen){
	String resLine = langDao.translate(line);
	resLine = resLine.replaceAll("'", "&apos;");
	resLine = resLine.replaceAll("\"", "&quot;");
	if(isEmpty(resLine)){
		return line;
	}
	return wLib.breakLines(resLine, "\n<br>", maxLineLen);
}

//-----------------------------------------------
String translate(String line){
	return translate(line, 120);
}

//-----------------------------------------------
String translateF(String fmt, Object... args){
	String newfmt = translate(fmt);
	return String.format(newfmt, args);
}

//##################################################################################################
//##################################################################################################
//-----------------------------------------------
// Company info.
String getNxName(){
	return GlobalDao.getNxName();
}

//-----------------------------------------------
String getNxVersion(){
	return GlobalDao.getNxVersion();
}

//-----------------------------------------------
String getNxCompany(){
	return GlobalDao.getNxCompany();
}

//-----------------------------------------------
String getNxHomepage(){
	return GlobalDao.getNxHomepage();
}

//-----------------------------------------------
String getNxEmail(){
	return GlobalDao.getNxEmail();
}

//-----------------------------------------------
String getNxTutorial(){
	return "http://www.nxfilter.org/tutorial/index.php?locale=en";
}

//-----------------------------------------------
String getNxForum(){
	return "https://nxfilter.org/forum/";
}

//-----------------------------------------------
String getNxDownload(){
	return "http://www.nxfilter.org/p3/download";
}
// Company info.

//-----------------------------------------------
// From wLib.
boolean isEmpty(String s){
	return wLib.isEmpty(s);
}

//-----------------------------------------------
boolean isNotEmpty(String s){
	return wLib.isNotEmpty(s);
}

//-----------------------------------------------
String null2str(Object o) {
	return wLib.null2str(o);
}

//-----------------------------------------------
String strftime(String fmt){
	return wLib.strftime(fmt);
}

//-----------------------------------------------
String strftime(String fmt, Date d){
	return wLib.strftime(fmt, d);
}

//-----------------------------------------------
String strftimeAdd(String fmt, int sec){
	return wLib.strftimeAdd(fmt, sec);
}

//-----------------------------------------------
String strftimeAdd(String fmt, String sdate, int sec){
	return wLib.strftimeAdd(fmt, sdate, sec);
}

//-----------------------------------------------
static String strftimeNewFmt(String fmt, String newFmt, String sdate) {
	return wLib.strftimeNewFmt(fmt, newFmt, sdate);
}

//-----------------------------------------------
String escapeHtml(String html){
	return wLib.escapeHtml(html);
}

//-----------------------------------------------
String safeSubstring(String line, int start, int end){
	return wLib.safeSubstring(line, start, end);
}

//-----------------------------------------------
String safeSubstring(String line, int len){
	return wLib.safeSubstring(line, len);
}

//-----------------------------------------------
boolean isValidIp(String ip){
	return wLib.isValidIp(ip);
}

//-----------------------------------------------
boolean isValidIpv6(String ip){
	return wLib.isValidIpv6(ip);
}

//-----------------------------------------------
boolean isValidDomain(String domain){
	return wLib.isValidDomain(domain);
}

//-----------------------------------------------
boolean isUnicodeDomain(String domain){
	return wLib.isUnicodeDomain(domain);
}

//-----------------------------------------------
boolean isValidEmail(String email){
	return wLib.isValidEmail(email);
}

//-----------------------------------------------
boolean isSha1Hex(String s){
	return wLib.isSha1Hex(s);
}

//-----------------------------------------------
boolean isPrivateIp(String ip){
	return wLib.isPrivateIp(ip);
}

//-----------------------------------------------
String getGuiDateFormatWithYear(){
	return wLib.getGuiDateFormatWithYear();
}

//-----------------------------------------------
String getGuiTimeFormatWithYear(){
	return wLib.getGuiTimeFormatWithYear();
}

//-----------------------------------------------
String getGuiDateFormatForPicker(){
	return wLib.getGuiDateFormatForPicker();
}
// From wLib.
%>
<%
//##################################################################################################
//##################################################################################################
// Init library and do the ground work.
initLib(pageContext);

if(!isUserPage()){
	// Check if it's from allowed IP.
	if(!adminLoginDao.isAllowedIp()){
		out.println("Not allowed IP!");
		return;
	}
	
	// Check SSL.
	if(adminLoginDao.isSslRequired()){
		try{
			response.sendRedirect(adminLoginDao.getSslAdminUrl());
		}
		catch(Exception e){}
		out.println("SSL only!");
		return;
	}
}
%>