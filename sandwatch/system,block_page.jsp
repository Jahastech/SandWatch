<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(BlockPageDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	BlockPageData data = new BlockPageData();

	// We use requestString here to preserve all the special characters.
	data.blockPage = requestString("blockPage");
	data.loginPage = requestString("loginPage");
	data.welcomePage = requestString("welcomePage");
	data.passwordPage = requestString("passwordPage");

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
BlockPageDao dao = new BlockPageDao();

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
BlockPageData data = dao.selectOne();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("SYSTEM")%></li>
		<li class="breadcrumb-item text-info"><%= translate("BLOCK PAGE")%></li>
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
						<%= translate("You can edit your block page, login page, welcome page here. When you edit these pages do not modify the template variables between '\\#{' and '}'.", 1000)%>
							<br>&nbsp;&nbsp;ex) \#{domain}, \#{reason}
					</div>

					<div class="form-group col-lg-8">
						<label class="col-form-label"><%= translate("Block Page")%></label>
						<textarea class="form-control" id="blockPage" name="blockPage" rows="6"><%= escapeHtml(data.blockPage)%></textarea>
					</div>

					<div class="form-group col-lg-8">
						<label class="col-form-label">
							<%= translate("Login Page")%>
							<small id="input-help" class="form-text text-muted">
								http://<%= request.getLocalAddr()%>/block,login.jsp
							</small>
						</label>
						<textarea class="form-control" id="loginPage" name="loginPage" rows="6"><%= escapeHtml(data.loginPage)%></textarea>
					</div>

					<div class="form-group col-lg-8">
						<label class="col-form-label">
							<%= translate("Password Page")%>
							<small id="input-help" class="form-text text-muted">
								http://<%= request.getLocalAddr()%>/block,password.jsp
							</small>
						</label>
						<textarea class="form-control" id="passwordPage" name="passwordPage" rows="6"><%= escapeHtml(data.passwordPage)%></textarea>
					</div>

					<div class="form-group col-lg-8">
						<label class="col-form-label"><%= translate("Welcome Page")%>
							<small id="input-help" class="form-text text-muted">
								http://<%= request.getLocalAddr()%>/block,welcome.jsp
							</small>
						</label>
						<textarea class="form-control" id="welcomePage" name="welcomePage" rows="6"><%= escapeHtml(data.welcomePage)%></textarea>
					</div>

					<div class="form-group col-lg-8">
						<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
						<button type="button" class="btn btn-warning" onclick="javascript:restoreDefault(this.form);"><%= translate("RESTORE DEFAULT")%></button>
						<button type="button" class="btn btn-info" onclick="javascript:preview(this.form.blockPage.value);"><%= translate("VIEW BLOCK PAGE")%></button>
						<button type="button" class="btn btn-info" onclick="javascript:preview(this.form.loginPage.value);"><%= translate("VIEW LOGIN PAGE")%></button>
						<button type="button" class="btn btn-info" onclick="javascript:preview(this.form.passwordPage.value);"><%= translate("VIEW PASSWORD PAGE")%></button>
						<button type="button" class="btn btn-info" onclick="javascript:preview(this.form.welcomePage.value);"><%= translate("VIEW WELCOME PAGE")%></button>
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
function preview(text){
	var w = window.open("", "previewWindow", "width=1024,height=600");
	w.document.open();
	w.document.write(text);
	w.document.close();
}

//-----------------------------------------------
function restoreDefault(form){
	if(!confirm('<%= translate("Restore default?")%>')){
		return;
	}

	form.actionFlag.value = "restore";
	form.submit();
}
</script>
