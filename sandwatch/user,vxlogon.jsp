<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
boolean checkParam(VxlogonData data){
	// logon, logoff domain.
	if (!isValidDomain(data.logonDomain)) {
		errList.add(translate("Invalid logon domain."));
		return false;
	}

	if (!isValidDomain(data.logoffDomain)) {
		errList.add(translate("Invalid logoff domain."));
		return false;
	}

	return true;
}

//-----------------------------------------------
void update(VxlogonDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	VxlogonData data = new VxlogonData();

    data.logonDomain = paramString("logonDomain");
    data.logoffDomain = paramString("logoffDomain");
	data.useVxlogon = paramBoolean("useVxlogon");

	// Validate and update it.
	if(checkParam(data) && dao.update(data)){
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
VxlogonDao dao = new VxlogonDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
VxlogonData data = dao.selectOne();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("USER")%></li>
		<li class="breadcrumb-item text-info"><%= translate("VXLOGON")%></li>
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
					<%= translate("VxLogon is an Active Directory single sign-on agent.")%>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Logon Domain")%></label>
					<input type="text" class="form-control" id="logonDomain" name="logonDomain"
						value="<%= data.logonDomain%>">
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Logoff Domain")%></label>
					<input type="text" class="form-control" id="logoffDomain" name="logoffDomain"
						value="<%= data.logoffDomain%>">
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="useVxlogon"
							name="useVxlogon" <%if(data.useVxlogon){out.print("checked");}%>>
						<label for="useVxlogon" class="custom-control-label"><%= translate("Use VxLogon")%></label>
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
