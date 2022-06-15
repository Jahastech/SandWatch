<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(DnsSetupDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	DnsSetupData data = dao.selectOne();

	data.dropAttackRequestByDomain = paramBoolean("dropAttackRequestByDomain");
	data.dropAttackRequestByIp = paramBoolean("dropAttackRequestByIp");
	data.dropHostnameWithoutDomain = paramBoolean("dropHostnameWithoutDomain");
	data.dropPtrForPrivateIp = paramBoolean("dropPtrForPrivateIp");
	data.allowPtrForServerIp = paramBoolean("allowPtrForServerIp");

	data.allowedRequestType = paramString("allowedRequestType");
	data.blockedRequestType = paramString("blockedRequestType");

	// Update it.
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
DnsSetupDao dao = new DnsSetupDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
DnsSetupData data = dao.selectOne();

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
		<li class="breadcrumb-item"><%= translate("DNS")%></li>
		<li class="breadcrumb-item text-info"><%= translate("SERVER PROTECTION")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<!-- Tab -->
	<div>
		<ul class="nav nav-tabs" style="margin-left:10px; margin-right:10px;">
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(0);">
				<a class="nav-link<%= tabActive0%>" data-toggle="tab" href="#tab0"><%= translate("SERVER PROTECTION")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(1);">
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("REQUEST TYPE CONTROL")%></a>
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

			<!-- Server Protection -->
			<div class="tab-pane <%= showActive0%>" id="tab0">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="dropAttackRequestByDomain"
										name="dropAttackRequestByDomain" <%if(data.dropAttackRequestByDomain){out.print("checked");}%>>
									<label class="custom-control-label" for="dropAttackRequestByDomain">
										<%= translate("Drop Attack Request by Domain")%>
										&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("When there is a domain queried too many times and fills up the request queue rapidly, we drop the DNS requests for the domain for less than 1 minute not to flood the request queue.")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="dropAttackRequestByIp"
										name="dropAttackRequestByIp" <%if(data.dropAttackRequestByIp){out.print("checked");}%>>
									<label class="custom-control-label" for="dropAttackRequestByIp">
										<%= translate("Drop Attack Request by IP")%>
										&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("When there is a client sending abnormal amount of DNS requests, we drop the DNS requests from the client for less than 1 minute not to flood the request queue.")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="dropHostnameWithoutDomain"
										name="dropHostnameWithoutDomain" <%if(data.dropHostnameWithoutDomain){out.print("checked");}%>>
									<label class="custom-control-label" for="dropHostnameWithoutDomain">
										<%= translate("Drop Hostname without Domain")%>
										&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("If it's on cloud, you don't need to deal with the hostname only domains.")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="dropPtrForPrivateIp"
										name="dropPtrForPrivateIp" <%if(data.dropPtrForPrivateIp){out.print("checked");}%>>
									<label class="custom-control-label" for="dropPtrForPrivateIp">
										<%= translate("Drop Reverse Lookup for Private IP")%>
										&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("If it's on cloud, you don't need to deal with the PTR queries for private IPs.")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="allowPtrForServerIp"
										name="allowPtrForServerIp" <%if(data.allowPtrForServerIp){out.print("checked");}%>>
									<label class="custom-control-label" for="allowPtrForServerIp">
										<%= translate("Allow Reverse Lookup for Server IP")%>
										&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("At default, NxFilter drops revers lookups for itself.")%>"></i>
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
			<!-- /Server Protection -->

			<!-- Request Type Control -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Allowed Request Type")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("When you add DNS request types here, only the specified types of DNS requests will be accepted. DNS request types should be added as numbers and should be separated by commas. For example, when you add '1,28,5,12', it means you only allow A, AAAA, CNAME, PTR types of DNS requests to your server.")%>"></i>
					</label>
					<textarea class="form-control" id="allowedRequestType" name="allowedRequestType"><%= data.allowedRequestType%></textarea>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Blocked Request Type")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("When you add DNS request types here, the specified types of DNS requests will be dropped. DNS request types should be added as numbers and should be separated by commas. For example, when you add '255,252', it means you block ANY, AXFR types of DNS requests to your server.")%>"></i>
					</label>
					<textarea class="form-control" id="blockedRequestType" name="blockedRequestType"><%= data.blockedRequestType%></textarea>
				</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Request Type Control -->

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
$("#upstreamDns1").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d\.]*$/.test(value);
});
$("#upstreamDns2").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d\.]*$/.test(value);
});
$("#upstreamDns3").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d\.]*$/.test(value);
});
$("#upstreamTimeout").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) <= 20;
});
$("#respCacheSize").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) <= 10000000;
});
$("#minCacheTtl").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) <= 3600;
});
$("#blockCacheTtl").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) <= 3600;
});
$("#localDns").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d\.]*$/.test(value);
});
$("#localTimeout").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) <= 20;
});
</script>
