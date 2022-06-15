<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void insert(ZoneTransferDao dao){
	ZoneTransferData data = new ZoneTransferData();
	data.id = paramInt("id");
	data.domain = paramString("domain");
	data.ip = paramString("ip");

	if (isEmpty(data.domain)) {
		errList.add(translate("Domain missing."));
		return;
	}

	if (!isValidIp(data.ip)) {
		errList.add(translate("Invalid DNS server IP."));
		return;
	}

	if(dao.insert(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void delete(ZoneTransferDao dao){
	if(dao.delete(paramInt("id"))){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void test(ZoneTransferDao dao){
	try{
		dao.test(paramInt("id"));
		succList.add("It worked.");
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
ZoneTransferDao dao = new ZoneTransferDao();

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
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("DNS")%></li>
		<li class="breadcrumb-item text-info"><%= translate("ZONE TRANSFER")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Form -->
<div class="container-fluid">
	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="insert">
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Domain")%></label>
					<input type="text" class="form-control" id="domain" name="domain">
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("DNS Server IP")%></label>
					<input type="text" class="form-control" id="ip" name="ip">
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
					<th><%= translate("DNS Server IP")%></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
<%
List<ZoneTransferData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	ZoneTransferData data = dataList.get(i);
%>
				<tr>
					<td><%= data.domain%></td>
					<td><%= data.ip%></td>
					<td>
						<i class="fa fa-trash pointer-cursor" title="<%= translate("Delete")%>" onclick="javascript:actionDelete(<%= data.id%>, '<%= data.domain%>')"></i>
						<i class="fa fa-plug pointer-cursor" title="<%= translate("Test")%>" onclick="javascript:goTest(<%= data.id%>)"></i>&nbsp;
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

$("#ip").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d\.]*$/.test(value);
});

//-----------------------------------------------
function actionDelete(id, domain){
	if(!confirm('<%= translate("Deleting zone transfer setup")%> : ' + domain)){
		return;
	}

	var form = document.goForm;
	form.actionFlag.value = "delete";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
function goTest(id){
	var form = document.goForm;
	form.actionFlag.value = "test";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
// Prevent submit again.
if(window.history.replaceState){
	window.history.replaceState(null, null, window.location.href);
}
</script>
