<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void insert(ZoneFileDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	ZoneFileData data = new ZoneFileData();
	data.domain = paramString("domain");
	data.description = paramString("description");

	if (isEmpty(data.domain)) {
		errList.add(translate("Domain missing."));
		return;
	}

	if (ParamTest.isDupZoneFile(data.domain)) {
		errList.add(translate("Zone file already exists."));
		return;
	}

	if(dao.insert(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void delete(ZoneFileDao dao){
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
ZoneFileDao dao = new ZoneFileDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("insert")){
	insert(dao);
}
if(actionFlag.equals("delete")){
	delete(dao);
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("DNS")%></li>
		<li class="breadcrumb-item text-info"><%= translate("ZONE FILE")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Form -->
<div class="container-fluid">
	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="insert">

				<div class="form-group col-lg-8 text-secondary">
					 <%= translate("You can run NxFilter as an authoritative DNS server.")%>
				</div>
				
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Domain")%></label>
					<input type="text" class="form-control" id="domain" name="domain">
					<small id="input-help" class="form-text text-muted">ex) example.com, 0.168.192.in-addr.arpa</small>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Description")%></label>
					<input type="text" class="form-control" id="ip" name="description">
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
					<th><%= translate("Domain")%></th>
					<th><%= translate("Description")%></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
<%
List<ZoneFileData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	ZoneFileData data = dataList.get(i);
%>
				<tr>
					<td><%= data.domain%></td>
					<td><%= data.description%></td>
					<td>
						<i class="fa fa-pencil-square pointer-cursor" title="<%= translate("Edit")%>" onclick="javascript:goEdit(<%= data.id%>)"></i>&nbsp;
						<i class="fa fa-trash pointer-cursor" title="<%= translate("Delete")%>" onclick="javascript:actionDelete(<%= data.id%>, '<%= data.domain%>')"></i>
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
</form>
<!-- /goForm -->

<%@include file="include/footer.jsp"%>

<script>
$(document).ready(function(){
	$("#list").DataTable({
		"bFilter" : false,
		"paging" : false,
		"ordering" : false,
		"info" : true,
//		"dom": "<'top'if>rt<'bottom'p>"
		"columnDefs": [{
			"targets": 2,
			"width": "50"
		}],
		"initComplete": function(settings, json){
			$("#listDiv").show();
		},
		language : langMulti,
	});
});

//-----------------------------------------------
function actionDelete(id, domain){
	if(!confirm('<%= translate("Deleting zone file")%> : ' + domain)){
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
	form.action = "dns,zone_file_edit.jsp";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
// Prevent submit again.
if(window.history.replaceState){
	window.history.replaceState(null, null, window.location.href);
}
</script>
