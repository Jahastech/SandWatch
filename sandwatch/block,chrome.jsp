<%@include file="include/lib.jsp"%>
<%
// See if it's from Chrome agent.
String domain = paramString("domain");
if(isEmpty(domain)){
	out.print("");
	return;
}

// Create data access object.
BlockDao dao = new BlockDao(request);

// Now we set reason and etc..
dao.setReason(domain);

String reason = dao.getReason();
String user = dao.getUser();
String group = dao.getGroup();
String policy = dao.getPolicy();
String category = dao.getCategory();

// Get block-page.
BlockPageDao bpDao = new BlockPageDao();
BlockPageData data = bpDao.selectOneLocal();
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