<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(SubAdminDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	SubAdminData data = new SubAdminData();

	data.id = paramInt("id");
	data.description = paramString("description");
	data.passwd = paramString("passwd");

	data.permDns = paramBoolean("permDns");
	data.permUser = paramBoolean("permUser");
	data.permPolicy = paramBoolean("permPolicy");
	data.permCategory = paramBoolean("permCategory");
	
	data.permClassifier = paramBoolean("permClassifier");
	data.permWhitelist = paramBoolean("permWhitelist");
	data.permLogging = paramBoolean("permLogging");
	data.permReport = paramBoolean("permReport");

	data.permDashboard = paramBoolean("permDashboard");

	if(dao.update(data)){
		succList.add(translate("Update finished."));
	}
}
%>
<%
//-----------------------------------------------
// Set permission for this page.
permission.addAdmin();

//Check permission.
if(!checkPermission()){
	return;
}

// Create data access object.
SubAdminDao dao = new SubAdminDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
SubAdminData data = dao.selectOne(paramInt("id"));
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("SYSTEM")%></li>
		<li class="breadcrumb-item"><%= translate("SUB-ADMIN")%></li>
		<li class="breadcrumb-item text-info"><%= translate("EDIT")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="update">
				<input type="hidden" name="id" value="<%= data.id%>">

				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Name")%></label>
					<input type="text" class="form-control" id="name" name="name" value="<%= data.name%>" disabled>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Description")%></label>
					<input type="text" class="form-control" id="description" name="description" value="<%= data.description%>">
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Password")%></label>
					<input type="password" class="form-control" id="passwd" name="passwd" value="<%= data.passwd%>">
				</div>

				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="permDashboard" name="permDashboard"
							<%if(data.permDashboard){out.print("checked");}%>>
						<label for="permDashboard" class="custom-control-label"><%= translate("GUI Access to DASHBOARD")%></label>
					</div>
				</div>

				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="permDns" name="permDns"
							<%if(data.permDns){out.print("checked");}%>>
						<label for="permDns" class="custom-control-label"><%= translate("GUI Access to DNS")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="permUser" name="permUser"
							<%if(data.permUser){out.print("checked");}%>>
						<label for="permUser" class="custom-control-label"><%= translate("GUI Access to USER")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="permPolicy" name="permPolicy"
							<%if(data.permPolicy){out.print("checked");}%>>
						<label for="permPolicy" class="custom-control-label"><%= translate("GUI Access to POLICY")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="permCategory" name="permCategory"
							<%if(data.permCategory){out.print("checked");}%>>
						<label for="permCategory" class="custom-control-label"><%= translate("GUI Access to CATEGORY")%></label>
					</div>
				</div>

				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="permClassifier" name="permClassifier"
							<%if(data.permClassifier){out.print("checked");}%>>
						<label for="permClassifier" class="custom-control-label"><%= translate("GUI Access to CLASSIFIER")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="permWhitelist" name="permWhitelist"
							<%if(data.permWhitelist){out.print("checked");}%>>
						<label for="permWhitelist" class="custom-control-label"><%= translate("GUI Access to WHITELIST")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="permLogging" name="permLogging"
							<%if(data.permLogging){out.print("checked");}%>>
						<label for="permLogging" class="custom-control-label"><%= translate("GUI Access to LOGGING")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="permReport" name="permReport"
							<%if(data.permReport){out.print("checked");}%>>
						<label for="permReport" class="custom-control-label"><%= translate("GUI Access to REPORT")%></label>
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
