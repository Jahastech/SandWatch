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
ClassifiedDao dao = new ClassifiedDao();
dao.limit = 1000;
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("CLASSIFIER")%></li>
		<li class="breadcrumb-item text-info"><%= translate("CLASSIFIED")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Form -->
<div class="container-fluid">
	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<div class="form-group col-lg-8 text-secondary">
				<%= translate("You can review the dynamic classification result log.")%>
			</div>
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
					<th></th>
					<th><%= translate("Time")%></th>
					<th><%= translate("Domain")%></th>
					<th><%= translate("Category")%></th>
					<th><%= translate("Reason")%></th>
				</tr>
			</thead>
			<tbody>
<%
List<ClassifiedData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	ClassifiedData data = dataList.get(i);

	String reason = safeSubstringWithTailingDots(data.reason, 130);
%>
				<tr>
					<td><%= data.id%></td>
					<td><%= data.getCtime()%></td>
					<td><%= data.domain%></td>
					<td><%= data.categoryName%></td>
					<td><%= reason%></td>
				</tr>
<%}%>
			</tbody>
		</table>
	</div>
</div>
<!-- /List -->

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
			$("#listDiv").show();
		},
		language : langMulti,
	});
});
</script>
