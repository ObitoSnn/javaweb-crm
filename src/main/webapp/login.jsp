<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@include file="pages/common/base_css_jquery.jsp"%>
	<script type="text/javascript">

		var login = function() {
			var loginAct = $("#loginAct").val();
			var loginPwd = $("#loginPwd").val();


			if ($.trim(loginAct) == "" || loginPwd == "") {
				$("#msg").html("账号或密码不能为空");
				return false;
			}

			// alert("执行登录的操作");
			$.ajax({
				url : "user/login",
				data : {
					"loginAct" : loginAct,
					"loginPwd" : loginPwd
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					/*
						{"success":"true/false","errorMsg":具体错误原因}
					 */
					if (data.success) {
						//登录成功
						document.location.href = "pages/workbench/index.jsp";
					} else {
						//登录失败，获取登录失败信息
						var errorMsg = data.errorMsg;
						$("#msg").html(errorMsg);
					}
				}
			});
		}

		$(function () {

			// 使login.jsp始终在顶层窗口显示
			if (window.top != window) {
				window.top.location = window.location;
			}

			//刷新页面清空账号和密码框内容
			$("#loginAct").val("");
			$("#loginPwd").val("");

			//页面加载完毕后用户名输入框获取焦点
			$("#loginAct").focus();

			$("#loginBtn").click(function () {
				// alert("执行验证的操作");
				login();
			});

			$(window).keydown(function (event) {
				// alert(event.keyCode);
				//回车键的 keyCode = 13
				var enterKeyCode = 13;
				if (event.keyCode === enterKeyCode) {
					// alert("执行验证的操作");
					login();
				}
			});
		});
	</script>
<meta charset="UTF-8">
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="static/image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<%@include file="pages/common/copyright.jsp"%>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input id="loginAct" class="form-control" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input id="loginPwd" class="form-control" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						
							<span id="msg" style="color: red"></span>
						
					</div>
					<%--
						按钮在form表单中，默认的行为就是提交表单
						一定要将按钮的type属性设置为button
						按钮所触发的行为应该是由我们自己手动写js代码来决定
					--%>
					<button id="loginBtn" type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>