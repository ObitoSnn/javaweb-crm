<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../../common/base_css_jquery.jsp"%>
	<link href="static/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>
	<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>
<meta charset="UTF-8">
	<script type="text/javascript">

		$(function () {

			//复选框绑定单击事件
			$("input[name='checkbox-manager']").click(function () {

				$("input[name='checkbox-single']").prop("checked", this.checked);

			});

			$("#showDicTypeTBody").on("click",$("input[name='checkbox-single']"),function () {
				//复选框选中的个数和复选框的个数一致时触发控制所有复选框的复选框选中
				$("input[name='checkbox-manager']").prop("checked", $("input[name='checkbox-single']").length == $("input[name='checkbox-single']:checked").length);

			});

			pageList(1, 5);

			window.onpageshow = function (event) {

				if (event.persisted || window.performance && window.performance.navigation.type == 2) {
					window.location.reload();
				}

			}

		});

		function pageList(pageNo, pageSize) {

			//刷新后台数据之前取消总复选框的选中状态
			$("input[name='checkbox-manager']").prop("checked", false);
			$.ajax({
				url : "settings/dictionary/type/pageList",
				data : {
					"pageNo" : pageNo,
					"pageSize" : pageSize,
				},
				type : "get",
				dataType : "json",
				success : function (data) {
					// data {"total":总记录数,"dataList":[{市场活动},{}...]}
					var html = "";
					$.each(data.dataList, function (i, obj) {
						html += '<tr>';
						html += '<td><input name="checkbox-single" value="' + obj.code + '" type="checkbox"/></td>';
						html += '<td>' + (i + 1) + '</td>';
						html += '<td>' + obj.code + '</td>';
						html += '<td>' + obj.name + '</td>';
						html += '<td>' + obj.description + '</td>';
						html += '</tr>';
					});
					$("#showDicTypeTBody").html(html);
					var totalPages = data.total % pageSize == 0 ? data.total / pageSize : Math.ceil(data.total / pageSize);
					//数据处理完毕后，结合分页插件展现每页数据
					$("#dicTypePage").bs_pagination({
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

		function openRemoveDicTypeModal() {

			var $checkbox = $("input[name='checkbox-single']:checked");
			if ($checkbox.length == 0) {
				alert("请选择要删除的字典类型");
			} else {
				$("#removeDicTypeModal").modal("show");
			}

		}

		function edit() {

			var $checkbox = $("input[name='checkbox-single']:checked");
			if ($checkbox.length == 0) {
				alert("请选择要编辑的字典类型");
			} else if ($checkbox.length > 1) {
				alert("一次只能编辑一个字典类型");
			} else {
				var code = $checkbox.val();
				window.location.href = 'pages/settings/dictionary/type/edit.jsp?code=' + code + '';
			}

		}

		function deleteDicType() {

			var $checkbox = $("input[name='checkbox-single']:checked");
			var param = "";
			for (var i = 0; i < $checkbox.length; i++) {
				param += "code=" + $($checkbox[i]).val();
				if (i < $checkbox.length - 1) {
					param += "&";
				}
			}
			$.ajax({
				url : "settings/dictionary/deleteDicTypeByCodes",
				data : param,
				type : "post",
				dataType : "json",
				success : function (data) {
					// {"success":true/false,"errorMsg":错误信息}
					if (data.success) {
						$("#removeDicTypeModal").modal("hide");
						pageList(1, $("#dicTypePage").bs_pagination('getOption', 'rowsPerPage'));
					} else {
						alert(data.errorMsg);
					}
				}
			});

		}

	</script>
</head>
<body>

	<!-- 删除字典类型的模态窗口 -->
	<div class="modal fade" id="removeDicTypeModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除字典类型</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除所选字典类型吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button onclick="deleteDicType()" type="button" class="btn btn-danger">删除</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='pages/settings/dictionary/type/save.jsp'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-default" onclick="edit()"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" onclick="openRemoveDicTypeModal()" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input name="checkbox-manager" type="checkbox" /></td>
					<td>序号</td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>
			<tbody id="showDicTypeTBody">
			</tbody>
		</table>
		<div style="height: 50px; position: relative;">
			<div id="dicTypePage"></div>
		</div>
	</div>
	
</body>
</html>