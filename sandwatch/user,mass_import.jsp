<%@include file="include/header.jsp"%>
<%!
//-----------------------------------------------
void insert(UserDao dao){
	String usernames = paramString("usernames");
	int grpId = paramInt("grpId");
	String description = paramString("description");

	String[] arr = usernames.split("\\s+");
	for(String a : arr){
		UserData data = new UserData();
		data.name = a;
		data.grpId = grpId;
		data.massFlag = true;
		data.description = description;

		// Param validation.
		if(!ParamTest.isValidNameLen(data.name)){
			errList.add(translate("Name length must be between 1 and 64.") + " - " + data.name);
			break;
		}
		
		if(!ParamTest.isValidUsernameChar(data.name)){
			errList.add(translate("Only alphabet, number, [.@-_] allowed in name.") + " - " + data.name);
			break;
		}

		if (ParamTest.isDupUser(data.name)) {
			continue;
		}

		if(!dao.insert(data)){
			errList.add(translate("Couldn't add a user!") + " - " + data.name);
			break;
		}
	}

	// Reload user dictionary.
	dao.reloadUserDic();

	if(errList.size() > 0){
		return;
	}

	succList.add(translate("Update finished."));
}

//-----------------------------------------------
void delete(UserDao dao){
	if(demoFlag){
		errList.add("Not allowed on demo site.");
		return;
	}

	if(dao.deleteMassImportedUsers()){
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
UserDao dao = new UserDao();

// Action.
String actionFlag = paramString("actionFlag");
if(actionFlag.equals("insert")){
	insert(dao);
}
if(actionFlag.equals("delete")){
	delete(dao);
}

// Get policy list.
List<GroupData> gGroupList = new GroupDao().selectListUserCreatedOnly();
%>
<!-- Action info -->
<%@include file="include/ab-notify.jsp"%>
<!-- /Action info -->

<!-- Breadcrumb -->
<div class="container-fluid primary" style="margin-top:-5px;">
	<ol class="breadcrumb" style="margin-left:10px; margin-right:10px;">
		<li class="breadcrumb-item"><%= translate("USER")%></li>
		<li class="breadcrumb-item text-info"><%= translate("MASS IMPORT")%></li>
	</ol>
</div>
<!-- /Breadcrumb -->

<!-- Main content -->
<div class="container-fluid">

	<div class="card bg-light m-2 expand-lg">
		<div class="card-body">
			<form action="<%= getPageName()%>" method="post">
				<input type="hidden" name="actionFlag" value="insert">
				<div class="form-group col-lg-8 text-secondary">
					<%= translate("You can create new users en masse here.")%>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label">
						<%= translate("Username")%>
						&nbsp;<i class="fa fa-question-circle south-east"
							title="<%= translate("Multiple usernames should be separated by spaces.")%>"></i>
					</label>
					<textarea class="form-control" id="usernames" name="usernames" rows="16"></textarea>
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Description")%></label>
					<input type="text" class="form-control" id="description" name="description" >
				</div>
				<div class="form-group col-lg-8">
					<label class="col-form-label"><%= translate("Default Group for New User")%></label>
					<select class="form-control" id="grpId" name="grpId">
						<option value="0">anon-grp</option>
<%
for(GroupData grp : gGroupList){
	printf("<option value='%s'>%s</option>\n", grp.id, grp.name);
}
%>
					</select>
				</div>
				<div class="form-group col-lg-8">
					<button type="submit" class="btn btn-primary"><%= translate("SUBMIT")%></button>
					<button type="button" class="btn btn-warning" onclick="javascript:actionDelete(this.form);"><%= translate("DELETE MASS IMPORTED USERS")%></button>
				</div>

			</form>
		</div>
	</div>

</div>
<!-- /Main content -->

<%@include file="include/footer.jsp"%>

<script type="text/javascript">
//-----------------------------------------------
function actionDelete(form){
	if(!confirm('<%= translate("Deleting mass imported users.")%>')){
		return;
	}

	form.action = "<%= getPageName()%>";
	form.actionFlag.value = "delete";
	form.submit();
}
</script>
