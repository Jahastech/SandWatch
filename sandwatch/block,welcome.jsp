<%@include file="include/lib.jsp"%>
<%
// Create data access object.
UserTestDao dao = new UserTestDao();
String user = dao.findUser(request.getRemoteAddr());

// Get welcome-page.
BlockPageDao bpDao = new BlockPageDao();
BlockPageData data = bpDao.selectOneLocal();
String welcomePage = data.welcomePage;

// Replace template params.
welcomePage = welcomePage.replaceAll("#\\{user\\}", user);

// nx_name.
welcomePage = welcomePage.replaceAll("#\\{nx_name\\}", getNxName());

out.print(welcomePage);
%>