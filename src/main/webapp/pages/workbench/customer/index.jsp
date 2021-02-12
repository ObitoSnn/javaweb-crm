<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/base_css_jquery.jsp"%>
<meta charset="UTF-8">
<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link href="static/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>
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

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//页面加载完毕后调用分页方法，默认打开第一页，展现2条记录
		pageList(1, 2);

		//给控制总的复选框绑定单击事件
		$("input[name='checkbox-manager']").click(function () {
			$("input[name='checkbox-single']").prop("checked", this.checked);
		});

		//给单个的复选框绑定单击事件
		$("#showCustomerTBody").on("click", $("input[name='checkbox-single']"), function () {
			$("input[name='checkbox-manager']").prop("checked", $("input[name='checkbox-single']").length == $("input[name='checkbox-single']:checked").length);
		})

		//给查询按钮绑定单击事件
		$("#searchBtn").click(function () {

			//查询之前将文本框信息保存至隐藏域中
			var name = $.trim($("#input-name").val());
			var owner = $.trim($("#input-owner").val());
			var phone = $.trim($("#input-phone").val());
			var website = $.trim($("#input-website").val());

			$("#hidden-name").val(name);
			$("#hidden-owner").val(owner);
			$("#hidden-phone").val(phone);
			$("#hidden-website").val(website);

			//查询操作后，刷新页面数据，回到第一页，每页显示数据数不变
			pageList(1
					,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));

		});

		//给创建客户的按钮绑定单击事件
		$("#addCustomerBtn").click(function () {

			$.ajax({
				url : "workbench/customer/getUserList",
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
					$("#createCustomerModal").modal("show");
				}
			});

		});

		//给保存客户的按钮绑定单击事件
		$("#addCustomerSaveBtn").click(function () {


			var owner = $.trim($("#create-owner").val());
			var name = $.trim($("#create-name").val());
			var website = $.trim($("#create-website").val());
			var phone = $.trim($("#create-phone").val());
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $.trim($("#create-nextContactTime").val());
			var address = $.trim($("#create-address").val());

			if (owner == "" || name == "") {
				alert("请填写两项基本信息");
			} else {
				$.ajax({
					url : "workbench/customer/saveCustomer",
					data : {
						"owner" : owner,
						"name" : name,
						"website" : website,
						"phone" : phone,
						"contactSummary" : contactSummary,
						"nextContactTime" : nextContactTime,
						"description" : description,
						"address" : address
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
							$("#createCustomerModal").modal("hide");

							//清空表单项内容
							$("div form.form-horizontal")[0].reset();

							//保存数据后，刷新页面数据，回到第一页，每页显示数据数不变
							pageList(1,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));

						} else {
							alert(data.errorMsg);
						}
					}
				});
			}

		});

		//给修改客户按钮绑定单击事件
		$("#editCustomerBtn").click(function () {
			var $checkbox = $("input[name='checkbox-single']:checked");
			//获取客户id
			var customerId = $checkbox.val();

			if ($checkbox.length == 0) {
				alert("请选择要修改的客户信息");
			} else if ($checkbox.length > 1) {
				alert("最多只能修改一个客户信息");
			} else {
				$.ajax({
					url : "workbench/customer/getUserListAndCustomerById",
					data : {
						"id" : customerId
					},
					type : "get",
					dataType : "json",
					success : function (data) {
                            // data
                            //     {"uList":[{用户1}...],"customer":{客户}}
						var html = "";
						$.each(data.uList, function (i, userObj) {
							html += "<option value='" + userObj.id + "'>" + userObj.name + "</option>";
						});
						$("#edit-owner").html(html);

						$("#edit-owner").val(data.customer.owner);
						$("#edit-name").val(data.customer.name);
						$("#edit-website").val(data.customer.website);
						$("#edit-phone").val(data.customer.phone);
						$("#edit-contactSummary").val(data.customer.contactSummary);
						$("#edit-nextContactTime").val(data.customer.nextContactTime);
						$("#edit-description").val(data.customer.description);
						$("#edit-address").val(data.customer.address);

						//打开修改客户的模态窗口
						$("#editCustomerModal").modal("show");
					}
				});
			}

		});

		//给更新客户按钮绑定单击事件
		$("#updateCustomerBtn").click(function () {

			var owner = $.trim($("#edit-owner").val());
			var name = $.trim($("#edit-name").val());
			var website = $.trim($("#edit-website").val());
			var phone = $.trim($("#edit-phone").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $.trim($("#edit-nextContactTime").val());
			var description = $.trim($("#edit-description").val());
			var address = $.trim($("#edit-address").val());

			if (owner == "" || owner == "") {
				alert("请填写两项基本信息");
			} else {
				//选中的复选框
				var $checkbox = $("input[name='checkbox-single']:checked");
				var id = $checkbox.val();
				$.ajax({
					url : "workbench/customer/updateCustomerById",
					data : {
						"id" : id,
						"name" : name,
						"website" : website,
						"phone" : phone,
						"description" : description,
						"contactSummary" : contactSummary,
						"nextContactTime" : nextContactTime,
						"address" : address
					},
					type : "post",
					dataType : "json",
					success : function (data) {

                            // data
                            //     {"success":true/false,"errorMsg":错误信息}

						if (data.success) {
							//关闭修改客户的模态窗口
							$("#editClueModal").modal("hide");

							//修改数据后，刷新页面数据，留在当前页面，每页显示数据数不变
							pageList($("#customerPage").bs_pagination('getOption', 'currentPage')
									,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
						} else {
							alert(data.errorMsg);
						}
					}
				});
			}

		});

		//给删除客户按钮绑定单击事件
		$("#deleteCustomerBtn").click(function () {
			//选中的复选框
			var $checkbox = $("input[name='checkbox-single']:checked");

			if ($checkbox.length == 0) {
				alert("请选择要删除的客户信息");
			} else {
				if (confirm("你确定要删除所选客户吗？")) {
					var param = "";
					for(var i = 0; i < $checkbox.length; i++) {
						param += "id=" + $($checkbox[i]).val();
						if (i < $checkbox.length - 1) {
							param += "&";
						}
					}

					$.ajax({
						url : "workbench/customer/deleteCustomerByIds",
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
								pageList(1,$("#customerPage").bs_pagination('getOption', 'rowsPerPage'));
							} else {
								alert(data.errorMsg);
							}
						}
					});
				}
			}

		});

	});

	function pageList(pageNo, pageSize) {

		//刷新后台数据之前取消总复选框的选中状态
		$("input[name='checkbox-manager']").prop("checked", false);

		//分页之前从隐藏域中取出文本框信息
		var name = $.trim($("#hidden-name").val());
		var owner = $.trim($("#hidden-owner").val());
		var phone = $.trim($("#hidden-phone").val());
		var website = $.trim($("#hidden-website").val());

		$("#input-name").val(name);
		$("#input-owner").val(owner);
		$("#input-phone").val(phone);
		$("#input-website").val(website);


		$.ajax({
			url : "workbench/customer/pageList",
			data : {
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"name" : name,
				"owner" : owner,
				"phone" : phone,
				"website" : website
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				/*
                    data
                        {"total":总记录数,"dataList":[{客户},{}...]}
                 */
				var html = "";
				$.each(data.dataList, function (i, obj) {

                    var phone = obj.phone;
                    if (phone == "" || phone == null) {
                        phone = "";
                    }
                    var website = obj.website;
                    if (website == "" || website == null) {
                        website = "";
                    }

                    html += '<tr>';
					html += '<td><input type="checkbox" name="checkbox-single" value="' + obj.id + '"/></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/customer/detail?id=' + obj.id + '\';">' + obj.name + '</a></td>';
					html += '<td>' + obj.owner + '</td>';
					html += '<td>' + phone + '</td>';
					html += '<td>' + website + '</td>';
					html += '</tr>';
				});
				$("#showCustomerTBody").html(html);

				var totalPages = data.total % pageSize == 0 ? data.total / pageSize : Math.ceil(data.total / pageSize);

				//数据处理完毕后，结合分页插件展现每页数据
				$("#customerPage").bs_pagination({
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
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-phone">
	<input type="hidden" id="hidden-website">

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								</select>
							</div>
							<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
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
				<div>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="addCustomerSaveBtn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								</select>
							</div>
							<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
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
				<div>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="updateCustomerBtn" type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
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
				      <input class="form-control" type="text" id="input-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="input-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="input-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" type="text" id="input-website">
				    </div>
				  </div>
				  
				  <button id="searchBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="addCustomerBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editCustomerBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteCustomerBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" name="checkbox-manager"/></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="showCustomerTBody">
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="customerPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>