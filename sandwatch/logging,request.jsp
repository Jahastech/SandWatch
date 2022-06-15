<%@include file="include/header.jsp"%>
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
RequestDao dao = new RequestDao();
dao.limit = paramInt("limit", 1000);

// Set filtering option.
dao.stime = paramString("stime");
dao.etime = paramString("etime");

dao.domain = paramString("domain");
dao.user = paramString("user");
dao.grp = paramString("grp");

dao.cltIp = paramString("cltIp");
dao.policy = paramString("policy");
dao.category = paramString("category");
dao.blockFlag = paramBoolean("blockFlag");

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("csv")){
	String filename = "logging-request.csv";

	// Don't make it too big.
	dao.limit = 100000;
	if(dao.writeCsvFile(filename)){
		response.sendRedirect("download.jsp?filename=" + filename + "&contentType=text/csv");
		return;
	}
	else{
		errList.add(translate("Couldn't write the file."));
	}
}

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
	tabActive0 = " active";
	showActive0 = " show active";
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("LOGGING")%></li>
		<li class="breadcrumb-item text-info"><%= translate("DNS REQUEST")%></li>
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
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("SEARCH OPTIONS")%></a>
			</li>
		</ul>
	</div>
	<!-- Tab -->

	<!-- Form -->
	<form action="<%= getPageName()%>" method="post">
		<input type="hidden" name="actionFlag" value="search">
		<input type="hidden" id="tabIdx" name="tabIdx" value="<%= tabIdx%>">

		<!-- Tab content -->
		<div id="myTabContent" class="tab-content">

			<!-- List -->
			<div class="tab-pane <%= showActive0%>" id="tab0">
				<div id="loadingDiv" class="container-fluid" style="display: block;">
					<table class="cell-border hover" style="width: 100%">
						<tr height="500">
							<td width="100%" align="center" valign="center">
								<img src="img/loading.gif?<%= new Random().nextInt(10000)%>">
							</td>
						<tr>
					</table>
				</div>
				<div id="listDiv" class="container-fluid" style="display: none;">
					<table id="list" class="cell-border hover" style="width: 100%">
						<thead>
							<tr>
								<th></th>
								<th><%= translate("Time")%></th>
								<th><%= translate("Count")%></th>
								<th><%= translate("Type")%></th>
								<th><%= translate("Domain")%></th>
								<th><%= translate("User")%></th>
								<th><%= translate("Client IP")%></th>
								<th><%= translate("Group")%></th>
								<th><%= translate("Policy")%></th>
								<th><%= translate("Category")%></th>
							</tr>
						</thead>
						<tbody>
<%
List<RequestData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	RequestData data = dataList.get(i);

	String categoryLine = data.category;
	if(categoryLine.length() > 30){
		categoryLine = safeSubstring(data.category, 30) + "..";
	}

	String domainReason = "";
	if(data.getBlockYn().equals("Y")){
		domainReason = "<span class='logging-reason'>" + data.getReason() + "</span>";
	}
%>
							<tr>
								<td><%= data.ctime%></td>
								<td><%= data.getCtime()%></td>
								<td><%= data.cnt%></td>
								<td><%= data.getTypeCode()%></td>
								<td data-toggle="modal" data-target="#recatPopup" style="cursor: pointer;"
									onclick="javascript:setDomain('<%= data.domain%>')">
									<%= data.domain%> <%= domainReason%>
								</td>
								<td><%= data.user%></td>
								<td><%= data.cltIp%></td>
								<td><%= data.grp%></td>
								<td><%= data.policy%></td>
								<td title="<%= data.category%>"><%= categoryLine%></td>
							</tr>
<%}%>
						</tbody>
					</table>
				</div>
			</div>
			<!-- /List -->

			<!-- Search options -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Time")%></label>
								<div class="form-row" style="margin-left: 2px;">
									<input type="text" class="form-control col-lg-5 col-md-5" id="stime" name="stime" value="<%= dao.getStime()%>">&nbsp;~&nbsp;
									<input type="text" class="form-control col-lg-5 col-md-5" id="etime" name="etime" value="<%= dao.getEtime()%>">
								</div>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Domain")%></label>
								<input type="text" class="form-control" id="domain" name="domain" value="<%= dao.domain%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("User")%></label>
								<input type="text" class="form-control" id="user" name="user" value="<%= dao.user%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Client IP")%></label>
								<input type="text" class="form-control" id="cltIp" name="cltIp" value="<%= dao.cltIp%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Group")%></label>
								<input type="text" class="form-control" id="grp" name="grp" value="<%= dao.grp%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Policy")%></label>
								<input type="text" class="form-control" id="policy" name="policy" value="<%= dao.policy%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Category")%></label>
								<input type="text" class="form-control" id="category" name="category" value="<%= dao.category%>">
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="blockFlag"
										name="blockFlag" <%if(dao.blockFlag){out.print("checked");}%> onclick="javascript:setDefaultPort(this.form);">
									<label for="blockFlag" class="custom-control-label"><%= translate("Block Only")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Fetch Limit")%></label>
								<select class="form-control" id="limit" name="limit">
