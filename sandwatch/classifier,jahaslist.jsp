<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void insert(JahaslistDao dao){
	JahaslistData data = new JahaslistData();
	data.domain = paramString("domain");
	data.categoryId = paramInt("categoryId");

	// Param validation.
	if(isEmpty(data.domain)){
		return;
	}

    if(data.categoryId == 0){
		errList.add("Invalid category.");
		return;
	}

	String[] arr = data.domain.split("\\s+");
	for(String domain : arr){
		domain = domain.trim();

		if(!isValidDomain(domain)){
			if(errList.size() < 5){
				errList.add("Invalid domain. - " + domain);
			}
			continue;
		}
	}

	if(dao.insert(data)){
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
JahaslistDao dao = new JahaslistDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("insert")){
	insert(dao);
}
if(actionFlag.equals("export")){
	String filename = dao.exportFile();

	if(isNotEmpty(filename)){
		response.sendRedirect("download.jsp?filename=" + filename + "&contentType=text/plain");
		return;
	}
	else{
		errList.add("Couldn't write the file.");
	}
}

// If it's about importation.
int importCount = paramInt("importCount");
if(importCount > 0){
	if(actionFlag.equals("ruleset")){
		succList.add(importCount + " classification rules imported.");
	}
	else{
		succList.add(importCount + " domains imported.");
	}
}

// Global.
int gCount = dao.selectCount();
if(dao.selectCount() < 3000000){
	warnList.add(translate("Jahaslist size is too small. You may have an incomplete update."));
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("CLASSIFIER")%></li>
		<li class="breadcrumb-item text-info"><%= translate("JAHASLIST")%></li>
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
				<div class="form-group col-lg-8 text-secondary">
					<%
					String tLine = translate("You can add domains into Jahaslist directly. We have %s domains classified at the moment.");
					printf(tLine, NumberFormat.getIntegerInstance().format(gCount));
					%>
				</div>

				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Domain")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("Multiple domains should be separated by spaces or newlines.")%>"></i>
					</label>
					<textarea class="form-control" id="domain" name="domain" rows="4"></textarea>
				</div>

				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Category")%></label>
					<select class="form-control" id="categoryId" name="categoryId">
						<option value="0"><%= translate("SELECT CATEGORY")%></option>
<%
Map<Integer,String> jahasCategoryMap = dao.getJahasCategoryMap();
for(Map.Entry<Integer,String> entry : jahasCategoryMap.entrySet()){
	int categoryId = entry.getKey();
	String categoryName = entry.getValue();
	printf("<option value='%s'>%s", categoryId, translate(categoryName));
}
%>
					</select>
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

<!-- goForm -->
<form name="goForm" method="get">
<input type="hidden" name="actionFlag" value="">
</form>
<!-- /goForm -->

<%@include file="include/footer.jsp"%>

<script>
//-----------------------------------------------
function actionExport(){
	var form = document.goForm;
	form.actionFlag.value = "export";
	form.submit();
}

//-----------------------------------------------
function actionImport(uploadForm){
	if(uploadForm.file1.value == ""){
		divFile1.style.display = "block";
		return;
	}

	uploadForm.action = "import.jsp";
	uploadForm.actionFlag.value = "jahaslist";
	uploadForm.enctype = "multipart/form-data";
	uploadForm.submit();
}

//-----------------------------------------------
// Prevent submit again.
if(window.history.replaceState){
	window.history.replaceState(null, null, window.location.href);
}
</script>
