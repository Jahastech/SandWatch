<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(PolicyDao dao){
	PolicyData data = new PolicyData();

	data.id = paramInt("id");
	data.points = paramInt("points");
	data.description = paramString("description");
	data.enableFilter = paramBoolean("enableFilter");

	data.blockAll = paramBoolean("blockAll");
	data.blockUnclass = paramBoolean("blockUnclass");
	data.blockCNameCloaking = paramBoolean("blockCNameCloaking");
	
	/*
	data.adRemove = paramBoolean("adRemove");
	data.maxDomainLen = paramInt("maxDomainLen");

	data.blockCovertChan = paramBoolean("blockCovertChan");
	data.blockMailerWorm = paramBoolean("blockMailerWorm");

	data.aRecordOnly = paramBoolean("aRecordOnly");
	*/
	
	data.quota = paramInt("quota");
	data.quotaAll = paramBoolean("quotaAll");
	data.bwdtLimit = paramLong("bwdtLimit");

	data.safeMode = paramInt("safeMode");
	data.safeModeWithoutYoutube = paramBoolean("safeModeWithoutYoutube");

	data.logOnly = paramBoolean("logOnly");
	data.blockCategoryArr = paramArray("blockCategoryArr");
	data.quotaCategoryArr = paramArray("quotaCategoryArr");

	String stimeHh = paramString("stimeHh");
	String stimeMm = paramString("stimeMm");
	String etimeHh = paramString("etimeHh");
	String etimeMm = paramString("etimeMm");

	data.btStime = stimeHh + stimeMm;
	data.btEtime = etimeHh + etimeMm;

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
PolicyDao dao = new PolicyDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
PolicyData data = dao.selectOne(paramInt("id"));

// Active tab.
String tabActive0 = "";
String tabActive1 = "";
String tabActive2 = "";

String showActive0 = "";
String showActive1 = "";
String showActive2 = "";

int tabIdx = paramInt("tabIdx");
if(tabIdx == 0){
	tabActive0 = " active";
	showActive0 = " show active";
}
else if(tabIdx == 1){
	tabActive1 = " active";
	showActive1 = " show active";
}
else if(tabIdx == 2){
	tabActive2 = " active";
	showActive2 = " show active";
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("POLICY")%></li>
		<li class="breadcrumb-item"><%= translate("POLICY")%></li>
		<li class="breadcrumb-item text-info"><%= translate("EDIT")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<!-- Tab -->
	<div>
		<ul class="nav nav-tabs" style="margin-left:10px; margin-right:10px;">
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(0);">
				<a class="nav-link<%= tabActive0%>" data-toggle="tab" href="#tab0"><%= translate("EDIT")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(1);">
				<a class="nav-link<%= tabActive1%>" data-toggle="tab" href="#tab1"><%= translate("BLOCKED CATEGORIES")%></a>
			</li>
			<li class="nav-item" onclick="javascript:$('#tabIdx').val(2);">
				<a class="nav-link<%= tabActive2%>" data-toggle="tab" href="#tab2"><%= translate("SCREEN TIME CATEGORIES")%></a>
			</li>
		</ul>
	</div>
	<!-- Tab -->

	<!-- Form -->
	<form action="<%= getPageName()%>" method="post">
		<input type="hidden" name="actionFlag" value="update">
		<input type="hidden" id="tabIdx" name="tabIdx" value="<%= tabIdx%>">
		<input type="hidden" name="id" value="<%= data.id%>">
 
		<!-- Tab content -->
		<div id="myTabContent" class="tab-content">

			<!-- Edit -->
			<div class="tab-pane <%= showActive0%>" id="tab0">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Name")%></label>
								<input type="text" class="form-control" id="host" name="host" value="<%= data.name%>" disabled>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Description")%></label>
								<input type="text" class="form-control" id="description" name="description" value="<%= data.description%>">
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Priority Points")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("When a user is associated to multiple policies, the policy having the highest points will be applied.")%>"></i>
								</label>
								<div class="input-group">
									<input type="text" class="form-control" id="points" name="points" value="<%= data.points%>">
									<div class="input-group-append">
										<span class="input-group-text">0 ~ 1000</span>
									</div>				
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="enableFilter"
										name="enableFilter" <%if(data.enableFilter){out.print("checked");}%>>
									<label for="enableFilter" class="custom-control-label"><%= translate("Enable Filter")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="blockAll"
										name="blockAll" <%if(data.blockAll){out.print("checked");}%>>
									<label for="blockAll" class="custom-control-label"><%= translate("Block All")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="blockUnclass"
										name="blockUnclass" <%if(data.blockUnclass){out.print("checked");}%>>
									<label for="blockUnclass" class="custom-control-label"><%= translate("Block Unclassified")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="blockCNameCloaking"
										name="blockCNameCloaking" <%if(data.blockCNameCloaking){out.print("checked");}%>>
									<label for="blockCNameCloaking" class="custom-control-label"><%= translate("Block CName Cloaking")%></label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Screen Time")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("You can set daily screen time for accessing websites in certain categories.")%>"></i>
								</label>
								<div class="input-group">
									<input type="text" class="form-control" id="quota" name="quota" value="<%= data.quota%>">
									<div class="input-group-append">
										<span class="input-group-text">0 ~ 1440 <%= translate("minutes")%></span>
									</div>				
								</div>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="quotaAll"
										name="quotaAll" <%if(data.quotaAll){out.print("checked");}%>>
									<label for="quotaAll" class="custom-control-label">
										<%= translate("Screen Time for All")%>
										&nbsp;<i class="fa fa-question-circle south-east"
											title="<%= translate("Screen time will be applied for all websites including unclassified websites.")%>"></i>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Data Cap")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("You can limit data usage for users on daily basis. This feature requires you to run NetFlow collector.")%>"></i>
								</label>
								<div class="input-group">
									<input type="text" class="form-control" id="bwdtLimit" name="bwdtLimit" value="<%= data.bwdtLimit%>">
									<div class="input-group-append">
										<span class="input-group-text">MB, 0 = <%= translate("bypass")%></span>
									</div>				
								</div>
							</div>

							<div class="form-group col-lg-8">
								<label class="col-form-label">
									<%= translate("Safe Search Enforcing")%>
									&nbsp;<i class="fa fa-question-circle south-east"
										title="<%= translate("Enforcing Safe Search against Google, Bing, Youtube, DuckDuckGo, Yandex. The difference between Moderate and Strict is only for YouTube.")%>"></i>
								</label>
								<select class="form-control" id="safeMode" name="safeMode">
									<option value="0" <%if(data.safeMode == 0){out.print("selected");}%>><%= translate("Off")%></option>
									<option value="1" <%if(data.safeMode == 1){out.print("selected");}%>><%= translate("Moderate")%></option>
									<option value="2" <%if(data.safeMode == 2){out.print("selected");}%>><%= translate("Strict")%></option>
								</select>
							</div>
							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="safeModeWithoutYoutube"
										name="safeModeWithoutYoutube" <%if(data.safeModeWithoutYoutube){out.print("checked");}%>>
									<label for="safeModeWithoutYoutube" class="custom-control-label"><%= translate("Exclude Youtube from Safe Search Enforcing")%></label>
								</div>
							</div>

							<div class="form-group col-lg-8">
								<label class="col-form-label"><%= translate("Block Time")%></label>
								<div class="form-row" style="margin-left: 2px;">
<%
List<String> hhList = getHhList();
List<String> mmList = getMmList();
%>
									<select class="form-control col-lg-1 col-md-1" id="stimeHh" name="stimeHh">
<%
for(String hh : hhList){
	if(data.btStime.startsWith(hh)){
		printf("<option value='%s' selected>%s</option>", hh, hh);
	}
	else{
		printf("<option value='%s'>%s</option>", hh, hh);
	}
}
%>
									</select>&nbsp;

									<select class="form-control col-lg-1 col-md-1" id="stimeMm" name="stimeMm">
<%
for(String mm : mmList){
	if(data.btStime.endsWith(mm)){
		printf("<option value='%s' selected>%s</option>", mm, mm);
	}
	else{
		printf("<option value='%s'>%s</option>", mm, mm);
	}
}
%>
									</select>&nbsp;~&nbsp;

									<select class="form-control col-lg-1 col-md-1" id="etimeHh" name="etimeHh">
<%
for(String hh : hhList){
	if(data.btEtime.startsWith(hh)){
		printf("<option value='%s' selected>%s</option>", hh, hh);
	}
	else{
		printf("<option value='%s'>%s</option>", hh, hh);
	}
}
%>
									</select>&nbsp;

									<select class="form-control col-lg-1 col-md-1" id="etimeMm" name="etimeMm">
<%
for(String mm : mmList){
	if(data.btEtime.endsWith(mm)){
		printf("<option value='%s' selected>%s</option>", mm, mm);
	}
	else{
		printf("<option value='%s'>%s</option>", mm, mm);
	}
}
%>
									</select>
								</div>
							</div>

							<div class="form-group col-lg-8">
								<div class="custom-control custom-checkbox">
									<input type="checkbox" class="custom-control-input" id="logOnly"
										name="logOnly" <%if(data.logOnly){out.print("checked");}%>>
									<label for="logOnly" class="custom-control-label"><%= translate("Logging without Block")%>
									</label>
								</div>
							</div>
							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Edit -->

			<!-- Blocked Categories -->
			<div class="tab-pane fade<%= showActive1%>" id="tab1">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>

<%
List<CategoryData> blockCategoryList = data.getBlockCategoryList();
for(int i = 0; i < blockCategoryList.size();){

	out.println("<div class='form-group col-lg-8 row' style='padding-left: 30px'>");

	for(int k = 0; k < 4; k++){
		CategoryData cd = blockCategoryList.get(i);

		String chkLine = "";
		if(cd.checkFlag){
			chkLine = "checked";
		}
%>
							<div class="custom-control custom-checkbox col-lg-3">
								<input type="checkbox" class="custom-control-input" id="blockedCategory-<%= i%>"
									name="blockCategoryArr" value="<%= cd.id%>" <%= chkLine%>>
								<label class="custom-control-label" for="blockedCategory-<%= i%>"><%= cd.name%></label>
							</div>
<%
		if(++i >= blockCategoryList.size()){
			break;
		}
	}

	out.println("</div>");
}
%>

							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
								<button type="button" class="btn btn-info" onclick="javascript:checkboxToggleAll3('blockCategoryArr');"><%= translate("SELECT ALL")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Blocked Categories -->

			<!-- Quotaed Categories -->
			<div class="tab-pane fade<%= showActive2%>" id="tab2">
				<div class="card bg-light m-2 expand-lg">
					<div class="card-body">
						<fieldset>


<%
List<CategoryData> quotaCategoryList = data.getQuotaCategoryList();
for(int i = 0; i < quotaCategoryList.size();){

	out.println("<div class='form-group col-lg-8 row' style='padding-left: 30px'>");

	for(int k = 0; k < 4; k++){
		CategoryData cd = quotaCategoryList.get(i);

		String chkLine = "";
		if(cd.checkFlag){
			chkLine = "checked";
		}
%>
							<div class="custom-control custom-checkbox col-lg-3">
								<input type="checkbox" class="custom-control-input" id="quotaCategory-<%= i%>"
									name="quotaCategoryArr" value="<%= cd.id%>" <%= chkLine%>>
								<label class="custom-control-label" for="quotaCategory-<%= i%>"><%= cd.name%></label>
							</div>
<%
		if(++i >= quotaCategoryList.size()){
			break;
		}
	}

	out.println("</div>");
}
%>

							<div class="form-group col-lg-8">
								<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
								<button type="button" class="btn btn-warning" onclick="javascript:checkboxToggleAll3('quotaCategoryArr');"><%= translate("SELECT ALL")%></button>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
			<!-- /Quotaed Categories -->

		</div>
		<!-- Tab content -->

	</form>
	<!-- /Form -->

</div>
<!-- /Main content -->

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
$("#points").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d]*$/.test(value) && value <= 1000;
});
$("#quota").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d]*$/.test(value) && value <= 1440;
});
$("#bwdtLimit").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d]*$/.test(value);
});
</script>
