<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void insert(WhitelistTempDao dao){
	WhitelistTempData data = new WhitelistTempData();
	data.domain = paramString("domain");
	data.description = paramString("description");
	data.type = paramInt("type");

	data.uname = paramString("uname");
	data.ttl = paramInt("ttl");

	if(isGloblist()){
		errList.add(translate("Globlist doesn't support temporary whitelist."));
		return;
	}

	// Param validation.
	if(!isUnicodeDomain(data.domain)){
		errList.add(translate("Invalid domain."));
		return;
	}

	if(data.type != WhitelistTempData.TYPE_GLOBAL && isEmpty(data.uname)){
		errList.add(translate("User or group needs to be specified."));
		return;
	}
	
	if(dao.insert(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void delete(WhitelistTempDao dao){
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
WhitelistTempDao dao = new WhitelistTempDao();
dao.limit = 10000;

if(isGloblist()){
	warnList.add(translate("Globlist doesn't support temporary whitelist."));
}

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("insert")){
	insert(dao);
}
if(actionFlag.equals("delete")){
	delete(dao);
}

// Active tab.
String tabActive0 = "";
String tabActive1 = "";

String showActive0 = "";
String showActive1 = "";

// Reset tabIdx.
int tabIdx = 0;

// If there's an error while creating a new data, stay with the create form.
String g_domain = "";
String g_description = "";
int g_type = 1;
String g_uname = "";
int g_ttl = 1;
if(actionFlag.equals("insert") && errList.size() > 0){
	g_domain = paramString("domain");
	g_description = paramString("description");
	g_type = paramInt("type");
	g_uname = paramString("uname");
	g_ttl = paramInt("ttl");
	tabIdx = 1;
}

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
		<li class="breadcrumb-item"><%= translate("WHITELIST")%></li>
		<li class="breadcrumb-item text-info"><%= translate("TEMPORARY")%></li>
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
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("CREATE")%></a>
			</li>
		</ul>
	</div>
	<!-- Tab -->

	<!-- Form -->
	<form action="<%= getPageName()%>" method="post">
		<input type="hidden" name="actionFlag" value="insert">
		<input type="hidden" id="tabIdx" name="tabIdx" value="<%= tabIdx%>">

		<!-- Tab content -->
		<div id="myTabContent" class="tab-content">

			<!-- List -->
			<div class="tab-pane <%= showActive0%>" id="tab0">
				<div id="listDiv" class="container-fluid" style="display: none;">
					<table id="list" class="cell-border hover" style="width:100%">
						<thead>
							<tr>
								<th><%= translate("Domain")%></th>
								<th><%= translate("User")%> / <%= translate("Group")%></th>
								<th><%= translate("Expire Time")%></th>
								<th><%= translate("Description")%></th>
								<th></th>
							</tr>
						</thead>
						<tbody>

<%
List<WhitelistTempData> dataList = dao.selectList();
for(int i = 0; i < dataList.size(); i++){
	WhitelistTempData data = dataList.get(i);

	String expDeco = "";
	if(data.isExpired()){
		expDeco = " style=\"text-decoration: line-through;\"";
	}

	String uname = data.uname;
	if(data.type == WhitelistTempData.TYPE_GLOBAL){
		uname = translate("Global");
	}
%>
							<tr>
								<td><%= data.domain%></td>
								<td><%= uname%></td>
								<td<%= expDeco%>><%= data.getExpireTime()%></td>
								<td><%= data.description%></td>
								<td>
									<i class="fa fa-trash pointer-cursor" title="<%= translate("Delete")%>" onclick="javascript:actionDelete(<%= data.id%>, '<%= data.domain%>')"></i>
								</td>
							</tr>
<%}%> 
						</tbody>
					</table>
				</div>
			</div>
			<!-- /List -->

			<!-- CREATE -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Domain")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("You can use a wildcard domain here.")%>
											<br>&nbsp;&nbsp;ex) *.nxfilter.org"></i>
								</label>
								<input type="text" class="form-control" id="domain" name="domain" value="<%= g_domain%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Description")%></label>
								<input type="text" class="form-control" id="description" name="description" value="<%= g_description%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Type")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("You can create a user or group specific or global rule.")%>"></i>
								</label>
								<select class="form-control" id="type" name="type" onchange="javascript:resetUser(this.form)">
									<option value="1" <%if(g_type == 1){out.print("selected");}%>><%= translate("User")%></option>
									<option value="2" <%if(g_type == 2){out.print("selected");}%>><%= translate("Group")%></option>
									<option value="100" <%if(g_type == 100){out.print("selected");}%>><%= translate("Global")%></option>
								</select>
							</div>
							<div class="form-group col-lg-8">
								<datalist id="unamelist">
<%
List<String> unameList = new UserDao().selectListUname();
unameList.addAll(new GroupDao().selectListGname());
for(String uname : unameList){
	printf("<option value='%s'>", uname);
}
%>
								</datalist>
								<label class="col-form-label"><%= translate("User")%> / <%= translate("Group")%></label>
								<input type="text" class="form-control" id="uname" name="uname" value="<%= g_uname%>" list="unamelist">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("TTL")%></label>
								<div class="input-group">
									<input type="text" class="form-control" id="ttl" name="ttl" value="<%= g_ttl%>">
									<div class="input-group-append">
										<span class="input-group-text"><%= translate("hour")%>, 0 ~ 720, 0 = <%= translate("Permanent")%></span>
									</div>				
								</div>
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /CREATE -->

		</div>
		<!-- Tab content -->

	</form>
	<!-- /Form -->

</div>
<!-- /Main content -->

<!-- goForm -->
<form action="<%= getPageName()%>" name="goForm" method="get">
<input type="hidden" name="actionFlag" value="">
<input type="hidden" name="id" value="">
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

// Install input filters.
$("#ttl").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) <= 720;
});

//-----------------------------------------------
$(document).ready(function(){
	$("#list").DataTable({
		"pageLength": 15,
		"bLengthChange" : false,
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
	if(!confirm('<%= translate("Deleting whitelist rule")%> : ' + name)){
		return;
	}

	var form = document.goForm;
	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "delete";
	form.id.value = id;
	form.submit();
}

//-----------------------------------------------
function resetUser(form){
	if(form.type.value == <%= WhitelistTempData.TYPE_GLOBAL%>){
		form.uname.value = "";
		form.uname.disabled = true;
	}
	else{
		form.uname.disabled = false;
	}
}

//-----------------------------------------------
// Prevent submit again.
if(window.history.replaceState){
	window.history.replaceState(null, null, window.location.href);
}
</script>
