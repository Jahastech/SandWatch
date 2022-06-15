<%@include file="include/header.jsp"%>
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
DomainTestDao dao = new DomainTestDao();

// Global.
DomainTestData data = dao.test(paramString("domain"));
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("CATEGORY")%></li>
		<li class="breadcrumb-item text-info"><%= translate("DOMAIN TEST")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">

				<div class="form-group col-lg-8 text-secondary">
					 <%= translate("Finding categories for a domain.")%>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Domain")%></label>
					<input type="text" class="form-control" id="domain"
						name="domain" value="<%= data.domain%>">
				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
				</div>

<%if(isNotEmpty(data.category)){%>
				<hr class="my-4">

				<div class="form-group col-lg-12">
					<%= data.category%>
				</div>
<%}%>

			</form>
		</div>
	</div>

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>
