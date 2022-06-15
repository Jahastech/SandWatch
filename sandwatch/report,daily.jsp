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

// If there's a user it becomes user specific report.
String stime = paramString("stime");
String user = paramString("user");

// Create data access object.
D1ReportDao dao = new D1ReportDao(stime, user);
ReportStatsData stats = dao.getStats();
ReportChartData requestTrend = dao.getRequestTrend();
ReportChartData domainTop = dao.getDomainTop(5);
ReportChartData categoryTop = dao.getCategoryTop(5);
ReportChartData userTop = dao.getUserTop(5);
ReportChartData cltIpTop = dao.getCltIpTop(5);

// Global.
String gUser = paramString("user");

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
		<li class="breadcrumb-item"><%= translate("REPORT")%></li>
		<li class="breadcrumb-item text-info"><%= translate("DAILY")%></li>
		<li class="breadcrumb-item"><%= dao.getStime()%></li>
		<li class="breadcrumb-item"><%= translate("DOMAIN")%> = <%= stats.domainCnt%></li>
		<li class="breadcrumb-item"><%= translate("USER")%> = <%= stats.userCnt%></li>
		<li class="breadcrumb-item"><%= translate("CLIENT IP")%> = <%= stats.cltIpCnt%></li>

<%if(isNotEmpty(gUser)){%>
		<li class="breadcrumb-item text-warning"><%= gUser%></li>
<%}%>

	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<!-- Tab -->
	<div>
		<ul class="nav nav-tabs" style="margin-left:10px; margin-right:10px;">
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(0);">
				<a class="nav-link<%= tabActive0%>" data-toggle="tab" href="#tab0"><%= translate("STATS FOR 1 DAY")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(1);">
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("SEARCH OPTIONS")%></a>
			</li>
		</ul>
	</div>
	<!-- Tab -->

	<!-- Form -->
	<form action="<%= getPageName()%>" method="get">
		<input type="hidden" id="tabIdx" name="tabIdx" value="<%= tabIdx%>">
		<input type="hidden" name="actionFlag" value="search">

		<!-- Tab content -->
		<div id="myTabContent" class="tab-content">

			<!-- Stats for 1 day -->
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

<%if(isEmpty(gUser)){%>
						<div class="card" style="min-width: 600px; margin-top: 20px">
							<div class="card-body">
								<canvas id="user-top" width="600" height="300"></canvas>
							</div>
						</div>
						<div class="card" style="min-width: 600px; margin-top: 20px">
							<div class="card-body">
								<canvas id="user-block" width="600" height="300"></canvas>
							</div>
						</div>
						<div class="card" style="min-width: 600px; margin-top: 20px">
							<div class="card-body">
								<canvas id="clt-ip-top" width="600" height="300"></canvas>
							</div>
						</div>
						<div class="card" style="min-width: 600px; margin-top: 20px">
							<div class="card-body">
								<canvas id="clt-ip-block" width="600" height="300"></canvas>
							</div>
						</div>
<%}%>


					</div>
				</div>
			</div>
			<!-- /Stats for 1 day -->

			<!-- Search options -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Report Day")%></label>
								<input type="text" class="form-control" id="stime" name="stime" value="<%= dao.getStime()%>">
							</div>
							<div class="form-group col-lg-8">
								<datalist id="userlist">
<%
List<String> userList = dao.getLogUserList();
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
			text: '<%= translate("Request trend for 1 day")%>'
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
			text: '<%= translate("Block trend for 1 day")%>'
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

//-----------------------------------------------
// User top.
<%
labelLine = new StringBuilder();
dataLine = new StringBuilder();
arrList = userTop.getDataList();
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
new Chart(document.getElementById("user-top"), {
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
			text: '<%= translate("Top 5 users by request")%>'
		}
	}
});

//-----------------------------------------------
// User block.
<%
labelLine = new StringBuilder();
dataLine = new StringBuilder();
arrList = userTop.getDataListBlocked();
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
new Chart(document.getElementById("user-block"), {
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
			text: '<%= translate("Top 5 users by block")%>'
		}
	}
});

//-----------------------------------------------
// Client IP top.
<%
labelLine = new StringBuilder();
dataLine = new StringBuilder();
arrList = cltIpTop.getDataList();
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
new Chart(document.getElementById("clt-ip-top"), {
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
			text: '<%= translate("Top 5 client IPs by request")%>'
		}
	}
});

//-----------------------------------------------
// Client IP block.
<%
labelLine = new StringBuilder();
dataLine = new StringBuilder();
arrList = cltIpTop.getDataListBlocked();
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
new Chart(document.getElementById("clt-ip-block"), {
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
			text: '<%= translate("Top 5 client IPs by block")%>'
		}
	}
});

//-----------------------------------------------
var dateToDisable = new Date();

//-----------------------------------------------
jQuery("#stime").datetimepicker({
	timepicker: false,
	format: "<%= getGuiDateFormatForPicker()%>",
	beforeShowDay: function(date) {
		if (date.getTime() > dateToDisable.getTime()) {
			return [false, ""]
		}

		return [true, ""];
	}
});
</script>
