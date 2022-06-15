<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void addDomain(CategorySystemDao dao){
	CategoryDomainData data = new CategoryDomainData();
	data.categoryId = paramInt("id");
	data.domain = paramString("domain");

	// Param validation.
	if(isEmpty(data.domain)){
		return;
	}

	String[] arr = data.domain.split("\\s+");
	for (String domain : arr) {
		domain = domain.trim();

		if (!isValidDomain(domain)) {
			errList.add(translate("Invalid domain.") + " - " + domain);
			return;
		}
	}

	if(dao.addDomain(data)){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void deleteDomain(CategorySystemDao dao){
	if(dao.deleteDomain(paramInt("domainId"))){
		succList.add(translate("Update finished."));
	}
}

//-----------------------------------------------
void deleteDomainAll(CategorySystemDao dao, int categoryId){
	if(dao.deleteDomainAll(categoryId)){
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

// Action.
String actionFlag = paramString("actionFlag");
System.out.println(actionFlag);
if(actionFlag.equals("addDomain")){
	addDomain(dao);
}
if(actionFlag.equals("deleteDomain")){
	deleteDomain(dao);
}
if(actionFlag.equals("deleteDomainAll")){
	deleteDomainAll(dao, paramInt("id"));
}

// Global.
CategoryData data = dao.selectOne(paramInt("id"));

// Preventing null pointer exception when a domain classified into
// a custom category on 'Logging > Request'.
if(data == null){
	return;
}
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("CATEGORY")%></li>
		<li class="breadcrumb-item"><%= translate("SYSTEM")%></li>
		<li class="breadcrumb-item text-info"><%= translate("EDIT")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="update">
				<input type="hidden" name="id" value="<%= data.id%>">
				<input type="hidden" name="domainId">

				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Name")%></label>
					<input type="text" class="form-control" id="name" name="name" value="<%= data.name%>" disabled>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Description")%></label>
					<input type="text" class="form-control" id="description"
						name="description" value="<%= data.description%>" disabled>
				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
				</div>

				<hr class="my-4">

				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Domain")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("You can add multiple domains separated by spaces.")%>"></i>
					</label>
					<textarea class="form-control" id="domain" name="domain"></textarea>
					<button type="button" class="btn btn-primary btn-sm" style="margin-top: 3px;"
						onclick="javascript:actionAddDomain(this.form)"><%= translate("ADD DOMAIN")%></button>
					<button type="button" class="btn btn-warning btn-sm" style="margin-top: 3px;"
						onclick="javascript:actionDeleteDomainAll(this.form)"><%= translate("DELETE DOMAIN ALL")%></button>
				</div>

				<div class="form-group col-lg-12">
<%
List<CategoryDomainData> domainList = data.getDomainList();
for(int i = 0; i < domainList.size(); i++){
	CategoryDomainData cd = domainList.get(i);

	printf("<span class='domain-item'><a class='xlink' href='javascript:actionDeleteDomain(%s)'>[x]</a> %s</span>", cd.id, cd.domain);
}
%>
				</div>

			</form>
		</div>
	</div>

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>

<script>
//-----------------------------------------------
function actionUpdate(form){
	form.actionFlag.value = "update";
	form.submit();
}

//-----------------------------------------------
function actionAddDomain(form){
	form.actionFlag.value = "addDomain";
	form.submit();
}

//-----------------------------------------------
function actionDeleteDomain(domainId){
	form = document.forms[0];
	form.actionFlag.value = "deleteDomain";
	form.domainId.value = domainId;
	form.submit();
}

//-----------------------------------------------
function actionDeleteDomainAll(){
	if(!confirm('<%= translate("Deleting all domains.")%>')){
		return;
	}

	form = document.forms[0];
	form.actionFlag.value = "deleteDomainAll";
	form.submit();
}
</script>