<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(BlocklistDao dao){
	BlocklistData data = new BlocklistData();
	
	data.id = paramInt("id");
	data.priority = paramInt("priority");

	if(dao.update(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void insert(BlocklistDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	BlocklistData data = new BlocklistData();
	
	data.url = paramString("url");
	data.categoryId = paramInt("categoryId");
	data.priority = paramInt("priority");
	data.bypassDnsCheck = paramBoolean("bypassDnsCheck");

	// Param validation.
    if(isEmpty(data.url) || !ParamTest.isValidBlocklistUrl(data.url)){
		errList.add(translate("Invalid URL."));
		return;
	}

	if(data.categoryId == 0){
		errList.add(translate("Invalid category."));
		return;
	}

	if(dao.insert(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void delete(BlocklistDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	if(dao.delete(paramInt("id"))){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void test(BlocklistDao dao){
	try{
		dao.test(paramInt("id"));
		succList.add(translate("Blocklist URL connection succeeded."));
	}
	catch(Exception e){
		errList.add(e.toString());
	}
}

//-----------------------------------------------
void merge(BlocklistDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	if(!dao.merge(paramInt("id"))){
		errList.add(translate("We already have a working thread."));
		return;
	}
	succList.add(translate("A worker thread started. Depending on the blocklist size, it will take some time to finish the job."));
}

//-----------------------------------------------
void mergeAll(BlocklistDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	if(!dao.mergeAll()){
		errList.add(translate("We already have a working thread."));
		return;
	}
	succList.add(translate("A worker thread started. Depending on the blocklist size, it will take some time to finish the job."));
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
BlocklistDao dao = new BlocklistDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("insert")){
	insert(dao);
}
if(actionFlag.equals("update")){
	update(dao);
}
if(actionFlag.equals("delete")){
	delete(dao);
}
if(actionFlag.equals("test")){
	test(dao);
}
if(actionFlag.equals("merge")){
	merge(dao);
}
if(actionFlag.equals("mergeAll")){
	mergeAll(dao);
}

//
ActiveThreadData atd = dao.getActiveThread();
if(atd != null){
	infoList.add(translateF("We are working on %s from %s, line count = %s. You can't start another theread before we finish the current job."
		, atd.url, atd.getStime(), atd.lineCnt));
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("TIME")%></li>
		<li class="breadcrumb-item text-info"><%= translate("BLOCKLIST")%></li>
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
					<%= translate("You can merge blocklists from the Internet into Jahaslist. When you add a blocklist URL here, it will be processed overnight automatically. A valid blocklist file should list the domains separated by newlines or should be in /etc/hosts file format.", 1000)%>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label">URL</label>
					<input type="text" class="form-control" id="url" name="url">
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
					<label class="col-form-label">
						<%= translate("Priority Points")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("Blocklist having igher priority points will be processed before others.")%>"></i>
					</label>
					<div class="input-group">
						<input type="text" class="form-control" id="priority" name="priority" value="0">
						<div class="input-group-append">
							<span class="input-group-text">0 ~ 1000</span>
						</div>				
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="bypassDnsCheck" name="bypassDnsCheck">
						<label for="bypassDnsCheck" class="custom-control-label">
							<%= translate("Bypass DNS Checking")%>
							&nbsp;<i class="fa fa-question-circle south-east"
								title="<%= translate("At default, NxFilter tries to exclude non-existent domains from your blocklist by DNS checking. With this option enabled, it adds all the domains from the blocklist into Jahaslist even if they don't exist. If you have to deal with a big list, you can try this option.")%>"></i>
						</label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
					<button type="button" class="btn btn-warning" onclick="javascript:actionMergeAll();"><%= translate("MERGE ALL")%></button>
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
					<th>URL</th>
					<th><%= translate("Category")%></th>
					<th><%= translate("Priority Points")%></th>
					<th><%= translate("Bypass DNS Checking")%></th>
					<th><%= translate("Merge Count")%></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
<%
List<BlocklistData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	BlocklistData data = dataList.get(i);
%>
				<tr>
					<td><%= data.url%></td>
					<td><%= data.categoryName%></td>
					<td><input type="text" id="priority_<%= data.id%>" size="3" value="<%= data.priority%>"></td>
					<td><%= data.bypassDnsCheck ? "Y" : "N"%></td>
					<td><%= data.mergeCnt%></td>
					<td>
						<i class="fa fa-check-circle pointer-cursor" title="<%= translate("Update")%>" onclick="javascript:actionUpdate('<%= data.id%>')"></i>&nbsp;
						<i class="fa fa-trash pointer-cursor" title="<%= translate("Delete")%>" onclick="javascript:actionDelete(<%= data.id%>, '<%= data.url%>')"></i>
						<i class="fa fa-plug pointer-cursor" title="<%= translate("Test")%>" onclick="javascript:actionTest('<%= data.id%>')"></i>&nbsp;
						<i class="fa fa-database pointer-cursor" title="<%= translate("Merge")%>" onclick="javascript:actionMerge('<%= data.id%>')"></i>&nbsp;
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
<input type="hidden" name="priority" value="">
</form>
<!-- /goForm -->

<%@include file="include/footer.jsp"%>

<script>
//-----------------------------------------------
// Restricts input for each element in the set of matched elements to the given inputFilter.
(function($) {
	$.fn.inputFilter = function(inputFilter){
		return this.on("input keydown keyup mousedown mouseup select contextmenu drop", function(){
			if (inputFilter(this.value)){
				this.oldValue = this.value;
				this.oldSelectionStart = this.selectionStart;
				this.oldSelectionEnd = this.selectionEnd;
			} else if (this.hasOwnProperty("oldValue")){
				this.value = this.oldValue;
				this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
			} else {
				this.value = "";
			}
		});
	};
}(jQuery));

//-----------------------------------------------
$(document).ready(function(){
	$("#list").DataTable({
		"bFilter" : false,
		"paging" : false,
		"ordering" : false,
		"info" : true,
		"columnDefs": [
			{
				"targets": 5,
				"width": "60"
			}
		],
		"initComplete": function(settings, json){
			$("#listDiv").show();
		},
		language : langMulti,
	});
});

// Install input filters.
$("#priority").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) <= 1000;
});

//-----------------------------------------------
function actionUpdate(id){
	var form = document.goForm;
	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "update";
	form.id.value = id;
	form.priority.value = $("#priority_" + id).val();
	form.submit();
}

//-----------------------------------------------
function actionDelete(id, url){
	if(!confirm("Deleting URL : " + url)){
		return;
	}

	var form = document.goForm;
	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "delete";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
function actionTest(id){
	var form = document.goForm;
	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "test";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
function actionMerge(id){
	var form = document.goForm;
	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "merge";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
function actionMergeAll(){
	if(!confirm('<%= translate("Starting a worker thread for merging all the blocklists?")%>')){
		return;
	}

	var form = document.goForm;
	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "mergeAll";
	form.submit();
}

//-----------------------------------------------
// Prevent submit again.
if(window.history.replaceState){
	window.history.replaceState(null, null, window.location.href);
}
</script>
