<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
boolean checkParam(AlertData data){
	if (isNotEmpty(data.adminEmail) && !isValidEmail(data.adminEmail)) {
		errList.add(translate("Invalid email address."));
		return false;
	}

	if (data.period > 0 && (isEmpty(data.adminEmail) || isEmpty(data.smtpHost))) {
		errList.add(translate("Email alert option requires admin email and SMTP host."));
		return false;
	}

	return true;
}

//-----------------------------------------------
void update(AlertDao dao){
	AlertData oldData = dao.selectOne();
	AlertData data = new AlertData();

	data.adminEmail = paramString("adminEmail");
	data.adminCc = paramString("adminCc");
	data.smtpHost = paramString("smtpHost");
	data.smtpPort = paramInt("smtpPort");
	data.smtpEncType = paramInt("smtpEncType");
	data.smtpUser = paramString("smtpUser");
	data.smtpPasswd = paramString("smtpPasswd");
	data.period = paramInt("period");

	data.alertCategoryArr = paramArray("alertCategoryArr");

	// Alert events.
	data.recvAlertAdminBlock = paramBoolean("recvAlertAdminBlock");
	data.recvAlertCategoryBlock = paramBoolean("recvAlertCategoryBlock");
	data.recvAlertUnclassified = paramBoolean("recvAlertUnclassified");
	data.recvAlertCnameCloaking = paramBoolean("recvAlertCnameCloaking");
	data.recvAlertScreenTime = paramBoolean("recvAlertScreenTime");
	data.recvAlertDataCap = paramBoolean("recvAlertDataCap");
	data.recvAlertBlockTime = paramBoolean("recvAlertBlockTime");
	data.recvAlertSystemBlock = paramBoolean("recvAlertSystemBlock");
	data.recvAlertOtherReasons = paramBoolean("recvAlertOtherReasons");

	// Validate and update it.
	if(checkParam(data) && dao.update(data)){
		succList.add(translate("Update finished."));

		if(!oldData.adminEmail.equals(data.adminEmail)
			|| !oldData.smtpHost.equals(data.smtpHost)
			|| oldData.smtpEncType != data.smtpEncType
			|| oldData.smtpPort != data.smtpPort
			|| !oldData.smtpUser.equals(data.smtpUser)
			|| !oldData.smtpPasswd.equals(data.smtpPasswd)
		){
			warnList.add(translate("Restart is required to apply new settings."));
		}
	}
}

//-----------------------------------------------
void test(AlertDao dao){
	try{
		dao.test();
		succList.add(translate("Test email has been sent."));
	}
	catch(Exception e){
		errList.add(e.toString());
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
AlertDao dao = new AlertDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}
if(actionFlag.equals("test")){
	test(dao);
}

// Global.
AlertData data = dao.selectOne();

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
		<li class="breadcrumb-item"><%= translate("SYSTEM")%></li>
		<li class="breadcrumb-item text-info"><%= translate("ALERT")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<!-- Tab -->
	<div>
		<ul class="nav nav-tabs" style="margin-left:10px; margin-right:10px;">
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(0);">
				<a class="nav-link<%= tabActive0%>" data-toggle="tab" href="#tab0"><%= translate("EMAIL SETUP")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(1);">
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("ALERT EVENTS")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(2);">
				<a class="nav-link<%= tabActive2%>" data-toggle="tab" href="#tab2"><%= translate("ALERT CATEGORIES")%></a>
			</li>
		</ul>
	</div>
	<!-- Tab -->

	<!-- Form -->
	<form action="<%= getPageName()%>" method="post">
		<input type="hidden" name="actionFlag" value="update">
		<input type="hidden" id="tabIdx" name="tabIdx" value="<%= tabIdx%>">

		<!-- Tab content -->
		<div id="myTabContent" class="tab-content">

			<!-- Alert -->
			<div class="tab-pane <%= showActive0%>" id="tab0">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8 text-secondary">
								<%= translate("NxFilter sends you emails about DNS request block and system related events.", 1000)%>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Admin Email")%></label>
								<input type="text" class="form-control" id="adminEmail" name="adminEmail" value="<%= data.adminEmail%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("CC Recipients")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("Only for access violation not for system or license related events. You can add multiple email addresses separated by semicolons.")%>"></i>
								</label>
								<input type="text" class="form-control" id="adminCc" name="adminCc" value="<%= data.adminCc%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("SMTP Host")%></label>
								<input type="text" class="form-control" id="smtpHost" name="smtpHost" value="<%= data.smtpHost%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("SMTP Port")%></label>
								<input type="text" class="form-control" id="smtpPort" name="smtpPort" value="<%= data.smtpPort%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">SSL/TLS</label>
								<select class="form-control" id="smtpEncType" name="smtpEncType">
									<option value="0" <%if(data.smtpEncType == 0){out.print("selected");}%>><%= translate("None")%></option>
									<option value="1" <%if(data.smtpEncType == 1){out.print("selected");}%>>SSL</option>
									<option value="2" <%if(data.smtpEncType == 2){out.print("selected");}%>>STARTTLS</option>
								</select>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("SMTP User")%></label>
								<input type="text" class="form-control" id="smtpUser"
									name="smtpUser" value="<%= data.smtpUser%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("SMTP Password")%></label>
								<input type="password" class="form-control" id="smtpPasswd"
									name="smtpPasswd" value="<%= data.smtpPasswd%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Alert Period")%>
									&nbsp;<i class="fa fa-question-circle south-east" title="<%= translate("Only for access violation emails.")%>"></i>
								</label>
								<select class="form-control" id="period" name="period">
