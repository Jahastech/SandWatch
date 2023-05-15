<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
boolean checkParam(ConfigData data){
	// Redirection IP.
	if (!ParamTest.isValidBlockIp(data.blockRediIp)) {
		errList.add(translate("Invalid block redirection IP."));
		return false;
	}

	// Login, logout domain.
	if (!isValidDomain(data.loginDomain)) {
		errList.add(translate("Invalid login domain."));
		return false;
	}

	if (!isValidDomain(data.logoutDomain)) {
		errList.add(translate("Invalid logout domain."));
		return false;
	}

	// Syslog.
	if (isNotEmpty(data.syslogHost) && !isValidIp(data.syslogHost)) {
		errList.add(translate("Invalid IP address for Syslog host."));
		return false;
	}

	if (data.remoteLogging && isEmpty(data.syslogHost)) {
		errList.add(translate("Remote logging option requires Syslog host."));
		return false;
	}

	// Netflow.
	if (isNotEmpty(data.netflowIp) && !isValidIp(data.netflowIp)) {
		errList.add(translate("Invalid router IP."));
		return false;
	}

	if (data.useNetflow && isEmpty(data.netflowIp)) {
		errList.add(translate("Router IP missing."));
		return false;
	}

	// Misc.
	if (!isValidDomain(data.adminDomain)) {
		errList.add(translate("Invalid admin domain."));
		return false;
	}

	return true;
}

