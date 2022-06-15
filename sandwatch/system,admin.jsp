<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void updateName(AdminDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	AdminData data = new AdminData();
	data.name = paramString("adminName");

	// Param validation.
	if(data.name.length() < 4 || !ParamTest.isValidNameLen(data.name)){
		errList.add("Name length must be between 4 and 64.");
		return;
	}
	
	if(!ParamTest.isValidNameChar(data.name)){
		errList.add("Only alphabet, number, [-_] allowed in name.");
		return;
	}

	if(dao.update(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void updateAdminPw(AdminDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	String newPw = paramString("newPw");
	String newPw2 = paramString("newPw2");
	String adminPw = paramString("adminPw");

	// Validate and update it.
	if(newPw.length() < 4 || !ParamTest.isValidPasswdLen(newPw)){
		errList.add(translate("Password length must be between 4 and 128."));
		return;
	}
	
	if(!ParamTest.isValidPasswdChar(newPw)){
		errList.add(translate("Only ASCII characters are allowed in password."));
		return;
	}

	if(!newPw.equals(newPw2)){
		errList.add(translate("Passwords don't match."));
		return;
	}

	if(!dao.isAdminPw(adminPw)){
		errList.add(translate("Wrong password."));
		return;
	}

	if(dao.updateAdminPw(newPw)){
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
AdminDao dao = new AdminDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	updateName(dao);
}
if(actionFlag.equals("adminPw")){
	updateAdminPw(dao);
}

// Global.
AdminData data = dao.selectOne();

// Active tab.
String tabActive0 = "";
String tabActive1 = "";

String showActive0 = "";
String showActive1 = "";

int tabIdx = paramInt("tabIdx");
if(tabIdx == 0){
	tabActive0 = " active";
	showActive0 = " show active";
}
else if(tabIdx == 1){
	tabActive1 = " active";
	showActive1 = " show active";
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("SYSTEM")%></li>
		<li class="breadcrumb-item text-info"><%= translate("ADMIN")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<!-- Tab -->
	<div>
		<ul class="nav nav-tabs" style="margin-left:10px; margin-right:10px;">
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(0); $('#actionFlag').val('update');">
				<a class="nav-link<%= tabActive0%>" data-toggle="tab" href="#tab0"><%= translate("ADMIN NAME")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(1); $('#actionFlag').val('adminPw');">
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("ADMIN PASSWORD")%></a>
			</li>
		</ul>
	</div>
	<!-- Tab -->

	<!-- Form -->
	<form action="<%= getPageName()%>" method="post">
		<input type="hidden" id="actionFlag" name="actionFlag" value="<%= actionFlag%>">
		<input type="hidden" id="tabIdx" name="tabIdx" value="<%= tabIdx%>">

		<!-- Tab content -->
		<div id="myTabContent" class="tab-content">

			<!-- Admin Name -->
			<div class="tab-pane <%= showActive0%>" id="tab0">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Admin Name")%></label>
								<input type="text" class="form-control" id="adminName" name="adminName" value="<%= data.name%>">
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"
									onclick="javascript:this.form.actionFlag.value='update';"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Admin Name -->

			<!-- Admin Password -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Current Password")%></label>
								<input type="password" class="form-control" id="adminPw" name="adminPw">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("New Password")%></label>
								<input type="password" class="form-control" id="newPw" name="newPw">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Confirm Password")%></label>
								<input type="password" class="form-control" id="newPw2" name="newPw2">
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"
									onclick="javascript:this.form.actionFlag.value='adminPw';"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Admin Password -->

		</div>
		<!-- Tab content -->

	</form>
	<!-- /Form -->

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>
