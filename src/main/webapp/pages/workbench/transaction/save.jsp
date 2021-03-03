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
<script type="text/javascript" src="static/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<script type="text/javascript">

		$(function () {

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

			$("#stage").change(function () {
				var stage = $("#stage").val();
				var possibility = json[stage];
				//给可能性文本框赋值
				$("#create-possibility").val(possibility);
			});

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

			$("#create-customerName").typeahead({
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
				$("#create-activitySource").val(activityName);
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
				$("#create-contactsName").val(contactName);
				//隐藏域中保存联系人id
				$("#contactsId").val(contactId);
				//关闭模态窗口
				$("#findContacts").modal("hide");

			});

			$("#saveTranBtn").click(function () {

				var owner = $.trim($("#owner").val());
				var name = $.trim($("#create-name").val());
				var expectedDate = $.trim($("#create-expectedDate").val());
				var customerName = $.trim($("#create-customerName").val());
				var stage = $.trim($("#stage").val());

				//未填写市场活动源，默认不添加
				if ($.trim($("#create-activityName").val()) == "") {
					//隐藏域中保存市场活动id
					$("#activityId").val("");
				}

				//未填写联系人名称，默认不添加
				if ($.trim($("#create-contactsName").val()) == "") {
					//隐藏域中保存联系人id
					$("#contactsId").val("");
				}

				if (owner == "" || name == "" || expectedDate == ""
				|| customerName == "" || stage == "") {
					alert("请填写5项相关信息");
				} else {

                    $.ajax({
                        url : "workbench/transaction/saveTran",
                        data : $("#tranForm").serialize(),
                        type : "post",
                        dataType : "json",
                        success : function (data) {
                            /*
                                data
                                    {"success":true/false,"errorMsg":错误信息}
                             */
                            if (data.success) {
								window.history.back();
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
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
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
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveTranBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form id="tranForm" action="workbench/transaction/saveTran" method="post" class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="owner" name="owner">
				  <c:forEach items="${requestScope.uList}" var="u">
					  <c:if test="${u.loginAct ne 'root'}">
						  <option value="${u.id}" ${sessionScope.user.id eq u.id ? "selected" : ""}>${u.name}</option>
					  </c:if>
				  </c:forEach>
				</select>
			</div>
			<label for="create-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-money" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name" name="name">
			</div>
			<label for="create-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control timeBottom" id="create-expectedDate" name="expectedDate" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customerName" name="customerName" value="${requestScope.customerName}" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="stage" name="stage">
			  	<option></option>
			  	<c:forEach items="${applicationScope.stageList}" var="s">
					<option value="${s.value}">${s.text}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="type" name="type">
					<option></option>
					<c:forEach items="${applicationScope.transactionTypeList}" var="t">
						<option value="${t.value}">${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="source" name="source">
				    <option></option>
					<c:forEach items="${applicationScope.sourceList}" var="t">
						<option value="${t.value}">${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySource" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openActivitySourceBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-activityName" placeholder="点击左侧图标添加，默认不添加">
				<input type="hidden" id="activityId" name="activityId"/>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="openContactBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contactsName" placeholder="点击左侧图标添加，默认不添加">
				<input type="hidden" id="contactsId" name="contactsId"/>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control timeTop" id="create-nextContactTime" name="nextContactTime" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>