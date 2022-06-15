<%@include file="lib.jsp"%>
<%@include file="customLib.jsp"%>
<%
response.setDateHeader("Expires", -1);
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="Expires" content="-1"> 
<meta http-equiv="Pragma" content="no-cache"> 
<meta http-equiv="Cache-Control" content="no-cache">
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" href="/lib/bootstrap.css" media="screen">
<link rel="stylesheet" href="/lib/custom.css">
<link rel="stylesheet" href="/lib/fa6/css/all.min.css">
<link rel="stylesheet" href="/lib/dataTables.1.10.20.css">
<link rel="stylesheet" href="/lib/jquery.powertip.min.css">
<link rel="stylesheet" href="/lib/xdpick/jquery.datetimepicker.css"/>
<link rel="stylesheet" href="/lib/nxlib.css">
<title><%= getNxName()%> v<%= getNxVersion()%></title>
</head>

<body>
	<div class="navbar navbar-expand-lg fixed-top navbar-dark bg-primary">
		<div class="container-fluid">
			<a href="dashboard.jsp" class="navbar-brand"><img id="logo" class="d-inline-block mr-1" alt="Logo" src="img/logo.png"></a>
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive"
				aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarResponsive">
				<ul class="navbar-nav mr-auto">
					<li class="nav-item">
						<a class="nav-link" href="dashboard.jsp"><%= translate("DASHBOARD")%></a>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#"><%= translate("SYSTEM")%>&nbsp;<span class="caret"></span></a>
						<div class="dropdown-menu">
							<a class="dropdown-item" href="system,setup.jsp"><%= translate("SETUP")%></a>
							<a class="dropdown-item" href="system,admin.jsp"><%= translate("ADMIN")%></a>
							<a class="dropdown-item" href="system,sub_admin.jsp"><%= translate("SUB-ADMIN")%></a>
							<a class="dropdown-item" href="system,alert.jsp"><%= translate("ALERT")%></a>
							<a class="dropdown-item" href="system,allowed_ip.jsp"><%= translate("GUI ACCESS CONTROL")%></a>
							<a class="dropdown-item" href="system,backup.jsp"><%= translate("BACKUP")%></a>
							<a class="dropdown-item" href="system,block_page.jsp"><%= translate("BLOCK PAGE")%></a>
							<a class="dropdown-item" href="system,cluster.jsp"><%= translate("CLUSTERING")%></a>
						</div>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#"><%= translate("DNS")%>&nbsp;<span class="caret"></span></a>
						<div class="dropdown-menu">
							<a class="dropdown-item" href="dns,setup.jsp"><%= translate("SETUP")%></a>
							<a class="dropdown-item" href="dns,access_control.jsp"><%= translate("ACCESS CONTROL")%></a>
							<a class="dropdown-item" href="dns,server_protection.jsp"><%= translate("SERVER PROTECTION")%></a>
							<a class="dropdown-item" href="dns,zone_file.jsp"><%= translate("ZONE FILE")%></a>
							<a class="dropdown-item" href="dns,zone_transfer.jsp"><%= translate("ZONE TRANSFER")%></a>
							<a class="dropdown-item" href="dns,redirection.jsp"><%= translate("REDIRECTION")%></a>
						</div>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#"><%= translate("USER")%>&nbsp;<span class="caret"></span></a>
						<div class="dropdown-menu">
							<a class="dropdown-item" href="user,user.jsp"><%= translate("USER")%></a>
							<a class="dropdown-item" href="user,group.jsp"><%= translate("GROUP")%></a>
							<a class="dropdown-item" href="user,adap.jsp"><%= translate("ACTIVE DIRECTORY")%></a>
							<a class="dropdown-item" href="user,mass_import.jsp"><%= translate("MASS IMPORT")%></a>
							<a class="dropdown-item" href="user,radius.jsp"><%= translate("RADIUS")%></a>
							<a class="dropdown-item" href="user,vxlogon.jsp"><%= translate("VXLOGON")%></a>
							<a class="dropdown-item" href="user,cxlogon.jsp"><%= translate("CXLOGON")%></a>
							<a class="dropdown-item" href="user,login_request.jsp"><%= translate("LOGIN REQUEST")%></a>
						</div>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#"><%= translate("POLICY")%>&nbsp;<span class="caret"></span></a>
						<div class="dropdown-menu">
							<a class="dropdown-item" href="policy,policy.jsp"><%= translate("POLICY")%></a>
							<a class="dropdown-item" href="policy,free_time.jsp"><%= translate("FREE TIME")%></a>
							<a class="dropdown-item" href="policy,nxproxy.jsp"><%= translate("NXPROXY")%></a>
							<a class="dropdown-item" href="policy,cxblock.jsp"><%= translate("CXBLOCK")%></a>
						</div>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#"><%= translate("CATEGORY")%>&nbsp;<span class="caret"></span></a>
						<div class="dropdown-menu">
							<a class="dropdown-item" href="category,system.jsp"><%= translate("SYSTEM")%></a>
							<a class="dropdown-item" href="category,custom.jsp"><%= translate("CUSTOM")%></a>
							<a class="dropdown-item" href="category,domain_test.jsp"><%= translate("DOMAIN TEST")%></a>
						</div>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#"><%= translate("CLASSIFIER")%>&nbsp;<span class="caret"></span></a>
						<div class="dropdown-menu">
							<a class="dropdown-item" href="classifier,setup.jsp"><%= translate("SETUP")%></a>
							<a class="dropdown-item" href="classifier,classified.jsp"><%= translate("CLASSIFIED")%></a>
							<a class="dropdown-item" href="classifier,blocklist.jsp"><%= translate("BLOCKLIST")%></a>
							<a class="dropdown-item" href="classifier,jahaslist.jsp"><%= translate("JAHASLIST")%></a>
						</div>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#"><%= translate("WHITELIST")%>&nbsp;<span class="caret"></span></a>
						<div class="dropdown-menu">
							<a class="dropdown-item" href="whitelist,domain.jsp"><%= translate("DOMAIN")%></a>
							<a class="dropdown-item" href="whitelist,keyword.jsp"><%= translate("KEYWORD")%></a>
							<a class="dropdown-item" href="whitelist,common_bypass.jsp"><%= translate("COMMON BYPASS")%></a>
							<a class="dropdown-item" href="whitelist,temp.jsp"><%= translate("TEMPORARY")%></a>
						</div>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#"><%= translate("LOGGING")%>&nbsp;<span class="caret"></span></a>
						<div class="dropdown-menu">
							<a class="dropdown-item" href="logging,request.jsp"><%= translate("DNS REQUEST")%></a>
							<a class="dropdown-item" href="logging,signal.jsp"><%= translate("AGENT SIGNAL")%></a>
							<a class="dropdown-item" href="logging,netflow.jsp"><%= translate("NETFLOW")%></a>
							<a class="dropdown-item" href="logging,admin_activity.jsp"><%= translate("ADMIN ACTIVITY")%></a>
						</div>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" id="download"><%= translate("REPORT")%>&nbsp;<span class="caret"></span></a>
						<div class="dropdown-menu">
							<a class="dropdown-item" href="report,daily.jsp"><%= translate("DAILY")%></a>
							<a class="dropdown-item" href="report,weekly.jsp"><%= translate("WEEKLY")%></a>
							<a class="dropdown-item" href="report,usage.jsp"><%= translate("USAGE")%></a>
						</div>
					</li>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#"><%= translate("HELP")%>&nbsp;<span class="caret"></span></a>
						<div class="dropdown-menu">
							<a class="dropdown-item" target="_blank" href="<%= getNxTutorial()%>"><%= translate("TUTORIAL")%></a>
							<a class="dropdown-item" target="_blank" href="<%= getNxForum()%>"><%= translate("SUPPORT FORUM")%></a>
							<a class="dropdown-item" href=""><%= translate("VERSION")%>&nbsp;<%= getNxVersion()%></a>
							<%if(isSubAdmin()){%>
								<a class="dropdown-item" href="help,mypage.jsp"><%= translate("MY PAGE")%></a>
							<%}%>
						</div>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="admin.jsp?actionFlag=logout"><%= translate("LOGOUT")%></a>
					</li>
				</ul>

			</div>
		</div>
	</div>
