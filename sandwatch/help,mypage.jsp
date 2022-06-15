<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(SubAdminDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	SubAdminData data = new SubAdminData();

	int id = paramInt("id");
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

	if(!dao.isAdminPw(adminPw, id)){
		errList.add(translate("Wrong password."));
		return;
	}

	if(dao.updateAdminPw(newPw, id)){
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
SubAdminDao dao = new SubAdminDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
SubAdminData data = dao.selectOneByName(getAdminName());

// Error message.
if(paramBoolean("permErrorFlag")){
	errList.add(translate("Not enough permission."));
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("HELP")%></li>
		<li class="breadcrumb-item text-info"><%= translate("MY PAGE")%></li>
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
					<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
				</div>

			</form>
		</div>
	</div>

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>
