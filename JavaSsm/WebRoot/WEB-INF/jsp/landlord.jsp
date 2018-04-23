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
		if (!ids.contains("4")) {
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
	href="../js/jquery-easyui-1.4.4/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"
	href="../js/jquery-easyui-1.4.4/themes/icon.css">
<link rel="stylesheet" type="text/css"
	href="../js/jquery-easyui-1.4.4/demo/demo.css">
<link href="../css/06.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="../js/jquery-easyui-1.4.4/jquery.min.js">
	</script>
<script type="text/javascript"
	src="../js/jquery-easyui-1.4.4/jquery.easyui.min.js">
		</script>
<script type="text/javascript"
	src="../js/jquery-easyui-1.4.4/locale/easyui-lang-zh_CN.js">
	 </script>
<script>

	window.onresize = function() {
		$('#landlord-main').datagrid('resize', {
			width : 1610,
			height : 720
		})
	}
	var landlordName = "";
	var telephone = "";
	var identity = "";
	var url_data = '<%=basePath%>population/selectLanlord?landlordName='+
	landlordName+'&telephone='+telephone+'&identity='+identity;
	
	function SearchLanlord(){
	     landlordName = $("#landlordName").val();
	     telephone = $("#telephone").val();
	     identity = $("#identity").val();
	     alert(landlordName+""+telephone+""+identity);
	     url_data = '<%=basePath%>population/selectLanlord?landlordName='+
	     landlordName+'&telephone='+telephone+'&identity='+identity;
	     <%-- url_data = '<%=basePath%>population/landlordInfo'; --%>
	     $('#landlord-main').datagrid('options').url = url_data;
         $('#landlord-main').datagrid('reload');  	
	}
	
	$(function() {
	url_data = '<%=basePath%>population/landlordInfo';
	$('#landlord-main').datagrid({
			iconCls : 'icon_save',
			/* 	width:700,
				height:350, */
			width : $(window).width() - 100,
			height : $(window).height() - 100,
			nowrap : false,
			striped : true,
			collapsible : true,
			fitColumns : true,
			url : url_data,
			sortOrder : 'desc',
			idField : 'landlordId',
			remoteSort : false,
			frozenColumns : [ [
				{
					field : 'landlordId',
					checkbox : true
				},
				{
					title : '姓名',
					field : 'landlordName',
					width : 100,
					sortable : true,
				},
				{
					title : '联系方式',
					field : 'telephone',
					width : 150,
					sortable : true
				},
				{
					title : '身份证号',
					field : 'identity',
					width : 200,
					sortable : true
				},
				{
					title : '地址',
					field : 'address',
					width : 200,
					sortable : true
				},
				{
					title : '分区',
					field : 'zoneName',
					width : 100,
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
					text : '<form id="searchform" name="searchform">姓名：<input type="text" id="landlordName" />'+
					'手机号：<input type="text" id="telephone" />'+
					'身份证号：<input type="text" id="identity" />'+
					'</form>'
				},
				{
					id : 'search',
					text : '搜索',
					iconCls : 'icon-search',
					handler : function() {
						SearchLanlord();
					}
				},
				{
					id : 'export',
					text : 'Excel导出',
					iconCls : 'icon-redo',
					handler : function() {
						Exproter();
					}
				},
				{
					id : 'import',
					text : '导入Excel',
					iconCls : 'icon-undo',
					handler : function() {
						openUploadFileDialog();
					}
				},
				{
					id : 'btnadd',
					text : '协管员添加房东',
					iconCls : 'icon-add', //弹出框图标				
					handler : function() {
						$('#btnsave').linkbutton('enable');
						alert('add');
						}
				},
				{
					id : 'batchRemove',
					text : '批量删除',
					iconCls : 'icon-remove',
					handler : function() {
						batchRemove();
					}
				}   ]
		});
		var p = $('#landlord-main').datagrid('getPager');
		$(p).pagination({
			onBeforeRefresh : function() {
			url_data = '<%=basePath%>population/landlordInfo'
	     $('#landlord-main').datagrid('options').url = url_data;
         $('#landlord-main').datagrid('load');  
			}
		});
		
		
	});
	function formatOper(value, row, index) {
		var c = '<a href="#" onclick="giveaddress(' + index + ')">配置地址 |</a> ';
		var e = '<a href="#" onclick="editrow(' + index + ')">编辑 |</a> ';
		var d = '<a href="#" onclick="deleterow(' + index + ')">删除 |</a>';
		var f = '<a href="#" onclick="showvitality(' + index + ')">活跃度</a>';
		return c + e + d + f;
	}
	
	var url;	
	
	function batchRemove() {
		var landlordIds = "";
		var rows = $('#landlord-main').datagrid('getSelections');
		if(rows.length < 1){
			alert("请选择要刪除的数据");
			return;
		}
		
		for (var i = 0; i < rows.length; i++) {
			var row = rows[i];
			landlordIds += row.landlordId + ","; //这里list要和后台的参数名List<Category> list一样
		}
		alert(landlordIds);

		$.ajax({
			url : '<%=basePath%>population/batchRemove?landlordIds= '+landlordIds,
			dataType : "json",
			type : "GET",
			success : function(result) {
				if(result == 1){
					$.messager.alert("系统提示","批量删除成功");
        			 $('#landlord-main').datagrid('reload'); 
				}else{
					$.messager.alert("系统提示","批量删除失败");
				}
			}
		});
		
	}
	<%-- //EasyUI datagrid 动态导出Excel  
	function Exproter() {
		var rows = $('#landlord-main').datagrid('getSelections');
		var landlordIds = "";
		for (var i = 0; i < rows.length; i++) {
			var row = rows[i];
			landlordIds += row.landlordId + ","; //这里list要和后台的参数名List<Category> list一样
		}
		alert(landlordIds);

		$.ajax({
			url : '<%=basePath%>population/exprotExcel',
			data : {
				'landlordIds' : landlordIds
			},
			dataType : "json",
			type : "GET",
			success : function(data) {
				alert(data);
			}
		});
		
	} --%>

	function openUploadFileDialog(){
			$("#uploadFileDialog").dialog('open').dialog('setTitle','批量导入数据');
	}
	
	function downloadTemplate(){
		window.open('<%=basePath%>template/userExporTemplate.xls');
	}
		
	function uploadFile(){
		$("#uploadForm").form("submit",{
			success:function(result){
				/* var result=eval('('+result+')'); */
				/* if(result.errorMsg){
					$.messager.alert("系统提示",result.errorMsg);
				}else{ */
					$.messager.alert("系统提示","上传成功");
					$("#uploadFileDialog").dialog("close");
         				$('#landlord-main').datagrid('reload'); 
				/* } */
			}
		});
	}

	function Exproter() {
		var rows = $('#landlord-main').datagrid('getSelections');
		if(rows.length < 1){
			alert("请选择要导出的数据");
			return;
		}
		alert(JSON.stringify(rows));
		$.ajax({
			url : '<%=basePath%>population/exprotExcel',
			contentType:'application/json;charset=utf-8',  
			data : JSON.stringify(rows),
			dataType : "json",
			type : "POST",
			success : function(result) {
				if(result = 1){
					window.open('<%=basePath%>population/exprot');				
				}else{
					$.messager.alert("系统提示","请重试");
				}
			}
		});
	}
	
	function addAccount() {
		$('#addAccount').dialog('open');
		$("#addAccount").form("clear");
	}

	function giveaddress(index) {
		url = '<%=basePath%>population/addAddressForLandlord';
		$('#landlord-main').datagrid('selectRow', index);
		var row = $('#landlord-main').datagrid('getSelected');
		document.getElementById('addressLandlordId').value = row.landlordId;
		$('#address').dialog('open').dialog('setTitle', '配置地址');
		$.ajax({
			url : '<%=basePath%>population/updateGetLandlord?landlordId=' + row.landlordId + '&type=stu',
			//加了个type，作用是以后不管什么删除，都可以转到这个ashx中处理
			dataType : 'json',
			success : function(landlord) {
				//返回的数据在role中  
				document.getElementById("addLandlordAddress").value = landlord.address;
				$('#landlord-main').datagrid('reload');
			}
		});
	}

	function editrow(index) {
		url = '<%=basePath%>population/updateLandlord';
		$('#landlord-main').datagrid('selectRow', index);
		var row = $('#landlord-main').datagrid('getSelected');
		document.getElementById('updateLandlordId').value = row.landlordId;
		$('#updateLandlord').dialog('open').dialog('setTitle', '编辑房客');

		$.ajax({
			url : '<%=basePath%>population/updateGetLandlord?landlordId=' + row.landlordId + '&type=stu',
			//加了个type，作用是以后不管什么删除，都可以转到这个ashx中处理
			dataType : 'json',
			success : function(landlord) {
				//返回的数据在role中  
				document.getElementById("updateLandlordName").value = landlord.landlordName;
				document.getElementById("updateTelephone").value = landlord.telephone;
				document.getElementById("updateAddress").value = landlord.address;
			}
		});
	}
	function deleterow(index) { //删除操作
		$.messager.confirm('确认', '确认删除?', function(row) {
			if (row) {
				var selectedRow = $('#landlord-main').datagrid('getSelected'); //获取选中行
				$.ajax({
					url : '<%=basePath%>population/deleteLandlord?id=' + selectedRow.landlordId + '&type=stu',
					//加了个type，作用是以后不管什么删除，都可以转到这个ashx中处理
					success : function(result) {
						if (result == 1) {
							alert('删除成功');
							$('#landlord-main').datagrid('reload');
						}
						else {
							alert('刪除失敗');
						}
					}
				});
				$('#landlord-main').datagrid('deleteRow', index);
			}
		})
	}

	function showvitality(index) {
		$('#landlord-main').datagrid('selectRow', index);
		var row = $('#landlord-main').datagrid('getSelected');
		if (row) {
			$('#vitality').dialog('open').dialog('setTitle', '活跃度');
		}
	}

	function updateUser() {
		$("#updateLandlordFrom").form("submit", {
			url : '<%=basePath%>population/updateLandlord',
			onsubmit : function() {
				return $(this).form("validate");
			},
			success : function(result) {
				if (result == "1") {
					$.messager.alert("提示信息", "操作成功");
					$("#updateLandlord").dialog("close");
					$("#landlord-main").datagrid("reload");
				}
				else {
					$.messager.alert("提示信息", "操作失败");
				}
			}
		});
	}

	function addAddress() {
		$("#addressLandlordFrom").form("submit", {
			url : '<%=basePath%>population/addAddressForLandlord',
			onsubmit : function() {
				return $(this).form("validate");
			},
			success : function(result) {
				if (result == "1") {
					$.messager.alert("提示信息", "操作成功");
					$("#address").dialog("close");
        			 $('#landlord-main').datagrid('reload'); 
				}
				else {
					$.messager.alert("提示信息", "操作失败");
					$("#address").dialog("close");
				}
			}
		});
	}
	
</script>
</head>
<body>
	<table id="landlord-main"></table>
	<div id="updateLandlord" class="easyui-dialog"
		style="width: 400px; height: 200px; padding: 10px 20px;" closed="true"
		buttons="#landlord-dlg-buttons">
		<form id="updateLandlordFrom">
			<table border="0" cellpadding="1" align="center">
				<tr>
					<td><label>姓名</label></td>
					<td><input id="updateLandlordName" name="landlordName"
						class="easyui-text" required="false" /></td>
				</tr>
				<tr>
					<td><label>联系方式 </label></td>
					<td><input id="updateTelephone" name="telephone"
						class="easyui-text" required="false" /></td>
				</tr>
				<tr>
					<td><label>地址</label></td>
					<td><input id="updateAddress" name="address"
						class="easyui-text" required="false" /></td>
				</tr>
			</table>
			<input type="hidden" name="landlordId" id="updateLandlordId" />
		</form>
	</div>
	</div>
	<div id="landlord-dlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			onclick="updateUser()" iconcls="icon-save">保存</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			onclick="javascript:$('#updateLandlord').dialog('close')"
			iconcls="icon-cancel">取消</a>

	</div>
	<div id="addAccount" class="easyui-dialog" title="添加"
		style="width:400px;height:200px;text-align:center" resizable="true"
		modal="true" closed="true">
		<br />
		<table></table>
		角色名称：<input type="text" id="role_name" /><br /> <br /> 角色权限：<input
			type="text" id="role_limit" /><br /> <br /> <input type="button"
			value=" 添 加 " iconCls="icon-add" onclick="addUserInfo()" /> <input
			type="button" value=" 重置 " onclick="clearForm()" />
		<script>
			function clearForm() {
				$('#addRole').form('clear');
			}
		</script>
	</div>


	<div id="address" class="easyui-dialog" title="配置地址"
		style="width:400px;height:200px;text-align:center" resizable="true"
		modal="true" closed="true" buttons="#landlord-dlg-buttons-1">
		<form id="addressLandlordFrom">
			<div style="margin-top:40px;aligin:center">
				<label>地址:</label> <input type="text" id="addLandlordAddress"
					name="address" style="margin-right:20px" /> <input type="hidden"
					id="addressLandlordId" name="landlordId" />
			</div>
		</form>
	</div>
	<div id="landlord-dlg-buttons-1">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconcls="icon-save" onclick="addAddress()">保存</a>
	</div>


	<div id="vitality" class="easyui-dialog" title="活跃度"
		style="width:400px;height:200px;text-align:center" resizable="true"
		modal="true" closed="true">
		<br />
		<table></table>
		活跃度：
	</div>

	<div id="uploadFileDialog" class="easyui-dialog"
		style="width:400px;height:180px;padding:10px 20px" closed="true"
		buttons="#uploadFileDialog-buttons">
		<form id="uploadForm" action="<%=basePath%>population/upload"
			method="post" enctype="multipart/form-data">
			<table>
				<tr>
					<td>下载模版：</td>
					<td><a href="javascript:void(0)" class="easyui-linkbutton"
						onclick="downloadTemplate()">导入模版</a></td>
				</tr>
				<tr>
					<td>上传文件：</td>
					<td><input type="file" name="userUploadFile"></td>
				</tr>
			</table>
		</form>
	</div>

	<div id="uploadFileDialog-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="uploadFile()">上传</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel"
			onclick="javascript:$('#uploadFileDialog').dialog('close')">关闭</a>
	</div>




</body>
</html>