<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(PolicyCxBlockDao dao){
	PolicyCxBlockData data = new PolicyCxBlockData();
	data.enableFilter = paramBoolean("enableFilter");
	data.cacheTtl = paramInt("cacheTtl");
	data.blockedKeyword = paramString("blockedKeyword");

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
PolicyCxBlockDao dao = new PolicyCxBlockDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
PolicyCxBlockData data = dao.selectOne();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("POLICY")%></li>
		<li class="breadcrumb-item text-info"><%= translate("CXBLOCK")%></li>
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
					 <%= translate("CxBlock is a remote filtering agent for Chrome, Edge like browsers.")%>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="enableFilter"
							name="enableFilter" <%if(data.enableFilter){out.print("checked");}%>>
						<label for="enableFilter" class="custom-control-label"><%= translate("Enable Filter")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Query Cache TTL")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("CxBlock keeps its filtering query result in cache.")%>"></i>
					</label>
					<div class="input-group">
						<input type="text" class="form-control" id="cacheTtl"
							name="cacheTtl" value="<%= data.cacheTtl%>">
						<div class="input-group-append">
							<span class="input-group-text">seconds, 60 ~ 3600</span>
						</div>				
					</div>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Blocked Keywords in URL")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("You can add blocked keywords separated by spaces.")%>"></i>
					</label>
					<textarea class="form-control" id="blockedKeyword" name="blockedKeyword" rows="18"><%= data.blockedKeyword%></textarea>
				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary">Submit</button>
				</div>

			</form>
		</div>
	</div>

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>
