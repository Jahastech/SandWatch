<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
boolean checkParam(UserData data){
	// Check password only if there's a password updated.
	if (!isEmpty(data.passwd) && !isSha1Hex(data.passwd)) {
		if (data.passwd.length() < 4 || !ParamTest.isValidPasswdLen(data.passwd)) {
			errList.add(translate("Password length must be between 4 and 128."));
			return false;
		}

		if (!ParamTest.isValidPasswdChar(data.passwd)) {
			errList.add(translate("Only ASCII character allowed in password."));
			return false;
		}
	}

	// token.
	if (!isEmpty(data.token) && !ParamTest.isValidToken(data.token)) {
		errList.add(translate("Not a valid token, only alphabet and number, length must be 8."));
		return false;
	}

	return true;
}

//-----------------------------------------------
void update(UserDao dao){
	UserData data = new UserData();
	data.id = paramInt("id");
	data.passwd = paramString("passwd");
	data.policyId = paramInt("policyId");
	data.ftPolicyId = paramInt("ftPolicyId");
	data.expDate = paramString("expDate");
	data.token = paramString("token");
	data.description = paramString("description");

	// Validate and update it.
	if(checkParam(data) && dao.update(data)){
		succList.add(translate("Update finished."));

		if(isNotEmpty(data.passwd) && !new ConfigDao().selectOne().enableLogin){
			warnList.add(translate("User authentication needs to be enabled."));
		}
	}
}

//-----------------------------------------------
void newToken(UserDao dao){
	UserData data = new UserData();
	data.id = paramInt("id");
	data.token = paramString("token");

	if(dao.newToken(data.id)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void addIp(UserDao dao){
	UserIpData data = new UserIpData();
	data.userId = paramInt("id");
	data.startIp = paramString("startIp");
	data.endIp = paramString("endIp");

	// Param validation.
	if (!isValidIp(data.startIp)) {
		errList.add(translate("Invalid start IP."));
		return;
	}

	if (isNotEmpty(data.endIp) && !isValidIp(data.endIp)) {
		errList.add(translate("Invalid end IP."));
		return;
	}

	if(dao.addIp(data)){
		succList.add(translate("Update finished."));

		if(!new ConfigDao().selectOne().enableLogin){
			warnList.add(translate("User authentication needs to be enabled."));
		}
	}
}

//-----------------------------------------------
void deleteIp(UserDao dao){
	if(dao.deleteIp(paramInt("ipId"))){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void joinGroup(UserDao dao){
	UserData data = new UserData();
	data.id = paramInt("id");
	String[] newGroupIdLineArr = paramArray("newGroupIdLineArr");

	if(dao.joinGroup(data.id, newGroupIdLineArr)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void withdrawGroup(UserDao dao){
	GroupData data = new GroupData();
	data.id = paramInt("id");
	int withdrawGroupId = paramInt("withdrawGroupId");

	if(dao.withdrawGroup(data.id, withdrawGroupId)){
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
UserDao dao = new UserDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}
if(actionFlag.equals("newToken")){
	newToken(dao);
}
if(actionFlag.equals("addIp")){
	addIp(dao);
}
if(actionFlag.equals("deleteIp")){
	deleteIp(dao);
}
if(actionFlag.equals("mobileConfig")){
	String filename = dao.writeMobileConfigFile(paramInt("id"));

	// Don't make it too big.
	if(isNotEmpty(filename)){
		response.sendRedirect("download.jsp?filename=" + filename + "&contentType=application/xml");
		return;
	}
	else{
		errList.add(translate("Couldn't write the file."));
	}
}
if(actionFlag.equals("joinGroup")){
	joinGroup(dao);
}
if(actionFlag.equals("withdrawGroup")){
	withdrawGroup(dao);
}

// Global.
UserData data = dao.selectOne(paramInt("id"));

// Get policy list.
List<PolicyData> gPolicyList = new PolicyDao().selectListAll();
List<GroupData> gGroupList = new GroupDao().selectListUserCreatedOnly();

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
		<li class="breadcrumb-item"><%= translate("USER")%></li>
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
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("ADD IP")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(2);">
				<a class="nav-link<%= tabActive2%>" data-toggle="tab" href="#tab2"><%= translate("MEMBER OF")%></a>
			</li>
		</ul>
	</div>
	<!-- Tab -->

	<!-- Form -->
	<form action="<%= getPageName()%>" method="post">
		<input type="hidden" name="actionFlag" value="update">
		<input type="hidden" name="id" value="<%= data.id%>">
		<input type="hidden" name="ipId" value="">
		<input type="hidden" id="tabIdx" name="tabIdx" value="<%= tabIdx%>">
		<input type="hidden" name="withdrawGroupId">

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
								<label class="col-form-label">
									<%= translate("Password")%>
									&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("This password can be used on NxFilter login page. The users imported from Active Directory can use Active Directory password.")%>"></i>
								</label>
								<input type="password" class="form-control" id="passwd"
									name="passwd" value="<%= data.passwd%>">
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
								<label class="col-form-label"><%= translate("Expiration Date")%></label>
								<input type="text" class="form-control" id="expDate" name="expDate" value="<%= data.getExpDate()%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Login Token")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("User identifier for the remote filtering agents of NxFilter.")%>"></i>
								</label>
								<input type="text" class="form-control" id="token" name="token" value="<%= data.token%>">
							</div>

							<div class="form-group col-lg-8">
								<button type="button" class="btn btn-primary" onclick="javascript:actionUpdate(this.form);"><%= translate("SUBMIT")%></button>
								<button type="button" class="btn btn-info" onclick="javascript:actionNewToken(this.form)"><%= translate("NEW LOGIN TOKEN")%></button>
								<button type="button" class="btn btn-warning" onclick="javascript:actionMobileConfig(this.form)"><%= translate("DOWNLOAD MOBILE CONFIG FILE")%></button>
							</div>

						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Edit -->

			<!-- Add IP -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8 text-secondary">
								<%= translate("You can associate an IP address or an IP address range to a user. If it is a single IP association, add Start IP only.")%>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Start IP")%></label>
								<input type="text" class="form-control" id="startIp"
									name="startIp">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("End IP")%></label>
								<input type="text" class="form-control" id="endIp"
									name="endIp">
							</div>
							<div class="form-group col-lg-8">
								<button type="button" class="btn btn-primary" onclick="javascript:actionAddIp(this.form);"><%= translate("SUBMIT")%></button>
							</div>

<%
for(int i = 0; i < data.ipList.size(); i++){

	out.println("<div class='form-group col-lg-8 row' style='padding-left: 30px'>");

	for(int k = 0; k < 4; k++){
		UserIpData uip = data.ipList.get(i);

		printf("<span class='domain-item'><a class='xlink' href='javascript:actionDeleteIp(%s)'>[x]</a> %s</span>", uip.id, uip.asString());

		if(++i >= data.ipList.size()){
			break;
		}
	}

	out.println("</div>");
}
%>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Add IP -->

			<!-- MEMBER OF -->
			<div class="tab-pane fade<%= showActive2%>" id="tab2">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>

				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Groups Available")%></label>
					<select class="form-control" id="newGroupIdLineArr" name="newGroupIdLineArr" multiple <%if(data.ldapId > 0){out.print("disabled");};%>>
<%
List<GroupData> availGroups = dao.getAvailGroups(data.id);
for(GroupData ou : availGroups){
	printf("<option value='%s'>%s</option>\n", ou.id, ou.name);
}
%>
					</select>
					<button type="button" class="btn btn-primary btn-sm" style="margin-top: 3px;"
						onclick="javascript:actionJoinGroup(this.form)"><%= translate("ADD GROUP")%></button>
				</div>

				<div class="form-group col-lg-12">
<%
for(int i = 0; i < data.groupList.size(); i++){
	GroupData gd = data.groupList.get(i);

	printf("<span class='domain-item'><a class='xlink' href='javascript:actionWithdrawGroup(%s)'>[x]</a> %s</span>", gd.id, gd.name);
}
%>
				</div>

						</fieldset>
					</div>
				</div>
			</div>
			<!-- /MEMBER OF -->

		</div>
		<!-- Tab content -->

	</form>
	<!-- /Form -->

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>

<script>
//-----------------------------------------------
// Restricts input for each element in the set of matched elements to the given inputFilter.
(function($) {
	$.fn.inputFilter = function(inputFilter){
		return this.on("input keydown keyup mousedown mouseup select contextmenu drop", function(){
			if (inputFilter(this.value)){
				this.oldValue = this.value;
				this.oldSelectionStart = this.selectionStart;
				this.oldSelectionEnd = this.selectionEnd;
			} else if (this.hasOwnProperty("oldValue")){
				this.value = this.oldValue;
				this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
			} else {
				this.value = "";
			}
		});
	};
}(jQuery));

// Install input filters.
$("#startIp").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d\.]*$/.test(value);
});
$("#endIp").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d\.]*$/.test(value);
});

