<%@ page language="java" import="java.util.*" pageEncoding="utf-8"
	contentType="text/html; charset=utf-8"%>
	
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<%
 	String ids = (String)request.getSession().getAttribute("ids");
	if(ids!=null){
		if(!ids.contains("6")){
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
	href="<%=basePath %>/js/jquery-easyui-1.2.6/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"
	href="<%=basePath %>/js/jquery-easyui-1.2.6/themes/icon.css">
<link rel="stylesheet" type="text/css"
	href="<%=basePath %>/js/jquery-easyui-1.2.6/demo/demo.css">
	<link rel="stylesheet" type="text/css"
	href="<%=basePath %>/css/04.css">	
</head>
<body>
	<table id="distinct-main"></table>
<div id="distinct-dlg"  class="easyui-dialog"  style="width: 400px; height: 300px; padding: 10px 20px;"
        closed="true" buttons="#distinct-dlg-buttons"> 
       <form id="distinct-fm" method="post"> 
       <fieldset > 
       <legend>分区</legend>
           <div class="fitem" > 
           <label>分区名称 </label> 
           <input name="zoneName" class="easyui-text" required="false" /> 
       </div> 
       <br/>
        <div class="fitem" > 
           <label>所属地 </label> 
           <input name="area" class="easyui-text" required="false" /> 
       </div> 
       <br/>
       </fieldset>         
       <input type="hidden" name="action" id="hidtype" /> 
       <input type="hidden" name="ID" id="Nameid" /> 
       </form> 
   </div> 

<div id="distinct-dlg-buttons"> 
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="saveuser()" iconcls="icon-ok">添加</a> 
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#distinct-dlg').dialog('close')"
          iconcls="icon-cancel"  >取消</a> 
    </div> 
<script type="text/javascript"
	src="<%=basePath %>/js/jquery-easyui-1.2.6/jquery-1.7.2.min.js">
	</script>
<script type="text/javascript"
	src="<%=basePath %>/js/jquery-easyui-1.2.6/jquery.easyui.min.js">
	 </script>
 <script type="text/javascript"
	src="<%=basePath %>/js/jquery-easyui-1.2.6/locale/easyui-lang-zh_CN.js">
	 </script>
<script type="text/javascript">
      window.onresize = function() {
			$('#distinct-main').datagrid('resize', {
				width : 1610,
				height : 720
			})
		}
      $(function() {
			$('#distinct-main').datagrid({
				iconCls : 'icon-save',
				/* 	width:700,
					height:350, */
				width : $(window).width() - 100,
				height : $(window).height() - 100,
				fitColumns: true,
				nowrap : false,
				striped : true,
				collapsible : true,
				url : '<%=basePath%>population/zoneInfo',
				sortOrder : 'desc',
				remoteSort : false,
				frozenColumns : [ [
					{
						field : 'zoneName',
						title : '分区名称',
						width : 400,
						sortable : true
					}
				] ],
				columns : [ [
					{
						field : 'area',
						title : '所属地',
						width : 100,
						align : 'left'
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
			var p = $('#distinct-main').datagrid('getPager');
			$(p).pagination({
				onBeforeRefresh : function() {
					/* alert('before refresh'); */
				}
			});
		});
        var url;
        var type;
        function newuser() {
            $("#distinct-dlg").dialog("open").dialog('setTitle', '添加'); ;
            $("#distinct-fm").form("clear");
            url = "UserManage.aspx";
            document.getElementById("hidtype").value="submit";
        }
        function edituser() {
            var row = $("#distinct-main").datagrid("getSelected");
            if (row) {
                $("#distinct-dlg").dialog("open").dialog('setTitle', '编辑账户');
                $("#distinct-fm").form("load", row);
                url = "UserManage.aspx?id=" + row.ID;
            }
        }
        function saveuser() {
            $("#distinct-fm").form("submit", {
                url: '<%=basePath%>population/addZone',
                onsubmit: function () {
                    return $(this).form("validate");
                },
                success: function (result) {
                    if (result == "1") {
                        $.messager.alert("提示信息", "操作成功");
                        $("#distinct-dlg").dialog("close");
                        $("#distinct-main").datagrid("load");
                    }
                    else {
                        $.messager.alert("提示信息", "操作失败");
                    }
                }
            });
        }
        function destroyUser() {
            var row = $('#distinct-main').datagrid('getSelected');
            if (row) {
                $.messager.confirm('Confirm', 'Are you sure you want to destroy this user?', function (r) {
                    if (r) {
                        $.post('destroy_user.php', { id: row.id }, function (result) {
                            if (result.success) {
                                $('#distinct-main').datagrid('reload');    // reload the user data  
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