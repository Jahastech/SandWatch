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

// Create data access object for chart.
H2ReportDao reportDao = new H2ReportDao();
ReportStatsData stats = reportDao.getStats();
ReportChartData requestTrend = reportDao.getRequestTrend();
ReportChartData domainTop = reportDao.getDomainTop(5);
ReportChartData categoryTop = reportDao.getCategoryTop(5);

// Create data access object for blocked list.
RequestDao requestDao = new RequestDao();
requestDao.page = 1;
requestDao.limit = 50;
requestDao.stime = strftimeAdd("yyyyMMddHHmm", 60 * 60 * -12);  // 12 hours ago.
requestDao.etime = strftime("yyyyMMddHHmm");
requestDao.blockFlag = true;

if(isNewLogin() && isFreeJahaslist()){
	warnList.add(translate("We're using free Jahaslist license for 25 users."));
}

if(isNewLogin() && new JahaslistDao().selectCount() < 3000000){
	errList.add(translate("Jahaslist size is too small. You may have an incomplete update."));
}

// Message check.
checkNewMessage();

// Version check.
checkNewVersion();

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
	tabActive1 = " active";
	showActive1 = " show active";
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item text-info"><%= translate("DASHBOARD")%></li>
		<li class="breadcrumb-item"><%= reportDao.getStime()%> ~ <%= reportDao.getEtime()%></li>
		<li class="breadcrumb-item"><%= translate("DOMAIN")%> = <%= stats.domainCnt%></li>
		<li class="breadcrumb-item"><%= translate("USER")%> = <%= stats.userCnt%></li>
		<li class="breadcrumb-item"><%= translate("CLIENT IP")%> = <%= stats.cltIpCnt%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<!-- Tab -->
	<div>
		<ul class="nav nav-tabs" style="margin-left:10px; margin-right:10px;">
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(0);">
				<a class="nav-link<%= tabActive0%>" data-toggle="tab" href="#tab0"><%= translate("STATS FOR 2 HOURS")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(1);">
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("RECENT BLOCK")%></a>
			</li>
		</ul>
	</div>
	<!-- Tab -->

	<!-- Form -->
	<form action="<%= getPageName()%>" method="get">
		<input type="hidden" id="tabIdx" name="tabIdx" value="<%= tabIdx%>">

		<!-- Tab content -->
		<div id="myTabContent" class="tab-content">

			<!-- Stats for 2 hours -->
			<div class="tab-pane fade<%= showActive0%>" id="tab0">
				<div class="row m-2 expand-lg">
					<div class="card-deck">

						<div class="card" style="min-width: 600px; margin-top: 20px">
							<div class="card-body">
								<canvas id="request-trend" width="600" height="200"></canvas>
							</div>
							<div class="card-footer">
								<div class="row">
									<div class="col-md-4">
										<div class="d-flex align-items-center justify-content-md-center mb-2 mb-md-0">
											<i class="mdi mdi-flag-variant-outline icon-md mr-3 text-info"></i>
											<div>
												<p class="mb-1"><%= translate("Total Requests")%></p>
												<div class="d-flex align-items-center">
													<h4 class="mb-0 mr-2 font-weight-bold"><%= stats.reqSum%></h4>
												</div>
											</div>
										</div>
									</div>
									<div class="col-md-4">
										<div class="d-flex align-items-center justify-content-md-center mb-2 mb-md-0 mt-2 mt-md-0">
											<i class="mdi mdi-target icon-md mr-3 text-danger"></i>
											<div>
												<p class="mb-1"><%= translate("Unique Requests")%></p>
												<div class="d-flex align-items-center">
													<h4 class="mb-0 mr-2 font-weight-bold"><%= stats.reqCnt%></h4>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="card" style="min-width: 600px; margin-top: 20px">
							<div class="card-body">
								<canvas id="block-trend" width="600" height="200"></canvas>
							</div>
							<div class="card-footer">
								<div class="row">
									<div class="col-md-4">
										<div class="d-flex align-items-center justify-content-md-center mb-2 mb-md-0">
											<i class="mdi mdi-flag-variant-outline icon-md mr-3 text-info"></i>
											<div>
												<p class="mb-1"><%= translate("Total Blocks")%></p>
												<div class="d-flex align-items-center">
													<h4 class="mb-0 mr-2 font-weight-bold"><%= stats.blockSum%></h4>
												</div>
											</div>
										</div>
									</div>
									<div class="col-md-4">
										<div class="d-flex align-items-center justify-content-md-center mb-2 mb-md-0 mt-2 mt-md-0">
											<i class="mdi mdi-target icon-md mr-3 text-danger"></i>
											<div>
												<p class="mb-1"><%= translate("Unique Blocks")%></p>
												<div class="d-flex align-items-center">
													<h4 class="mb-0 mr-2 font-weight-bold"><%= stats.blockCnt%></h4>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="card" style="min-width: 600px; margin-top: 20px">
							<div class="card-body">
								<canvas id="domain-top" width="600" height="300"></canvas>
							</div>
						</div>
						<div class="card" style="min-width: 600px; margin-top: 20px">
							<div class="card-body">
								<canvas id="domain-block" width="600" height="300"></canvas>
							</div>
						</div>
						<div class="card" style="min-width: 600px; margin-top: 20px">
							<div class="card-body">
								<canvas id="category-top" width="600" height="300"></canvas>
							</div>
						</div>
						<div class="card" style="min-width: 600px; margin-top: 20px">
							<div class="card-body">
								<canvas id="category-block" width="600" height="300"></canvas>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- /Stats for 2 hours -->

			<!-- Recent block -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div id="listDiv" class="container-fluid" style="display: none;">
					<table id="list" class="cell-border hover" style="width:100%">
						<thead>
							<tr>
								<th></th>
								<th><%= translate("Time")%></th>
								<th><%= translate("Count")%></th>
								<th><%= translate("Type")%></th>
								<th><%= translate("Domain")%></th>
								<th><%= translate("User")%></th>
								<th><%= translate("Client IP")%></th>
								<th><%= translate("Group")%></th>
								<th><%= translate("Policy")%></th>
								<th><%= translate("Category")%></th>
							</tr>
						</thead>
						<tbody>
