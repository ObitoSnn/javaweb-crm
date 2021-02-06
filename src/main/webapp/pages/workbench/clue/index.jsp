<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/base_css_jquery.jsp"%>
	<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link href="static/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>
	<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>
<meta charset="UTF-8">
<script type="text/javascript">

	$(function(){

		//时间控件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd', //显示格式
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		//给创建线索的按钮绑定单击事件
		$("#addClueBtn").click(function () {

			$.ajax({
				url : "workbench/clue/getUserList",
				type : "get",
				dataType : "json",
				success : function (data) {
					/*
						data
							[{用户},...]
					 */

					var html = "";
					$.each(data, function (i, userObj) {
						html += "<option value='" + userObj.id + "'>" + userObj.name + "</option>";
					})
					//为所有者下拉框填数据
					$("#create-owner").html(html);

					//默认选中当前登录的用户
					$("#create-owner").val("${sessionScope.user.id}");

					//打开模态窗口
					$("#createClueModal").modal("show");
				}
			});

		});

		//给保存线索的按钮绑定单击事件
		$("#addClueSaveBtn").click(function () {

			var fullname = $.trim($("#create-fullname").val());
			var appellation = $.trim($("#create-appellation").val());
			var owner = $.trim($("#create-owner").val());
			var company = $.trim($("#create-company").val());
			var job = $.trim($("#create-job").val());
			var email = $.trim($("#create-email").val());
			var phone = $.trim($("#create-phone").val());
			var website = $.trim($("#create-website").val());
			var mphone = $.trim($("#create-mphone").val());
			var state = $.trim($("#create-state").val());
			var source = $.trim($("#create-source").val());
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $.trim($("#create-nextContactTime").val());
			var address = $.trim($("#create-address").val());

			if (fullname == "" || appellation == "" || owner == ""
			|| company == "" || job == "" || email == "" || phone == ""
			|| website == "" || mphone == "" || state == "" || source == ""
			|| description == "" ||contactSummary == ""
			|| nextContactTime == "" || address == "") {
				alert("请填写相关信息");
			} else {
				$.ajax({
					url : "workbench/clue/saveClue",
					data : {

						"fullname" : $.trim($("#create-fullname").val()),
						"appellation" : $.trim($("#create-appellation").val()),
						"owner" : $.trim($("#create-owner").val()),
						"company" : $.trim($("#create-company").val()),
						"job" : $.trim($("#create-job").val()),
						"email" : $.trim($("#create-email").val()),
						"phone" : $.trim($("#create-phone").val()),
						"website" : $.trim($("#create-website").val()),
						"mphone" : $.trim($("#create-mphone").val()),
						"state" : $.trim($("#create-state").val()),
						"source" : $.trim($("#create-source").val()),
						"description" : $.trim($("#create-description").val()),
						"contactSummary" : $.trim($("#create-contactSummary").val()),
						"nextContactTime" : $.trim($("#create-nextContactTime").val()),
						"address" : $.trim($("#create-address").val())

					},
					type : "post",
					dataType : "json",
					success : function (data) {
						/*
                            data
                                {"success":true/false}
                         */
						if (data.success) {

							//关闭模态窗口
							$("#createClueModal").modal("hide");

							//清空表单项内容
							$("div form.form-horizontal")[0].reset();

							//保存数据后，刷新页面数据，回到第一页，每页显示数据数不变
							pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));

						} else {
							alert(data.errorMsg);
						}
					}
				});
			}

		});

		//给控制总的复选框绑定单击事件
		$("input[name='checkbox-manager']").click(function () {

			$("input[name='checkbox-single']").prop("checked", this.checked);

		});

		//给单个的复选框绑定单击事件
		$("#showClueTBody").on("click", $("input[name='checkbox-single']"), function () {
			$("input[name='checkbox-manager']").prop("checked", $("input[name='checkbox-single']:checked").length == $("input[name='checkbox-single']").length);
		})

		//页面加载完毕后调用分页方法
		pageList(1, 2);

		//给查询按钮绑定单击事件
		$("#searchBtn").click(function () {

			//查询之前将文本框信息保存至隐藏域中
			$("#hidden-fullname").val($.trim($("#input-fullname").val()));
			$("#hidden-company").val($.trim($("#input-company").val()));
			$("#hidden-phone").val($.trim($("#input-phone").val()));
			$("#hidden-source").val($.trim($("#sourceSelect").val()));
			$("#hidden-owner").val($.trim($("#input-owner").val()));
			$("#hidden-mphone").val($.trim($("#input-mphone").val()));
			$("#hidden-state").val($.trim($("#clueStateSelect").val()));

			//查询操作后，刷新页面数据，回到第一页，每页显示数据数不变
			pageList(1
					,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));

		});

		//给修改线索按钮绑定单击事件
		$("#editClueBtn").click(function () {
			var $checkbox = $("input[name='checkbox-single']:checked");
			//获取线索id
			var clueId = $checkbox.val();

			if ($checkbox.length == 0) {
				alert("请选择要修改的线索信息");
			} else if ($checkbox.length > 1) {
				alert("最多只能修改一个线索信息");
			} else {
				$.ajax({
					url : "workbench/clue/getUserListAndClueById",
					data : {
						"id" : clueId
					},
					type : "get",
					dataType : "json",
					success : function (data) {
						/*
                            data
                                {"uList":[{用户1}...],"clue":{线索}}
                        */
						var html = "";
						$.each(data.uList, function (i, userObj) {
							html += "<option value='" + userObj.id + "'>" + userObj.name + "</option>";
						});
						$("#edit-owner").html(html);

						$("#edit-owner").val(data.clue.owner);
						$("#edit-company").val(data.clue.company);
						$("#edit-appellation").val(data.clue.appellation);
						$("#edit-fullname").val(data.clue.fullname);
						$("#edit-job").val(data.clue.job);
						$("#edit-email").val(data.clue.email);
						$("#edit-phone").val(data.clue.phone);
						$("#edit-website").val(data.clue.website);
						$("#edit-mphone").val(data.clue.mphone);
						$("#edit-state").val(data.clue.state);
						$("#edit-source").val(data.clue.source);
						$("#edit-description").val(data.clue.description);
						$("#edit-contactSummary").val(data.clue.contactSummary);
						$("#edit-nextContactTime").val(data.clue.nextContactTime);
						$("#edit-address").val(data.clue.address);

						//打开修改线索的模态窗口
						$("#editClueModal").modal("show");
					}
				});
			}

		});

		//给删除线索按钮绑定单击事件
		$("#deleteClueBtn").click(function () {

			if (confirm("你确定要删除所选线索吗？")) {
				//选中的复选框
				var $checkbox = $("input[name='checkbox-single']:checked");

				var param = "";
				for(var i = 0; i < $checkbox.length; i++) {
					param += "id=" + $($checkbox[i]).val();
					if (i < $checkbox.length - 1) {
						param += "&";
					}
				}

				$.ajax({

					url : "workbench/clue/deleteClueByIds",
					data : param,
					type : "post",
					dataType : "json",
					success : function (data) {
						/*
                            data
                                {"success":true/false,"errorMsg":错误信息}
                        */
						if (data.success) {
							//删除操作后，刷新页面数据，回到第一页，每页显示数据数不变
							pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						} else {
							alert(data.errorMsg);
						}
					}
				});
			}

		});

		//给更新线索按钮绑定单击事件
		$("#updateClueBtn").click(function () {

			var owner = $.trim($("#edit-owner").val());
			var company = $.trim($("#edit-company").val());
			var appellation = $.trim($("#edit-appellation").val());
			var fullname = $.trim($("#edit-fullname").val());
			var job = $.trim($("#edit-job").val());
			var email = $.trim($("#edit-email").val());
			var phone = $.trim($("#edit-phone").val());
			var website = $.trim($.trim($("#edit-website").val()));
			var mphone = $.trim($("#edit-mphone").val());
			var state = $.trim($("#edit-state").val());
			var source = $.trim($("#edit-source").val());
			var description = $.trim($("#edit-description").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $.trim($("#edit-nextContactTime").val());
			var address = $.trim($("#edit-address").val());


			if (fullname == "" || appellation == "" || owner == ""
					|| company == "" || job == "" || email == "" || phone == ""
					|| website == "" || mphone == "" || state == "" || source == ""
					|| description == "" ||contactSummary == ""
					|| nextContactTime == "" || address == "") {
				alert("请填写相关信息");
			} else {
				//选中的复选框
				var $checkbox = $("input[name='checkbox-single']:checked");
				var id = $checkbox.val();
				$.ajax({
					url : "workbench/clue/updateClueById",
					data : {
						"id" : id,
						"fullname" : fullname,
						"appellation" : appellation,
						"owner" : owner,
						"company" : company,
						"job" : job,
						"email" : email,
						"phone" : phone,
						"website" : website,
						"mphone" : mphone,
						"state" : state,
						"source" : source,
						"description" : description,
						"contactSummary" : contactSummary,
						"nextContactTime" : nextContactTime,
						"address" : address
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						/*
                            data
                                {"success":true/false,"errorMsg":错误信息}
                        */
						if (data.success) {
							//关闭修改线索的模态窗口
							$("#editClueModal").modal("hide");

							//修改数据后，刷新页面数据，留在当前页面，每页显示数据数不变
							pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
									,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						} else {
							alert(data.errorMsg);
						}
					}
				});
			}

		});

	});

	function pageList(pageNo, pageSize) {

		//刷新后台数据之前取消总复选框的选中状态
		$("input[name='checkbox-manager']").prop("checked", false);

		//分页之前从隐藏域中取出文本框信息
		$("#input-fullname").val($.trim($("#hidden-fullname").val()));
		$("#input-company").val($.trim($("#hidden-company").val()));
		$("#input-phone").val($.trim($("#hidden-phone").val()));
		$("#sourceSelect").val($.trim($("#hidden-source").val()));
		$("#input-owner").val($.trim($("#hidden-owner").val()));
		$("#input-mphone").val($.trim($("#hidden-mphone").val()));
		$("#clueStateSelect").val($.trim($("#hidden-state").val()));


		$.ajax({
			url : "workbench/clue/pageList",
			data : {
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"fullname" : $.trim($("#input-fullname").val()),
				"company" : $.trim($("#input-company").val()),
				"phone" : $.trim($("#input-phone").val()),
				"source" : $("#sourceSelect").val(),
				"owner" : $.trim($("#input-owner").val()),
				"mphone" : $.trim($("#input-mphone").val()),
				"state" : $("#clueStateSelect").val()
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
					html += '<tr class="active">';
					html += '<td><input name="checkbox-single" type="checkbox" value="' + obj.id + '" /></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/getClueDetail?id=' + obj.id + '\';">' + obj.fullname + '</a></td>';
					html += '<td>' + obj.company + '</td>';
					html += '<td>' + obj.phone + '</td>';
					html += '<td>' + obj.mphone + '</td>';
					html += '<td>' + obj.source + '</td>';
					html += '<td>' + obj.owner + '</td>';
					html += '<td>' + obj.state + '</td>';
					html += '</tr>';
				});
				$("#showClueTBody").html(html);

				var totalPages = data.total % pageSize == 0 ? data.total / pageSize : Math.ceil(data.total / pageSize);


				//数据处理完毕后，结合分页插件展现每页数据
				$("#cluePage").bs_pagination({
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
	
</script>
</head>
<body>
	<input type="hidden" id="hidden-fullname">
	<input type="hidden" id="hidden-company">
	<input type="hidden" id="hidden-phone">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-mphone">
	<input type="hidden" id="hidden-state">

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								  <c:forEach items="${applicationScope.appellationList}" var="a">
									  <option value="${a.value}">${a.text}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  	<option></option>
									<c:forEach items="${applicationScope.clueStateList}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  	<option></option>
									<c:forEach items="${applicationScope.sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="addClueSaveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${applicationScope.appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								    <option></option>
									<c:forEach items="${applicationScope.clueStateList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								    <option></option>
									<c:forEach items="${applicationScope.sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="updateClueBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="input-fullname" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="input-company" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="input-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select id="sourceSelect" class="form-control">
					  	  <option></option>
					  	  <C:forEach items="${applicationScope.sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </C:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="input-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="input-mphone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="clueStateSelect" class="form-control">
						  <option></option>
						  <C:forEach items="${applicationScope.clueStateList}" var="c">
							  <option value="${c.value}">${c.text}</option>
						  </C:forEach>
					  </select>
				    </div>
				  </div>

				  <button id="searchBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>

			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="addClueBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editClueBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteClueBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
			</div>

			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input name="checkbox-manager" type="checkbox" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="showClueTBody">
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="cluePage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>