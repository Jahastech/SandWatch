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

// Global.
String gUser = paramString("user");
String gUptime = new ConfigDao().getUptimeInfo();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("REPORT")%></li>
		<li class="breadcrumb-item text-info"><%= translate("USAGE")%></li>
		<li class="breadcrumb-item">Up <%= gUptime%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Form -->
<div class="container-fluid">
	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="get">
				<input type="hidden" name="actionFlag" value="search">
				<div class="form-group col-lg-8">
					<datalist id="userlist">
<%
String xtime = strftimeAdd("yyyyMMdd", 86400 * -1);
List<String> userList = new D1ReportDao(xtime, "").getLogUserList();
for(String uname : userList){
	printf("<option value='%s'>", uname);
}
%>
					</datalist>
					<label class="col-form-label"><%= translate("User")%></label>
					<input type="text" list="userlist" class="form-control" id="user" name="user" value="<%= gUser%>">
				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- /Form -->

<!-- List -->
<div id="listDiv" class="container-fluid" style="display: none;">
	<div class="m-2 expand-lg">
		<table id="list" class="cell-border hover" style="width:100%">
			<thead>
				<tr>
					<th></th>
					<th><%= translate("Time")%></th>
					<th><%= translate("Request (total / unique)")%></th>
					<th><%= translate("Block (total / unique)")%></th>
					<th><%= translate("Domain")%></th>
					<th><%= translate("User")%></th>
					<th><%= translate("Client IP")%></th>
				</tr>
			</thead>
			<tbody>
<%
for(int i = 0; i < 30; i++){
	String stime = strftimeAdd("yyyyMMdd", (86400 * i * -1) - 1);

	D1ReportDao dao = new D1ReportDao(stime, gUser);
	ReportStatsData stats = dao.getStats();
%>
				<tr>
					<td><%= dao.stime%></td>
					<td><%= dao.getStime()%></td>
					<td><%= stats.reqSum%> / <%= stats.reqCnt%></td>
					<td><%= stats.blockSum%> / <%= stats.blockCnt%></td>
					<td><%= stats.domainCnt%></td>
					<td><%= stats.userCnt%></td>
					<td><%= stats.cltIpCnt%></td>
				</tr>
<%}%>
			</tbody>
		</table>
	</div>
</div>
<!-- /List -->

<%@include file="include/footer.jsp"%>

<script>
$(document).ready(function(){
	$("#list").DataTable({
		"bFilter" : false,
		"paging" : false,
		"ordering" : false,
		"info" : true,
		"aaSorting": [[0, "desc"]],
		"columnDefs": [{
			"targets": 0,
			"visible": false,
			"searchable": false,
		}],
		"initComplete": function(settings, json){
			$("#listDiv").show();
		},
		language : langMulti,
	});
});
</script>