//-----------------------------------------------
var dateToDisable = new Date();
jQuery("#expDate").datetimepicker({
	format: "<%= getGuiDateFormatForPicker()%> H:i",
	step: 1,
	beforeShowDay: function(date) {
		if (date.getTime() < dateToDisable.getTime()) {
			return [false, ""]
		}

		return [true, ""];
	}
});

//-----------------------------------------------
function actionNewToken(form){
	form.actionFlag.value = "newToken";
	form.submit();
}

//-----------------------------------------------
function actionUpdate(form){
	form.actionFlag.value = "update";
	form.submit();
}

//-----------------------------------------------
function actionAddIp(form){
	form.actionFlag.value = "addIp";
	form.submit();
}

//-----------------------------------------------
function actionDeleteIp(ipId){
	form = document.forms[0];
	form.actionFlag.value = "deleteIp";
	form.ipId.value = ipId;
	form.submit();
}

//-----------------------------------------------
function actionMobileConfig(form){
	form.actionFlag.value = "mobileConfig";
	form.submit();
}

//-----------------------------------------------
function actionJoinGroup(form){
<%if(data.ldapId > 0){
	out.print("return;");
}
%>

	form.actionFlag.value = "joinGroup";
	form.submit();
}

//-----------------------------------------------
function actionWithdrawGroup(withdrawGroupId){
<%if(data.ldapId > 0){
	out.print("return;");
}
%>

	form = document.forms[0];
	form.actionFlag.value = "withdrawGroup";
	form.withdrawGroupId.value = withdrawGroupId;
	form.submit();
}
</script>
