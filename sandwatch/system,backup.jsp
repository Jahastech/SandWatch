<%@include file="include/header.jsp"%>
<%
//-----------------------------------------------
// Set permission for this page.
permission.addAdmin();

//Check permission.
if(!checkPermission()){
	return;
}

// Create data access object.
ConfigDao dao = new ConfigDao();

// Action.
String actionFlag = paramString("actionFlag");
if(!demoFlag && actionFlag.equals("backup")){
	String filename = dao.backup();
	if(isNotEmpty(filename)){
		response.sendRedirect("download.jsp?filename=" + filename);
		return;
	}
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("SYSTEM")%></li>
		<li class="breadcrumb-item text-info"><%= translate("BACKUP")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">
	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="backup">
				<div class="form-group col-lg-8 text-secondary">
					<%= translate("By clicking the button below, you will download a backup file for your configuration. When you restore your configuration from the backup file, stop NxFilter and copy config.h2.db into /nxfilter/db directory.", 1000)%>
				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary"><%= translate("CREATE BACKUP")%></button>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>
