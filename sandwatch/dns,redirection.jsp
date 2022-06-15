<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void insert(RedirectionDao dao){
	RedirectionData data = new RedirectionData();
	data.src = paramString("src");
	data.dst = paramString("dst");

	if (isEmpty(data.src)) {
		errList.add(translate("Source domain missing."));
		return;
	}

	if (isEmpty(data.dst) || data.dst.indexOf('.') == -1) {
		errList.add(translate("Invalid IP or domain."));
		return;
	}

	if(dao.insert(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void delete(RedirectionDao dao){
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
RedirectionDao dao = new RedirectionDao();

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
		<li class="breadcrumb-item text-info"><%= translate("REDIRECTION")%></li>
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
					<%= translate("DNS level redirection. You can set domain to IP or domain to domain redirection.")%>
				</div>

				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Domain")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("You can use a wildcard domain here.")%>
								<br>&nbsp;&nbsp;ex) *.nxfilter.org"></i>
					</label>
					<input type="text" class="form-control" id="src" name="src">
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("IP")%> / <%= translate("Domain")%></label>
					<input type="text" class="form-control" id="dst" name="dst">
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
					<th><%= translate("IP")%> / <%= translate("Domain")%></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
<%
List<RedirectionData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	RedirectionData data = dataList.get(i);
%>
				<tr>
					<td><%= data.src%></td>
					<td><%= data.dst%></td>
					<td>
						<i class="fa fa-trash pointer-cursor" title="<%= translate("Delete")%>" onclick="javascript:actionDelete(<%= data.id%>, '<%= data.src%>')"></i>
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
	if(!confirm('<%= translate("Deleting redirection rule")%> : ' +  domain)){
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
