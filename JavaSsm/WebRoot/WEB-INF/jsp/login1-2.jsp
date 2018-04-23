<%@ page language="java" import="java.util.*" pageEncoding="utf-8"
	contentType="text/html; charset=utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html lang="zh">
<head>
<title>Login</title>
<meta charset="utf-8" />
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>/js/jquery-easyui-1.2.6/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>/js/jquery-easyui-1.2.6/themes/icon.css">
<script type="text/javascript"
	src="<%=basePath%>/js/jquery-easyui-1.2.6/jquery-1.7.2.min.js">
	</script>
<script type="text/javascript"
	src="<%=basePath%>/js/jquery-easyui-1.2.6/jquery.easyui.min.js">
	 </script>
<script type="text/javascript">
	$(function() {
		$("#login").click(function() {
			$("#loginForm").submit();
		});
	});
</script>
<script type="text/javascript">
	$(function() {
		$("#reset").click(function() {
			$("#loginForm").submit();
		});
	});
</script>
<!-- <script type="text/javascript">
	$(function() {
		$("#reset").click(function() {
			$("#loginForm").submit();
		});
	});
</script> -->
</head>

<body>
	<div id="win" class="easyui-window" title="登录"
		style="width:300px;height:240px;">
		<form id="loginForm" action="login" method="post" style="padding:10px 20px 10px 40px;">
			<p>
				账号: <input type="text" name="userName"><br>
				<br/>
				<font color="#f00">${userNull }</font>
			</p>
			<p>
				密码: <input type="password" name="password"><br><br/>
				<font color="#f00">${pswFail }</font>
			</p>
			<div style="padding:5px;text-align:center;">
				<a class="easyui-linkbutton" icon="icon-ok" id="login">登入</a>
				<a class="easyui-linkbutton" icon="icon-cancel" id="reset">重置</a>
			</div>
		</form>
	</div>

</body>
</html>
  