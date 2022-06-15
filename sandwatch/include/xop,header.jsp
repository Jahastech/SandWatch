<%@include file="lib.jsp"%>
<%
response.setDateHeader("Expires", -1);
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Expires" content="-1"> 
<meta http-equiv="Pragma" content="no-cache"> 
<meta http-equiv="Cache-Control" content="no-cache"> 
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="lib/fa6/css/all.min.css">
<link rel="stylesheet" href="lib/bootstrap.css">
<link rel="stylesheet" href="lib/nxlib.css">
<style type="text/css">
body{
	font-family: sans-serif;
	background-image: url("img/first.jpg");
}
.modal-login{
	color: #636363;
	width: 350px;
}
.modal-login .modal-content{
	padding: 20px;
	border-radius: 5px;
	border: none;
}
.modal-login .modal-header{
	border-bottom: none;
	position: relative;
	justify-content: center;
}
.modal-login h4{
	text-align: center;
	font-size: 26px;
}
.modal-login  .form-group{
	position: relative;
}
.modal-login i{
	position: absolute;
	left: 13px;
	top: 11px;
	font-size: 18px;
}
.modal-login .form-control{
	padding-left: 40px;
}
.modal-login .form-control:focus{
	border-color: #00ce81;
}
.modal-login .form-control, .modal-login .btn{
	min-height: 40px;
	border-radius: 3px; 
}
.modal-login .hint-text{
	text-align: center;
	padding-top: 10px;
}
.modal-login .close{
	position: absolute;
	top: -5px;
	right: -5px;
}
.modal-login .btn{
	background: #00ce81;
	border: none;
	line-height: normal;
}
.modal-login .btn:hover, .modal-login .btn:focus{
	background: #00bf78;
}
.modal-login .modal-footer{
	background: #ecf0f1;
	border-color: #dee4e7;
	text-align: center;
	margin: 0 -20px -20px;
	border-radius: 5px;
	font-size: 13px;
	justify-content: center;
}
.modal-login .modal-footer a{
	color: #999;
}
.trigger-btn{
	display: inline-block;
	margin: 100px auto;
}
</style>
<title><%= getNxName()%> v<%= getNxVersion()%></title>
</head>
<body bgproperties="fixed">
