<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/base_css_jquery.jsp"%>
	<link href="static/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>
	<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>
<meta charset="UTF-8">
	<script type="text/javascript">

		$(function () {

			//给控制总的复选框绑定单击事件
			$("input[name='checkbox-manager']").click(function () {

				$("input[name='checkbox-single']").prop("checked", this.checked);

			});

			//给单个的复选框绑定单击事件
			$("#showDeptTBody").on("click", $("input[name='checkbox-single']"), function () {
				$("input[name='checkbox-manager']").prop("checked", $("input[name='checkbox-single']:checked").length == $("input[name='checkbox-single']").length);
			})

			//页面加载完毕后调用分页方法
			pageList(1, 2);

			//给输入原密码的文本框绑定失去焦点事件，校验密码是否正确
			$("#oldPwd").blur(function () {

				var oldPwd = $.trim($("#oldPwd").val());
				if (oldPwd == "") {
					$("#oldPwdMsg").text("请输入原密码");
					$("#pwdMsg").text("");
					return false;
				}
				$.ajax({
					url: "settings/user/checkPwd",
					data: {
						"id": "${sessionScope.user.id}",
						"oldPwd": oldPwd
					},
					type: "post",
					dataType: "text",
					success: function (data) {
						// {信息}
						$("#oldPwdMsg").text($.trim(data));
						if (data != "") {
							$("#pwdMsg").text("");
						}
					}
				});

			});

			//校验新密码
			$("#newPwd").blur(function () {

				var oldPwd = $.trim($("#oldPwd").val());
				var newPwd = $.trim($("#newPwd").val());
				var confirmPwd = $.trim($("#confirmPwd").val());
				var oldPwdMsg = $.trim($("#oldPwdMsg").text());
				if (oldPwd == "") {
					$("#oldPwdMsg").text("请输入原密码");
					return false;
				}
				if (oldPwdMsg != "") {
					return false;
				}
				if (newPwd == "") {
					$("#pwdMsg").text("请输入新密码");
					return false;
				}
				if (newPwd == oldPwd) {
					$("#pwdMsg").text("新密码与原密码一致");
					return false;
				}
				if (confirmPwd == "") {
					$("#pwdMsg").text("请输入确认密码");
					return false;
				}
				if (newPwd != confirmPwd) {
					$("#pwdMsg").text("新密码与确认密码不一致");
					return false;
				}
				$("#pwdMsg").text("");

			});

			//校验确认密码
			$("#confirmPwd").blur(function () {

				var oldPwd = $.trim($("#oldPwd").val());
				var newPwd = $.trim($("#newPwd").val());
				var confirmPwd = $.trim($("#confirmPwd").val());
				var oldPwdMsg = $.trim($("#oldPwdMsg").text());
				if (oldPwd == "") {
					$("#oldPwdMsg").text("请输入原密码");
					return false;
				}
				if (oldPwdMsg != "") {
					return false;
				}
				if (newPwd == "") {
					$("#pwdMsg").text("请输入新密码");
					return false;
				}
				if (newPwd == oldPwd) {
					$("#pwdMsg").text("新密码与原密码一致");
					return false;
				}
				if (confirmPwd == "") {
					$("#pwdMsg").text("请输入确认密码");
					return false;
				}
				if (newPwd != confirmPwd) {
					$("#pwdMsg").text("新密码与确认密码不一致");
					return false;
				}
				$("#pwdMsg").text("");

			});

		});

		function pageList(pageNo, pageSize) {

			//刷新后台数据之前取消总复选框的选中状态
			$("input[name='checkbox-manager']").prop("checked", false);

			$.ajax({
				url : "settings/dept/pageList",
				data : {
					"pageNo" : pageNo,
					"pageSize" : pageSize,
				},
				type : "get",
				dataType : "json",
				success : function (data) {
					// [{部门},...]
					var html = "";
					$.each(data.dataList, function (i, obj) {
						var name = obj.name;
						if ("" == name || name == null) {
							name = "";
						}
						var userId = obj.userId;
						if ("" == userId || userId == null) {
							userId = "";
						}
						var phone = obj.phone;
						if ("" == phone || phone == null) {
							phone = "";
						}
						var description = obj.description;
						if ("" == description || description == null) {
							description = "";
						}
						html += '<tr>';
						html += '<td><input name="checkbox-single" type="checkbox" value="' + obj.id + '"/></td>';
						html += '<td>' + obj.deptno + '</td>';
						html += '<td>' + name + '</td>';
						html += '<td>' + userId + '</td>';
						html += '<td>' + phone + '</td>';
						html += '<td>' + description + '</td>';
						html += '</tr>';
					});
					$("#showDeptTBody").html(html);

					var totalPages = data.total % pageSize == 0 ? data.total / pageSize : Math.ceil(data.total / pageSize);


					//数据处理完毕后，结合分页插件展现每页数据
					$("#deptPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: data.total, // 总记录条数

						visiblePageLinks: 3, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						//该回调函数是在点击分页组件的时候触发的
						onChangePage : function(event, data){
							pageList(data.currentPage , data.rowsPerPage);
						}
					});
				}
			});

		}

		function openCreateDeptModal() {

			$.ajax({
				url : "settings/dept/getUserList",
				type : "get",
				dataType : "json",
				success : function (data) {
					var html = "<option></option>";
					$.each(data, function (i, obj) {
						if ("root" == obj.loginAct) {
							return true;
						}
						html += "<option value='" + obj.id + "'>" + obj.name + "</option>";
					});
					$("#create-userId").html(html);
				}
			});

			//打开模态窗口
			$("#createDeptModal").modal("show");

		}

		function saveDept() {

			var userId = $.trim($("#create-userId").val());
			var deptno = $.trim($("#create-deptno").val());
			var name = $.trim($("#create-name").val());
			var phone = $.trim($("#create-phone").val());
			var description = $.trim($("#create-description").val());
			if (deptno == "") {
				alert("请填写编号");
			} else if (deptno.length != 4) {
				alert("填写的编号必须为4位数");
			} else {
				$.ajax({
					url : "settings/dept/saveDept",
					data : {
						"userId" : userId,
						"deptno" : deptno,
						"name" : name,
						"phone" : phone,
						"description" : description
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						//{"success":true/false,"errorMsg":错误信息}
						if (data.success) {
							//保存数据后，刷新页面数据，回到第一页，每页显示数据数不变
							pageList($("#deptPage").bs_pagination('getOption', 'totalPages'),$("#deptPage").bs_pagination('getOption', 'rowsPerPage'));
							//清空表单项内容
							$("#createDeptForm")[0].reset();
							//关闭模态窗口
							$("#createDeptModal").modal("hide");
						} else {
							alert(data.errorMsg);
						}
					}
				});
			}

		}

		function openEditDeptModal() {
			//选中的复选框
			var $checkbox = $("input[name='checkbox-single']:checked");
			if ($checkbox.length == 0) {
				alert("请选择要修改的部门信息");
			} else if ($checkbox.length > 1) {
				alert("一次只能修改一个部门信息");
			} else {
				var id = $checkbox.val();
				$.ajax({
					url : "settings/dept/getDeptByIdAndUserList",
					data : {
						"id" : id
					},
					type : "get",
					dataType : "json",
					success : function (data) {
						// {{部门},[{用户},...]}
						var html = "<option></option>";
						$.each(data.userList, function (i, obj) {
							if ("root" == obj.loginAct) {
								return true;
							}
							html += "<option value='" + obj.id + "'>" + obj.name + "</option>";
						});
						$("#edit-userId").html(html);

						$("#edit-deptno").val($.trim(data.dept.deptno));
						$("#edit-name").val($.trim(data.dept.name));
						$("#edit-userId").val($.trim(data.dept.userId));
						$("#edit-phone").val($.trim(data.dept.phone));
						$("#edit-description").val($.trim(data.dept.description));
						//打开模态窗口
						$("#editDeptModal").modal("show");
					}
				});
			}
		}

		function updateDept() {

			var $checkbox = $("input[name='checkbox-single']:checked");
			var id = $checkbox.val();
			var deptno = $.trim($("#edit-deptno").val());
			var name = $.trim($("#edit-name").val());
			var userId = $.trim($("#edit-userId").val());
			var phone = $.trim($("#edit-phone").val());
			var description = $.trim($("#edit-description").val());
			$.ajax({
				url : "settings/dept/updateDept",
				data : {
					"id" : id,
					"deptno" : deptno,
					"name" : name,
					"userId" : userId,
					"phone" : phone,
					"description" : description
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					// {"success":true/false,"errorMsg":错误信息}
					if (data.success) {
						//修改数据后，刷新页面数据，留在当前页面，每页显示数据数不变
						pageList($("#deptPage").bs_pagination('getOption', 'currentPage')
								,$("#deptPage").bs_pagination('getOption', 'rowsPerPage'));
						//关闭模态窗口
						$("#editDeptModal").modal("hide");
					} else {
						alert(data.errorMsg);
					}
				}
			});

		}

		function deleteDept() {

			var $checkbox = $("input[name='checkbox-single']:checked");
			if ($checkbox.length == 0) {
				alert("请选择要删除的部门信息");
			} else {
				if (confirm("你确定要删除所选部门吗？")) {
					var param = "";
					for (var i = 0; i < $checkbox.length; i++) {
						param += "id=" + $($checkbox[i]).val();
						if (i < $checkbox.length - 1) {
							param += "&";
						}
					}
					$.ajax({
						url : "settings/dept/deleteDeptByIds",
						data : param,
						type : "post",
						dataType : "json",
						success : function (data) {
							// {"success":true/false,"errorMsg":错误信息}
							if (data.success) {
								//删除操作后，刷新页面数据，回到第一页，每页显示数据数不变
								pageList(1,$("#deptPage").bs_pagination('getOption', 'rowsPerPage'));
							} else {
								alert(data.errorMsg);
							}
						}
					});
				}
			}

		}

		//打开修改密码的模态窗口
		function openEditPwdModal() {

			//重置表单项
			$("#editPwdForm")[0].reset();
			//重置span标签文本内容
			$("#oldPwdMsg").text("");
			$("#pwdMsg").text("");
			//打开模态窗口
			$("#editPwdModal").modal("show");

		}

		//修改密码
		function updatePwd() {

			var oldPwd = $.trim($("#oldPwd").val());
			var newPwd = $.trim($("#newPwd").val());
			var confirmPwd = $.trim($("#confirmPwd").val());
			var oldPwdMsg = $.trim($("#oldPwdMsg").text());
			if (oldPwd == "") {
				$("#oldPwdMsg").text("请输入原密码");
				return false;
			}
			if (oldPwdMsg != "") {
				return false;
			}
			if (newPwd == "") {
				$("#pwdMsg").text("请输入新密码");
				return false;
			}
			if (newPwd == oldPwd) {
				$("#pwdMsg").text("新密码与原密码一致");
				return false;
			}
			if (confirmPwd == "") {
				$("#pwdMsg").text("请输入确认密码");
				return false;
			}
			if (newPwd != confirmPwd) {
				$("#pwdMsg").text("新密码与确认密码不一致");
				return false;
			}
			$("#pwdMsg").text("");
			$.ajax({
				url : "settings/user/updatePwd",
				data : {
					"id": "${sessionScope.user.id}",
					"loginPwd": newPwd
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					// {"success":true/false,"errorMsg":错误信息}
					if (data.success) {
						location.href = "login.jsp";
					} else {
						alert(data.errorMsg);
					}
				}
			});

		}

	</script>
