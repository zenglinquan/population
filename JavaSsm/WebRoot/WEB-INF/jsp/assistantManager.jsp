<%@ page language="java" import="java.util.*" pageEncoding="utf-8"
	contentType="text/html; charset=utf-8"%>
	<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<%
 	String ids = (String)request.getSession().getAttribute("ids");
	if(ids!=null){
		if(!ids.contains("7")){
			response.sendRedirect(basePath);
			return;
		}
	}else{
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
<link rel="stylesheet" type="text/css" href="<%=basePath%>/css/04.css">
</head>
<body>	
	<table id="assistant-main"></table>
	<div id="assistant-dlg" class="easyui-dialog"
		style="width: 400px; height: 300px; padding: 10px 20px;" closed="true"
		buttons="#assistant-dlg-buttons">		
		<form id="assistant-fm" method="post">
			<fieldset>
				<legend>协管员</legend>
				<div class="fitem">
					<label>协管员账号 </label> 
					<input id="assistantName" name="assistantName" class="easyui-text"
						required="false" />
				</div>
				<br />
				<div class="fitem">
					<label>密码 </label> <input name="password" class="easyui-text"
						type="password" required="false" />
				</div>
				<br />
				<div class="fitem">
					<label>分区</label> 
					<select id="zoneName" name="zoneName" class="easyui-combobox"
						style="width:140px;">
						<c:forEach var="zone" items="${zoneList}">
							<option>${zone.zoneName}</option>
						</c:forEach>
					</select>
				</div>
			</fieldset>

			<input type="hidden" name="roleId" id="roleId" /> 
			<input type="hidden"  id="zoneId" name="zoneId" />
			
		</form>
	</div>

	<div id="assistant-dlg-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			onclick="saveuser()" iconcls="icon-ok">添加</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			onclick="javascript:$('#assistant-dlg').dialog('close')">取消</a>
	</div>
<script type="text/javascript"
	src="<%=basePath%>/js/jquery-easyui-1.2.6/jquery-1.7.2.min.js">
	</script>
<script type="text/javascript"
	src="<%=basePath%>/js/jquery-easyui-1.2.6/jquery.easyui.min.js">
	 </script>
<script type="text/javascript"
	src="<%=basePath%>/js/jquery-easyui-1.2.6/locale/easyui-lang-zh_CN.js">
	 </script>
<script type="text/javascript">
	window.onresize = function() {
		$('#assistant-main').datagrid('resize', {
			width : 1610,
			height : 720
		})
	}
          $(function() {
			$('#assistant-main').datagrid({
				iconCls : 'icon-save',
				/* 	width:700,
					height:350, */
				width : $(window).width() - 100,
				height : $(window).height() - 100,
				fitColumns: true,
				nowrap : false,
				striped : true,
				collapsible : true,
				url : '<%=basePath %>/population/assistantInfo',
				sortOrder : 'desc',
				remoteSort : false,
				frozenColumns : [ [
					{
						field : 'assistantName',
						title : '协管员账号',
						width :1000,
						sortable : true
					}		
				] ],
				pagination : true,
				rownumbers : true,
				toolbar : [ {
					id : 'btnadd',
					text : '添加',
					iconCls : 'icon-add', //弹出框图标
					handler : function() {
						newuser();
					}
				} ]
			});
			var p = $('#assistant-main').datagrid('getPager');
			$(p).pagination({
				onBeforeRefresh : function() {
					/* alert('before refresh'); */
				}
			});
		});
        var url;
        var type;
        function newuser() {
            $("#assistant-dlg").dialog("open").dialog('setTitle', '添加协管员'); ;
            $("#assistant-fm").form("clear");
			document.getElementById("roleId").value = "5";
			document.getElementById("zoneId").value = "0";
			
        }
        /* function edituser() {
            var row = $("#assistant-main").datagrid("getSelected");
            if (row) {
                $("#assistant-dlg").dialog("open").dialog('setTitle', '编辑账户');
                $("#assistant-fm").form("load", row);
                url = "UserManage.aspx?id=" + row.ID;
            }
        } */
        function saveuser() {
            $("#assistant-fm").form("submit", {
                url: '<%=basePath%>/population/addAssistant',
                onsubmit: function () {
                    return $(this).form("validate");
                },
                success: function (result) {
                    if (result == "1") {
                        $.messager.alert("提示信息", "操作成功");
                        $("#assistant-dlg").dialog("close");
                        $("#assistant-main").datagrid("load");
                    }
                    else {
                        $.messager.alert("提示信息", "操作失败");
                    }
                }
            });
        }
        function destroyUser() {
            var row = $('#assistant-main').datagrid('getSelected');
            if (row) {
                $.messager.confirm('Confirm', 'Are you sure you want to destroy this user?', function (r) {
                    if (r) {
                        $.post('destroy_user.php', { id: row.id }, function (result) {
                            if (result.success) {
                                $('#assistant-main').datagrid('reload');    // reload the user data  
                            } else {
                                $.messager.show({   // show error message  
                                    title: 'Error',
                                    msg: result.errorMsg
                                });
                            }
                        }, 'json');
                    }
                });
            }
        } 

    </script>
</body>
</html>