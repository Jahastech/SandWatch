<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(MobileConfigDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	MobileConfigData data = new MobileConfigData();

	// We use requestString here to preserve all the special characters.
	data.template = requestString("template");

	if(dao.update(data)){
		succList.add(translate("Update finished."));
	}
}
%>
<%
//-----------------------------------------------
// Set permission for this page.
permission.addAdmin();

//Check permission.
if(!checkPermission()){
	return;
}

// Create data access object.
MobileConfigDao dao = new MobileConfigDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}
if(actionFlag.equals("restore")){
	if(dao.restoreDefault()){
		succList.add(translate("Update finished."));
	}
}

// Global.
MobileConfigData data = dao.selectOne();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("SYSTEM")%></li>
		<li class="breadcrumb-item text-info"><%= translate("MOBILE CONFIG")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="update">
				<fieldset>

					<div class="form-group col-lg-8 text-secondary">
						<%= translate("You can create a template for iOS, macOS mobile config file. You should not modify the template variables between '\\#{' and '}'.", 1000)%>
					</div>

					<div class="form-group col-lg-8">
						<label class="col-form-label">
							<%= translate("Mobile Config File Template")%>
							&nbsp;<i class="fa fa-question-circle south-east"
								title="<%= translate("You need to set your own domain in the template. You can download a user specific mobile config file based on this template from user edit page.")%>"></i>
						</label>
						<textarea class="form-control" id="template" name="template" rows="22"><%= escapeHtml(data.template)%></textarea>
					</div>

					<div class="form-group col-lg-8">
						<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
						<button type="button" class="btn btn-warning" onclick="javascript:restoreDefault(this.form);"><%= translate("RESTORE DEFAULT")%></button>
					</div>

				</fieldset>
			</form>
		</div>
	</div>

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>

<script>
//-----------------------------------------------
function restoreDefault(form){
	if(!confirm('<%= translate("Restore default?")%>')){
		return;
	}

	form.actionFlag.value = "restore";
	form.submit();
}
</script>
