<%@include file="include/xop,header.jsp"%>
<%
// Create data access object.
AdminLoginDao dao = new AdminLoginDao(request);

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("logout")){
	dao.logout();
}
else if(actionFlag.equals("login")){
	if(dao.login(paramString("uname"), paramString("passwd"))){
		writeAdminActivity();

		if(isAdmin()){
			// Start page for admin.
			response.sendRedirect("dashboard.jsp");
			return;
		}
		else if(isSubAdmin()){
			// Start page for sub-admin.
			response.sendRedirect("help,mypage.jsp");
			return;
		}
	}
	else{
		errList.add(translate("Login failed."));
	}
}
%>
<!-- Action info -->
<%@include file="include/xb-notify.jsp"%>
<!-- /Action info -->

<!-- Modal HTML -->
<div id="login-form" class="d-flex justify-content-center" data-backdrop="false" style="margin-top: 150px;">
	<div class="modal-dialog modal-login">
		<div class="modal-content">

			<div class="modal-body">
				<form method="post" action="<%= getPageName()%>">
					<input type="hidden" name="actionFlag" value="login">
					<div class="form-group">
						<i class="fa fa-user"></i>
						<input type="text" name="uname" class="form-control" placeholder="<%= translate("Username")%>" required="required">
					</div>
					<div class="form-group">
						<i class="fa fa-lock"></i>
						<input type="password" name="passwd" class="form-control" placeholder="<%= translate("Password")%>" required="required"
							onkeypress="javascript:if(event.keyCode == 13){this.form.submit(); return;}">
					</div>
					<div class="form-group" style="margin-bottom: -5px;">
						<input type="submit" class="btn btn-primary btn-block btn-lg" style="font-size: 1.3rem; font-weight: bold;" value="<%= translate("LOGIN")%>">
					</div>
				</form>			
			</div>

<%if(dao.isFirstLogin()){%>
			<div style="margin-top: -15; text-align: center; color: #A6A6A6; padding: 2px;">
				<%= translate("Username and password")%> : admin/admin
			</div>
<%}%>

<%if(demoFlag){%>
			<div style="margin-top: -15; text-align: center; color: #A6A6A6; padding: 2px;">
				Username and password : admin/admin
			</div>
<%}%>

		</div>
	</div>
</div>

<%@include file="include/xop,footer.jsp"%>

<script>
$(document).ready(function(){
	$("#login-form").modal("show");
});
</script>