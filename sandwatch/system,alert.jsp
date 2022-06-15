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

	// Validate and update it.
	if(checkParam(data) && dao.update(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void test(AlertDao dao){
	AlertData data = new AlertData();

	data.adminEmail = paramString("adminEmail");
	data.adminCc = paramString("adminCc");
	data.smtpHost = paramString("smtpHost");
	data.smtpPort = paramInt("smtpPort");
	data.smtpEncType = paramInt("smtpEncType");
	data.smtpUser = paramString("smtpUser");
	data.smtpPasswd = paramString("smtpPasswd");
	data.period = paramInt("period");

	// Validate and update it.
	if(!checkParam(data) || !dao.update(data)){
		return;
	}

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
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("ALERT CATEGORIES")%></a>
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

			<!-- Alert Categories -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
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

//-----------------------------------------------
function actionTest(form){
	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "test";
	form.submit();
}
</script>
