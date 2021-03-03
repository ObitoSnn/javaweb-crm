<%@ page contentType="text/html;charset=utf-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/base_css_jquery.jsp"%>
<meta charset="UTF-8">
<script type="text/javascript">

	//页面加载完毕
	$(function(){
		
		//导航中所有文本颜色为黑色
		$(".liClass > a").css("color" , "black");
		
		//默认选中导航菜单中的第一个菜单项
		$(".liClass:first").addClass("active");
		
		//第一个菜单项的文字变成白色
		$(".liClass:first > a").css("color" , "white");
		
		//给所有的菜单项注册鼠标单击事件
		$(".liClass").click(function(){
			//移除所有菜单项的激活状态
			$(".liClass").removeClass("active");
			//导航中所有文本颜色为黑色
			$(".liClass > a").css("color" , "black");
			//当前项目被选中
			$(this).addClass("active");
			//当前项目颜色变成白色
			$(this).children("a").css("color","white");
		});
		
		//展示用户页面
		window.open("pages/settings/qx/user/index.jsp","workareaFrame");

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
				type: "get",
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
	
	<!-- 中间 -->
	<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">
	
		<!-- 导航 -->
		<div id="navigation" style="left: 0px; width: 18%; position: relative; height: 100%; overflow:auto;">
		
			<ul id="no1" class="nav nav-pills nav-stacked">
				<li class="liClass"><a href="pages/settings/qx/user/index.jsp" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> 用户维护</a></li>
			</ul>
			
			<!-- 分割线 -->
			<div id="divider1" style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
		</div>
		
		<!-- 工作区 -->
		<div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%;">
			<iframe style="border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
		</div>
		
	</div>
	
	<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>
	
	<!-- 底部 -->
	<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>
	
</body>
</html>