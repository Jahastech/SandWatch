<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(AccessControlDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	AccessControlData data = new AccessControlData();
	data.dnsAllowed = paramString("dnsAllowed");
	data.dnsBlocked = paramString("dnsBlocked");
	data.bypassAll = paramString("bypassAll");

	String invalidIp = ParamTest.findInvalidAllowedIp(data.dnsAllowed);
	if(isEmpty(invalidIp)){
		invalidIp = ParamTest.findInvalidAllowedIp(data.dnsBlocked);
	}
	if(isEmpty(invalidIp)){
		invalidIp = ParamTest.findInvalidAllowedIp(data.bypassAll);
	}

	if(isNotEmpty(invalidIp)){
		if(invalidIp.contains("/")){
			errList.add(translate("Invalid CIDR") + " - " + invalidIp);
			return;
		}

		if(invalidIp.contains("-")){
			errList.add(translate("Invalid IP range") + " - " + invalidIp);
			return;
		}

		errList.add(translate("Invalid IP") + " - " + invalidIp);
		return;
	}

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
AccessControlDao dao = new AccessControlDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
AccessControlData data = dao.selectOne();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("DNS")%></li>
		<li class="breadcrumb-item text-info"><%= translate("ACCESS CONTROL")%></li>
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
					<%= translate("This is an IP based access control. You can add IP addresses, IP ranges, CIDRs separated by spaces or newlines.")%>
					</p>

					<div class="tab">
						ex) 192.168.0.10 192.168.0.20<br>
						192.168.0.21-192.168.0.100<br>
						192.168.1.0/24
					</div>
				</div>

				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Allowed IP for DNS")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("Whitelist based access control. If there's nothing added here, everybody can access DNS service.")%>"></i>
					</label>
					<textarea class="form-control" id="dnsAllowed" name="dnsAllowed" rows="4"><%= data.dnsAllowed%></textarea>
				</div>

				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Blocked IP for DNS")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("Blacklist based access control. It overrides Allowed IP for DNS.")%>"></i>
					</label>
					<textarea class="form-control" id="dnsBlocked" name="dnsBlocked" rows="4"><%= data.dnsBlocked%></textarea>
				</div>

				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Bypass All")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("Bypass from authentication and filtering, logging.")%>"></i>
					</label>
					<textarea class="form-control" id="bypassAll" name="bypassAll" rows="4"><%= data.bypassAll%></textarea>
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
