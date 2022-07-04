<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
boolean checkParam(DnsSetupData data){
	if (!ParamTest.isValidUpstreamDnsServer(data.upstreamDns1)) {
		errList.add(translate("Invalid IP address for Upstream DNS server #1."));
		return false;
	}

	if (isNotEmpty(data.upstreamDns2) && !ParamTest.isValidUpstreamDnsServer(data.upstreamDns2)) {
		errList.add(translate("Invalid IP address for Upstream DNS server #2."));
		return false;
	}

	if (isNotEmpty(data.upstreamDns3) && !ParamTest.isValidUpstreamDnsServer(data.upstreamDns3)) {
		errList.add(translate("Invalid IP address for Upstream DNS server #3."));
		return false;
	}

	return true;
}

//-----------------------------------------------
void update(DnsSetupDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	DnsSetupData data = dao.selectOne();

	// DNS setup.	
	data.upstreamDns1 = paramString("upstreamDns1");
	data.upstreamDns2 = paramString("upstreamDns2");
	data.upstreamDns3 = paramString("upstreamDns3");
	data.upstreamTimeout = paramInt("upstreamTimeout");
	data.respCacheSize = paramInt("respCacheSize");
	data.usePersistentCache = paramBoolean("usePersistentCache");
	data.useNegativeCache = paramBoolean("useNegativeCache");
	data.minimalResponses = paramBoolean("minimalResponses");

	data.minCacheTtl = paramInt("minCacheTtl");
	data.blockCacheTtl = paramInt("blockCacheTtl");

	data.localDns = paramString("localDns");
	data.localDomain = paramString("localDomain");
	data.localTimeout = paramInt("localTimeout");
	data.useLocalDns = paramBoolean("useLocalDns");

	// DNS Over HTTPS.
	data.httpsDnsType = paramInt("httpsDnsType");
	data.httpsDnsTimeout = paramInt("httpsDnsTimeout");
	data.failsafeWithUdp53 = paramBoolean("failsafeWithUdp53");
	data.useHttpsDns = paramBoolean("useHttpsDns");

	// Validate and update it.
	if(checkParam(data) && dao.update(data)){
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
		<li class="breadcrumb-item"><%= translate("DNS")%></li>
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
				<a class="nav-link<%= tabActive0%>" data-toggle="tab" href="#tab0"><%= translate("DNS SETUP")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(1);">
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("LOCAL DNS")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(2);">
				<a class="nav-link<%= tabActive2%>" data-toggle="tab" href="#tab2"><%= translate("DNS OVER HTTPS (UPSTREAM)")%></a>
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

			<!-- DNS Setup -->
			<div class="tab-pane <%= showActive0%>" id="tab0">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Upstream DNS Server")%> #1</label>
								<input type="text" class="form-control" id="upstreamDns1" name="upstreamDns1" value="<%= data.upstreamDns1%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Upstream DNS Server")%> #2</label>
								<input type="text" class="form-control" id="upstreamDns2" name="upstreamDns2" value="<%= data.upstreamDns2%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Upstream DNS Server")%> #3</label>
								<input type="text" class="form-control" id="upstreamDns3" name="upstreamDns3" value="<%= data.upstreamDns3%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Upstream DNS Query Timeout")%></label>
								<div class="input-group">
									<input type="text" class="form-control" id="upstreamTimeout"
										name="upstreamTimeout" value="<%= data.upstreamTimeout%>">
									<div class="input-group-append">
										<span class="input-group-text"><%= translate("seconds")%>, 1 ~ 20</span>
									</div>				
								</div>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Response Cache Size")%></label>
								<div class="input-group">
									<input type="text" class="form-control" id="respCacheSize"
										name="respCacheSize" value="<%= data.respCacheSize%>">
									<div class="input-group-append">
										<span class="input-group-text">100,000 ~ 10,000,000</span>
									</div>
								</div>