<%
List<RequestData> dataList = requestDao.selectList();

for(int i = 0; i < dataList.size(); i++){
	RequestData data = dataList.get(i);

	String categoryLine = safeSubstringWithTailingDots(data.category, 30);

	if(data.getBlockYn().equals("Y") && data.getReason().contains("category")){
		//categoryLine = "<span class='logging-category'>" + categoryLine + "</span>";
	}
%>
							<tr>
								<td><%= data.ctime%></td>
								<td><%= data.getCtime()%></td>
								<td><%= data.cnt%></td>
								<td><%= data.getTypeCode()%></td>
								<td><%= data.domain%><span class="logging-reason"><%= data.getReason()%></span></td>
								<td><%= data.user%></td>
								<td><%= data.cltIp%></td>
								<td><%= data.grp%></td>
								<td><%= data.policy%></td>
								<td title="<%= data.category%>"><%= categoryLine%></td>
							</tr>
<%}%>
						</tbody>
					</table>
				</div>
			</div>
			<!-- /Recent block -->

		</div>
		<!-- Tab content -->

	</form>
	<!-- /Form -->

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>

<script>
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
// Request trend.
<%
StringBuilder labelLine = new StringBuilder();
StringBuilder dataLine = new StringBuilder();
List<String[]> arrList = requestTrend.getDataList();
for(int i = 0; i < arrList.size(); i++){
	String[] arr = arrList.get(i);

	if(i > 0){
		labelLine.append(", ");
		dataLine.append(", ");
	}
	labelLine.append("'" + arr[0] + "'");
	dataLine.append(arr[1]);
}
%>
new Chart(document.getElementById("request-trend"), {
	type: "line",
	data: {
		labels: [<%= labelLine.toString()%>],
		datasets: [{ 
				data: [<%= dataLine.toString()%>],
				label: "",
				borderColor: "#3E95CD",
				backgroundColor: "#C1D1F0",
				fill: true
			},
		]
	},
	options: {
		maintainAspectRatio: false,
		title: {
		label: "fd",
			display: true,
			text: '<%= translate("Request trend for 2 hours")%>'
		},
		legend: {
			display: false
		},
		tooltips: {
			callbacks: {
				 label: function(tooltipItem) {
					return tooltipItem.yLabel;
				 }
			}
		}
	}
});

