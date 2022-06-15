<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(WhitelistDomainDao dao){
	WhitelistData data = new WhitelistData();
	data.id = paramInt("id");
	data.description = paramString("description");

	data.bypassAuth = paramBoolean("bypassAuth");
	data.bypassFilter = paramBoolean("bypassFilter");
	data.bypassLog = paramBoolean("bypassLog");
	data.adminBlock = paramBoolean("adminBlock");
	data.dropPacket = paramBoolean("dropPacket");
	data.appliedPolicyArr = paramArray("appliedPolicyArr");

	if((data.bypassAuth || data.dropPacket)
		&& (data.appliedPolicyArr != null && data.appliedPolicyArr.length > 0)){

		errList.add(translate("Bypass Authetication and Drop Packet should be applied on global level."));
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
WhitelistDomainDao dao = new WhitelistDomainDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
WhitelistData data = dao.selectOne(paramInt("id"));

// Get policy list.
PolicyDao polDao = new PolicyDao();
Map<Integer, String> policyIdNameMap = dao.getPolicyIdNameMap();

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
		<li class="breadcrumb-item"><%= translate("WHITELIST")%></li>
		<li class="breadcrumb-item"><%= translate("DOMAIN")%></li>
		<li class="breadcrumb-item text-info"><%= translate("EDIT")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<!-- Tab -->
	<div>
		<ul class="nav nav-tabs" style="margin-left:10px; margin-right:10px;">
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(0);">
				<a class="nav-link<%= tabActive0%>" data-toggle="tab" href="#tab0"><%= translate("EDIT")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(1);">
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("APPLIED POLICIES")%></a>
			</li>
		</ul>
	</div>
	<!-- Tab -->

	<!-- Form -->
	<form action="<%= getPageName()%>" method="post">
		<input type="hidden" name="actionFlag" value="update">
		<input type="hidden" id="tabIdx" name="tabIdx" value="<%= tabIdx%>">
		<input type="hidden" name="id" value="<%= data.id%>">

		<!-- Tab content -->
		<div id="myTabContent" class="tab-content">

			<!-- Edit -->
			<div class="tab-pane <%= showActive0%>" id="tab0">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>

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
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="adminBlock" name="adminBlock"
										<%if(data.adminBlock){out.print("checked");}%>>
									<label for="adminBlock" class="custom-control-label"><%= translate("Admin Block")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="dropPacket" name="dropPacket"
										<%if(data.dropPacket){out.print("checked");}%>>
									<label for="dropPacket" class="custom-control-label">
										<%= translate("Drop Packet")%>
										&nbsp;<i class="fa fa-question-circle south-east"
												title="<%= translate("NxFilter drops UDP packets and does not keep log for that. Use this option when you are not interested in the domain at all.")%>"></i>
									</label>
								</div>
							</div>

							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>

						</fieldset>
					</div>
				</div>

			</div>
			<!-- Edit -->

			<!-- Applied Policies -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">

				<div class="form-group col-lg-8 text-secondary">
					<%= translate("If there's no policy selected, it becomes a global whitelist rule.")%>
				</div>

						<fieldset>

<%
int i = 0;
for(Map.Entry<Integer, String> e: policyIdNameMap.entrySet()){
	int policyId = e.getKey();
	String policyName = e.getValue();

	String chkLine = "";
	if(data.isAppliedPolicy(policyId)){
		chkLine = "checked";	
	}

	out.println("<div class='form-group col-lg-8 row' style='padding-left: 30px'>");
%>
								<div class="custom-control custom-checkbox col">
									<input type="checkbox" class="custom-control-input" id="appliedPolicy-<%= i%>"
										name="appliedPolicyArr" value="<%= policyId%>" <%= chkLine%>>
									<label class="custom-control-label" for="appliedPolicy-<%= i%>"><%= policyName%></label>
								</div>
<%
	out.println("</div>");
	
	i++;
}
%>

							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Applied Policies -->
		
		</div>
		<!-- Tab content -->

	</form>
	<!-- /Form -->

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>
