<%@ page language="java" import="java.util.*" pageEncoding="utf-8"
	contentType="text/html; charset=utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<%
	String ids = (String) request.getSession().getAttribute("ids");
	if (ids != null) {
		if (!ids.contains("5")) {
			response.sendRedirect(basePath);
			return;
		}
	} else {
		response.sendRedirect(basePath);
		return;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html lang="zh">
<head>
<meta charset="utf-8" />
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>/js/jquery-easyui-1.2.6/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css"
		href="<%=basePath%>/js/jquery-easyui-1.2.6/themes/icon.css">
		<link rel="stylesheet" type="text/css"
			href="<%=basePath%>/js/jquery-easyui-1.2.6/demo/demo.css">
			<link href="<%=basePath%>/css/06.css" rel="stylesheet"
				type="text/css" />
			<script type="text/javascript"
				src="<%=basePath%>/js/jquery-easyui-1.2.6/jquery-1.7.2.min.js">
	</script>
			<script type="text/javascript"
				src="<%=basePath%>/js/jquery-easyui-1.2.6/jquery.easyui.min.js">
		</script>
			<script type="text/javascript"
				src="<%=basePath%>/js/jquery-easyui-1.2.6/locale/easyui-lang-zh_CN.js">
	 </script>
			<script>
			 window.onresize = function() {
		      $('#tenant-main').datagrid('resize', {
			          width : 1610,
			          height : 720
		                })
	          }
				$(function() {
					$('#tenant-main').datagrid({
						iconcls : 'icon-save',
						/* 	width:700,
							height:350, */
						width : $(window).width() - 100,
						height : $(window).height() - 100,
						fitColumns : true,
						nowrap : false,
						striped : true,
						collapsible : true,
						url : '<%=basePath%>population/tenantInfo',
						sortOrder : 'desc',
						remoteSort : false,
						frozenColumns : [ [
							{
								title : '姓名',
								field : 'tenantName',
								width : 490,
								sortable : true
							},
							{
								title : '地址',
								field : 'address',
								width : 300,
								sortable : true
							},
							{
								title : '房间号',
								field : 'roomNumber',
								width : 310,
								sortable : true
							}
						] ],
						columns : [ [
							{
								field : 'opt',
								title : '操作',
								width : 180,
								align : 'left',
								formatter : formatOper
							}
			
						] ],
						pagination : true,
						rownumbers : true,
						toolbar : [
			
							{
								id : 'btnadd',
								text : '添加',
								iconCls : 'icon-add', //弹出框图标			
								handler : function() {
									addTenant();
								}
							} ]
					});
					$(function(){
						var roleId = ${user.roleId};
						if(roleId!=4){
							$('div.datagrid div.datagrid-toolbar a').eq(0).hide();
						}
					});
					var p = $('#tenant-main').datagrid('getPager');
					$(p).pagination({
						onBeforeRefresh : function() {
							/* alert('before refresh'); */
						}
					});
				});
				
        
				function formatOper(value, row, index) {
					var c = '<a href="#" onclick="houseManager(' + index + ')">房间管理 |</a> ';
					var e = '<a href="#" onclick="editrow(' + index + ')">编辑 |</a> ';
					var d = '<a href="#" onclick="deleterow(' + index + ')">删除</a>';
					return c + e + d;
				}
				var url;
				function addTenant() {
					$('#addTenant').dialog('open');
					$("#addTenantForm").form("clear");
					url = '<%=basePath%>population/addOrUpdateToTenant';
				}
			
				function houseManager(index) {
					$('#tenant-main').datagrid('selectRow', index);
					var row = $('#tenant-main').datagrid('getSelected');
					if (row) {
						$('#room').dialog('open').dialog('setTitle', '房间管理');
					}
				}
			
				function editrow(index) {
				
					url='<%=basePath%>population/updateTenant';
					$('#tenant-main').datagrid('selectRow', index);
					var row = $('#tenant-main').datagrid('getSelected');
					document.getElementById('updateTenantId').value = row.tenantId; 
						$('#updateTenant').dialog('open').dialog('setTitle', '编辑房客');
						$.ajax({
							url : '<%=basePath%>population/updateGetTenant?tenantId=' + row.tenantId + '&type=stu',
							//加了个type，作用是以后不管什么删除，都可以转到这个ashx中处理
							dataType : 'json',
							success : function(tenant) {
								//返回的数据在role中  
								document.getElementById("updateTenantName").value = tenant.tenantName;
								document.getElementById("updateRoomNumber").value = tenant.roomNumber;
								$('#tenant-main').datagrid('reload');
							}
						});
					
				}
				function deleterow(index) { //删除操作
					$.messager.confirm('确认', '确认删除?', function(row) {
						if (row) {
							var selectedRow = $('#tenant-main').datagrid('getSelected'); //获取选中行
							$.ajax({
								url : '<%=basePath%>population/deleteTenant?id=' + selectedRow.tenantId + '&type=stu',
								//加了个type，作用是以后不管什么删除，都可以转到这个ashx中处理
								success : function(result) {
									if (result == 1) {
										alert('删除成功');
										$('#tenant-main').datagrid('reload');
									}
									else {
										alert('刪除失敗');
									}
								}
							});
							$('#tenant-main').datagrid('deleteRow', index);
						}
					})
				}
			
				function saveUser() {
					$("#addTenantForm").form("submit", {
						url : url,
						onsubmit : function() {
							return $(this).form("validate");
						},
						success : function(result) {
							if (result == "1") {
								$.messager.alert("提示信息", "操作成功");
								$("#addTenant").dialog("close");
								$("#dg").datagrid("load");
							}
							else {
								$.messager.alert("提示信息", "操作失败");
							}
						}
					});
				}
				
				function updateUser() {
					$("#updateTenantForm").form("submit", {
						url : url,
						onsubmit : function() {
							return $(this).form("validate");
						},
						success : function(result) {
							if (result == "1") {
								$.messager.alert("提示信息", "操作成功");
								$("#updateTenant").dialog("close");
								$("#tenant-main").datagrid("load");
							}
							else {
								$.messager.alert("提示信息", "操作失败");
							}
						}
					});
				}
			</script>
</head>
<body>

	<table id="tenant-main"></table>
	<div id="addTenant" class="easyui-dialog" title="添加房客"
		style="width:400px;height:200px;text-align:center" resizable="true"
		modal="true" closed="true" buttons="#tenant-dlg-buttons">
		<br />
		<form id="addTenantForm" method="post">
			<table border="0" cellpadding="1" align="center">
				<tr>
					<td><label>姓名</label></td>
					<td><input name="tenantName" class="easyui-text"
						required="false" /></td>
				</tr>
				<tr>
					<td><label>地址 </label></td>
					<td><input name="address" class="easyui-text" required="false" />
					</td>
				</tr>
				<tr>
					<td><label>房间号</label></td>
					<td><input name="roomNumber" class="easyui-text"
						required="false" /></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="tenant-dlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			onclick="saveUser()" iconcls="icon-add">添加</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			onclick="javascript:$('#addTenant').dialog('close')"
			iconcls="icon-cancel">取消</a>
	</div>
	<div id="updateTenant" class="easyui-dialog"
		style="width: 400px; height: 200px; padding: 10px 20px;" closed="true"
		buttons="#tenant-dlg-buttons-2">
		<form id="updateTenantForm">
			<table border="0" cellpadding="1" align="center">
				<tr>
					<td><label>姓名</label></td>
					<td><input name="tenantName" id="updateTenantName"
						class="easyui-text" required="false" /></td>
				</tr>
				<tr>
					<td><label>房间号</label></td>
					<td><input name="roomNumber" id="updateRoomNumber"
						class="easyui-text" required="false" /></td>
				</tr>
			</table>
			<input type="hidden" name="tenantId" id="updateTenantId" value = "0">
		</form>
		<div id="tenant-dlg-buttons-2">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				onclick="updateUser()" iconcls="icon-save">保存</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				onclick="javascript:$('#updateTenant').dialog('close')"
				iconcls="icon-cancel">取消</a>
		</div>
	</div>

	<div id="room" class="easyui-dialog" title="房间管理"
		style="width:400px;height:200px;text-align:center" resizable="true"
		modal="true" closed="true" buttons="#tenant-dlg-buttons-1">
		<br />
		<table border="0" cellpadding="1" align="center">
			<tr>
				<td><label>房间号:</label></td>
				<td><input type="text" id="room_qrcode" /></td>
			</tr>
			<tr>
				<td><label>房间二维码:</label></td>
				<td><input type="text" id="room_qrcode" /></td>
			</tr>
		</table>
		<div id="tenant-dlg-buttons-1">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				onclick="saveuser()" iconcls="icon-save">保存</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				onclick="javascript:$('#dlg').dialog('close')" iconcls="icon-cancel">取消</a>
		</div>
		<script>
			function clearForm() {
				$('#room').form('clear');
			}
		</script>
	</div>



</body>
</html>