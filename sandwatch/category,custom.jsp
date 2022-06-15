<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void insert(CategoryCustomDao dao){
	CategoryData data = new CategoryData();
	data.name = paramString("name");
	data.description = paramString("description");

	// Param validation.
	if(!ParamTest.isValidNameLen(data.name)){
		errList.add(ParamTest.ERR_NAME_LEN);
		return;
	}
	
	if(!ParamTest.isValidUsernameChar(data.name)){
		errList.add(ParamTest.ERR_NAME_CHAR);
		return;
	}

	if(dao.insert(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void delete(CategoryCustomDao dao){
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
CategoryCustomDao dao = new CategoryCustomDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("insert")){
	insert(dao);
}
if(actionFlag.equals("delete")){
	delete(dao);
}
if(actionFlag.equals("export")){
	String filename = "catcustom_" + strftime("yyyyMMddHHmm") + ".txt";

	if(new CategorySystemDao().exportFile(filename, false)){
		response.sendRedirect("download.jsp?filename=" + filename + "&contentType=text/plain");
		return;
	}
	else{
		errList.add(translate("Couldn't write the file."));
	}
}

// If it's about importation.
int importCount = paramInt("importCount");
if(importCount > 0){
	succList.add(translateF("%s domains imported.", importCount));
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("CATEGORY")%></li>
		<li class="breadcrumb-item text-info"><%= translate("CUSTOM")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Form -->
<div class="container-fluid">
	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="insert">
				<input type="hidden" name="originPage" value="<%= getPageName()%>">
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Name")%></label>
					<input type="text" class="form-control" id="name" name="name">
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Description")%></label>
					<input type="text" class="form-control" id="description" name="description">
				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
					<button type="button" class="btn btn-info" onclick="javascript:actionImport(this.form);">
						<%= translate("IMPORT")%></button>
					<button type="button" class="btn btn-warning" onclick="javascript:actionExport();">
						<%= translate("EXPORT")%></button>
				</div>
				<div id="divFile1" class="form-group col-lg-4" style="display: none">
					<input class="form-control" type="file" id="file1" name="file1">
					<small id="input-help" class="form-text text-muted">
						<%= translate("Select file and then click IMPORT button.")%>
					</small>
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
					<th><%= translate("Name")%></th>
					<th><%= translate("Description")%></th>
					<th><%= translate("Domain")%></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
<%
List<CategoryData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	CategoryData data = dataList.get(i);

	String name = data.name;
	if(data.systemFlag){
		name = "*" + name;
	}

	int domainCnt = data.getDomainCount();
	if(domainCnt > 0){
		name = name + " - " + domainCnt;
	}

	String domainLine = data.getDomainLine();
	if(domainLine.length() > 120){
		domainLine = safeSubstring(domainLine, 120) + "..";
	}
%>
				<tr>
					<td><%= name%></td>
					<td><%= data.description%></td>
					<td><%= domainLine%></td>
					<td>
						<i class="fa fa-pencil-square pointer-cursor" title="<%= translate("Edit")%>" onclick="javascript:goEdit(<%= data.id%>)"></i>&nbsp;
						<i class="fa fa-trash pointer-cursor" title="<%= translate("Delete")%>" onclick="javascript:actionDelete(<%= data.id%>, '<%= data.name%>')"></i>
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
function actionDelete(id, name){
	if(!confirm('<%= translate("Deleting category")%> : ' + name)){
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
	form.action = "category,custom_edit.jsp";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
function actionImport(uploadForm){
	if(uploadForm.file1.value == ""){
		divFile1.style.display = "block";
		return;
	}

	uploadForm.action = "import.jsp";
	uploadForm.actionFlag.value = "catsystem";
	uploadForm.enctype = "multipart/form-data";
	uploadForm.submit();
}

//-----------------------------------------------
function actionExport(){
	var form = document.goForm;
	form.actionFlag.value = "export";
	form.submit();
}

//-----------------------------------------------
// Prevent submit again.
if(window.history.replaceState){
	window.history.replaceState(null, null, window.location.href);
}
</script>