<%
for(int i = 1000; i <= 10000; i += 1000){
	if(i == dao.limit){
		printf("<option value='%s' selected>%s</option>\n", i, i);
	}
	else{
		printf("<option value='%s'>%s</option>\n", i, i);
	}
}
%>
								</select>
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
								<button type="button" class="btn btn-info" onclick="javascript:actionCsv(this.form);"><%= translate("CSV EXPORT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Search options -->

		</div>
		<!-- Tab content -->

	</form>
	<!-- /Form -->

</div>
<!-- /Main content -->

<!-- recatForm -->
<div class="modal" id="recatPopup">
<form id="recatForm" name="recatForm" method="post" action="category,system_edit.jsp">
<input type="hidden" name="actionFlag" value="addDomain">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Move Domain</h5>
				<button type="button" class="close" data-dismiss="modal" aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="form-group col-lg-11">
				<label class="col-form-label"><%= translate("Domain")%></label>
				<input type="text" class="form-control" id="domain" name="domain" value="<%= dao.domain%>">
			</div>
			<div class="form-group col-lg-11">
				<select class="form-control" id="id" name="id">
					<option value="0">Select a new category</option>
<%
List<CategoryData> catList = new CategorySystemDao().selectList();

// Add custom categories.
catList.addAll(new CategoryCustomDao().selectList());

for(CategoryData data : catList){
	printf("<option value='%s'> %s</option>", data.id, data.name);
}
%>
				</select>
			</div>
			<div class="modal-footer">
				<button type="button" id="btnRecat" class="btn btn-primary"
					onclick="javascript:recatDomain(this.form)">SUBMIT</button>
			</div>
		</div>
	</div>
</form>
</div>
<!-- /recatForm -->

<%@include file="include/footer.jsp"%>

<script>
//-----------------------------------------------
$(document).ready(function(){
	$("#list").DataTable({
		"pageLength": 15,
		"lengthMenu": [[15, 50, 100], [15, 50, 100]],
		"bLengthChange" : true,
		"aaSorting": [[0, "desc"]],
		"columnDefs": [{
			"targets": 0,
			"visible": false,
			"searchable": false,
		}],
		"initComplete": function(settings, json){
			$("#loadingDiv").hide();
			$("#listDiv").show();
		},
		language : langMulti,
	});
});

//-----------------------------------------------
var dateToDisable = new Date();

//-----------------------------------------------
jQuery("#stime").datetimepicker({
	format: "<%= getGuiDateFormatForPicker()%> H:i",
	step: 1,
	beforeShowDay: function(date) {
		if (date.getTime() > dateToDisable.getTime()) {
			return [false, ""]
		}

		return [true, ""];
	}
});

//-----------------------------------------------
jQuery("#etime").datetimepicker({
	format: "<%= getGuiDateFormatForPicker()%> H:i",
	step: 1,
	beforeShowDay: function(date) {
		if (date.getTime() > dateToDisable.getTime()) {
			return [false, ""]
		}

		return [true, ""];
	}
});

//-----------------------------------------------
function actionCsv(form){
	form.actionFlag.value = "csv";
	form.submit();
}

//-----------------------------------------------
function setDomain(domain){
	document.recatForm.reset();
	document.recatForm.domain.value = domain;
}

//-----------------------------------------------
function recatDomain(form){
	$.ajax({
		type: "POST",
		url: form.action,
		data: {
			"actionFlag": "addDomain",
			"id": form.id.value,
			"domain": form.domain.value,
		},
		success: function (data) {
			alert("Domain has been moved.");
		},
		error: function (e) {
			alert("ERROR : ", e);
		}
	});

	$("#recatPopup").modal("hide");
}
</script>
