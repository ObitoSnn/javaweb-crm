<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/base_css_jquery.jsp"%>
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet"/>
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
			pickerPosition: "bottom-left"
		});

		// 给打开创建市场活动操作的模态窗口绑定单击事件
		$("#addBtn").click(function () {

			//时间控件
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd', //显示格式
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			/*
				操作模态窗口的方式：
				需要操作的模态窗口的jquery对象，调用modal方法，
				为该方法传递参数
					show：打开模态窗口
					hide：关闭模态窗口
			 */

			//获取后台用户数据，供下拉框显示
			$.ajax({
				url : "workbench/activity/ajaxGetUserList",
				type : "get",
				dataType : "json",
				success : function (data) {
					/*
						data
							[{用户1},{2},{2},....]
					 */
					var optionHtml = "<option></option>";
					$.each(data, function (i, obj) {
                        optionHtml += "<option value='" + obj.id + "'>" + obj.name + "</option>";
					});
                    $("#create-owner").html(optionHtml);
                    //设置所有者下拉框为当前登录用户
					$("#create-owner").val("${sessionScope.user.id}");
                    $("#createActivityModal").modal("show");
				}

			});

		});

		// 给保存市场活动按钮绑定单击事件
		$("#addActivitySaveBtn").click(function () {

			var inputOwnerText = $.trim($("#create-owner").val());
			var inputNameText = $.trim($("#create-name").val());
			var inputStartDateText = $.trim($("#create-startDate").val());
			var inputEndDateText = $.trim($("#create-endDate").val());
			var inputCostText = $.trim($("#create-cost").val());
			var inputDescriptionText = $.trim($("#create-description").val());

			//检验文本框内容，不能为空
			if (inputOwnerText == "" || inputNameText == "" ||
			inputStartDateText == "" || inputStartDateText == "" ||
			inputEndDateText == "" || inputCostText == "" ||
			inputDescriptionText == "") {
				alert("请填写相关信息");
			} else {
				$.ajax({
					url : "workbench/activity/saveActivity",
					data : {
						"owner" : $.trim($("#create-owner").val()),
						"name" : $.trim($("#create-name").val()),
						"startDate" : $.trim($("#create-startDate").val()),
						"endDate" : $.trim($("#create-endDate").val()),
						"cost" : $.trim($("#create-cost").val()),
						"description" : $.trim($("#create-description").val())
					},
					type : "post",
					dataType : "json",
					success : function (data) {
						/*
                            data : {"success":"true/false","errorMsg":错误信息}
                        */
						if (data.success) {
							//保存成功

							/*
                                注意：
                                    我们拿到了form表单的jquery对象
                                    对于表单的jquery对象，提供了submit()方法让我们提交表单
                                    但是表单的jquery对象，没有为我们提供reset()方法让我们重置表单

                                    虽然jquery对象没有为我们提供reset()方法，但是原生的js为我们提供了reset方法
                                    所以我们要将jquery对象转换为原生的dom对象

                                    jquery对象转换为dom对象：
                                        jquery对象[小标]

                                    dom对象转换为jquery对象：
                                        $(dom)
                            */
							//关闭模态窗口前清空文本框内容
							$("#addActivityForm")[0].reset();

							//关闭模态窗口
							$("#createActivityModal").modal("hide");

							//保存数据后，刷新页面数据，回到第一页，每页显示数据数不变
							pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

						} else {
							alert(data.errorMsg);
						}
					}
				});
			}

		});


		/*
			对于所有关系型数据库，做前端的分页相关操作的基础组件
			就是pageNo和pageSize
			pageNo：页码
			pageSize：每页展现的记录数

			调用pageList方法的时机
			1）点击左侧菜单中的“市场活动”超链接
			2）添加，修改，删除后，需要刷新市场活动列表
			3）点击查询按钮时，需要刷新市场活动列表
			4）点击分页组件时，需要刷新市场活动列表
		 */

		//页面加载完毕后调用分页方法
		//默认打开第一页，展现2条记录
		pageList(1, 2);

		//给查询按钮绑定单击事件
		$("#searchBtn").click(function () {

			//查询之前将文本框信息保存至隐藏域中
			$("#hidden-name").val($.trim($("#input-name").val()));
			$("#hidden-owner").val($.trim($("#input-owner").val()));
			$("#hidden-startDate").val($.trim($("#input-startDate").val()));
			$("#hidden-endDate").val($.trim($("#input-endDate").val()));

			//查询操作后，刷新页面数据，回到第一页，每页显示数据数不变
			pageList(1
					,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));


		});

		//复选框绑定单击事件
		$("input[name='checkbox-manager']").click(function () {

			$("input[name='checkbox-single']").prop("checked", this.checked);

		});

		/*
			动态生成的元素，是不能够以普通绑定事件的形式来进行操作的
				动态生成的元素，要以on方法的形式来触发事件
				语法：
					$(需要绑定元素的有效的外层元素的jquery对象).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
		*/
		$("#showActivityTBody").on("click",$("input[name='checkbox-single']"),function () {
			//复选框选中的个数和复选框的个数一致时触发控制所有复选框的复选框选中
			$("input[name='checkbox-manager']").prop("checked", $("input[name='checkbox-single']").length == $("input[name='checkbox-single']:checked").length);

		});

		//给删除按钮绑定单击事件
		$("#deleteBtn").click(function () {
			//找出选中状态的复选框的jquery对象
			var $checkBoxes = $("input[name='checkbox-single']:checked");

			if ($checkBoxes.length == 0) {
				alert("请选择要删除的市场活动信息");
			} else {

				if (confirm("你确定要删除所选信息吗？")) {
					//url : workbench/activity/deleteActivity?id=xx&id=xx
					var param = "";

					for (var i = 0; i < $checkBoxes.length; i++) {
						param += "id=" + $($checkBoxes[i]).val();
						//不是最后一个
						if (i < $checkBoxes.length - 1) {
							param += "&";
						}
					}
					$.ajax({
						url : "workbench/activity/deleteActivity",
						data : param,
						type : "post",
						dataType : "json",
						success : function (data) {
							/*
                                data:
                                    {"success" : true/false,"errorMsg":错误信息}
                            */
							if (data.success) {
								//删除操作后，刷新页面数据，回到第一页，每页显示数据数不变
								// pageList(1, 2);
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							} else {
								alert(data.errorMsg);
							}
						}
					});
				}
			}

		});

        //给修改按钮绑定单击事件
        $("#editBtn").click(function () {


			var $checkbox = $("input[name='checkbox-single']:checked");
			//市场活动的id
			var id = $checkbox.val();

			if ($checkbox.length == 0) {
				alert("请选择要修改的市场活动信息");
			} else if ($checkbox.length > 1) {
				alert("最多只能修改一个市场活动信息");
			} else {
				$.ajax({
					url : "workbench/activity/getUserListAndActivity",
					data : {
						"id" : id
					},
					type : "get",
					dataType : "json",
					success : function (data) {
						/*
                            data:
                                {"uList":[{用户1},{用户2},...],"activity":"{市场活动}"}
                        */
						var html = "<option></option>";
						$.each(data.uList, function (i, obj) {
							html += "<option value='" + obj.id +"'>" + obj.name + "</option>";
						});
						//下拉框填写信息
						$("#edit-owner").html(html);
						//将市场活动的id保存至隐藏域
						$("#edit-id").val(data.activity.id);
						$("#edit-owner").val(data.activity.owner);
						$("#edit-name").val(data.activity.name);
						$("#edit-startDate").val(data.activity.startDate);
						$("#edit-endDate").val(data.activity.endDate);
						$("#edit-cost").val(data.activity.cost);
						$("#edit-description").val(data.activity.description);
					}
				});
				//打开修改市场活动的模态窗口
				$("#editActivityModal").modal("show");
			}
        });

		//给更新按钮绑定单击事件
		$("#updateActivityBtn").click(function () {

			$.ajax({
				url : "workbench/activity/updateActivity",
				data : {
					"id" : $.trim($("#edit-id").val()),
					"owner" : $.trim($("#edit-owner").val()),
					"name" : $.trim($("#edit-name").val()),
					"startDate" : $.trim($("#edit-startDate").val()),
					"endDate" : $.trim($("#edit-endDate").val()),
					"cost" : $.trim($("#edit-cost").val()),
					"description" : $.trim($("#edit-description").val())
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					/*
						data : {"success":"true/false","errorMsg":错误信息}
					*/
					if (data.success) {
						//更新成功

						//关闭模态窗口
						$("#editActivityModal").modal("hide");

						//修改数据后，刷新页面数据，留在当前页面，每页显示数据数不变
						pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
								,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
					} else {
						//更新失败后相关的操作
						alert(data.errorMsg);
					}
				}
			});

		});

	});
	//分页方法
	function pageList(pageNo, pageSize) {

		//刷新后台数据之前取消总复选框的选中状态
		$("input[name='checkbox-manager']").prop("checked", false);

		//分页之前从隐藏域中取出文本框信息
		$("#input-name").val($.trim($("#hidden-name").val()));
		$("#input-owner").val($.trim($("#hidden-owner").val()));
		$("#input-startDate").val($.trim($("#hidden-startDate").val()));
		$("#input-endDate").val($.trim($("#hidden-endDate").val()));

		$.ajax({
			url : "workbench/activity/pageList",
			data : {

				"pageNo" : pageNo,
				"pageSize" : pageSize,
				"name" : $.trim($("#input-name").val()),
				"owner" : $.trim($("#input-owner").val()),
				"startDate" : $.trim($("#input-startDate").val()),
				"endDate" : $.trim($("#input-endDate").val())

			},
			type : "get",
			dataType : "json",
			success : function (data) {

				/*
                    data
                        {"total":总记录数,"dataList":[{市场活动},{}...]}
                 */
				var html = "";
				$.each(data.dataList, function (i, obj) {

					html += '<tr class="active">';
					html += '<td><input name="checkbox-single" type="checkbox" value="' + obj.id + '" /></td>';
					html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/getActivityDetail?id=' + obj.id + '\';">' + obj.name + '</a></td>';
					html += '<td>' + obj.owner + '</td>';
					html += '<td>' + obj.startDate + '</td>';
					html += '<td>' + obj.endDate + '</td>';
					html += '</tr>';

				});

				$("#showActivityTBody").html(html);

				var totalPages = data.total % pageSize == 0 ? data.total / pageSize : Math.ceil(data.total / pageSize);


				//数据处理完毕后，结合分页插件展现每页数据
				$("#activityPage").bs_pagination({
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

	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="addActivityForm" class="form-horizontal" role="form">
					
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
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" readonly placeholder="请选择日期">
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" readonly placeholder="请选择日期">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<!--
						data-dismiss="modal"
							表示关闭模态窗口
					-->
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="addActivitySaveBtn" type="button" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">

						<input id="edit-id" type="hidden">

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
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" readonly>
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<!--
									关于文本域(textarea)
										1）一定是要以标签对的形式来呈现，正常情况下标签对要紧紧的挨着
										2）textarea虽然是以标签对的形式来呈现的，但是它也是属于表单元素范畴
											我们所有的对于textarea的取值和赋值操作，我们统一使用val()方法(而不是html()方法)
								-->
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="updateActivityBtn" type="button" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <input id="input-name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="input-owner" class="form-control" type="text">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input id="input-startDate" class="form-control" type="text" id="startTime" placeholder="请输入日期"/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input id="input-endDate" class="form-control" type="text" id="endTime" placeholder="请输入日期"/>
				    </div>
				  </div>
				  
				  <button id="searchBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<!--
						点击创建按钮，观察两个属性和属性值

						data-toggle="modal"
							表示出发该按钮，将要打开一个模态窗口
						data-target="#createActivityModal"
							表示要打开哪个模态窗口，通过#id的形式找到该窗口

						现在是以属性和属性值的方式卸载了button元素中，用来打开模态窗口
						但是这样做是有问题的：
							问题在于没有办法对按钮的功能进行扩充
						所以实际项目开发中，对于触发模态窗口的操作，一定不要写死在元素当中，
						应该由我们自己写js代码操控
					-->
				  <button id="addBtn" type="button" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input name="checkbox-manager" type="checkbox"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="showActivityTBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="activityPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>