<%
DecimalFormat dfmt = new DecimalFormat("###,###");
String size1 = dfmt.format(data.inMemoryCacheSize);
String size2 = dfmt.format(data.persistentCacheSize);
String size3 = dfmt.format(data.negativeCacheSize);
%>
								<small id="input-help" class="form-text text-muted">
									<%= translate("Current cache size")%> : In-memory = <%= size1%> / Persistent = <%= size2%> / Negative = <%= size3%>
								</small>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="usePersistentCache"
										name="usePersistentCache" <%if(data.usePersistentCache){out.print("checked");}%>>
									<label class="custom-control-label" for="usePersistentCache">
										<%= translate("Use Persistent Cache")%>
										&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("Keeping DNS cache in DB. When there's an upstream DNS server failure, NxFilter uses its persistent cache.")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="useNegativeCache"
										name="useNegativeCache" <%if(data.useNegativeCache){out.print("checked");}%>>
									<label class="custom-control-label" for="useNegativeCache">
										<%= translate("Use Negative Cache")%>
										&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("Keeping negative DNS responses such as Server Failure or Non-existent Domain responses up to 15 minutes.")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="minimalResponses"
										name="minimalResponses" <%if(data.minimalResponses){out.print("checked");}%>>
									<label class="custom-control-label" for="minimalResponses">
										<%= translate("Minimal Responses")%>
										&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("Sending only answer records in response for reducing DNS packet size and improving server performance")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Minimum Cache TTL")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("Manipulating TTL value for a DNS response. Bigger minimum cache TTL reduces the number of DNS queries from your clients.")%>"></i>
								</label>
								<div class="input-group">
									<input type="text" class="form-control" id="minCacheTtl"
										name="minCacheTtl" value="<%= data.minCacheTtl%>">
									<div class="input-group-append">
										<span class="input-group-text"><%= translate("seconds")%>, 0 ~ 3600, 0 = <%= translate("Bypass")%></span>
									</div>				
								</div>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Block Cache TTL")%></label>
								<div class="input-group">
									<input type="text" class="form-control" id="blockCacheTtl"
										name="blockCacheTtl" value="<%= data.blockCacheTtl%>">
									<div class="input-group-append">
										<span class="input-group-text"><%= translate("seconds")%>, 0 ~ 3600</span>
									</div>				
								</div>
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /DNS Setup -->

			<!-- Local DNS -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Local DNS Server")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("When you run another DNS server in your network, you may need to bypass some domains into the DNS server.")%>"></i>
								</label>
								<input type="text" class="form-control" id="localDns" name="localDns" value="<%= data.localDns%>">
								<small id="input-help" class="form-text text-muted">
									<%= translate("Multiple IP addresses should be separated by commas.")%>
								</small>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Local Domain")%></label>
								<input type="text" class="form-control" id="localDomain" name="localDomain" value="<%= data.localDomain%>">
								<small id="input-help" class="form-text text-muted">
									<%= translate("Multiple domains should be separated by commas.")%>
								</small>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Local DNS Query Timeout")%></label>
								<div class="input-group">
									<input type="text" class="form-control" id="localTimeout"
										name="localTimeout" value="<%= data.localTimeout%>">
									<div class="input-group-append">
										<span class="input-group-text"><%= translate("seconds")%>, 1 ~ 20</span>
									</div>				
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="useLocalDns"
										name="useLocalDns" <%if(data.useLocalDns){out.print("checked");}%>>
									<label class="custom-control-label" for="useLocalDns"><%= translate("Use Local DNS")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Local DNS -->

			<!-- DNS over HTTPS -->
			<div class="tab-pane fade<%= showActive2%>" id="tab2">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>

							<div class="form-group col-lg-8 text-secondary">
								<%= translate("This is for when you use DNS over HTTPS supporting server as your upstream server.")%>
							</div>

							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("HTTPS DNS Server")%></label>
								<select class="form-control" id="httpsDnsType" name="httpsDnsType">
									<option value="1" <%if(data.httpsDnsType == 1){out.print("selected");}%>>Cloudflare</option>
									<option value="2" <%if(data.httpsDnsType == 2){out.print("selected");}%>>Google</option>
								</select>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("HTTPS DNS Query Timeout")%></label>
								<div class="input-group">
									<input type="text" class="form-control" id="httpsDnsTimeout"
										name="httpsDnsTimeout" value="<%= data.httpsDnsTimeout%>">
									<div class="input-group-append">
										<span class="input-group-text"><%= translate("seconds")%>, 1 ~ 20</span>
									</div>				
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="failsafeWithUdp53"
										name="failsafeWithUdp53" <%if(data.failsafeWithUdp53){out.print("checked");}%>>
									<label class="custom-control-label" for="failsafeWithUdp53">
										<%= translate("Fail-safe with UDP/53")%>
										&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("Query again using UDP/53 when there's a failure with HTTPS DNS query.")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="useHttpsDns"
										name="useHttpsDns" <%if(data.useHttpsDns){out.print("checked");}%>>
									<label class="custom-control-label" for="useHttpsDns"><%= translate("Use HTTPS DNS")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /DNS over HTTPS -->

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

	return /^[\d\.:]*$/.test(value);
});
$("#upstreamDns2").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d\.:]*$/.test(value);
});
$("#upstreamDns3").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d\.:]*$/.test(value);
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

	return /^[\d\.,]*$/.test(value);
});
$("#localTimeout").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) <= 20;
});
</script>
