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
NetflowDao dao = new NetflowDao();
dao.limit = paramInt("limit", 1000);

// Set filtering option.
dao.stime = paramString("stime");
dao.etime = paramString("etime");

if(paramString("actionFlag").equals("userSum")){
	dao.userSumFlag = true;
}
else{
	dao.user = paramString("user");
	dao.cltIp = paramString("cltIp");
	dao.srcIp = paramString("srcIp");
	dao.dstIp = paramString("dstIp");

	dao.srcPort = paramInt("srcPort");
	dao.dstPort = paramInt("dstPort");
	dao.protocol = paramInt("protocol");

	if(isNotEmpty(dao.srcIp) && !isValidIp(dao.srcIp)){
		errList.add(translate("Invalid source IP."));
	}

	if(isNotEmpty(dao.dstIp) && !isValidIp(dao.dstIp)){
		errList.add(translate("Invalid destination IP."));
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
		<li class="breadcrumb-item text-info"><%= translate("NETFLOW")%></li>
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
								<th><%= translate("User")%></th>
								<th><%= translate("Client IP")%></th>
								<th><%= translate("Size")%></th>
								<th><%= translate("Source IP")%></th>
								<th><%= translate("Source Port")%></th>
								<th><%= translate("Destination IP")%></th>
								<th><%= translate("Destination Port")%></th>
								<th><%= translate("Protocol")%></th>
							</tr>
						</thead>
						<tbody>
<%
List<NetflowData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	NetflowData data = dataList.get(i);

	// Format size.
	String fmtSize = formatFileSize(data.size);

	// For user-sum.
	if(isEmpty(data.cltIp)){
		data.cltIp = "0.0.0.0";
	}
	if(isEmpty(data.srcIp)){
		data.srcIp = "0.0.0.0";
	}
	if(isEmpty(data.dstIp)){
		data.dstIp = "0.0.0.0";
	}
%>
							<tr>
								<td><%= data.ctime%></td>
								<td><%= data.getCtime()%></td>
								<td><%= data.user%></td>
								<td><%= data.cltIp%></td>
								<td><%= fmtSize%></td>
								<td><%= data.srcIp%></td>
								<td><%= data.srcPort%></td>
								<td><%= data.dstIp%></td>
								<td><%= data.dstPort%></td>
								<td><%= data.getProtocol()%></td>
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
								<label class="col-form-label"><%= translate("User")%></label>
								<input type="text" class="form-control" id="user" name="user" value="<%= dao.user%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Client IP")%></label>
								<input type="text" class="form-control" id="cltIp" name="cltIp" value="<%= dao.cltIp%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Protocol")%></label>
								<select class="form-control" id="protocol" name="protocol">
<%
Map<String,String> protoMap = dao.getProtoMap();
for(Map.Entry<String,String> entry : protoMap.entrySet()){
	String kw = entry.getKey();
	String val = entry.getValue();

	if(kw.equals(dao.protocol+"")){
		printf("<option value='%s' selected>%s</option>", kw, val);
	}
	else{
		printf("<option value='%s'>%s</option>", kw, val);
	}
}
%>
								</select>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Source IP")%></label>
								<input type="text" class="form-control" id="srcIp" name="srcIp" value="<%= dao.srcIp%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Destination IP")%></label>
								<input type="text" class="form-control" id="dstIp" name="dstIp" value="<%= dao.dstIp%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Source Port")%></label>
								<input type="text" class="form-control" id="srcPort" name="srcPort" value="<%= dao.srcPort == 0 ? "" : dao.srcPort%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Destination Port")%></label>
								<input type="text" class="form-control" id="dstPort" name="dstPort" value="<%= dao.dstPort == 0 ? "" : dao.dstPort%>">
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
								<button type="button" class="btn btn-info" onclick="javascript:actionUserSum(this.form);"><%= translate("USER SUM")%></button>
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

//-----------------------------------------------
function actionUserSum(form){
	form.actionFlag.value = "userSum";
	form.submit();
}
</script>
