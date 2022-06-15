<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
boolean hasBlacklist(int blacklistType){
	if(blacklistType != 8 && blacklistType != 99){
		return true;
	}
	return false;
}

//-----------------------------------------------
void update(CategorySystemDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	// License update.
	String licenseKey = paramString("licenseKey");
	if(isNotEmpty(licenseKey)){
		LicenseDao licDao = new LicenseDao();

		if(!licDao.isValidLicenseKey(licenseKey)){
			errList.add(translate("Invalid license key."));
			return;
		}
		
		if(licDao.isExpiredLicenseKey(licenseKey)){
			errList.add(translate("Expired license key."));
			return;
		}

		if(new LicenseDao().updateLicenseKey(licenseKey)){
			succList.add(translate("Update finished."));
			warnList.add(translate("Restart is required to apply new settings."));
		}
		else{
			errList.add(translate("Invalid license key."));
		}
		return;
	}

	// Change blacklist type.
	int blacklistType = paramInt("blacklistType");
	if(blacklistType == 4 && !dao.hasKomodiaLicense()){
		errList.add(translate("Cloudlist license is required."));
		return;
	}

	if(dao.updateBlacklistType(blacklistType)){
		succList.add(translate("Update finished."));
		warnList.add(translate("Restart is required to apply new settings."));
	}
}

//-----------------------------------------------
void updatePolicyGloblist(PolicyGloblistDao dao){
	PolicyGloblistData data = dao.selectOne();

	data.blockAds = paramBoolean("blockAds");
	data.blockPhimal = paramBoolean("blockPhimal");
	data.blockPorn = paramBoolean("blockPorn");
	data.adRemove = paramBoolean("adRemove");

	// Update it.
	if(dao.update(data)){
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
CategorySystemDao dao = new CategorySystemDao();
PolicyGloblistDao pgDao = new PolicyGloblistDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}
if(actionFlag.equals("updatePolicyGloblist")){
	updatePolicyGloblist(pgDao);
}
if(actionFlag.equals("export")){
	String filename = "catsystem_" + strftime("yyyyMMddHHmm") + ".txt";

	if(dao.exportFile(filename)){
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

// 4 = Cloudlist, 5 = Jahaslist, 8 = Globlist.
int gBlacklistType = dao.getBlacklistType();
String gLicenseEndDate = dao.getLicenseEndDate();
int gLicenseMaxUser = dao.getLicenseMaxUser();

if(dao.isTrialLicense() && succList.isEmpty() && errList.isEmpty()){
	infoList.add(translate("We're in 30 day trial period. You can try Jahaslist for unlimited number of users or Cloudlist for 50 users.", 1000));
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("CATEGORY")%></li>
		<li class="breadcrumb-item text-info"><%= translate("SYSTEM")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Form -->
<div class="container-fluid">
	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="update">
				<input type="hidden" name="originPage" value="<%= getPageName()%>">
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Domain Categorization Database")%></label>
					<select class="form-control" id="blacklistType" name="blacklistType">
						<option value="5" <%if(gBlacklistType == 5){out.print("selected");}%>>Jahaslist - <%= translate("Local database with auto-update and dynamic classification.")%></option>
						<option value="4" <%if(gBlacklistType == 4){out.print("selected");}%>>Cloudlist - <%= translate("Cloud based domain categorization service.")%></option>
						<option value="8" <%if(gBlacklistType == 8){out.print("selected");}%>>Globlist - <%= translate("Free domain categorization database having 3 categories.")%></option>
					</select>

<%if(hasBlacklist(gBlacklistType)){%>
					<small id="input-help" class="form-text text-info">
						License info : End date = <%= gLicenseEndDate%> / Max user = <%= gLicenseMaxUser%>
					</small>
<%}%>

				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>

<%if(hasBlacklist(gBlacklistType)){%>
					<button type="button" class="btn btn-info" onclick="javascript:actionImport(this.form);">
						<%= translate("IMPORT")%></button>
					<button type="button" class="btn btn-warning" onclick="javascript:actionExport();">
						<%= translate("EXPORT")%></button>
<%}%>
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

<!-- Globlist Policy -->
<%
if(gBlacklistType == 8){
	PolicyGloblistData pgData = pgDao.selectOne();
	//int pgCount = pgDao.selectCount();
%>
<!-- Form -->
<p>
<div class="container-fluid">
	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="updatePolicyGloblist">
				<div class="form-group col-lg-8 text-secondary">
					<%= translate("Globlist is a free domain categorization database derived from Jahaslist. It works on global policy level only.")%>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="blockAds"
							name="blockAds" <%if(pgData.blockAds){out.print("checked");}%>>
						<label class="custom-control-label" for="blockAds"><%= translate("Block Ads")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="blockPhimal"
							name="blockPhimal" <%if(pgData.blockPhimal){out.print("checked");}%>>
						<label class="custom-control-label" for="blockPhimal"><%= translate("Block Phishing/Malware")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="blockPorn"
							name="blockPorn" <%if(pgData.blockPorn){out.print("checked");}%>>
						<label class="custom-control-label" for="blockPorn"><%= translate("Block Porn")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary">Submit</button>
				</div>
			</form>
		</div>
	</div>
</div>
<!-- /Form -->
<%}%>

<%if(hasBlacklist(gBlacklistType)){%>
<!-- List -->
<div id="listDiv" class="container-fluid" style="display: none;">
	<div class="m-2 expand-lg">
		<table id="list" class="cell-border hover" style="width:100%">
			<thead>
				<tr>
					<th><%= translate("Name")%></th>
					<th><%= translate("Description")%></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
<%
List<CategoryData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	CategoryData data = dataList.get(i);

	String name = data.name;
	int domainCnt = data.getDomainCount();
	if(domainCnt > 0){
		name = name + " - " + domainCnt;
	}
%>
				<tr>
					<td><%= name%></td>
					<td><%= data.description%></td>
					<td>
						<i class="fa fa-pencil-square pointer-cursor" title="<%= translate("Edit")%>" onclick="javascript:goEdit(<%= data.id%>)"></i>
					</td>
				</tr>
<%}%>
			</tbody>
		</table>
	</div>
</div>
<!-- /List -->
<%}%>

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
function goEdit(id){
	var form = document.goForm;
	form.action = "category,system_edit.jsp";
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
</script>
