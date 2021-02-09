<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<%@ include file="../../common/base_css_jquery.jsp"%>
<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link href="static/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	$(function(){

		//页面加载完毕后调用分页方法，默认打开第一页，展现2条记录
		pageList(1, 2);

		//给控制总的复选框绑定单击事件
		$("input[name='checkbox-manager']").click(function () {
			$("input[name='checkbox-single']").prop("checked", this.checked);
		});

		//给单个的复选框绑定单击事件
		$("#showTranTBody").on("click", $("input[name='checkbox-single']"), function () {
			$("input[name='checkbox-manager']").prop("checked", $("input[name='checkbox-single']").length == $("input[name='checkbox-single']:checked").length);
		})

		//给查询按钮绑定单击事件
		$("#searchBtn").click(function () {

			//查询之前将文本框信息保存至隐藏域中
			$("#hidden-owner").val($.trim($("#input-owner").val()));
			$("#hidden-name").val($.trim($("#input-name").val()));
			$("#hidden-customerName").val($.trim($("#input-customerName").val()));
			$("#hidden-stage").val($.trim($("#select-stage").val()));
			$("#hidden-transactionType").val($.trim($("#select-transactionType").val()));
			$("#hidden-source").val($.trim($("#select-source").val()));
			$("#hidden-contactsFullName").val($.trim($("#input-contactsFullName").val()));

			//查询操作后，刷新页面数据，回到第一页，每页显示数据数不变
			pageList(1
					,$("#tranPage").bs_pagination('getOption', 'rowsPerPage'));

		});

		//给删除按钮绑定单击事件
		$("#deleteBtn").click(function () {
			//选中的复选框
			var $isChecked = $("input[name='checkbox-single']:checked");
			if ($isChecked.length == 0) {
				alert("请选择要删除的交易信息");
			} else if ($isChecked.length > 1) {
				alert("一次只能删除一条交易信息");
			} else {
				if (confirm("你确定要删除所选交易信息吗？")) {
					var id = $isChecked.val();
					$.ajax({
						url : "workbench/transaction/deleteTran",
						data : {
							"id" : id
						},
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
			}

		});

	});

	function pageList(pageNo, pageSize) {

		//刷新后台数据之前取消总复选框的选中状态
		$("input[name='checkbox-manager']").prop("checked", false);

		//分页之前从隐藏域中取出文本框信息
		$("#input-owner").val($.trim($("#hidden-owner").val()));
		$("#input-name").val($.trim($("#hidden-name").val()));
		$("#input-customerName").val($.trim($("#hidden-customerName").val()));
		$("#select-stage").val($.trim($("#hidden-stage").val()));
		$("#select-transactionType").val($.trim($("#hidden-transactionType").val()));
		$("#select-source").val($.trim($("#hidden-source").val()));
		$("#input-contactsFullName").val($.trim($("#hidden-contactsFullName").val()));


		$.ajax({
			url : "workbench/transaction/pageList",
			data : {
				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"owner" : $.trim($("#input-owner").val()),
				"name" : $.trim($("#input-name").val()),
				"customerName" : $.trim($("#input-customerName").val()),
				"stage" : $.trim($("#select-stage").val()),
				"transactionType" : $.trim($("#select-transactionType").val()),
				"source" : $.trim($("#select-source").val()),
				"contactsFullName" : $.trim($("#input-contactsFullName").val())
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				/*
                    data
                        {"total":总记录数,"dataList":[{交易},{}...]}
                 */
				var html = "";
				$.each(data.dataList, function (i, obj) {
					var type = obj.type;
					if (type == null) {
						type = "";
					}
					html += '<tr>';
					html += '<td><input value="'+ obj.id + '" name="checkbox-single" type="checkbox" /></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail?id=' + obj.id + '\';">' + obj.name + '</a></td>';
					html += '<td>' + obj.customerId + '</td>';
					html += '<td>' + obj.stage + '</td>';
					html += '<td>' + type + '</td>';
					html += '<td>' + obj.owner + '</td>';
					html += '<td>' + obj.source + '</td>';
					html += '<td>' + obj.contactsId + '</td>';
					html += '</tr>';
				});
				$("#showTranTBody").html(html);

				var totalPages = data.total % pageSize == 0 ? data.total / pageSize : Math.ceil(data.total / pageSize);

				//数据处理完毕后，结合分页插件展现每页数据
				$("#tranPage").bs_pagination({
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

	function edit() {

		//选中的复选框
		var $isChecked = $("input[name='checkbox-single']:checked");
		if ($isChecked.length == 0) {
			alert("请选择要修改的交易信息");
		} else if ($isChecked.length > 1) {
			alert("一次只能修改一条交易信息");
		} else {
			var id = $isChecked.val();
			window.location.href="pages/workbench/transaction/edit.jsp?id=" + id + "";
		}


	}

</script>
</head>
<body>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-customerName"/>
	<input type="hidden" id="hidden-stage"/>
	<input type="hidden" id="hidden-transactionType"/>
	<input type="hidden" id="hidden-source"/>
	<input type="hidden" id="hidden-contactsFullName"/>

	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="input-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="input-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="input-customerName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select id="select-stage" class="form-control">
					  	<option></option>
					  	<c:forEach items="${applicationScope.stageList}" var="s">
							<option value="${s.value}">${s.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select id="select-transactionType" class="form-control">
					  	<option></option>
						  <c:forEach items="${applicationScope.transactionTypeList}" var="t">
							  <option value="${t.value}">${t.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="select-source">
						  <option></option>
						  <c:forEach items="${applicationScope.sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input id="input-contactsFullName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <button id="searchBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/add';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="edit()"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input name="checkbox-manager" type="checkbox" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="showTranTBody">
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="tranPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>