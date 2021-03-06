<%@ page contentType="text/html;charset=utf-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../../common/base_css_jquery.jsp"%>
	<link href="static/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>
	<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>
	<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<meta charset="UTF-8">
	<script type="text/javascript">

		$(function () {

			window.onpageshow = function (event) {
				if (event.persisted || window.performance &&
						window.performance.navigation.type == 2) {
					window.location.reload();
				}
			}

			//日历控件
			$(".time").datetimepicker({
				language:  "zh-CN",
				format: "yyyy-mm-dd hh:ii:ss",//显示格式
				autoclose: true,//选中自动关闭
				todayBtn: true, //显示今日按钮
				clearBtn : true,
				pickerPosition: "bottom-left"
			});

			//页面加载完毕后调用分页方法，默认打开第一页，展现2条记录
			pageList(1, 2);

			//给控制总的复选框绑定单击事件
			$("input[name='checkbox-manager']").click(function () {
				$("input[name='checkbox-single']").prop("checked", this.checked);
			});

			//给单个的复选框绑定单击事件
			$("#showUserTBody").on("click", $("input[name='checkbox-single']"), function () {
				$("input[name='checkbox-manager']").prop("checked", $("input[name='checkbox-single']").length == $("input[name='checkbox-single']:checked").length);
			})

			$("#create-loginAct").blur(function () {

				var loginAct = $.trim($("#create-loginAct").val());
				if (loginAct == "") {
					return false;
				}
				$.ajax({
					url : "settings/permission/user/checkAct",
					data : {
						"loginAct" : loginAct
					},
					type : "post",
					dataType : "text",
					success : function (data) {
						// {信息}
						if (data != "") {
							$("#errorMsg").text(data);
						} else {
							$("#errorMsg").text("");
						}
					}
				});

			});

			$("#create-confirmPwd").blur(function () {

				if ($("#errorMsg").text() == "该登录账号已存在") {
					return false;
				}
				var loginPwd = $.trim($("#create-loginPwd").val());
				var confirmPwd = $.trim($("#create-confirmPwd").val());
				if (loginPwd != confirmPwd) {
					$("#errorMsg").text("登录密码与确认密码不一致");
					return false;
				}
				$("#errorMsg").text("");

			});

		});

		function pageList(pageNo, pageSize) {

			//刷新后台数据之前取消总复选框的选中状态
			$("input[name='checkbox-manager']").prop("checked", false);

			//分页之前从隐藏域中取出文本框信息
			$("#input-name").val($.trim($("#hidden-name").val()));
			$("#input-deptno").val($.trim($("#hidden-deptno").val()));
			$("#lockState").val($.trim($("#hidden-lockState").val()));
			$("#input-startDate").val($.trim($("#hidden-startDate").val()));
			$("#input-endDate").val($.trim($("#hidden-endDate").val()));

			var name = $("#input-name").val();
			var deptno = $("#input-deptno").val();
			var lockState = $("#lockState").val();
			var startDate = $("#input-startDate").val();
			var endDate = $("#input-endDate").val();

			$.ajax({
				url : "settings/permission/user/pageList",
				data : {
					"pageNo" : pageNo,
					"pageSize" : pageSize,
					"name" : name,
					"deptno" : deptno,
					"lockState" : lockState,
					"startDate" : startDate,
					"endDate" : endDate
				},
				type : "get",
				dataType : "json",
				success : function (data) {
					/*
                        data
                            {"total":总记录数,"dataList":[{线索},{}...]}
                     */
					var html = "";
					$.each(data.dataList, function (i, obj) {
						var editBy = obj.editBy;
						if (editBy == null) {
							editBy = "";
						}
						var editTime = obj.editTime;
						if (editTime == null) {
							editTime = "";
						}
						var userName = obj.name;
						if (userName == null) {
							userName = "";
						}
						var email = obj.email;
						if (email == null) {
							email = "";
						}
						var expireTime = obj.expireTime;
						if (expireTime == null) {
							expireTime = "";
						}
						var allowIps = obj.allowIps;
						if (allowIps == null) {
							allowIps = "";
						}
						html += '<tr>';
						html += '<td><input type="checkbox" name="checkbox-single" value="' + obj.id + '"/></td>';
						html += '<td>' + (i + 1) + '</td>';
						html += '<td><a  href="settings/permission/user/detail?id=' + obj.id + '">' + obj.loginAct + '</a></td>';
						html += '<td>' + userName + '</td>';
						html += '<td>' + obj.deptno + '</td>';
						html += '<td>' + email + '</td>';
						html += '<td>' + expireTime + '</td>';
						html += '<td>' + allowIps + '</td>';
						html += '<td>' + obj.lockState + '</td>';
						html += '<td>' + obj.createBy + '</td>';
						html += '<td>' + obj.createTime + '</td>';
						html += '<td>' + editBy + '</td>';
						html += '<td>' + editTime + '</td>';
						html += '</tr>';
					});
					$("#showUserTBody").html(html);

					var totalPages = data.total % pageSize == 0 ? data.total / pageSize : Math.ceil(data.total / pageSize);

					//数据处理完毕后，结合分页插件展现每页数据
					$("#userPage").bs_pagination({
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

		function search() {

			//查询之前将文本框信息保存至隐藏域中
			$("#hidden-name").val($.trim($("#input-name").val()));
			$("#hidden-deptno").val($.trim($("#input-deptno").val()));
			$("#hidden-lockState").val($.trim($("#lockState").val()));
			$("#hidden-startDate").val($.trim($("#input-startDate").val()));
			$("#hidden-endDate").val($.trim($("#input-endDate").val()));

			//查询操作后，刷新页面数据，回到第一页，每页显示数据数不变
			pageList(1
					,$("#userPage").bs_pagination('getOption', 'rowsPerPage'));

		}

		function openCreateUserModal() {

			$("#createUserForm")[0].reset();
			$.ajax({
				url : "settings/permission/user/getDeptList",
				type : "get",
				dataType : "json",
				success : function (data) {
					// [{部门},...]
					var html = "<option></option>";
					$.each(data, function (i, obj) {
						html += "<option value='" + obj.deptno + "'>" + obj.name + "</option>"
					});
					$("#create-deptno").html(html);
				}
			});
			$("#createUserModal").modal("show");

		}

		function saveUser() {

			var loginAct = $.trim($("#create-loginAct").val());
			var name = $.trim($("#create-name").val());
			var loginPwd = $.trim($("#create-loginPwd").val());
			var confirmPwd = $.trim($("#create-confirmPwd").val());
			var email = $.trim($("#create-email").val());
			var expireTime = $.trim($("#create-expireTime").val());
			var lockState = $.trim($("#create-lockState").val());
			var deptno = $.trim($("#create-deptno").val());
			var allowIps = $.trim($("#create-allowIps").val());
			if ($("#errorMsg").text() == "该登录账号已存在") {
				return false;
			}
			if (loginAct == "") {
				$("#errorMsg").text("请输入登录账号");
				return false;
			}
			if (loginPwd == "") {
				$("#errorMsg").text("请输入登录密码");
				return false;
			}
			if (confirmPwd == "") {
				$("#errorMsg").text("请输入确认密码");
				return false;
			}
			if (loginPwd != confirmPwd) {
				$("#errorMsg").text("登录密码与确认密码不一致");
				return false;
			}
			if (lockState == "") {
				$("#errorMsg").text("请选择锁定状态");
				return false;
			}
			if (deptno == "") {
				$("#errorMsg").text("请选择部门");
				return false;
			}
			$("#errorMsg").text("");
			$.ajax({
				url : "settings/permission/user/saveUser",
				data : {
					"loginAct" : loginAct,
					"name" : name,
					"loginPwd" : loginPwd,
					"email" : email,
					"expireTime" : expireTime,
					"lockState" : lockState,
					"deptno" : deptno,
					"allowIps" : allowIps
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					if (data.success) {
						$("#createUserModal").modal("hide");
						//保存数据后，刷新页面数据，回到第一页，每页显示数据数不变
						pageList(1,$("#userPage").bs_pagination('getOption', 'rowsPerPage'));
					} else {
						alert(data.errorMsg);
					}
				}
			});

		}

	</script>
</head>
<body>
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-deptno">
	<input type="hidden" id="hidden-lockState">
	<input type="hidden" id="hidden-startDate">
	<input type="hidden" id="hidden-endDate">

	<!-- 创建用户的模态窗口 -->
	<div class="modal fade" id="createUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">新增用户</h4>
				</div>
				<div class="modal-body">
				
					<form id="createUserForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-loginAct" class="col-sm-2 control-label">登录帐号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-loginAct">
							</div>
							<label for="create-name" class="col-sm-2 control-label">用户姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						<div class="form-group">
							<label for="create-loginPwd" class="col-sm-2 control-label">登录密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-loginPwd">
							</div>
							<label for="create-confirmPwd" class="col-sm-2 control-label">确认密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-confirmPwd">
							</div>
						</div>
						<div class="form-group">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-expireTime" class="col-sm-2 control-label">失效时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-expireTime">
							</div>
						</div>
						<div class="form-group">
							<label for="create-lockState" class="col-sm-2 control-label">锁定状态<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-lockState">
								  <option></option>
								  <option value="1">启用</option>
								  <option value="0">锁定</option>
								</select>
							</div>
							<label for="create-deptno" class="col-sm-2 control-label">部门<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="create-deptno">
                                </select>
                            </div>
						</div>
						<div class="form-group">
							<label for="create-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-allowIps" style="width: 280%" placeholder="多个用逗号隔开">
								<span id="errorMsg" style="color: red;"></span>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="saveUser()">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>用户列表</h3>
			</div>
		</div>
	</div>
	
	<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; left: 30px; top: -10px;">
		<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">用户姓名</div>
		      <input class="form-control" type="text" id="input-name">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">部门名称</div>
		      <input class="form-control" type="text" id="input-deptno">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">锁定状态</div>
			  <select id="lockState" class="form-control">
			  	  <option></option>
			      <option value="0">锁定</option>
				  <option value="1">启用</option>
			  </select>
		    </div>
		  </div>
		  <br><br>
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">失效时间</div>
			  <input class="form-control time" type="text" id="input-startDate"/>
		    </div>
		  </div>
		  
		  ~
		  
		  <div class="form-group">
		    <div class="input-group">
			  <input class="form-control time" type="text" id="input-endDate"/>
		    </div>
		  </div>
		  
		  <button type="button" onclick="search()" class="btn btn-default">查询</button>
		  
		</form>
	</div>
	
	
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; width: 110%; top: 20px;">
		<div class="btn-group" style="position: relative; top: 18%;">
`		  <button type="button" class="btn btn-primary" onclick="openCreateUserModal()"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
		
	</div>
	
	<div style="position: relative; left: 30px; top: 40px; width: 110%">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" name="checkbox-manager"/></td>
					<td>序号</td>
					<td>登录帐号</td>
					<td>用户姓名</td>
					<td>部门名称</td>
					<td>邮箱</td>
					<td>失效时间</td>
					<td>允许访问IP</td>
					<td>锁定状态</td>
					<td>创建者</td>
					<td>创建时间</td>
					<td>修改者</td>
					<td>修改时间</td>
				</tr>
			</thead>
			<tbody id="showUserTBody">
			</tbody>
		</table>
	</div>
	
	<div style="height: 50px; position: relative;top: 30px; left: 30px;">
		<div id="userPage"></div>
	</div>
			
</body>
</html>