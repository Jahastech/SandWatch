<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(ZoneFileDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	ZoneFileData data = new ZoneFileData();
	data.id = paramInt("id");
	data.zone = paramString("zone");
	data.bypassAuth = paramBoolean("bypassAuth");
	data.bypassFilter = paramBoolean("bypassFilter");
	data.bypassLog = paramBoolean("bypassLog");
	data.description = paramString("description");

	try{
		dao.testZone(data);
	}
	catch(Exception e){
		errList.add(e.toString());
		return;
	}

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
ZoneFileDao dao = new ZoneFileDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
ZoneFileData data = dao.selectOne(paramInt("id"));

// Get policy list.
PolicyDao polDao = new PolicyDao();
Map<Integer, String> policyIdNameMap = dao.getPolicyIdNameMap();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("DNS")%></li>
		<li class="breadcrumb-item"><%= translate("ZONE FILE")%></li>
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
					<label class="col-form-label"><%= translate("Domain")%></label>
					<input type="text" class="form-control" id="domain" name="domain" value="<%= data.domain%>" disabled>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Description")%></label>
					<input type="text" class="form-control" id="description" name="description" value="<%= data.description%>">
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="bypassAuth" name="bypassAuth"
							<%if(data.bypassAuth){out.print("checked");}%>>
						<label for="bypassAuth" class="custom-control-label"><%= translate("Bypass Authentication")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="bypassFilter" name="bypassFilter"
							<%if(data.bypassFilter){out.print("checked");}%>>
						<label for="bypassFilter" class="custom-control-label"><%= translate("Bypass Filtering")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="bypassLog" name="bypassLog"
							<%if(data.bypassLog){out.print("checked");}%>>
						<label for="bypassLog" class="custom-control-label"><%= translate("Bypass Logging")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Zone File")%></label>
					<textarea class="form-control" id="zone" name="zone" rows="20"><%= data.zone%></textarea>
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
