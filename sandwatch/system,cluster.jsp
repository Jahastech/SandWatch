<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(ClusterDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	ClusterData data = new ClusterData();
	data.clusterMode = paramInt("clusterMode");
	data.masterIp = paramString("masterIp");
	data.slaveIp = paramString("slaveIp");

	String[] arr = data.slaveIp.split(",");
	if(arr.length > 1 && isGloblist()){
		errList.add(translate("Globlist supports only one slave node."));
		return;
	}

	if(dao.update(data)){
		succList.add(translate("Update finished."));
		warnList.add(translate("Restart is required to apply new settings."));
	}
}

//-----------------------------------------------
void delete(ClusterDao dao){
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
ClusterDao dao = new ClusterDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}
if(actionFlag.equals("delete")){
	delete(dao);
}

// Global.
ClusterData data = dao.selectOne();
int gNodeCount = dao.selectCount();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("SYSTEM")%></li>
		<li class="breadcrumb-item text-info"><%= translate("CLUSTERING")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Form -->
<div class="container-fluid">
	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="update">
					<div class="form-group col-lg-8">
						<label class="col-form-label"><%= translate("Run Mode")%></label>
						<select class="form-control" id="clusterMode" name="clusterMode" onchange="javascript:setClusterMode(this.form);">
							<option value="0" <%if(data.clusterMode == 0){out.print("selected");}%>><%= translate("Stand-alone Server")%></option>
							<option value="1" <%if(data.clusterMode == 1){out.print("selected");}%>><%= translate("Run as Master")%></option>
							<option value="2" <%if(data.clusterMode == 2){out.print("selected");}%>><%= translate("Run as Slave")%></option>
						</select>
					</div>
					<div class="form-group col-lg-8">
						<label class="col-form-label"><%= translate("Master IP")%></label>
						<input type="text" class="form-control" id="masterIp" name="masterIp" value="<%= data.masterIp%>">
					</div>
					<div class="form-group col-lg-8">
						<label class="col-form-label">
							<%= translate("Slave IP")%>
							&nbsp;<i class="fa fa-question-circle south-east"
								title="<%= translate("IP based access control for slave node. You can add up to 4 IP addresses separated by commas.")%>"></i>
						</label>
						<input type="text" class="form-control" id="slaveIp" name="slaveIp" value="<%= data.slaveIp%>">
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
					<th><%= translate("Node")%></th>
					<th><%= translate("Last Contact")%></th>
					<th><%= translate("Request")%></th>
					<th><%= translate("Block")%></th>
					<th><%= translate("User")%></th>
					<th><%= translate("Client IP")%></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
<%
List<NodeData> dataList = dao.selectList();

for(int i = 0; i < dataList.size(); i++){
	NodeData nd = dataList.get(i);
%>
				<tr>
					<td><%= nd.nodeIp%></td>
					<td><%= nd.getAtime()%></td>
					<td><%= nd.reqCnt%></td>
					<td><%= nd.blockCnt%></td>
					<td><%= nd.userCnt%></td>
					<td><%= nd.cltIpCnt%></td>
					<td>
						<i class="fa fa-trash pointer-cursor" title="Delete" onclick="javascript:actionDelete(<%= nd.id%>, '<%= nd.nodeIp%>')"></i>
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
function setClusterMode(form){
	var val = form.clusterMode.value;

	if(val == 0){
		form.masterIp.value = "";
		form.masterIp.disabled = true;

		form.slaveIp.value = "";
		form.slaveIp.disabled = true;
	}
	else if(val == 1){
		form.masterIp.value = "";
		form.masterIp.disabled = true;

		form.slaveIp.disabled = false;
	}
	else if(val == 2){
		form.slaveIp.value = "";
		form.slaveIp.disabled = true;

		form.masterIp.disabled = false;
	}
}

//-----------------------------------------------
function actionDelete(id, nodeIp){
	if(!confirm('<%= translate("Deleting node stats")%> : ' +  nodeIp)){
		return;
	}

	var form = document.goForm;
	form.actionFlag.value = "delete";
	form.id.value = id;
	form.submit();
}

setClusterMode(document.forms[0]);

//-----------------------------------------------
// Prevent submit again.
if(window.history.replaceState){
	window.history.replaceState(null, null, window.location.href);
}
</script>