//-----------------------------------------------
void update(ConfigDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	ConfigData oldData = dao.selectOne();
	ConfigData data = new ConfigData();

	// Block and authentication.
	data.blockRediIp = paramString("blockRediIp");
	data.silentBlock = paramBoolean("silentBlock");
	data.enableLogin = paramBoolean("enableLogin");
	data.disableLoginRedirection = paramBoolean("disableLoginRedirection");
	data.loginDomain = paramString("loginDomain");
	data.logoutDomain = paramString("logoutDomain");
	data.loginSessionTtl = paramInt("loginSessionTtl");

	// Syslog.
	data.syslogHost = paramString("syslogHost");
	data.syslogPort = paramInt("syslogPort");
	data.exportBlockedOnly = paramBoolean("exportBlockedOnly");
	data.fromEachNode = paramBoolean("fromEachNode");
	data.syslogJson = paramBoolean("syslogJson");
	data.remoteLogging = paramBoolean("remoteLogging");

	// Netflow.
	data.netflowIp = paramString("netflowIp");
	data.netflowPort = paramInt("netflowPort");
	data.useNetflow = paramBoolean("useNetflow");

	// Misc.
	data.adminDomain = paramString("adminDomain");
	data.bypassMsUpdate = paramBoolean("bypassMsUpdate");
	data.logRetentionDays = paramInt("logRetentionDays");
	data.sslOnly = paramBoolean("sslOnly");

	data.autoBackupDays = paramInt("autoBackupDays");
	data.agentPolicyUpdatePeriod = paramInt("agentPolicyUpdatePeriod");
	data.aQueryOnly = paramBoolean("aQueryOnly");
	data.guiLang = paramString("guiLang");
	data.guiDateFormat = paramString("guiDateFormat");
	data.disableVersionCheck = paramBoolean("disableVersionCheck");

	// Validate and update it.
	if(checkParam(data) && dao.update(data)){
		succList.add(translate("Update finished."));
	}

	if(!oldData.syslogHost.equals(data.syslogHost)
		|| oldData.syslogPort != data.syslogPort
		|| oldData.exportBlockedOnly != data.exportBlockedOnly
		|| oldData.fromEachNode != data.fromEachNode
		|| oldData.remoteLogging != data.remoteLogging
		|| !oldData.netflowIp.equals(data.netflowIp)
		|| oldData.netflowPort != data.netflowPort
		|| oldData.useNetflow != data.useNetflow
		|| !oldData.guiLang.equals(data.guiLang)
		|| !oldData.guiDateFormat.equals(data.guiDateFormat)
	){
		warnList.add(translate("Restart is required to apply new settings."));
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
ConfigDao dao = new ConfigDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
ConfigData data = dao.selectOne();

// Get list.
List<String[]> gGuiLangList = dao.getGuiLangList();
List<String[]> gGuiDateFormatList = dao.getGuiDateFormatList();

// Active tab.
String tabActive0 = "";
String tabActive1 = "";
String tabActive2 = "";
String tabActive3 = "";

String showActive0 = "";
String showActive1 = "";
String showActive2 = "";
String showActive3 = "";

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
else if(tabIdx == 3){
	tabActive3 = " active";
	showActive3 = " show active";
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("SYSTEM")%></li>
		<li class="breadcrumb-item text-info"><%= translate("SETUP")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<!-- Tab -->
	<div>
		<ul class="nav nav-tabs" style="margin-left:10px; margin-right:10px;">
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(0);">
				<a class="nav-link<%= tabActive0%>" data-toggle="tab" href="#tab0"><%= translate("BLOCK AND REDIRECTION")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(1);">
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("SYSLOG")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(2);">
				<a class="nav-link<%= tabActive2%>" data-toggle="tab" href="#tab2"><%= translate("NETFLOW")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(3);">
				<a class="nav-link<%= tabActive3%>" data-toggle="tab" href="#tab3"><%= translate("MISC")%></a>
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

			<!-- Block And Redirection -->
			<div class="tab-pane <%= showActive0%>" id="tab0">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Block Redirection IP")%>
									&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("It's the IP address where your block page is. Normally, it's the IP of NxFilter.")%>"></i>
								</label>
								<input type="text" class="form-control" id="blockRediIp" name="blockRediIp" value="<%= data.blockRediIp%>">
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="silentBlock"
										name="silentBlock"	<%if(data.silentBlock){out.print("checked");}%>>
									<label class="custom-control-label" for="silentBlock">
										<%= translate("Silent Block")%>
										&nbsp;<i class="fa fa-question-circle south-east"
												title="<%= translate("With this option enabled, there will be no block redirection. Use this option when you don't want to show your users block page.")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="enableLogin"
										name="enableLogin"	<%if(data.enableLogin){out.print("checked");}%>>
									<label class="custom-control-label" for="enableLogin">
										<%= translate("Enable User Authentication")%>
										&nbsp;<i class="fa fa-question-circle south-east"
												title="<%= translate("You can have user authentication in your network.")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Login Domain")%>
									&nbsp;<i class="fa fa-question-circle south-east" title="<%= translate("Domain for accessing login page.")%>"></i>
								</label>
								<input type="text" class="form-control" id="loginDoamin"
									name="loginDomain" value="<%= data.loginDomain%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Logout Domain")%>
									&nbsp;<i class="fa fa-question-circle south-east" title="<%= translate("Domain for deleting login session.")%>"></i>
								</label>
								<input type="text" class="form-control" id="logoutDoamin"
									name="logoutDomain" value="<%= data.logoutDomain%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Login Session TTL")%>
									&nbsp;<i class="fa fa-question-circle south-east" title="<%= translate("Login session will be alive as long as there's user activity.")%>"></i>
								</label>
								<div class="input-group">
									<input type="text" class="form-control" id="loginSessionTtl"
										name="loginSessionTtl" maxlength="4" value="<%= data.loginSessionTtl%>">
									<div class="input-group-append">
										<span class="input-group-text"><%= translate("minutes")%>, 5 ~ 1440</span>
									</div>				
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="disableLoginRedirection"
										name="disableLoginRedirection" <%if(data.disableLoginRedirection){out.print("checked");}%>>
									<label class="custom-control-label" for="disableLoginRedirection"><%= translate("Disable Login Redirection")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Block And Redirection -->

			<!-- Syslog -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8 text-secondary">
								<%= translate("Exporting DNS request log to a Syslog server.", 1000)%>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Syslog Host")%></label>
								<input type="text" class="form-control" id="syslogHost"
									name="syslogHost" value="<%= data.syslogHost%>">
								<small id="input-help" class="form-text text-muted">
									<%= translate("Restart is required after changing Syslog settings.")%>
								</small>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Syslog Port")%></label>
								<input type="text" class="form-control" id="syslogPort"
									name="syslogPort" maxlength="4"	value="<%= data.syslogPort%>">
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="exportBlockedOnly"
										name="exportBlockedOnly" <%if(data.exportBlockedOnly){out.print("checked");}%>>
									<label class="custom-control-label" for="exportBlockedOnly"><%= translate("Export Blocked Only")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="fromEachNode"
										name="fromEachNode" <%if(data.fromEachNode){out.print("checked");}%>>
									<label class="custom-control-label" for="fromEachNode">
										<%= translate("From Each Node")%>
										&nbsp;<i class="fa fa-question-circle south-east"
												title="<%= translate("In clustering, Syslog data will be sent from each node not through master node.")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="syslogJson"
										name="syslogJson" <%if(data.syslogJson){out.print("checked");}%>>
									<label class="custom-control-label" for="syslogJson"><%= translate("Use JSON Format")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="remoteLogging"
										name="remoteLogging" <%if(data.remoteLogging){out.print("checked");}%>>
									<label class="custom-control-label" for="remoteLogging"><%= translate("Enable Remote Logging")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Syslog -->

			<!-- NetFlow -->
			<div class="tab-pane fade<%= showActive2%>" id="tab2">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8 text-secondary">
								<%= translate("You can set policy level data usage limit for your users by importing NetFlow data to NxFilter.", 1000)%>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Router IP")%></label>
								<input type="text" class="form-control" id="netflowIp"
									name="netflowIp" value="<%= data.netflowIp%>">
								<small id="input-help" class="form-text text-muted">
									<%= translate("Restart is required after changing NetFlow settings.")%>
								</small>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Router Port")%></label>
								<input type="text" class="form-control" id="netflowPort"
									name="netflowPort" value="<%= data.netflowPort%>">
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="useNetflow"
										name="useNetflow" <%if(data.useNetflow){out.print("checked");}%>>
									<label class="custom-control-label" for="useNetflow"><%= translate("Run Collector")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /NetFlow -->

			<!-- Misc -->
			<div class="tab-pane fade<%= showActive3%>" id="tab3">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">

						<fieldset>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Admin Domain")%>
									&nbsp;<i class="fa fa-question-circle south-east" title="<%= translate("Domain for accessing admin GUI.")%>"></i>
								</label>
								<input type="text" class="form-control" id="adminDomain"
									name="adminDomain" value="<%= data.adminDomain%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Log Retension Days")%></label>
								<div class="input-group">
									<input type="text" class="form-control" id="logRetentionDays"
										name="logRetentionDays" maxlength="3" value="<%= data.logRetentionDays%>">
									<div class="input-group-append">
										<span class="input-group-text"><%= translate("days")%>, 0 ~ 400</span>
									</div>				
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="sslOnly"
										name="sslOnly" <%if(data.sslOnly){out.print("checked");}%>>
									<label class="custom-control-label" for="sslOnly"><%= translate("SSL Only to Admin GUI")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Auto Backup Days")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("NxFilter keeps auto backup files in /nxfilter/backup.")%>"></i>
								</label>
								<div class="input-group">
									<input type="text" class="form-control" id="autoBackupDays"
										name="autoBackupDays" maxlength="2" value="<%= data.autoBackupDays%>">
									<div class="input-group-append">
										<span class="input-group-text"><%= translate("days")%>, 0 ~ 30</span>
									</div>				
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="aQueryOnly"
										name="aQueryOnly" <%if(data.aQueryOnly){out.print("checked");}%>>
									<label class="custom-control-label" for="aQueryOnly">
										<%= translate("Filter A Query Only")%>
										&nbsp;<i class="fa fa-question-circle south-east" title="<%= translate("Filtering A and AAAA type queries only.")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("GUI Language")%></label>
								<select class="form-control" id="guiLang" name="guiLang">
									<option value=""><%= translate("SELECT LANGUAGE")%></option>
