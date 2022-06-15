<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void insert(FreeTimeDao dao){
	String stimeHh = paramString("stimeHh");
	String stimeMm = paramString("stimeMm");
	String etimeHh = paramString("etimeHh");
	String etimeMm = paramString("etimeMm");

	FreeTimeData data = new FreeTimeData();
	data.stime = stimeHh + stimeMm;
	data.etime = etimeHh + etimeMm;
	data.wdayArr = paramArray("wdayArr");
	data.description = paramString("description");

	if(dao.insert(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void delete(FreeTimeDao dao){
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
FreeTimeDao dao = new FreeTimeDao();

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
		<li class="breadcrumb-item"><%= translate("POLICY")%></li>
		<li class="breadcrumb-item text-info"><%= translate("FREE TIME")%></li>
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
								<label class="col-form-label"><%= translate("Time")%></label>
								<div class="form-row" style="margin-left: 2px;">
<%
List<String> hhList = getHhList();
List<String> mmList = getMmList();
%>
									<select class="form-control col-lg-1 col-md-1" id="stimeHh" name="stimeHh">
<%
for(String hh : hhList){
	printf("<option value='%s'>%s</option>", hh, hh);
}
%>
									</select>&nbsp;

									<select class="form-control col-lg-1 col-md-1" id="stimeMm" name="stimeMm">
<%
for(String mm : mmList){
	printf("<option value='%s'>%s</option>", mm, mm);
}
%>
									</select>&nbsp;~&nbsp;

									<select class="form-control col-lg-1 col-md-1" id="etimeHh" name="etimeHh">
<%
for(String hh : hhList){
	printf("<option value='%s'>%s</option>", hh, hh);
}
%>
									</select>&nbsp;

									<select class="form-control col-lg-1 col-md-1" id="etimeMm" name="etimeMm">
<%
for(String mm : mmList){
	printf("<option value='%s'>%s</option>", mm, mm);
}
%>
									</select>
								</div>
							</div>

					<div class="form-group col-lg-8">
						<label class="col-form-label"><%= translate("Day of Week")%></label>
						<select class="form-control" id="wdayArr" name="wdayArr" multiple>
							<option value="2"><%= translate("Monday")%></option>
							<option value="3"><%= translate("Tuesday")%></option>
							<option value="4"><%= translate("Wednesday")%></option>
							<option value="5"><%= translate("Thursday")%></option>
							<option value="6"><%= translate("Friday")%></option>
							<option value="7"><%= translate("Saturday")%></option>
							<option value="1"><%= translate("Sunday")%></option>
						</select>
					</div>

					<div class="form-group col-lg-8">
						<label class="col-form-label"><%= translate("Description")%></label>
						<input type="text" class="form-control" id="description" name="description">
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
					<th><%= translate("Time")%></th>
					<th><%= translate("Day of Week")%></th>
					<th><%= translate("Description")%></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
<%
List<FreeTimeData> dataList = dao.selectList();

for(int i = 0; i < dataList.size(); i++){
	FreeTimeData data = dataList.get(i);
%>
				<tr>
					<td><%= data.stime%> ~ <%= data.etime%></td>
					<td><%= data.getWdayLine()%></td>
					<td><%= data.description%></td>
					<td>
						<i class="fa fa-trash pointer-cursor" title="<%= translate("Delete")%>" onclick="javascript:actionDelete(<%= data.id%>)"></i>
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
function actionDelete(id){
	if(!confirm('<%= translate("Deleting a free-time slot?")%>')){
		return;
	}

	var form = document.goForm;
	form.actionFlag.value = "delete";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
// Prevent submit again.
if(window.history.replaceState){
	window.history.replaceState(null, null, window.location.href);
}
</script>
