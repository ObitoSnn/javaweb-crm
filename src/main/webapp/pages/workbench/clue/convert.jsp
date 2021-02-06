<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/base_css_jquery.jsp"%>
<meta charset="UTF-8">
<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){

		//时间控件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd', //显示格式
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		//给打开搜索市场活动的模态窗口的"放大镜图标"绑定单击事件，打开模态窗口
		$("#openSearchActivityBtn").click(function () {
			$("#searchActivityModal").modal("show");
		});

		//给以市场活动名字作为查询条件的文本框绑定keydown事件
		$("#searchActivityInput").keydown(function (event) {

			if (event.keyCode == 13) {
				//键入回车键
				$.ajax({
					url : "workbench/clue/getActivityByName",
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

		//给搜索市场活动模态窗口中的关联按钮绑定单击事件，将市场活动名字显示在文本框中
		$("#addActivitySourceBtn").click(function () {
			//市场活动的id
			var activityId = $("input[name='radio-single']:checked").val();
			//市场活动的名字
			var activityName = $("#activityName" + activityId).html();
			//将市场活动名字显示在文本框
			$("#activityName").val(activityName);

			//将市场活动id赋给隐藏域
			$("#activityId").val(activityId);

			//关闭模态窗口
			$("#searchActivityModal").modal("hide");
		});

		//给转换按钮绑定点击事件
		$("#convertBtn").click(function () {
			//判断是否为该客户创建交易
			if ($("#isCreateTransaction").prop("checked")) {
				$.ajax({
					url : "workbench/clue/convert",
					data : {
						"clueId" : "${param.id}",
						"money" : $.trim($("#money").val()),
						"name" : $.trim($("#name").val()),
						"expectedDate" : $.trim($("#expectedDate").val()),
						"stage" : $.trim($("#stage").val()),
						"activityId" : $.trim($("#activityId").val()),
						"isForm" : $.trim($("#isForm").val())
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						/*
							data
								{"success":true/false,"errorMsg":错误信息}
						 */
						if (data.success) {
							alert("转换线索成功");
							window.location.href = "pages/workbench/clue/index.jsp";
						} else {
							alert(data.errorMsg);
						}
					}
				});
			} else {
				$.ajax({
					url : "workbench/clue/convert",
					data : {
						"clueId" : "${param.id}"
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						/*
							data
								{"success":true/false,"errorMsg":错误信息}
						 */
						if (data.success) {
							alert("转换线索成功");
							window.location.href = "pages/workbench/clue/index.jsp";
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
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
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
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="showSearchActivityTBody">
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="addActivitySourceBtn" type="button" class="btn btn-primary">关联</button>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${param.fullname}${param.appellation}-${param.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${param.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${param.fullname}${param.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >

		<form id="tranForm" action="workbench/clue/convert" method="post">
			<input type="hidden" id="isForm" name="isForm" value="isForm"/>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="money">金额</label>
		    <input type="text" class="form-control" id="money" name="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="name">交易名称</label>
		    <input type="text" class="form-control" id="name" name="name">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedDate">预计成交日期</label>
		    <input type="text" class="form-control time" id="expectedDate" readonly name="expectedDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
				<c:forEach items="${applicationScope.stageList}" var="s">
					<option value="${s.value}">${s.text}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activityName">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
		    <input type="hidden" id="activityId" name="activityId"/>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${param.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="convertBtn" class="btn btn-primary" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input onclick="window.history.back();" class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>