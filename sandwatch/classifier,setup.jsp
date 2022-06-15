<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(ClassifierSetupDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	ClassifierSetupData data = new ClassifierSetupData();

	data.dnsTestTimeout = paramInt("dnsTestTimeout");
	data.httpConnTimeout = paramInt("httpConnTimeout");
	data.httpReadTimeout = paramInt("httpReadTimeout");
	data.classifiedRetentionDays = paramInt("classifiedRetentionDays");
	//data.keepHtmlText = paramBoolean("keepHtmlText");
	data.disableDomainPatternDic = paramBoolean("disableDomainPatternDic");
	data.disableCloudClassifier = paramBoolean("disableCloudClassifier");
	data.disableClassification = paramBoolean("disableClassification");

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
ClassifierSetupDao dao = new ClassifierSetupDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
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
ClassifierSetupData data = dao.selectOne();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("CLASSIFIER")%></li>
		<li class="breadcrumb-item text-info"><%= translate("SETUP")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="update">

				<div class="form-group col-lg-8 text-secondary">
					<%= translate("We have a dynamic classifier running on background for Jahaslist.")%>
				</div>

				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("DNS Test Timeout")%></label>
					<div class="input-group">
						<input type="text" class="form-control" id="dnsTestTimeout"
							name="dnsTestTimeout" maxlength="4" value="<%= data.dnsTestTimeout%>">
						<div class="input-group-append">
							<span class="input-group-text"><%= translate("seconds")%>, 1 ~ 12</span>
						</div>				
					</div>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("HTTP Connection Timeout")%></label>
					<div class="input-group">
						<input type="text" class="form-control" id="httpConnTimeout"
							name="httpConnTimeout" maxlength="4" value="<%= data.httpConnTimeout%>">
						<div class="input-group-append">
							<span class="input-group-text"><%= translate("seconds")%>, 1 ~ 12</span>
						</div>				
					</div>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("HTTP Read Timeout")%></label>
					<div class="input-group">
						<input type="text" class="form-control" id="httpReadTimeout"
							name="httpReadTimeout" maxlength="4" value="<%= data.httpReadTimeout%>">
						<div class="input-group-append">
							<span class="input-group-text"><%= translate("seconds")%>, 1 ~ 12</span>
						</div>				
					</div>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Classified Log Retention Days")%></label>
					<div class="input-group">
						<input type="text" class="form-control" id="classifiedRetentionDays"
							name="classifiedRetentionDays" maxlength="4" value="<%= data.classifiedRetentionDays%>">
						<div class="input-group-append">
							<span class="input-group-text"><%= translate("days")%>, 1 ~ 90</span>
						</div>				
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="disableDomainPatternDic"
							name="disableDomainPatternDic" <%if(data.disableDomainPatternDic){out.print("checked");}%>>
						<label for="disableDomainPatternDic" class="custom-control-label"><%= translate("Disable Domain Pattern Analyzer")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="disableCloudClassifier"
							name="disableCloudClassifier" <%if(data.disableCloudClassifier){out.print("checked");}%>>
						<label for="disableCloudClassifier" class="custom-control-label"><%= translate("Disable Cloud Classifier")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="disableClassification"
							name="disableClassification" <%if(data.disableClassification){out.print("checked");}%>>
						<label for="disableClassification" class="custom-control-label"><%= translate("Disable Dynamic Classification")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
				</div>

			</form>
		</div>
	</div>

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
$("#dnsTestTimeout").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) >= 1 && parseInt(value) <= 12;
});
$("#httpConnTimeout").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) >= 1 && parseInt(value) <= 12;
});
$("#httpReadTimeout").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) >= 1 && parseInt(value) <= 12;
});
$("#classifiedRetentionDays").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^\d*$/.test(value) && parseInt(value) >= 1 && parseInt(value) <= 90;
});
</script>
