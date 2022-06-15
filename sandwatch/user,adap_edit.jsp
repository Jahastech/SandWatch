<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(AdapDao dao){
	LdapData data = new LdapData();
	data.id = paramInt("id");
	data.host = paramString("host");
	data.admin = paramString("admin");
	data.passwd = paramString("passwd");
	data.basedn = paramString("basedn");
	data.domain = paramString("domain");
	data.followReferral = paramBoolean("followReferral");
	data.period = paramInt("period");
	data.excludeKeyword = paramString("excludeKeyword");

    data.dnsIp = paramString("dnsIp");
    data.dnsTimeout = paramInt("dnsTimeout");

	data.useSsl = paramBoolean("useSsl");
    data.port = paramInt("port");
	data.sslCertificateCn = paramString("sslCertificateCn");

	// Param validation.
	if (!isValidIp(data.host)) {
		errList.add(translate("Invalid host IP."));
		return;
	}

	if (isEmpty(data.admin)) {
		errList.add(translate("Admin missing."));
		return;
	}

	if (isEmpty(data.basedn)) {
		errList.add(translate("Base DN missing."));
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
AdapDao dao = new AdapDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
LdapData data = dao.selectOne(paramInt("id"));

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
		<li class="breadcrumb-item"><%= translate("ACTIVE DIRECTORY")%></li>
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
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1">MS DNS</a>
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
								<label class="col-form-label"><%= translate("Host")%></label>
								<input type="text" class="form-control" id="host" name="host" value="<%= data.host%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Port")%></label>
								<input type="text" class="form-control" id="port" name="port" value="<%= data.port%>">
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="useSsl"
										name="useSsl" <%if(data.useSsl){out.print("checked");}%> onclick="javascript:setDefaultPort(this.form);">
									<label for="useSsl" class="custom-control-label"><%= translate("Use SSL")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">SSL Certificate CN</label>
								<input type="text" class="form-control" id="sslCertificateCn" name="sslCertificateCn" value="<%= data.sslCertificateCn%>">
								<small id="input-help" class="form-text text-muted"><%= translate("When you use your own certificate for LDAPS protocol.")%></small>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Admin")%></label>
								<input type="text" class="form-control" id="admin" name="admin" value="<%= data.admin%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Password")%></label>
								<input type="password" class="form-control" id="passwd" name="passwd" value="<%= data.passwd%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">Base DN</label>
								<input type="text" class="form-control" id="basedn" name="basedn" value="<%= data.basedn%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Domain")%></label>
								<input type="text" class="form-control" id="domain" name="domain" value="<%= data.domain%>">
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="followReferral"
										name="followReferral" <%if(data.followReferral){out.print("checked");}%>>
									<label for="followReferral" class="custom-control-label">Follow Referral</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Auto-sync")%></label>
								<select class="form-control" id="period" name="period">
<%
Map<Integer, String> periodMap = getLdapPeriodMap();
for(Map.Entry<Integer, String> entry : periodMap.entrySet()){
	Integer key = entry.getKey();
	String val = entry.getValue();

	if(key == data.period){
		printf("<option value='%s' selected>%s</option>\n", key, translate(val));
	}
	else{
		printf("<option value='%s'>%s</option>\n", key, translate(val));
	}
}
%>
								</select>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Exclude Keyword")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("To exclude some users or groups from LDAP importation by keyword matching. Multiple keywords should be separated by spaces. For a keyword having space, use double quotes. For exact matching, use square brackets.")%>
										<br>&nbsp;&nbsp;ex) support devel [DHCP Users] &quot;main Co&quot; john"></i>
								</label>
								<textarea class="form-control" id="excludeKeyword" name="excludeKeyword"><%= data.excludeKeyword%></textarea>
							</div>
							<div class="form-group col-lg-8">
								<button type="button" class="btn btn-primary" onclick="javascript:actionUpdate(this.form);"><%= translate("SUBMIT")%></button>
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
								<%= translate("NxFilter bypasses Active Directory domain to MS DNS server based on your AD importation settings. When you run your MS DNS server on a different server other than your DC, you need to bypass it manually.", 1000)%>
							</div>

							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("DNS IP")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("Multiple IP addresses should be separated by commas.")%>"></i>
								</label>
								<input type="text" class="form-control" id="dnsIp" name="dnsIp" value="<%= data.dnsIp%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("DNS Query Timeout")%></label>
								<div class="input-group">
									<input type="text" class="form-control" id="dnsTimeout"
										name="dnsTimeout" value="<%= data.dnsTimeout%>">
									<div class="input-group-append">
										<span class="input-group-text" id="input-addon"><%= translate("seconds")%>, 1 ~ 20</span>
									</div>				
								</div>
							</div>
							<div class="form-group col-lg-8">
								<button type="button" class="btn btn-primary" onclick="javascript:actionUpdate(this.form);"><%= translate("SUBMIT")%></button>
							</div>
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
$("#host").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d\.]*$/.test(value);
});
$("#port").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d]*$/.test(value);
});
$("#dnsIp").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d\.,]*$/.test(value);
});
$("#dnsTimeout").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d]*$/.test(value);
});

//-----------------------------------------------
function actionUpdate(form){
	if(form.dnsIp.value.indexOf(form.host.value) == -1
		&& !confirm('<%= translate("MS DNS server IP is different from host IP address?")%>')){
		return;
	}

	form.submit();
}

//-----------------------------------------------
function setDefaultPort(form){
	var port = form.port.value;

	if(form.useSsl.checked && port == 389){
		form.port.value = 636;
	}

	if(!form.useSsl.checked && port == 636){
		form.port.value = 389;
	}

	if(!form.useSsl.checked){
		form.sslCertificateCn.value = ""
	}
}
</script>
