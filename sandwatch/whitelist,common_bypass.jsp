<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(CommonBypassDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	CommonBypassData data = new CommonBypassData();
	data.bypassAuth = paramBoolean("bypassAuth");
	data.bypassFilter = paramBoolean("bypassFilter");
	data.domain = paramString("domain");

	if(dao.update(data)){
		succList.add(translate("Update finished."));
	}
}
%>
<%
//-----------------------------------------------
// Set permission for this page.
permission.addAdmin();
permission.addSubAdmin();

//Check permission.
if(!checkPermission()){
	return;
}

// Create data access object.
CommonBypassDao dao = new CommonBypassDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
CommonBypassData data = dao.selectOne();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("WHITELIST")%></li>
		<li class="breadcrumb-item text-info"><%= translate("COMMON BYPASS")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="update">
				<div class="form-group col-lg-8 text-secondary">
					<%= translate("Adding globally bypassed domains. You can add your whitelisted domains en masse here.", 1000)%>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Domain")%>
					</label>
					<textarea class="form-control" id="domain" name="domain" rows="24"><%= data.domain%></textarea>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="bypassAuth"
							name="bypassAuth" <%if(data.bypassAuth){out.print("checked");}%>>
						<label for="bypassAuth" class="custom-control-label"><%= translate("Bypass Authentication")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="bypassFilter"
							name="bypassFilter" <%if(data.bypassFilter){out.print("checked");}%>>
						<label for="bypassFilter" class="custom-control-label"><%= translate("Bypass Filtering")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
				</div>

			</form>
		</div>
	</div>

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>