//-----------------------------------------------
// Block trend.
<%
labelLine = new StringBuilder();
dataLine = new StringBuilder();
arrList = requestTrend.getDataListBlocked();
for(int i = 0; i < arrList.size(); i++){
	String[] arr = arrList.get(i);

	if(i > 0){
		labelLine.append(", ");
		dataLine.append(", ");
	}
	labelLine.append("'" + arr[0] + "'");
	dataLine.append(arr[1]);
}
%>
new Chart(document.getElementById("block-trend"), {
	type: "line",
	data: {
		labels: [<%= labelLine.toString()%>],
		datasets: [{ 
				data: [<%= dataLine.toString()%>],
				label: "",
				borderColor: "#FF6464",
				backgroundColor: "#FFB2B2",
				fill: true
			},
		]
	},
	options: {
		maintainAspectRatio: false,
		title: {
		label: "fd",
			display: true,
			text: '<%= translate("Block trend for 2 hours")%>'
		},
		legend: {
			display: false
		},
		tooltips: {
			callbacks: {
				 label: function(tooltipItem) {
					return tooltipItem.yLabel;
				 }
			}
		}
	}
});

//-----------------------------------------------
// Domain top.
<%
labelLine = new StringBuilder();
dataLine = new StringBuilder();
arrList = domainTop.getDataList();
for(int i = 0; i < arrList.size(); i++){
	String[] arr = arrList.get(i);

	if(i > 0){
		labelLine.append(", ");
		dataLine.append(", ");
	}
	labelLine.append("'" + arr[0] + "'");
	dataLine.append(arr[1]);
}
%>
new Chart(document.getElementById("domain-top"), {
	type: "doughnut",
	data: {
		labels: [<%= labelLine.toString()%>],
		datasets: [{
			backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
			data: [<%= dataLine.toString()%>]
		}]
	},
	options: {
		maintainAspectRatio: false,
		title: {
			display: true,
			text: '<%= translate("Top 5 domains by request")%>'
		}
	}
});

//-----------------------------------------------
// Domain block.
<%
labelLine = new StringBuilder();
dataLine = new StringBuilder();
arrList = domainTop.getDataListBlocked();
for(int i = 0; i < arrList.size(); i++){
	String[] arr = arrList.get(i);

	if(i > 0){
		labelLine.append(", ");
		dataLine.append(", ");
	}
	labelLine.append("'" + arr[0] + "'");
	dataLine.append(arr[1]);
}
%>
new Chart(document.getElementById("domain-block"), {
	type: "pie",
	data: {
		labels: [<%= labelLine.toString()%>],
		datasets: [{
			backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
			data: [<%= dataLine.toString()%>]
		}]
	},
	options: {
		maintainAspectRatio: false,
		title: {
			display: true,
			text: '<%= translate("Top 5 domains by block")%>'
		}
	}
});

//-----------------------------------------------
// Category top.
<%
labelLine = new StringBuilder();
dataLine = new StringBuilder();
arrList = categoryTop.getDataList();
for(int i = 0; i < arrList.size(); i++){
	String[] arr = arrList.get(i);

	if(i > 0){
		labelLine.append(", ");
		dataLine.append(", ");
	}
	labelLine.append("'" + arr[0] + "'");
	dataLine.append(arr[1]);
}
%>
new Chart(document.getElementById("category-top"), {
	type: "pie",
	data: {
		labels: [<%= labelLine.toString()%>],
		datasets: [{
			backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
			data: [<%= dataLine.toString()%>]
		}]
	},
	options: {
		maintainAspectRatio: false,
		title: {
			display: true,
			text: '<%= translate("Top 5 categories by request")%>'
		}
	}
});

//-----------------------------------------------
// Category block.
<%
labelLine = new StringBuilder();
dataLine = new StringBuilder();
arrList = categoryTop.getDataListBlocked();
for(int i = 0; i < arrList.size(); i++){
	String[] arr = arrList.get(i);

	if(i > 0){
		labelLine.append(", ");
		dataLine.append(", ");
	}
	labelLine.append("'" + arr[0] + "'");
	dataLine.append(arr[1]);
}
%>
new Chart(document.getElementById("category-block"), {
	type: "doughnut",
	data: {
		labels: [<%= labelLine.toString()%>],
		datasets: [{
			backgroundColor: ["#3e95cd", "#8e5ea2","#3cba9f","#e8c3b9","#c45850"],
			data: [<%= dataLine.toString()%>]
		}]
	},
	options: {
		maintainAspectRatio: false,
		title: {
			display: true,
			text: '<%= translate("Top 5 categories by block")%>'
		}
	}
});
</script>
