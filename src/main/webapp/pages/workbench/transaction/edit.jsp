<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	Map<String, String> pMap = (Map<String, String>) application.getAttribute("possibility");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<%@ include file="../../common/base_css_jquery.jsp"%>
<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="static/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<script type="text/javascript">

		$(function () {
			//阶段和可能性对应关系的json串
			var json = {
				<%
                    Set<String> keySet = pMap.keySet();
                    for (String key : keySet) {
                        String value = pMap.get(key);
                %>
				"<%=key%>" : <%=value%>,
				<%
                    }
                %>
			};

			$(".timeTop").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd', //显示格式
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});

			$(".timeBottom").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd', //显示格式
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			//处理阶段和可能性两个文本框的对应关系
			$("#edit-stage").change(function () {
				var stage = $("#edit-stage").val();
				var possibility = json[stage];
				//给可能性文本框赋值
				$("#edit-possibility").val(possibility);
			});

			//获取后台交易数据，为文本框填写内容
			$.ajax({
				url : "workbench/transaction/getUserListAndTranById",
				data : {
					"id" : "${param.id}"
				},
				type : "get",
				dataType : "json",
				success : function (data) {
					/*
						data
							{"uList":[{用户},...],"tran":{交易}}
					 */
					var html = "";
					$.each(data.uList, function (i, uObj) {
						html += "<option value='" + uObj.id + "'>" + uObj.name + "</option>";
					});
					$("#edit-owner").html(html);

					$("#edit-owner").val(data.tran.owner);
					$("#edit-money").val(data.tran.money);
					$("#edit-name").val(data.tran.name);
					$("#edit-expectedDate").val(data.tran.expectedDate);
					$("#edit-customerName").val(data.tran.customerId);
					$("#edit-stage").val(data.tran.stage);
					var type = data.tran.type;
					if (type == null) {
						type = "";
					}
					$("#edit-type").val(type);
					$("#edit-source").val(data.tran.source);
					$("#edit-activityName").val(data.tran.activityId);
					$("#edit-contactsName").val(data.tran.contactsId);
					$("#edit-description").val(data.tran.description);
					$("#edit-contactSummary").val(data.tran.contactSummary);
					$("#edit-nextContactTime").val(data.tran.nextContactTime);
					//给createBy隐藏域赋值
					$("#createBy").val(data.tran.createBy);

					var stage = $("#edit-stage").val();
					var possibility = json[stage];
					//给可能性文本框赋值
					$("#edit-possibility").val(possibility);

					//给activityId和contactsId隐藏域赋值
					$.ajax({
						url : "workbench/transaction/getActivityIdAndContactsIdByTranId",
						data : {
							"id" : "${param.id}"
						},
						type : "get",
						dataType : "json",
						success : function (data) {
							/*
								data
									{交易}
							*/

							$("#activityId").val(data.activityId);
							$("#contactsId").val(data.contactsId);
						}
					});
					
				}
			});

			//给打开查找市场活动的模态窗口的"放大镜图标"绑定单击事件，打开模态窗口
			$("#openActivitySourceBtn").click(function () {
				$("#findMarketActivity").modal("show");
			});

			//给以市场活动名字作为查询条件的文本框绑定keydown事件
			$("#searchActivityInput").keydown(function (event) {

				if (event.keyCode == 13) {
					//键入回车键
					$.ajax({
						url : "workbench/transaction/getActivityByName",
						data : {
							"activityName" : $.trim($("#searchActivityInput").val())
						},
						type : "get",
						dataType : "json",
						success : function (data) {
							/*
                                data
                                    [{市场活动1},...]
                             */
							var html = "";
							$.each(data, function (i, aObj) {
								html += '<tr>';
								html += '<td><input type="radio" value="' + aObj.id + '" name="radio-single"/></td>';
								html += '<td id="activityName'+ aObj.id + '">'+ aObj.name + '</td>';
								html += '<td>' + aObj.startDate + '</td>';
								html += '<td>' + aObj.endDate + '</td>';
								html += '<td>' + aObj.owner + '</td>';
								html += '</tr>';
							});
							$("#showSearchActivityTBody").html(html);
						}
					});

					return false;
				}

			});

			//给查找市场活动的模态窗口中的添加按钮绑定单击事件，添加市场活动
			$("#addActivitySourceBtn").click(function () {

				var activityId = $("input[name='radio-single']:checked").val();
				var activityName = $("#activityName" + activityId).html();
				//给文本框填充内容
				$("#edit-activityName").val(activityName);
				//隐藏域中保存市场活动id
				$("#activityId").val(activityId);
				//关闭模态窗口
				$("#findMarketActivity").modal("hide");

			});

			//给打开查找联系人的"放大镜图标"绑定单击事件，打开模态窗口
			$("#openContactBtn").click(function () {
				$("#findContacts").modal("show");
			});

			//给以联系人名字作为查询条件的文本框绑定keydown事件
			$("#searchContactInput").keydown(function (event) {

				if (event.keyCode == 13) {
					//键入回车键
					$.ajax({
						url : "workbench/transaction/getContactByName",
						data : {
							"contactName" : $.trim($("#searchContactInput").val())
						},
						type : "get",
						dataType : "json",
						success : function (data) {
							/*
                                data
                                    [{联系人1},...]
                             */
							var html = "";
							$.each(data, function (i, cObj) {
								html += '<tr>';
								html += '<td><input type="radio" value="' + cObj.id + '" name="radio-single"/></td>';
								html += '<td id="contactName' + cObj.id + '">' + cObj.fullname + '</td>';
								html += '<td>' + cObj.email + '</td>';
								html += '<td>' + cObj.mphone + '</td>';
								html += '</tr>';
							});
							$("#showSearchContactTBody").html(html);
						}
					});

					return false;
				}

			});

			//给查找联系人的模态窗口中的添加按钮绑定单击事件，添加联系人
			$("#addContactBtn").click(function () {

				var contactId = $("input[name='radio-single']:checked").val();
				var contactName = $("#contactName" + contactId).html();
				//给文本框填充内容
				$("#edit-contactsName").val(contactName);
				//隐藏域中保存联系人id
				$("#contactsId").val(contactId);
				//关闭模态窗口
				$("#findContacts").modal("hide");

			});

			//自动补齐
			$("#edit-customerName").typeahead({
				source: function (query, process) {
					$.get(
							"workbench/transaction/getCustomerName",
							{ "name" : query },
							function (data) {
								//alert(data);
								/*
                                    data
                                        [{"客户名1",...}]
                                 */
								process(data);
							},
							"json"
					);
				},
				delay: 1500
			});

			//更新按钮绑定单击事件
			$("#updateTranBtn").click(function () {

				var owner = $.trim($("#edit-owner").val());
				var money = $.trim($("#edit-money").val());
				var name = $.trim($("#edit-name").val());
				var expectedDate = $.trim($("#edit-expectedDate").val());
				var customerName = $.trim($("#edit-customerName").val());
				var stage = $.trim($("#edit-stage").val());
				var type = $.trim($("#edit-type").val());
				var source = $.trim($("#edit-source").val());
				var activityId = $.trim($("#activityId").val());
				var contactsId = $.trim($("#contactsId").val());
				var description = $.trim($("#edit-description").val());
				var contactSummary = $.trim($("#edit-contactSummary").val());
				var nextContactTime = $.trim($("#edit-nextContactTime").val());

				if (owner == "" || money == "" || name == "" || expectedDate == ""
						|| customerName == "" || stage == "" || type == "" || source == ""
						|| activityId == "" || contactsId == "" || description == "" || contactSummary == ""
						|| nextContactTime == "") {
					alert("请填写相关信息");
				} else {

					$.ajax({
						url : "workbench/transaction/updateTran",
						data : $("#tranForm").serialize(),
						type : "post",
						dataType : "json",
						success : function (data) {
							/*
                                data
                                    {"success":true/false,"errorMsg":错误信息}
                             */
							if (data.success) {
								window.location.href = "pages/workbench/transaction/index.jsp";
							} else {
								alert(data.errorMsg);
							}
						}
					});

				}
			});

		});

	</script>

