<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(AllowedIpDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	AllowedIpData data = new AllowedIpData();
	data.guiAllowed = paramString("guiAllowed");

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
AllowedIpDao dao = new AllowedIpDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
AllowedIpData data = dao.selectOne();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("SYSTEM")%></li>
		<li class="breadcrumb-item text-info"><%= translate("GUI ACCESS CONTROL")%></li>
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
					<%= translate("This is an IP based access control to GUI. You can add IP addresses in the following format.")%>
					<div class="tab">
						ex) <%= translate("192.168.1 - IP addresses which start with '192.168.1'")%>
					</div>
					</p>

				<%= translate("You can add multiple IP addresses separated by spaces or newlines.")%>
					<div class="tab">
						ex) 192.168.1 192.168.2<br>
						192.168.3
					</div>
					</p>

				<%= translate("For exact matching add a tailing dot.")%>
					<div class="tab">
						ex) 192.168.0.100. 192.168.0.200.
					</div>
				</div>

				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Allowed IP to GUI")%>
						&nbsp;<i class="fa fa-question-circle south-east" title="<%= translate("127.0.0.1 is always allowed")%>"></i>
					</label>
					<textarea class="form-control" id="guiAllowed" name="guiAllowed" rows="10"><%= data.guiAllowed%></textarea>
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
