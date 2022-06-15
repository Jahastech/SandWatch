<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void insert(PolicyDao dao){
	PolicyData data = new PolicyData();
	data.name = paramString("name");
	data.description = paramString("description");
	data.copyId = paramInt("copyId");

	// Param validation.
	if(!ParamTest.isValidNameLen(data.name)){
		errList.add(translate("Name length must be between 1 and 64."));
		return;
	}
	
	if(!ParamTest.isValidNameChar(data.name)){
		errList.add(translate("Only alphabet, number, [-_] allowed in policy name."));
		return;
	}

	if (ParamTest.isDupPolicy(data.name)) {
		errList.add(translate("Policy already exists."));
		return;
	}

	if(dao.insert(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void delete(PolicyDao dao){
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
PolicyDao dao = new PolicyDao();
dao.limit = 10000;

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("insert")){
	insert(dao);
}
if(actionFlag.equals("delete")){
	delete(dao);
}

// Global.
Map<Integer, String> policyIdNameMap = dao.getPolicyIdNameMap();

if (dao.selectCount() > 3 && new CategorySystemDao().getBlacklistType() == 8) {
	warnList.add(translate("Globlist supports up to 3 policies. The policies except the first 3 ones will be replaced by default policy."));
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
		<li class="breadcrumb-item"><%= translate("POLICY")%></li>
		<li class="breadcrumb-item text-info"><%= translate("POLICY")%></li>
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
								<th><%= translate("Name")%></th>
								<th><%= translate("Priority Points")%></th>
								<th><%= translate("Description")%></th>
								<th></th>
							</tr>
						</thead>
						<tbody>
<%
List<PolicyData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	PolicyData data = dataList.get(i);

	if(data.systemFlag){
		data.name = "*" + data.name;
	}
%>
							<tr>
								<td><%= data.name%></td>
								<td><%= data.points%></td>
								<td><%= data.description%></td>
								<td>
									<i class="fa fa-pencil-square pointer-cursor" title="<%= translate("Edit")%>" onclick="javascript:goEdit(<%= data.id%>)"></i>&nbsp;
									<i class="fa fa-trash pointer-cursor" title="<%= translate("Delete")%>" onclick="javascript:actionDelete(<%= data.id%>, '<%= data.name%>')"></i>
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
								<label class="col-form-label"><%= translate("Template Policy")%></label>
								<select class="form-control" id="copyId" name="copyId">
									<option value="0"><%= translate("SELECT POLICY")%></option>
<%
for(Map.Entry<Integer, String> e: policyIdNameMap.entrySet()){
	printf("<option value='%s'>%s</option>", e.getKey(), e.getValue());
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
		"columnDefs": [{
			"targets": 3,
			"width": "50"
		}],
		"initComplete": function(settings, json){
			$("#listDiv").show();
		},
		language : langMulti,
	});
});

//-----------------------------------------------
function actionDelete(id, name){
	if(!confirm('<%= translate("Deleting policy")%> : ' + name)){
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
	form.action = "policy,policy_edit.jsp";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
// Prevent submit again.
if(window.history.replaceState){
	window.history.replaceState(null, null, window.location.href);
}
</script>