</head>
<body>

	<!-- 我的资料 -->
	<div class="modal fade" id="myInformation" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">我的资料</h4>
				</div>
				<div class="modal-body">
					<div style="position: relative; left: 40px;">
						姓名：<b>${sessionScope.user.name}</b><br><br>
						登录帐号：<b>${sessionScope.user.loginAct}</b><br><br>
						组织机构：<b>${sessionScope.user.deptno}</b><br><br>
						邮箱：<b>${sessionScope.user.email}</b><br><br>
						失效时间：<b>${sessionScope.user.expireTime}</b><br><br>
						允许访问IP：<b>${sessionScope.user.allowIps}</b>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改密码的模态窗口 -->
	<div class="modal fade" id="editPwdModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 70%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改密码</h4>
				</div>
				<div class="modal-body">
					<form id="editPwdForm" class="form-horizontal" role="form">
						<div class="form-group">
							<label for="oldPwd" class="col-sm-2 control-label">原密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="oldPwd" style="width: 200%;">
								<div>
									<span id="oldPwdMsg" style="color: red;"></span>
								</div>
							</div>
						</div>
						
						<div class="form-group">
							<label for="newPwd" class="col-sm-2 control-label">新密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="newPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="confirmPwd" style="width: 200%;">
								<div>
									<span id="pwdMsg" style="color: red;"></span>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" onclick="updatePwd()">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 退出系统的模态窗口 -->
	<div class="modal fade" id="exitModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">离开</h4>
				</div>
				<div class="modal-body">
					<p>您确定要退出系统吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="window.location.href='settings/user/logout';">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 顶部 -->
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<%@ include file="../../common/copyright.jsp"%>
		<div style="position: absolute; top: 15px; right: 15px;">
			<ul>
				<li class="dropdown user-dropdown">
					<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
						<span class="glyphicon glyphicon-user"></span> ${sessionScope.user.name} <span class="caret"></span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</a>
					<ul class="dropdown-menu">
						<li><a href="pages/workbench/index.jsp"><span class="glyphicon glyphicon-home"></span> 工作台</a></li>
						<li><a href="pages/settings/index.jsp"><span class="glyphicon glyphicon-wrench"></span> 系统设置</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span class="glyphicon glyphicon-file"></span> 我的资料</a></li>
						<li><a href="javascript:void(0)" onclick="openEditPwdModal()"><span class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
						<li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span class="glyphicon glyphicon-off"></span> 退出</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<!-- 创建部门的模态窗口 -->
	<div class="modal fade" id="createDeptModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1"><span class="glyphicon glyphicon-plus"></span> 新增部门</h4>
				</div>
				<div class="modal-body">
				
					<form id="createDeptForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-deptno" class="col-sm-2 control-label">编号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-deptno" style="width: 200%;" placeholder="编号不能为空，具有唯一性">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-name" class="col-sm-2 control-label">名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-userId" class="col-sm-2 control-label">负责人</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-userId" style="width: 200%;">

								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 55%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="saveDept()">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改部门的模态窗口 -->
	<div class="modal fade" id="editDeptModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel"><span class="glyphicon glyphicon-edit"></span> 编辑部门</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-deptno" class="col-sm-2 control-label">编号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-deptno" style="width: 200%;" placeholder="不能为空，具有唯一性">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-name" class="col-sm-2 control-label">名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-userId" class="col-sm-2 control-label">负责人</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-userId" style="width: 200%;">

								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 55%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="updateDept()">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<div style="width: 95%">
		<div>
			<div style="position: relative; left: 30px; top: -10px;">
				<div class="page-header">
					<h3>部门列表</h3>
				</div>
			</div>
		</div>
		<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; top:-30px;">
			<div class="btn-group" style="position: relative; top: 18%;">
			  <button type="button" class="btn btn-primary" onclick="openCreateDeptModal()"><span class="glyphicon glyphicon-plus"></span> 创建</button>
			  <button type="button" class="btn btn-default" onclick="openEditDeptModal()"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			  <button type="button" class="btn btn-danger" onclick="deleteDept()"><span class="glyphicon glyphicon-minus"></span> 删除</button>
			</div>
		</div>
		<div style="position: relative; left: 30px; top: -10px;">
			<table class="table table-hover">
				<thead>
					<tr style="color: #B3B3B3;">
						<td><input name="checkbox-manager" type="checkbox"/></td>
						<td>编号</td>
						<td>名称</td>
						<td>负责人</td>
						<td>电话</td>
						<td>描述</td>
					</tr>
				</thead>
				<tbody id="showDeptTBody">
				</tbody>
			</table>
		</div>
		
		<div style="height: 50px; position: relative;top: 0px; left:30px;">
			<div id="deptPage"></div>
		</div>
			
	</div>
	
</body>
</html>