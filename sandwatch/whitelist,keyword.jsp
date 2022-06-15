<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void insert(WhitelistKeywordDao dao){
	WhitelistData data = new WhitelistData();
	data.keyword = paramString("keyword");
	data.description = paramString("description");

	data.bypassAuth = paramBoolean("bypassAuth");
	data.bypassFilter = paramBoolean("bypassFilter");
	data.bypassLog = paramBoolean("bypassLog");
	data.adminBlock = paramBoolean("adminBlock");
	data.dropPacket = paramBoolean("dropPacket");

	// Param validation.
	if(isEmpty(data.keyword) || data.keyword.matches(".*\\s+.*")){
		errList.add(translate("Invalid keyword."));
		return;
	}

	if(dao.insert(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void delete(WhitelistKeywordDao dao){
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
WhitelistKeywordDao dao = new WhitelistKeywordDao();
dao.limit = 10000;

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
		<li class="breadcrumb-item"><%= translate("WHITELIST")%></li>
		<li class="breadcrumb-item text-info"><%= translate("KEYWORD")%></li>
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
								<th><%= translate("Keyword")%></th>
								<th><%= translate("Selected Options")%></th>
								<th><%= translate("Applied Policies")%></th>
								<th><%= translate("Description")%></th>
								<th></th>
							</tr>
						</thead>
						<tbody>

<%
List<WhitelistData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	WhitelistData data = dataList.get(i);
%>
							<tr>
								<td><%= data.keyword%></td>
								<td><%= data.getFlagLine()%></td>
								<td><%= data.getAppliedPolicyLine()%></td>
								<td><%= data.description%></td>
								<td>
									<i class="fa fa-pencil-square pointer-cursor" title="Edit" onclick="javascript:goEdit(<%= data.id%>)"></i>&nbsp;
									<i class="fa fa-trash pointer-cursor" title="Delete" onclick="javascript:actionDelete(<%= data.id%>, '<%= data.keyword%>')"></i>
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
								<%= translate("You can bypass or block domains by keyword matching.")%>
								<br>&nbsp;&nbsp;ex) porn, porn*site
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Keyword")%></label>
								<input type="text" class="form-control" id="keyword" name="keyword">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Description")%></label>
								<input type="text" class="form-control" id="description" name="description" >
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="bypassAuth" name="bypassAuth">
									<label for="bypassAuth" class="custom-control-label"><%= translate("Bypass Authentication")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="bypassFilter" name="bypassFilter">
									<label for="bypassFilter" class="custom-control-label"><%= translate("Bypass Filtering")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="bypassLog" name="bypassLog">
									<label for="bypassLog" class="custom-control-label"><%= translate("Bypass Logging")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="adminBlock" name="adminBlock">
									<label for="adminBlock" class="custom-control-label"><%= translate("Admin Block")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="dropPacket" name="dropPacket">
									<label for="dropPacket" class="custom-control-label"><%= translate("Drop Packet")%></label>
								</div>
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
		"pageLength": 15,
		"bLengthChange" : false,
		"columnDefs": [{
			"targets": 4,
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
	if(!confirm('<%= translate("Deleting whitelist rule")%> : ' + name)){
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
	form.action = "whitelist,keyword_edit.jsp";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
// Prevent submit again.
if(window.history.replaceState){
	window.history.replaceState(null, null, window.location.href);
}
</script>