<%
for(String[] arr : gGuiLangList){
	String code = arr[0];
	String language = arr[1];

	if(code.equals(data.guiLang.toUpperCase())){
		printf("<option value='%s' selected>%s - %s</option>\n", code, code, language);
	}
	else{
		printf("<option value='%s'>%s - %s</option>\n", code, code, language);
	}
}
%>
								</select>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("GUI Date Format")%></label>
								<select class="form-control" id="guiDateFormat" name="guiDateFormat">
									<option value=""><%= translate("SELECT DATE FORMAT")%></option>
<%
for(String[] arr : gGuiDateFormatList){
	String fmt = arr[0];
	String exLine = arr[1];

	if(fmt.equals(data.guiDateFormat)){
		printf("<option value='%s' selected>%s</option>\n", fmt, exLine);
	}
	else{
		printf("<option value='%s'>%s</option>\n", fmt, exLine);
	}
}
%>
								</select>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="disableVersionCheck"
										name="disableVersionCheck" <%if(data.disableVersionCheck){out.print("checked");}%>>
									<label class="custom-control-label" for="disableVersionCheck">
										<%= translate("Disable Version Check")%>
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
			<!-- /Misc -->

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
$("#loginSessionTtl").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value);
});
$("#syslogPort").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value);
});
$("#routerPort").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value);
});
$("#logRetentionDays").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) <= 400;
});
$("#autoBackupDays").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) <= 30;
});
</script>
