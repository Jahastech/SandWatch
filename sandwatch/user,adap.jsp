<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void insert(AdapDao dao){
	AdapData data = new AdapData();
	data.host = paramString("host");
	data.admin = paramString("admin");
	data.passwd = paramString("passwd");
	data.basedn = paramString("basedn");
	data.domain = paramString("domain");
	data.period = paramInt("period");

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

	if(dao.insert(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void delete(AdapDao dao){
	if(dao.delete(paramInt("id"))){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void test(AdapDao dao){
	try{
		dao.test(paramInt("id"));
		succList.add(translate("LDAP connection succeeded."));
	}
	catch(Exception e){
		errList.add(e.toString());
	}
}

//-----------------------------------------------
void importLdap(AdapDao dao){
	try{
		String res = dao.importLdap(paramInt("id"));
		succList.add(res);
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
AdapDao dao = new AdapDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("insert")){
	insert(dao);
}
if(actionFlag.equals("delete")){
	delete(dao);
}
if(actionFlag.equals("test")){
	test(dao);
}
if(actionFlag.equals("importLdap")){
	importLdap(dao);
}

// Global.
int gCount = dao.selectCount();

// Active tab.
String tabActive0 = "";
String tabActive1 = "";

String showActive0 = "";
String showActive1 = "";

// Reset tabIdx.
int tabIdx = 0;

// If there's an error while creating a new data, stay with the create form.
String g_host = "";
String g_admin = "";
String g_basedn = "";
String g_domain = "";
if(actionFlag.equals("insert") && errList.size() > 0){
	g_host = paramString("host");
	g_admin = paramString("admin");
	g_basedn = paramString("basedn");
	g_domain = paramString("domain");
	tabIdx = 1;
}

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
		<li class="breadcrumb-item text-info"><%= translate("ACTIVE DIRECTORY")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<!-- Tab -->
	<div>
		<ul class="nav nav-tabs" style="margin-left:10px; margin-right:10px;">
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(0);">
				<a class="nav-link<%= tabActive0%>" data-toggle="tab" href="#tab0"><%= translate("LIST")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(1);">
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("CREATE")%></a>
			</li>
		</ul>
	</div>
	<!-- Tab -->

	<!-- Form -->
	<form action="<%= getPageName()%>" method="post">
		<input type="hidden" name="actionFlag" value="insert">
		<input type="hidden" id="tabIdx" name="tabIdx" value="<%= tabIdx%>">

		<!-- Tab content -->
		<div id="myTabContent" class="tab-content">

			<!-- List -->
			<div class="tab-pane <%= showActive0%>" id="tab0">
				<div id="listDiv" class="container-fluid" style="display: none;">
					<table id="list" class="cell-border hover" style="width:100%">
						<thead>
							<tr>
								<th><%= translate("Host")%></th>
								<th><%= translate("Admin")%></th>
								<th><%= translate("Base DN")%></th>
								<th><%= translate("Domain")%></th>
								<th><%= translate("Auto-sync")%></th>
								<th></th>
							</tr>
						</thead>
						<tbody>
<%
List<LdapData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	AdapData data = (AdapData)dataList.get(i);
%>
							<tr>
								<td><%= data.host%></td>
								<td><%= data.admin%></td>
								<td><%= data.basedn%></td>
								<td><%= data.domain%></td>
								<td><%= getLdapPeriodStr(data.period)%></td>
								<td>
									<i class="fa fa-pencil-square pointer-cursor" title="<%= translate("Edit")%>" onclick="javascript:goEdit(<%= data.id%>)"></i>&nbsp;
									<i class="fa fa-trash pointer-cursor" title="<%= translate("Delete")%>" onclick="javascript:actionDelete(<%= data.id%>, '<%= data.host%>')"></i>
									<i class="fa fa-plug pointer-cursor" title="<%= translate("Test")%>" onclick="javascript:actionTest('<%= data.id%>')"></i>&nbsp;
									<i class="fa fa-user-plus pointer-cursor" title="<%= translate("Import")%>" onclick="javascript:actionImport('<%= data.id%>')"></i>&nbsp;
								</td>
							</tr>
<%}%> 
						</tbody>
					</table>
				</div>
			</div>
			<!-- /List -->

			<!-- CREATE -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8 text-secondary">
								<%= translate("You can import users and groups from Active Directory through LDAP connection.", 1000)%>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Host")%></label>
								<input type="text" class="form-control" id="host" name="host" value="<%= g_host%>">
								<small id="input-help" class="form-text text-muted">ex) 192.168.0.100</small>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Admin")%>
									&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("LDAP username having enough permission to fetch users and groups.")%>"></i>
								</label>
								<input type="text" class="form-control" id="admin" name="admin" value="<%= g_admin%>">
								<small id="input-help" class="form-text text-muted">ex) Administrator@nxfilter.local</small>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Password")%></label>
								<input type="password" class="form-control" id="passwd"
									name="passwd">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Base DN")%></label>
								<input type="text" class="form-control" id="basedn" name="basedn" value="<%= g_basedn%>">
								<small id="input-help" class="form-text text-muted">ex) cn=users,dc=nxfilter,dc=local</small>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Domain")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("The domain you want to bypass to Active Directory MS DNS server.")%>"></i>
								</label>
								<input type="text" class="form-control" id="domain" name="domain" value="<%= g_domain%>">
								<small id="input-help" class="form-text text-muted">ex) nxfilter.local</small>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Auto-sync")%></label>
								<select class="form-control" id="period" name="period">
<%
Map<Integer, String> periodMap = getLdapPeriodMap();
for(Map.Entry<Integer, String> entry : periodMap.entrySet()){
	Integer key = entry.getKey();
	String val = entry.getValue();

	printf("<option value='%s'>%s</option>", key, translate(val));
}
%>
								</select>
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /CREATE -->

		</div>
		<!-- Tab content -->

	</form>
	<!-- /Form -->

</div>
<!-- /Main content -->

<!-- goForm -->
<form action="<%= getPageName()%>" name="goForm" method="get">
<input type="hidden" name="actionFlag" value="">
<input type="hidden" name="id" value="">
</form>
<!-- /goForm -->

<%@include file="include/footer.jsp"%>

<script>
//-----------------------------------------------
$(document).ready(function(){
	$("#list").DataTable({
		"bFilter" : false,
		"paging" : false,
		"ordering" : false,
		"info" : true,
		"autoWidth" : false,
		"columnDefs": [{
			"targets": 5,
			"width": "80"
		}],
		"initComplete": function(settings, json){
			$("#listDiv").show();
		},
		language : langMulti,
	});
});

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

//-----------------------------------------------
function actionDelete(id, host){
	if(!confirm('<%= translate("Deleting Active Directory setup")%> : ' + host
		+ '\n<%= translate("All the users and groups associated to the host will be lost.")%>')){

		return;
	}

	var form = document.goForm;
	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "delete";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
function goEdit(id){
	var form = document.goForm;
	form.action = "user,adap_edit.jsp";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
function actionTest(id){
	var form = document.goForm;
	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "test";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
function actionImport(id){
	var form = document.goForm;
	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "importLdap";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
// Prevent submit again.
if(window.history.replaceState){
	window.history.replaceState(null, null, window.location.href);
}
</script>
