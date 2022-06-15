<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(CxlogonDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	CxlogonData data = new CxlogonData();

    data.cxlogonGrpId = paramInt("cxlogonGrpId");
    data.cxlogonAddNew = paramBoolean("cxlogonAddNew");

	// Validate and update it.
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
CxlogonDao dao = new CxlogonDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
CxlogonData data = dao.selectOne();
List<GroupData> gGroupList = new GroupDao().selectListUserCreatedOnly();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("USER")%></li>
		<li class="breadcrumb-item text-info"><%= translate("CXLOGON")%></li>
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
					<%= translate("CxLogon is a single sign-on agent running on user system.")%>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="cxlogonAddNew"
							name="cxlogonAddNew" <%if(data.cxlogonAddNew){out.print("checked");}%>>
						<label for="cxlogonAddNew" class="custom-control-label">
							<%= translate("Auto-register for New User")%>
							&nbsp;<i class="fa fa-question-circle south-east"
								title="<%= translate("Adding new users by CxLogon login request automatically.")%>"></i>
						</label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Default Group for New User")%></label>
					<select class="form-control" id="cxlogonGrpId" name="cxlogonGrpId">
						<option value="0">anon-grp</option>
<%
for(GroupData grp : gGroupList){
	if(grp.id == data.cxlogonGrpId){
		printf("<option value='%s' selected>%s</option>\n", grp.id, grp.name);
	}
	else{
		printf("<option value='%s'>%s</option>\n", grp.id, grp.name);
	}
}
%>
					</select>
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
