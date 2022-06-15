<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void quotaReset(UserTestDao dao){
	if(dao.quotaReset(paramString("name"))){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void bwdtReset(UserTestDao dao){
	if(dao.bwdtReset(paramString("name"))){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void loginSessionReset(UserTestDao dao){
	if(dao.loginSessionReset(paramString("name"))){
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
UserTestDao dao = new UserTestDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("quotaReset")){
	quotaReset(dao);
}
if(actionFlag.equals("bwdtReset")){
	bwdtReset(dao);
}
if(actionFlag.equals("loginSessionReset")){
	loginSessionReset(dao);
}

// Global.
UserTestData data = dao.test(paramString("name"));
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("USER")%></li>
		<li class="breadcrumb-item"><%= translate("USER")%></li>
		<li class="breadcrumb-item text-info"><%= translate("TEST")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="quotaReset">
				<input type="hidden" name="name" value="<%= data.name%>">
				<fieldset>
					<div class="form-row col-lg-8">
						<label class="col-form-label col-lg-2 col-sm-2"><%= translate("Name")%></label>
						<label class="col-form-label"><%= data.name%></label>
					</div>
					<div class="form-row col-lg-8">
						<label class="col-form-label col-lg-2 col-sm-2"><%= translate("Group")%></label>
						<label class="col-form-label"><%= data.groupName%></label>
					</div>
					<div class="form-row col-lg-8">
						<label class="col-form-label col-lg-2 col-sm-2"><%= translate("User Policy")%></label>
						<label class="col-form-label"><%= data.policyName%></label>
					</div>
					<div class="form-row col-lg-8">
						<label class="col-form-label col-lg-2 col-sm-2"><%= translate("Applied Policy")%></label>
						<label class="col-form-label"><%= data.appliedPolicyName%></label>
					</div>
					<div class="form-row col-lg-8">
						<label class="col-form-label col-lg-2 col-sm-2"><%= translate("Free Time")%></label>
						<label class="col-form-label"><%= data.isFreeTime ? "Yes" : "No"%></label>
					</div>
					<div class="form-row col-lg-8">
						<label class="col-form-label col-lg-2 col-sm-2"><%= translate("Screen Time")%></label>
						<label class="col-form-label"><%= data.quotaConsumed%> / <%= data.quotaLimit%>&nbsp;<%= translate("minutes")%></label>
					</div>
					<div class="form-row col-lg-8">
						<label class="col-form-label col-lg-2 col-sm-2"><%= translate("Data Cap")%></label>
						<label class="col-form-label"><%= data.bandwidthConsumed%> / <%= data.bandwidthLimit%>&nbsp;MB</label>
					</div>
					<div class="form-row col-lg-8">
						<label class="col-form-label col-lg-2 col-sm-2"><%= translate("Login Session TTL")%></label>
						<label class="col-form-label"><%= data.loginSessionTtl%>&nbsp;<%= translate("seconds")%></label>
					</div>
					<div class="form-group col-lg-8" style="margin-top: 10px;">
						<button type="button" class="btn btn-info" onclick="javascript:actionQuotaResetUser(this.form);"><%= translate("RESET SCREEN TIME")%></button>
						<button type="button" class="btn btn-warning" onclick="javascript:actionBandwidthResetUser(this.form);"><%= translate("RESET DATA CAP")%></button>
						<button type="button" class="btn btn-danger" onclick="javascript:actionLoginSessionResetUser(this.form);"><%= translate("RESET LOGIN SESSION")%></button>
					</div>
				</fieldset>
			</form>
		</div>
	</div>

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>

<script>
//-----------------------------------------------
function actionQuotaResetUser(form){
	if(!confirm('<%= translate("Reset screen time.")%>')){
		return;
	}

	form.actionFlag.value = "quotaReset";
	form.submit();
}

//-----------------------------------------------
function actionBandwidthResetUser(form){
	if(!confirm('<%= translate("Reset data cap.")%>')){
		return;
	}

	form.actionFlag.value = "bwdtReset";
	form.submit();
}

//-----------------------------------------------
function actionLoginSessionResetUser(form){
	if(!confirm('<%= translate("Reset login session TTL.")%>')){
		return;
	}

	form.actionFlag.value = "loginSessionReset";
	form.submit();
}
</script>
