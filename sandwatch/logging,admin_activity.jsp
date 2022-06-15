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
AdminActivityDao dao = new AdminActivityDao();
dao.limit = paramInt("limit", 1000);

// Set filtering option.
dao.stime = paramString("stime");
dao.etime = paramString("etime");

dao.uname = paramString("uname");
dao.cltIp = paramString("cltIp");
dao.upage = paramString("upage");
dao.action = paramString("action");

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
		<li class="breadcrumb-item text-info"><%= translate("ADMIN ACTIVITY")%></li>
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
								<th><%= translate("ID")%></th>
								<th><%= translate("Time")%></th>
								<th><%= translate("Page")%></th>
								<th><%= translate("Action")%></th>
								<th><%= translate("Name")%></th>
								<th><%= translate("Client IP")%></th>
							</tr>
						</thead>
						<tbody>
<%
List<AdminActivityData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	AdminActivityData data = dataList.get(i);
%>
							<tr>
								<td><%= data.id%></td>
								<td><%= data.getCtime()%></td>
								<td><%= data.upage%></td>
								<td><%= data.action%></td>
								<td><%= data.uname%></td>
								<td><%= data.cltIp%></td>
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
								<label class="col-form-label"><%= translate("Name")%></label>
								<input type="text" class="form-control" id="uname" name="uname" value="<%= dao.uname%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Client IP")%></label>
								<input type="text" class="form-control" id="cltIp" name="cltIp" value="<%= dao.cltIp%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Page")%></label>
								<input type="text" class="form-control" id="upage" name="upage" value="<%= dao.upage%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Action")%></label>
								<input type="text" class="form-control" id="action" name="action" value="<%= dao.action%>">
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
</script>
