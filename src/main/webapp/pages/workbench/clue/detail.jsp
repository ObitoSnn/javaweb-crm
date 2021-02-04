<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/base_css_jquery.jsp"%>
	<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<meta charset="UTF-8">
<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
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

		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		//页面加载完毕后展示关联的市场活动
		getActivityListByClueId();

		//页面加载完毕获取线索备注信息
		getClueRemarkList();
		//使用on操控动态生成的备注的修改和删除按钮
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		//给关联市场活动a标签绑定单击事件
		$("#bindActivity").click(function () {
			//清空文本框内容
			$("#activityNameInput").val("");

			//取消总复选框的选中状态
			$("input[name='checkbox-manager']").prop("checked", false);

			//打开关联市场活动模态窗口
			$("#bundModal").modal("show");

			//获取未关联的市场活动列表
			getNotBindActivityListByClueId();

		});

		//给关联市场活动的模态窗口中的文本框绑定keydown事件
		$("#activityNameInput").keydown(function (event) {
			var name = $.trim($("#activityNameInput").val());
			if (event.keyCode == 13) {
				getNotBindActivityListByName(name);
				//阻止模态窗口键入回车键刷新页面的默认行为
				return false;
			}
		});

		//复选框绑定单击事件
		$("input[name='checkbox-manager']").click(function () {

			$("input[name='checkbox-single']").prop("checked", this.checked);

		});

		//给每条记录的复选框绑定单击事件
		$("#showSearchActivityTBody").on("click", $("input[name='checkbox-single']"), function () {

			$("input[name='checkbox-manager']").prop("checked", $("input[name='checkbox-single']").length == $("input[name='checkbox-single']:checked").length);

		});

		//给关联市场活动按钮绑定单击事件，执行关联操作
		$("#bindActivityBtn").click(function () {

			var $activity = $("input[name='checkbox-single']:checked");

			if ($activity.length == 0) {
				alert("请选择要关联的市场活动");
			} else {
				//请求参数 cid=xxx&aid=xxx&aid=xxx
				var param = "cid=${requestScope.clue.id}&";
				for(var i = 0; i < $activity.length; i++) {
					var aid = $($("input[name='checkbox-single']:checked")[i]).val();
					param += "aid=" + aid;
					if (i < $activity.length - 1) {
						param += "&";
					}
				}
				$.ajax({
					url : "workbench/clue/bindActivityByClueIdAndActivityIds",
					data : param,
					type : "post",
					dataType : "json",
					success : function (data) {
						/*
                            data
                                {"success":true/false,"errorMsg":错误信息}
                         */
						if (data.success) {
							//刷新关联的市场活动列表
							getActivityListByClueId();
							//展现上次搜索信息
							getNotBindActivityListByName($("#activityNameInput").val());
						} else {
							alert(data.errorMsg);
						}
					}
				});
			}

		});

		//给保存线索备注按钮绑定单击事件
		$("#saveClueRemarkBtn").click(function () {

			$.ajax({
				url : "workbench/clue/saveClueRemark",
				data : {
					"noteContent" : $.trim($("#remark").val()),
					"clueId" : "${requestScope.clue.id}"
				},
				type : "post",
				dataType : "json",
				success : function (data) {

					/*
                        data
                            {"success":true/false,"clueRemark":{线索备注}}
                     */
					if (data.success) {
						var html = "";
						html += '<div id="' + data.clueRemark.id + '" class="remarkDiv" style="height: 60px;">';
						html += '<img title="zhangsan" src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						html += '<h5 id="h' + data.clueRemark.id + '">' + data.clueRemark.noteContent +'</h5>';
						html += '<font color="gray">线索</font> <font color="gray">-</font> <b>${requestScope.clue.fullname}-${requestScope.clue.company}</b> <small style="color: gray;" id="s' + data.clueRemark.id +'"> ' + data.clueRemark.createTime + '由' + data.clueRemark.createBy + '</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.clueRemark.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + data.clueRemark.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';

						//在显示文本域的上方追加备注信息
						$("#remarkDiv").before(html);

						//清空文本域内容
						$("#remark").val("");
					} else {
						alert(data.errorMsg);
					}
				}
			});

		});

		//给更新线索备注按钮绑定单击事件
		$("#updateRemarkBtn").click(function () {

			//从隐藏域中获取备注信息的id
			var id = $("#remarkId").val();

			$.ajax({
				url : "workbench/clue/updateClueRemark",
				data : {
					"id" : id,
					"noteContent" : $.trim($("#noteContent").val())
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					/*
                        data
                            {"success":true/false,"clueRemark":{线索备注},"errorMsg":错误信息}
                     */
					if (data.success) {
						//修改成功
						//修改h标签内容
						$("#h" + id).html(data.clueRemark.noteContent);
						//修改small标签内容
						$("#s" + id).html(data.clueRemark.editTime + '由' + data.clueRemark.editBy);
						//关闭模态窗口
						$("#editRemarkModal").modal("hide");
					} else {
						//修改失败
						alert(data.errorMsg);
					}
				}
			});

		});

		//给编辑按钮绑定单击事件
		$("#editClueBtn").click(function () {
			//获取市场活动id
			var id = "${requestScope.clue.id}";

			$.ajax({
				url : "workbench/clue/getUserListAndClueById",
				data : {
					"id" : id
				},
				type : "get",
				dataType : "json",
				success : function (data) {
					/*
                        data
                            {"uList":[{用户1},{用户2},...],"clue":"{线索}"}
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
				//获取市场活动id
				var id = "${requestScope.clue.id}";

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
                            data : {"success":"true/false","errorMsg":错误信息}
                        */
						if (data.success) {
							//向服务器发起请求，刷新市场活动详情页面
							location.href = "workbench/clue/getClueDetail?id=${requestScope.clue.id}";
						} else {
							//更新失败后相关的操作
							alert(data.errorMsg);
						}
					}
				});
			}

		});

	});

	//通过名字获取未关联的市场活动列表
	function getNotBindActivityListByName(name) {

		$.ajax({
			url : "workbench/clue/getNotBindActivityListByName",
			data : {
				"clueId" : "${requestScope.clue.id}",
				"name" : $.trim(name)
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
					html += '<td><input name="checkbox-single" value="' + aObj.id + '" type="checkbox"/></td>';
					html += '<td>' + aObj.name + '</td>';
					html += '<td>' + aObj.startDate + '</td>';
					html += '<td>' + aObj.endDate + '</td>';
					html += '<td>' + aObj.owner + '</td>';
					html += '</tr>';
				});
				//给展现未关联市场活动列表的tbody填充数据
				$("#showSearchActivityTBody").html(html);
			}
		});

	}

	//获取未关联的市场活动列表
	function getNotBindActivityListByClueId() {

		$.ajax({
			url : "workbench/clue/getNotBindActivityListByClueId",
			data : {
				"clueId" : "${requestScope.clue.id}"
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
					html += '<td><input name="checkbox-single" value="' + aObj.id + '" type="checkbox"/></td>';
					html += '<td>' + aObj.name + '</td>';
					html += '<td>' + aObj.startDate + '</td>';
					html += '<td>' + aObj.endDate + '</td>';
					html += '<td>' + aObj.owner + '</td>';
					html += '</tr>';
				});
				//给展现未关联市场活动列表的tbody填充数据
				$("#showSearchActivityTBody").html(html);
			}
		});

	}

	//展示与线索关联的市场活动列表
	function getActivityListByClueId() {
		$.ajax({
			url : "workbench/clue/getActivityListByClueId",
			data : {
				"clueId" : "${requestScope.clue.id}"
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				/*
					data
						[{市场活动1},{市场活动2},...]
				 */
				var html = "";
				$.each(data, function (i, aObj) {
					html += '<tr>';
					html += '<td>' + aObj.name + '</td>';
					html += '<td>' + aObj.startDate + '</td>';
					html += '<td>' + aObj.endDate + '</td>';
					html += '<td>' + aObj.owner + '</td>';
					html += '<td><a href="javascript:void(0);" onclick="unBindCarByCarId(\'' + aObj.id + '\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
					html += '</tr>';
				});
				//展示关联的市场活动信息
				$("#showActivityTBody").html(html);
			}
		});

	}

	//carId：关联关系表(tbl_clue_activity_relation)中的id
	function unBindCarByCarId(carId) {

		$.ajax({
			url : "workbench/clue/unBindCarByCarId",
			data : {
				"carId" : carId
			},
			type : "post",
			dataType : "json",
			success : function (data) {
				/*
					{"success":true/false,"errorMsg":错误信息}
				 */
				if (data.success) {
					//刷新与线索关联的市场活动列表
					getActivityListByClueId();
				} else {
					alert(data.errorMsg);
				}
			}
		});

	}

	//获取线索备注信息
	function getClueRemarkList() {

		$.ajax({
			url : "workbench/clue/getClueRemarkList",
			data : {
				"id" : "${requestScope.clue.id}"
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				/*
					data
						{"clueRemarkList":[{"线索备注1"},...]}
				 */
				var html = "";
				$.each(data.clueRemarkList, function (i, obj) {
					/*
                        javascript:void(0);
                            将超链接禁用，只能以触发事件的形式来操作
                     */
					html += '<div id="' + obj.id + '" class="remarkDiv" style="height: 60px;">';
					html += '<img title="zhangsan" src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5 id="h' + obj.id + '">' + obj.noteContent +'</h5>';
					html += '<font color="gray">线索</font> <font color="gray">-</font> <b>${requestScope.clue.fullname}-${requestScope.clue.company}</b> <small style="color: gray;" id="s' + obj.id +'"> ' + (obj.editFlag == 0 ? obj.createTime : obj.editTime) + '由' + (obj.editFlag == 0 ? obj.createBy : obj.editBy) + '</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + obj.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + obj.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
				});
				//在显示文本域的上方追加备注信息
				$("#remarkDiv").before(html);

			}
		});
	}

	function editRemark(id) {

		//从h标签中获取备注内容
		var noteContent = $("#h" + id).html();

		//将线索备注信息的id保存至隐藏域中
		$("#remarkId").val(id);

		//给修改备注信息的文本域填写原来的备注信息
		$("#noteContent").val(noteContent);

		//打开模态窗口
		$("#editRemarkModal").modal("show");

	}

	//删除线索备注
	function deleteRemark(id) {

		if (confirm("你确定要删除该备注吗？")) {

			$.ajax({
				url : "workbench/clue/deleteClueRemark",
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
						//删除成功
						//将删除的备注移除
						$("#"+id).remove();
					} else {
						alert(data.errorMsg);
					}
				}
			});

		}

	}

</script>

</head>
<body>

	<!-- 修改线索备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
	<%-- 备注的id --%>
	<input type="hidden" id="remarkId">
	<div class="modal-dialog" role="document" style="width: 40%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="ActivityRemarkModalLabel">修改备注</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<div class="form-group">
						<label for="edit-description" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="noteContent"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
			</div>
		</div>
	</div>
</div>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="activityNameInput" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input name="checkbox-manager" type="checkbox"/></td>
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
					<button id="bindActivityBtn" type="button" class="btn btn-primary">关联</button>
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
                    <h4 class="modal-title" id="myModalLabel">修改线索</h4>
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
                    <button type="button" class="btn btn-primary" id="updateClueBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.location.href = 'pages/workbench/clue/index.jsp'"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${requestScope.clue.fullname} <small>${requestScope.clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='pages/workbench/clue/convert.jsp';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" class="btn btn-default" id="editClueBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.fullname}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>${requestScope.clue.description}</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>${requestScope.clue.contactSummary}</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>${requestScope.clue.address}</b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveClueRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="showActivityTBody">
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="bindActivity" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>