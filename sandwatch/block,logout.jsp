<%@include file="include/lib.jsp"%>
<%
//-----------------------------------------------
// Create data access object.
UserLoginDao dao = new UserLoginDao(request);
dao.logout();
response.sendRedirect("block,login.jsp");
%>