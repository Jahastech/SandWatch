<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void insert(UserDao dao){
	UserData data = new UserData();
	data.name = paramString("name");
	data.description = paramString("description");

	// Param validation.
	if(data.name.length() < 1 || !ParamTest.isValidNameLen(data.name)){
		errList.add(translate("Name length must be between 1 and 64."));
		return;
	}
	
	if(!ParamTest.isValidUsernameChar(data.name)){
		errList.add(translate("Only alphabet, number, [.@-_] allowed in name."));
		return;
	}

	if (ParamTest.isDupUser(data.name)) {
		errList.add(translate("User already exists."));
		return;
	}

	if(dao.insert(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void delete(UserDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	if(dao.delete(paramInt("id"))){
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
UserDao dao = new UserDao();
dao.limit = 100000;

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("insert")){
	insert(dao);
}
if(actionFlag.equals("delete")){
	delete(dao);
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
		<li class="breadcrumb-item"><%= translate("USER")%></li>
		<li class="breadcrumb-item text-info"><%= translate("USER")%></li>
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
					<table id="list" class="cell-border hover" style="width:100%">
						<thead>
							<tr>
								<th></th>
								<th><%= translate("Name")%></th>
								<th>
									<%= translate("Type")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("I = IP, P = Password, L = Imported, E = Expired")%>"></i>
								</th>
								<th><%= translate("Policy")%></th>
								<th><%= translate("IP")%></th>
								<th><%= translate("Group")%></th>
								<th><%= translate("Description")%></th>
								<th></th>
							</tr>
						</thead>
						<tbody>
<%
List<UserData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	UserData data = dataList.get(i);

	String nameStyle = "";
	if(data.getType().equals("E")){
		nameStyle = "text-decoration:line-through;";
	}

	// Add free-time policy.
	if(!isEmpty(data.ftPolicyName)){
		data.policyName += " / " + data.ftPolicyName;
	}
%>
							<tr>
								<td><%= data.token%></td>
								<td style="<%= nameStyle%>"><%= data.name%></td>
								<td><%= data.getType()%></td>
								<td><%= data.policyName%></td>
								<td><%= safeSubstringWithTailingDots(data.getIpLine(), 45)%></td>
								<td><%= safeSubstringWithTailingDots(data.getGroupLine(), 45)%></td>
								<td><%= data.description%></td>
								<td>
									<i class="fa fa-pencil-square pointer-cursor" title="<%= translate("Edit")%>" onclick="javascript:goEdit(<%= data.id%>)"></i>&nbsp;
									<i class="fa fa-trash pointer-cursor" title="<%= translate("Delete")%>" onclick="javascript:actionDelete(<%= data.id%>, '<%= data.name%>')"></i>
									<i class="fa fa-eye pointer-cursor" title="<%= translate("Test")%>" onclick="javascript:goTest('<%= data.name%>')"></i>&nbsp;
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
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Name")%></label>
								<input type="text" class="form-control" id="name" name="name">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Description")%></label>
								<input type="text" class="form-control" id="description" name="description" >
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
<input type="hidden" name="name" value="">
</form>
<!-- /goForm -->

<%@include file="include/footer.jsp"%>

<script>
//-----------------------------------------------
$(document).ready(function(){
	$("#list").DataTable({
		"pageLength": 15,
		"bLengthChange" : false,
		"aaSorting": [[1, "asc"]],
		"autoWidth" : false,
		"columnDefs": [{
			"targets": 7,
			"width": "50"
		}],
		"columnDefs": [{
			"targets": 0,
			"searchable": true,
			"visible": false
		}],
		"initComplete": function(settings, json){
			$("#loadingDiv").hide();
			$("#listDiv").show();
		},
		language : langMulti,
	});
});

//-----------------------------------------------
function actionDelete(id, name){
	if(!confirm('<%= translate("Deleting user")%> : ' + name)){
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
	form.action = "user,user_edit.jsp";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
function goTest(name){
	var form = document.goForm;
	form.action = "user,user_test.jsp";
	form.name.value = name;
	form.submit();
}

//-----------------------------------------------
// Prevent submit again.
if(window.history.replaceState){
	window.history.replaceState(null, null, window.location.href);
}
</script>