<%
Map<Integer, String> periodMap = getAlertPeriodMap();
for(Map.Entry<Integer, String> entry : periodMap.entrySet()){
	Integer key = entry.getKey();
	String val = entry.getValue();

	if(key == data.period){
		printf("<option value='%s' selected>%s</option>", key, translate(val));
	}
	else{
		printf("<option value='%s'>%s</option>", key, translate(val));
	}
}
%>
								</select>
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
								<button type="button" class="btn btn-info" onclick="javascript:actionTest(this.form);"><%= translate("TEST")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Alert -->

			<!-- Alert Events -->
			<div class="tab-pane <%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="recvAlertAdminBlock"
										name="recvAlertAdminBlock" <%if(data.recvAlertAdminBlock){out.print("checked");}%>>
									<label class="custom-control-label" for="recvAlertAdminBlock"><%= translate("Receive alert emails for the block events by 'Admin Block'")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="recvAlertCategoryBlock"
										name="recvAlertCategoryBlock" <%if(data.recvAlertCategoryBlock){out.print("checked");}%>>
									<label class="custom-control-label" for="recvAlertCategoryBlock"><%= translate("Receive alert emails for the block events by 'Category'")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="recvAlertUnclassified"
										name="recvAlertUnclassified" <%if(data.recvAlertUnclassified){out.print("checked");}%>>
									<label class="custom-control-label" for="recvAlertUnclassified"><%= translate("Receive alert emails for the block events by 'Unclassified'")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="recvAlertCnameCloaking"
										name="recvAlertCnameCloaking" <%if(data.recvAlertCnameCloaking){out.print("checked");}%>>
									<label class="custom-control-label" for="recvAlertCnameCloaking"><%= translate("Receive alert emails for the block events by 'CName Cloaking'")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="recvAlertScreenTime"
										name="recvAlertScreenTime" <%if(data.recvAlertScreenTime){out.print("checked");}%>>
									<label class="custom-control-label" for="recvAlertScreenTime"><%= translate("Receive alert emails for the block events by 'Screen Time'")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="recvAlertDataCap"
										name="recvAlertDataCap" <%if(data.recvAlertDataCap){out.print("checked");}%>>
									<label class="custom-control-label" for="recvAlertDataCap"><%= translate("Receive alert emails for the block events by 'Data Cap'")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="recvAlertBlockTime"
										name="recvAlertBlockTime" <%if(data.recvAlertBlockTime){out.print("checked");}%>>
									<label class="custom-control-label" for="recvAlertBlockTime"><%= translate("Receive alert emails for the block events by 'Block Time'")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="recvAlertSystemBlock"
										name="recvAlertSystemBlock" <%if(data.recvAlertSystemBlock){out.print("checked");}%>>
									<label class="custom-control-label" for="recvAlertSystemBlock"><%= translate("Receive alert emails for the block events by 'System Block'")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="recvAlertOtherReasons"
										name="recvAlertOtherReasons" <%if(data.recvAlertOtherReasons){out.print("checked");}%>>
									<label class="custom-control-label" for="recvAlertOtherReasons"><%= translate("Receive alert emails for the block events by other reasons")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Alert Events -->

			<!-- Alert Categories -->
			<div class="tab-pane fade<%= showActive2%>" id="tab2">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">

						<div class="form-group col-lg-8 text-secondary">
							<%= translate("This is only for when you block domains by categories in a policy.")%>
						</div>

						<fieldset>

<%
for(int i = 0; i < data.alertCategoryList.size();){

	out.println("<div class='form-group col-lg-8 row' style='padding-left: 30px'>");

	for(int k = 0; k < 4; k++){
		CategoryData cd = data.alertCategoryList.get(i);

		String chkLine = "";
		if(cd.checkFlag){
			chkLine = "checked";
		}
%>
								<div class="custom-control custom-checkbox col-lg-3">
									<input type="checkbox" class="custom-control-input" id="alertCategory-<%= i%>"
										name="alertCategoryArr" value="<%= cd.id%>" <%= chkLine%>>
									<label class="custom-control-label" for="alertCategory-<%= i%>"><%= cd.name%></label>
								</div>
<%
		if(++i >= data.alertCategoryList.size()){
			break;
		}
	}

	out.println("</div>");
}
%>

							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
								<button type="button" class="btn btn-info" onclick="javascript:checkboxToggleAll3('alertCategoryArr');"><%= translate("SELECT ALL")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Alert Categories -->

		</div>
		<!-- Tab content -->

	</form>
	<!-- /Form -->

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>

<script>
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
$("#smtpPort").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value);
});

if($("#smtpPort").val() == "" || $("#smtpPort").val() == 0){
	$("#smtpPort").val(25);
}

//-----------------------------------------------
function actionTest(form){
	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "test";
	form.submit();
}
</script>
