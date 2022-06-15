<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void approve(LoginRequestDao dao){
	LoginRequestData data = new LoginRequestData();
	data.id = paramInt("id");
	data.uname = paramString("uname");

	if (ParamTest.isDupUser(data.uname)) {
		errList.add(translate("User already exists."));
		return;
	}

	if(dao.approve(data)){
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
LoginRequestDao dao = new LoginRequestDao();
dao.limit = 10000;

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("approve")){
	approve(dao);
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("USER")%></li>
		<li class="breadcrumb-item text-info"><%= translate("LOGIN REQUEST")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Form -->
<div class="container-fluid">
	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<div class="form-group col-lg-8 text-secondary">
				<%= translate("This feature requires CxLogon that is a single sign-on agent for NxFilter. When you install CxLogon on a user system, it will try to create a login session on NxFilter with the logged-in username on the system it is running on. When there's no matching username on NxFilter, it will create a login request and you can approve the request and create a new user on NxFilter.", 1000)%>
			</div>
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
					<th><%= translate("Username")%></th>
					<th><%= translate("Client IP")%></th>
					<th>OS</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
<%
List<LoginRequestData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	LoginRequestData data = dataList.get(i);
%>
				<tr>
					<td><%= data.id%></td>
					<td><%= data.getCtime()%></td>
					<td><%= data.uname%></td>
					<td><%= data.cltIp%></td>
					<td><%= data.getOsname()%></td>
					<td>
						<i class="fa fa-user-plus pointer-cursor" title="<%= translate("Approve")%>" onclick="javascript:actionApprove(<%= data.id%>, '<%= data.uname%>')"></i>
					</td>
				</tr>
<%}%>
			</tbody>
		</table>
	</div>
</div>
<!-- /List -->

<!-- goForm -->
<form name="goForm" method="get">
<input type="hidden" name="actionFlag" value="">
<input type="hidden" name="id" value="">
<input type="hidden" name="uname" value="">
</form>
<!-- /goForm -->

<%@include file="include/footer.jsp"%>

<script>
//-----------------------------------------------
$(document).ready(function(){
	$("#list").DataTable({
		"pageLength": 15,
		"bLengthChange" : false,
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

//-----------------------------------------------
function actionApprove(id, uname){
	if(!confirm('<%= translate("Approve the login request")%> : ' + uname)){
		return;
	}

	var form = document.goForm;
	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "approve";
	form.id.value = id;
	form.uname.value = uname;

	form.submit();
}
</script>
