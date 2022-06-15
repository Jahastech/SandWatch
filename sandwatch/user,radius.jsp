<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void update(RadiusDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	RadiusData data = new RadiusData();

    data.radiusAcctPort = paramInt("radiusAcctPort");
    data.radiusSharedSecret = paramString("radiusSharedSecret");
    data.radiusEnableLogout = paramBoolean("radiusEnableLogout");
	data.useRadius = paramBoolean("useRadius");

    data.radiusLocalDomain = paramString("radiusLocalDomain");
    data.radiusGrpId = paramInt("radiusGrpId");
    data.radiusAddNew = paramBoolean("radiusAddNew");

	// Validate and update it.
	if(dao.update(data)){
		succList.add(translate("Update finished."));
		warnList.add(translate("Restart is required to apply new settings."));
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
RadiusDao dao = new RadiusDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("update")){
	update(dao);
}

// Global.
RadiusData data = dao.selectOne();
List<GroupData> gGroupList = new GroupDao().selectListUserCreatedOnly();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("USER")%></li>
		<li class="breadcrumb-item text-info"><%= translate("RADIUS")%></li>
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
					<%= translate("NxFilter supports single sign-on by 802.1x Wi-Fi authentication with its built-in RADIUS accounting server.", 1000)%>
				</div>

				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Accounting Port")%></label>
					<input type="text" class="form-control" id="radiusAcctPort" name="radiusAcctPort"
						value="<%= data.radiusAcctPort%>">
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Shared Secret")%></label>
					<input type="text" class="form-control" id="radiusSharedSecret" name="radiusSharedSecret"
						value="<%= data.radiusSharedSecret%>">
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="radiusEnableLogout"
							name="radiusEnableLogout" <%if(data.radiusEnableLogout){out.print("checked");}%>>
						<label for="radiusEnableLogout" class="custom-control-label"><%= translate("Enable Logout")%></label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="radiusAddNew"
							name="radiusAddNew" <%if(data.radiusAddNew){out.print("checked");}%>>
						<label for="radiusAddNew" class="custom-control-label">
							<%= translate("Auto-register for New User")%>
							&nbsp;<i class="fa fa-question-circle south-east"
								title="<%= translate("Adding new users from 802.1x Wi-Fi authentication automatically.")%>"></i>
						</label>
					</div>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Default Group for New User")%></label>
					<select class="form-control" id="radiusGrpId" name="radiusGrpId">
						<option value="0">anon-grp</option>
<%
for(GroupData grp : gGroupList){
	if(grp.id == data.radiusGrpId){
		printf("<option value='%s' selected>%s</option>\n", grp.id, grp.name);
	}
	else{
		printf("<option value='%s'>%s</option>\n", grp.id, grp.name);
	}
}
%>
					</select>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Local Domain")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("When you recive usernames in an email form (uname@mydomain.loal) you can specify domains to remove."
								+ " At default, NxFilter removes the domain part from an email form username always.")%>"></i>
					</label>
					<input type="text" class="form-control" id="radiusLocalDomain" name="radiusLocalDomain"
						value="<%= data.radiusLocalDomain%>">
				</div>
				<div class="form-group col-lg-8">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="useRadius"
							name="useRadius" <%if(data.useRadius){out.print("checked");}%>>
						<label for="useRadius" class="custom-control-label"><%= translate("Use RADIUS")%></label>
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
$("#radiusAcctPort").inputFilter(function(value){
	if(value == ""){
		return true;
	}

	return /^[\d]*$/.test(value);
});
</script>
