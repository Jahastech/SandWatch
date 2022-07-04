<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(PolicyNxProxyDao dao){
	PolicyNxProxyData data = new PolicyNxProxyData();
	data.enableFilter = paramBoolean("enableFilter");
	data.localDns = paramString("localDns");
	data.localDomain = paramString("localDomain");
	data.autoSwitchDomain = paramString("autoSwitchDomain");
	data.useAutoSwitch = paramBoolean("useAutoSwitch");

	if(dao.update(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void newAutoSwitchDomain(PolicyNxProxyDao dao){
	if(dao.newAutoSwitchDomain()){
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
PolicyNxProxyDao dao = new PolicyNxProxyDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}
if(actionFlag.equals("newAutoSwitchDomain")){
	newAutoSwitchDomain(dao);
}

// Global.
PolicyNxProxyData data = dao.selectOne();

if(isGloblist()){
	warnList.add(translate("Globlist doesn't support NxProxy."));
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("POLICY")%></li>
		<li class="breadcrumb-item text-info"><%= translate("NXPROXY")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="update">

				<div class="form-group col-lg-8 text-secondary">
					 <%= translate("NxProxy is a remote filtering agent.")%>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="enableFilter"
							name="enableFilter" <%if(data.enableFilter){out.print("checked");}%>>
						<label for="enableFilter" class="custom-control-label"><%= translate("Enable Filter")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Local Domain")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("This is for bypassing local domains from filtering. Multiple domains should be separated by spaces.")%>
								<br>&nbsp;&nbsp;ex) www.nxfilter.local *.jahastech.local"></i>
					</label>
					<textarea class="form-control" id="localDomain" name="localDomain"><%= data.localDomain%></textarea>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Local DNS Server")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("Normally you don't need this. NxProxy will find the DNS server in its network by itself.")%>"></i>
					</label>
					<input type="text" class="form-control" id="localDns" name="localDns"
						value="<%= data.localDns%>">
					<small id="input-help" class="form-text text-muted">
						<%= translate("Multiple IP addresses should be separated by commas.")%>
					</small>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Auto-switch Domain")%>
						&nbsp;<i class="fa fa-question-circle south-east" title="<%= translate("Auto-switch domain is for NxProxy to find if it's in the same network as its server."
							+ " When it finds itself in the same network as its server, it stops filtering and bypass everything to its server that is NxFilter.")%>"></i>
					</label>
					<input type="text" class="form-control" id="autoSwitchDomain" name="autoSwitchDomain"
						value="<%= data.autoSwitchDomain%>">
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="useAutoSwitch"
							name="useAutoSwitch" <%if(data.useAutoSwitch){out.print("checked");}%>>
						<label for="useAutoSwitch" class="custom-control-label"><%= translate("Use Auto-switching")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
					<button type="submit" class="btn btn-info" onclick="javascript:actionNewAutoSwitchDomain(this.form);"><%= translate("NEW AUTO-SWITCH DOMAIN")%></button>
				</div>

			</form>
		</div>
	</div>

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>

<script type="text/javascript">
//-----------------------------------------------
function actionNewAutoSwitchDomain(form){
	form.actionFlag.value = "newAutoSwitchDomain";
	form.submit();
}
</script>