</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="searchActivityInput" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable4" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="showSearchActivityTBody">
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="addActivitySourceBtn" type="button" class="btn btn-primary">添加</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="searchContactInput" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="showSearchContactTBody">
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="addContactBtn" type="button" class="btn btn-primary">添加</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="updateTranBtn" type="button" class="btn btn-primary">更新</button>
			<button type="button" onclick="window.history.back();" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form id="tranForm" class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<input type="hidden" name="id" value="${param.id}">
		<input type="hidden" id="createBy" name="createBy">
		<div class="form-group">
			<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-owner" name="owner">
				</select>
			</div>
			<label for="edit-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-money" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name" name="name">
			</div>
			<label for="edit-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control timeBottom" id="edit-expectedDate" name="expectedDate" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-customerName" name="customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-stage" name="stage">
			  	<option></option>
			  	<c:forEach items="${stageList}" var="s">
					<option value="${s.value}">${s.text}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-type" name="type">
				    <option></option>
					<c:forEach items="${transactionTypeList}" var="t">
						<option value="${t.value}">${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-source" name="source">
				    <option></option>
					<c:forEach items="${sourceList}" var="s">
						<option value="${s.value}">${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openActivitySourceBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-activityName">
				<input type="hidden" id="activityId" name="activityId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="openContactBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-contactsName">
				<input type="hidden" id="contactsId" name="contactsId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-description" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control timeTop" id="edit-nextContactTime" name="nextContactTime" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>