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

//-----------------------------------------------
void addUser(GroupDao dao){
	GroupData data = new GroupData();
	data.id = paramInt("id");
	String[] newMemberIdArr = paramArray("newMemberIdArr");

	if(dao.addUser(data.id, newMemberIdArr)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void delUser(GroupDao dao){
	GroupData data = new GroupData();
	data.id = paramInt("id");
	int delUserId = paramInt("delUserId");

	if(dao.delUser(data.id, delUserId)){
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
if(actionFlag.equals("addUser")){
	addUser(dao);
}
if(actionFlag.equals("delUser")){
	delUser(dao);
}

// Global.
GroupData data = dao.selectOne(paramInt("id"));

// Get policy list.
List<PolicyData> gPolicyList = new PolicyDao().selectListAll();

// Active tab.
String tabActive0 = "";
String tabActive1 = "";
String tabActive2 = "";

String showActive0 = "";
String showActive1 = "";
String showActive2 = "";

int tabIdx = paramInt("tabIdx");
if(tabIdx == 0){
	tabActive0 = " active";
	showActive0 = " show active";
}
else if(tabIdx == 1){
	tabActive1 = " active";
	showActive1 = " show active";
}
else if(tabIdx == 2){
	tabActive2 = " active";
	showActive2 = " show active";
}
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

	<!-- Tab -->
	<div>
		<ul class="nav nav-tabs" style="margin-left:10px; margin-right:10px;">
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(0);">
				<a class="nav-link<%= tabActive0%>" data-toggle="tab" href="#tab0"><%= translate("EDIT")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(1);">
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("MEMBERS")%></a>
			</li>
			<!-- 
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(2);">
				<a class="nav-link<%= tabActive2%>" data-toggle="tab" href="#tab2"><%= translate("MEMBER OF")%></a>
			</li>
			-->
		</ul>
	</div>
	<!-- Tab -->

	<!-- Form -->
	<form action="<%= getPageName()%>" method="post">
		<input type="hidden" name="actionFlag" value="update">
		<input type="hidden" name="id" value="<%= data.id%>">
		<input type="hidden" name="delUserId">
		<input type="hidden" id="tabIdx" name="tabIdx" value="<%= tabIdx%>">
		<input type="hidden" name="delGroupId">

		<!-- Tab content -->
		<div id="myTabContent" class="tab-content">

			<!-- Edit -->
			<div class="tab-pane <%= showActive0%>" id="tab0">

				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>

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

						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Edit -->

			<!-- MEMBERS -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>

							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Users Available")%></label>

								<select class="form-control" id="newMemberIdArr" name="newMemberIdArr" multiple
									<%if(data.ldapId > 0){out.print("disabled");}%>>

<%
List<UserData> availUsers = dao.getAvailUsers(data.id);
for(UserData ou : availUsers){
	printf("<option value='%s'>%s</option>\n", ou.id, ou.name);
}
%>
								</select>
								<button type="button" class="btn btn-primary btn-sm" style="margin-top: 3px;"
									onclick="javascript:actionAddUser(this.form)"><%= translate("ADD USER")%></button>
							</div>

							<div class="form-group col-lg-12">
<%
for(int i = 0; i < data.userList.size(); i++){
	UserData ud = data.userList.get(i);

	printf("<span class='user-item'><a class='xlink' href='javascript:actionDelUser(%s)'>[x]</a> %s</span>", ud.id, ud.name);
}
for(int i = 0; i < data.groupList.size(); i++){
	GroupData gd = data.groupList.get(i);

	printf("<span class='user-item'><a class='xlink' href='#'>[x]</a> *%s</span>", gd.name);
}
%>
							</div>

						</fieldset>
					</div>
				</div>
			</div>
			<!-- /MEMBERS -->

		</div>
		<!-- Tab content -->

	</form>
	<!-- /Form -->

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>

<script>
//-----------------------------------------------
function actionAddUser(form){
<%if(data.ldapId > 0){
	out.print("return;");
}
%>

	form.actionFlag.value = "addUser";
	form.submit();
}

//-----------------------------------------------
function actionDelUser(userId){
<%if(data.ldapId > 0){
	out.print("return;");
}
%>

	form = document.forms[0];
	form.actionFlag.value = "delUser";
	form.delUserId.value = userId;
	form.submit();
}
</script>