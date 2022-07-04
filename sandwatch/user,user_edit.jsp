<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
boolean checkParam(UserData data){
	// Check password only if there's a password updated.
	if (!isEmpty(data.passwd) && !isSha1Hex(data.passwd)) {
		if (data.passwd.length() < 4 || !ParamTest.isValidPasswdLen(data.passwd)) {
			errList.add(translate("Password length must be between 1 and 128."));
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

	// Only for manually created users.
	data.grpId = paramInt("grpId");

	// Validate and update it.
	if(checkParam(data) && dao.update(data)){
		succList.add(translate("Update finished."));
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

// Global.
UserData data = dao.selectOne(paramInt("id"));

// Get policy list.
List<PolicyData> gPolicyList = new PolicyDao().selectListAll();
List<GroupData> gGroupList = new GroupDao().selectListUserCreatedOnly();

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
		</ul>
	</div>
	<!-- Tab -->

	<!-- Form -->
	<form action="<%= getPageName()%>" method="post">
		<input type="hidden" name="actionFlag" value="update">
		<input type="hidden" name="id" value="<%= data.id%>">
		<input type="hidden" name="ipId" value="">
		<input type="hidden" id="tabIdx" name="tabIdx" value="<%= tabIdx%>">
 
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
								<label class="col-form-label"><%= translate("Group, Member of")%></label>
<%
if(data.ldapId > 0){
	out.println("<input type='text' class='form-control' id='loginToken' name='loginToken' disabled value='");
	out.println(data.getGroupLine());
	out.println("'>");
}
else{
	out.println("<select class='form-control' id='grpId' name='grpId'>");
	out.println("<option value='0'>anon-grp");
	for(GroupData grp : gGroupList){
		if(grp.name.startsWith(data.getGroupLine())){
			printf("<option value='%s' selected>%s</option>\n", grp.id, grp.name);
		}
		else{
			printf("<option value='%s'>%s</option>\n", grp.id, grp.name);
		}
	}
	out.println("</select>");
}
%>
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
</script>
