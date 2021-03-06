<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../../common/base_css_jquery.jsp"%>
	<script type="text/javascript" src="static/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<meta charset="UTF-8">
<script type="text/javascript">

	$(function () {

		$("#edit-deptno").typeahead({
			source: function (query, process) {
				$.get(
					"settings/permission/user/getDeptNameList",
					{ "name" : query },
					function (data) {
						//alert(data);
						/*
							data
								[{"部门名1",...}]
						 */
						process(data);
					},
					"json"
				);
			},
			delay: 1500
		});

		$(".time").datetimepicker({
			minView: "hour",
			language:  'zh-CN',
			format: "yyyy-mm-dd hh:ii:ss",//显示格式
			autoclose: true,
			todayBtn: true, //显示今日按钮
			clearBtn : true,
			pickerPosition: "bottom-left"
		});

		$("#edit-loginPwd").blur(function () {

			$("#errorMsg").text("");
			var loginPwd = $.trim($("#edit-loginPwd").val());
			if ("" == loginPwd) {
				return false;
			}
			$.ajax({
				url: "settings/user/checkPwd",
				data: {
					"id": "${requestScope.user.id}",
					"oldPwd": loginPwd
				},
				type: "get",
				dataType: "text",
				success: function (data) {
					// {信息}
					if (data == "") {
						//新密码与原密码密码一致
						$("#errorMsg").text("登录密码与原密码一致");
						return false;
					}
				}
			});

		});

		$("#edit-confirmPwd").blur(function () {

			var loginPwd = $.trim($("#edit-loginPwd").val());
			var confirmPwd = $.trim($("#edit-confirmPwd").val());
			var $errorMsg = $("#errorMsg");
			if ("" == confirmPwd) {
				return false;
			}
			if ($errorMsg.text() == "登录密码与原密码一致") {
				return false;
			}
			if (loginPwd != confirmPwd) {
				$errorMsg.text("登录密码与确认密码不一致");
				return false;
			}
			$errorMsg.text("");

		});

	});

	function openEditUserModal() {

		$("#errorMsg").text("");
		$("#edit-loginPwd").val("");
		$("#edit-confirmPwd").val("");
		var lockState = "${requestScope.user.lockState}";
		if ("锁定" == lockState) {
			lockState = "0";
		}
		if ("启用" == lockState) {
			lockState = "1";
		}
		$("#edit-lockState").val(lockState);
		$("#editUserModal").modal("show");

	}

	function updateUser() {

		var id = "${requestScope.user.id}";
		var loginAct = $.trim($("#edit-loginAct").val());
		var loginPwd = $.trim($("#edit-loginPwd").val());
		var confirmPwd = $.trim($("#edit-confirmPwd").val());
		var deptno = $.trim($("#edit-deptno").val());
		var $errorMsg = $("#errorMsg");
		if ("" == loginAct) {
			$errorMsg.text("请输入登录账号");
			return false;
		}
		if ("" == loginPwd) {
			$errorMsg.text("请输入登录密码");
			return false;
		}
		if ($errorMsg.text() == "登录密码与原密码一致") {
			return false;
		}
		if ("" == confirmPwd) {
			$errorMsg.text("请输入确认密码");
			return false;
		}
		if (loginPwd != confirmPwd) {
			$errorMsg.text("登录密码与确认密码不一致");
			return false;
		}
		if ("" == deptno) {
			$errorMsg.text("请输入部门名称");
			return false;
		}
		$errorMsg.text("");
		var name = $.trim($("#edit-name").val());
		var email = $.trim($("#edit-email").val());
		var expireTime = $.trim($("#edit-expireTime").val());
		var lockState = $.trim($("#edit-lockState").val());
		var allowIps = $.trim($("#edit-allowIps").val());
		$.ajax({
			url : "settings/permission/user/updateUserById",
			data : {
				"id" : id,
				"loginAct" : loginAct,
				"name" : name,
				"loginPwd" : loginPwd,
				"email" : email,
				"expireTime" : expireTime,
				"lockState" : lockState,
				"deptno" : deptno,
				"allowIps" : allowIps,
			},
			type : "post",
			dataType : "json",
			success : function (data) {
				// {"success":true/false,"errorMsg":错误信息}
				if (data.success) {
					location.href = "settings/permission/user/detail?id=" + id;
				} else {
					alert(data.errorMsg);
				}
			}
		});

	}

</script>

</head>
<body>

	<!-- 编辑用户的模态窗口 -->
	<div class="modal fade" id="editUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改用户</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-loginAct" class="col-sm-2 control-label">登录帐号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-loginAct" value="${requestScope.user.loginAct}">
							</div>
							<label for="edit-name" class="col-sm-2 control-label">用户姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" value="${requestScope.user.name}">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-loginPwd" class="col-sm-2 control-label">登录密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="edit-loginPwd">
							</div>
							<label for="edit-confirmPwd" class="col-sm-2 control-label">确认密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="edit-confirmPwd">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="${requestScope.user.email}">
							</div>
							<label for="edit-expireTime" class="col-sm-2 control-label">失效时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-expireTime" value="${requestScope.user.expireTime}">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-lockState" class="col-sm-2 control-label">锁定状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-lockState">
								  <option value="1">启用</option>
								  <option value="0">锁定</option>
								</select>
							</div>
							<label for="edit-deptno" class="col-sm-2 control-label">部门名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-deptno" placeholder="输入部门名称，自动补全" value="${requestScope.user.deptno}">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-allowIps" style="width: 280%" placeholder="多个用逗号隔开" value="${requestScope.user.allowIps}">
								<span id="errorMsg" style="color: red;"></span>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="updateUser()">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>用户明细 <small>${requestScope.user.name}</small></h3>
			</div>
			<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 80%;">
				<button type="button" class="btn btn-default" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"></span> 返回</button>
			</div>
		</div>
	</div>
	
	<div style="position: relative; left: 60px; top: -50px;">
		
		<div id="myTabContent" class="tab-content">
			<div class="tab-pane fade in active" id="role-info">
				<div style="position: relative; top: 20px; left: -30px;">
					<div style="position: relative; left: 40px; height: 30px; top: 20px;">
						<div style="width: 300px; color: gray;">登录帐号</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.user.loginAct}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 40px;">
						<div style="width: 300px; color: gray;">用户姓名</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.user.name}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 60px;">
						<div style="width: 300px; color: gray;">邮箱</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.user.email}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 80px;">
						<div style="width: 300px; color: gray;">失效时间</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.user.expireTime}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 100px;">
						<div style="width: 300px; color: gray;">允许访问IP</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.user.allowIps}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 120px;">
						<div style="width: 300px; color: gray;">锁定状态</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.user.lockState}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 140px;">
						<div style="width: 300px; color: gray;">部门名称</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.user.deptno}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
						<button style="position: relative; left: 76%; top: -40px;" type="button" class="btn btn-default" onclick="openEditUserModal()"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
					</div>
				</div>
			</div>
		</div>
	</div>	
	
</body>
</html>