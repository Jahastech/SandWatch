<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(GroupDao dao){
	GroupData data = new GroupData();
	data.id = paramInt("id");
	data.policyId = paramInt("policyId");
	data.ftPolicyId = paramInt("ftPolicyId");
	data.description = paramString("description");

	String stimeHh = paramString("stimeHh");
	String stimeMm = paramString("stimeMm");
	String etimeHh = paramString("etimeHh");
	String etimeMm = paramString("etimeMm");

	data.ftStime = stimeHh + stimeMm;
	data.ftEtime = etimeHh + etimeMm;

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
GroupDao dao = new GroupDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
GroupData data = dao.selectOne(paramInt("id"));

// Get policy list.
List<PolicyData> gPolicyList = new PolicyDao().selectListAll();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("USER")%></li>
		<li class="breadcrumb-item"><%= translate("GROUP")%></li>
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
					<input type="text" class="form-control" id="description"
						name="description" value="<%= data.description%>">
				</div>

				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Work-time Policy")%></label>
					<select class="form-control" id="policyId" name="policyId">
<%
for(PolicyData pd : gPolicyList){
	if(pd.id == data.policyId){
		printf("<option value='%s' selected>%s</option>\n", pd.id, pd.name);
	}
	else{
		printf("<option value='%s'>%s</option>\n", pd.id, pd.name);
	}
}
%>
					</select>
				</div>

				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Free-time Policy")%></label>
					<select class="form-control" id="ftPolicyId" name="ftPolicyId">
<%
for(PolicyData pd : gPolicyList){
	if(pd.id == data.ftPolicyId){
		printf("<option value='%s' selected>%s</option>\n", pd.id, pd.name);
	}
	else{
		printf("<option value='%s'>%s</option>\n", pd.id, pd.name);
	}
}
%>
					</select>
				</div>

				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Group Specific Free-time")%></label>
					<div class="form-row" style="margin-left: 2px;">
<%
List<String> hhList = getHhList();
List<String> mmList = getMmList();
%>
						<select class="form-control col-lg-1 col-md-1" id="stimeHh" name="stimeHh">
<%
for(String hh : hhList){
	if(data.ftStime.startsWith(hh)){
		printf("<option value='%s' selected>%s</option>", hh, hh);
	}
	else{
		printf("<option value='%s'>%s</option>", hh, hh);
	}
}
%>
						</select>&nbsp;

						<select class="form-control col-lg-1 col-md-1" id="stimeMm" name="stimeMm">
<%
for(String mm : mmList){
	if(data.ftStime.endsWith(mm)){
		printf("<option value='%s' selected>%s</option>", mm, mm);
	}
	else{
		printf("<option value='%s'>%s</option>", mm, mm);
	}
}
%>
						</select>&nbsp;~&nbsp;

						<select class="form-control col-lg-1 col-md-1" id="etimeHh" name="etimeHh">
<%
for(String hh : hhList){
	if(data.ftEtime.startsWith(hh)){
		printf("<option value='%s' selected>%s</option>", hh, hh);
	}
	else{
		printf("<option value='%s'>%s</option>", hh, hh);
	}
}
%>
						</select>&nbsp;

						<select class="form-control col-lg-1 col-md-1" id="etimeMm" name="etimeMm">
<%
for(String mm : mmList){
	if(data.ftEtime.endsWith(mm)){
		printf("<option value='%s' selected>%s</option>", mm, mm);
	}
	else{
		printf("<option value='%s'>%s</option>", mm, mm);
	}
}
%>
						</select>
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
