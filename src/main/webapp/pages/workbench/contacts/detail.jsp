<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	Map<String, String> pMap = (Map<String, String>) application.getAttribute("possibility");
	Set<String> keySet = pMap.keySet();
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/base_css_jquery.jsp"%>
	<script type="text/javascript" src="static/jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<meta charset="UTF-8">
<script type="text/javascript">

	//阶段和可能性对应关系的json串
	var possibilityJson = {
		<%
            for (String key : keySet) {
                String value = pMap.get(key);
        %>
		"<%=key%>" : <%=value%>,
		<%
            }
        %>
	};

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		$("#activityName").typeahead({
			source: function (query, process) {
				$.get(
					"workbench/contacts/getActivityName",
					{ "name" : query },
					function (data) {
						//alert(data);
						/*
							data
								[{"市场活动名",...}]
						 */
						process(data);
					},
					"json"
				);
			},
			delay: 1500
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

		//页面加载完毕获取联系人备注信息
		getContactsRemarkList();
		//使用on操控动态生成的备注的修改和删除按钮
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		});
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		});

		window.onpageshow = function (event) {
			if (event.persisted || window.performance &&
					window.performance.navigation.type == 2) {
				window.location.reload();
			}
		}

		//页面加载完毕，显示交易列表
		getTranList();

		//页面加载完毕，显示与联系人关联的市场活动列表
		getActivityListByContactsId();

		//复选框绑定单击事件
		$("input[name='checkbox-manager']").click(function () {

			$("input[name='checkbox-single']").prop("checked", this.checked);

		});

		//给每条记录的复选框绑定单击事件
		$("#showSearchActivityTBody").on("click", $("input[name='checkbox-single']"), function () {

			$("input[name='checkbox-manager']").prop("checked", $("input[name='checkbox-single']").length == $("input[name='checkbox-single']:checked").length);

		});

		//给关联市场活动的模态窗口中的文本框绑定keydown事件
		$("#activityName").keydown(function (event) {
			var name = $.trim($("#activityName").val());
			if (event.keyCode == 13) {
				getNotBindActivityListByContactsIdAndName(name);
				//阻止模态窗口键入回车键刷新页面的默认行为
				return false;
			}
		});

	});

	function getContactsRemarkList() {

		$.ajax({
			url : "workbench/contacts/getContactsRemarkList",
			data : {
				"id" : "${requestScope.contacts.id}"
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				// [{"交易备注1"},...]
				var html = "";
				$.each(data, function (i, obj) {
					html += '<div id="' + obj.id + '" class="remarkDiv" style="height: 60px;">';
					html += '<img src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5 id="h' + obj.id + '">' + obj.noteContent + '</h5>';
					html += '<font color="gray">联系人</font> <font color="gray">-</font> <b>${requestScope.contacts.fullname}${requestScope.contacts.appellation}-${requestScope.contacts.customerId}</b> <small style="color: gray;" id="s' + obj.id + '"> ' + (obj.editFlag == 0 ? obj.createTime : obj.editTime) +' 由' + (obj.editFlag == 0 ? obj.createBy : obj.editBy) + '</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + obj.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + obj.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
				});
				$("#remarkDiv").before(html);
			}
		});

	}

	function saveContactsRemark() {

		$.ajax({
			url : "workbench/contacts/saveContactsRemark",
			data : {
				"noteContent" : $.trim($("#remark").val()),
				"contactsId" : "${requestScope.contacts.id}"
			},
			type : "post",
			dataType : "json",
			success : function (data) {
				// {"success":true/false,"contactsRemark":{线索备注},"errorMsg":错误信息}
				if (data.success) {
					var html = "";
					html += '<div id="' + data.contactsRemark.id + '" class="remarkDiv" style="height: 60px;">';
					html += '<img src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5 id="h' + data.contactsRemark.id + '">' + data.contactsRemark.noteContent + '</h5>';
					html += '<font color="gray">联系人</font> <font color="gray">-</font> <b>${requestScope.contacts.fullname}${requestScope.contacts.appellation}-${requestScope.contacts.customerId}</b> <small style="color: gray;" id="s' + data.contactsRemark.id + '"> ' + (data.contactsRemark.editFlag == 0 ? data.contactsRemark.createTime : data.contactsRemark.editTime) +' 由' + (data.contactsRemark.editFlag == 0 ? data.contactsRemark.createBy : data.contactsRemark.editBy) + '</small>';
					html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.contactsRemark.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '&nbsp;&nbsp;&nbsp;&nbsp;';
					html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + data.contactsRemark.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
					html += '</div>';
					html += '</div>';
					html += '</div>';
					$("#remarkDiv").before(html);
					$("#remark").val("");
				} else {
					alert(data.errorMsg);
				}
			}
		});

	}

	function deleteRemark(id) {

		$.ajax({
			url : "workbench/contacts/deleteContactsRemark",
			data : {
				"id" : id
			},
			type : "post",
			dataType : "json",
			success : function (data) {
				// {"success":true/false,"errorMsg":错误信息}
				if (data.success) {
					$("#" + id).remove();
				} else {
					alert(data.errorMsg);
				}
			}
		});

	}

	function editRemark(id) {

		$("#remarkId").val(id);
		$("#noteContent").val($.trim($("#h" + id).html()));
		$("#editRemarkModal").modal("show");

	}

	function updateContactsRemark() {

		var id = $("#remarkId").val();
		$.ajax({
			url : "workbench/contacts/updateContactsRemark",
			data : {
				"id" : id,
				"noteContent" : $("#noteContent").val()
			},
			type : "post",
			dataType : "json",
			success : function (data) {
				// {"success":true/false,"contactsRemark":{联系人备注},"errorMsg":错误信息}
				if (data.success) {
					//修改h标签内容
					$("#h" + id).html(data.contactsRemark.noteContent);
					//修改small标签内容
					$("#s" + id).html(data.contactsRemark.editTime + '由' + data.contactsRemark.editBy);
					//关闭模态窗口
					$("#editRemarkModal").modal("hide");
				} else {
					alert(data.errorMsg);
				}
			}
		});

	}

	function getTranList() {

		$.ajax({
			url : "workbench/contacts/getTranListByContactsId",
			data : {
				"contactsId" : "${requestScope.contacts.id}"
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				// [{交易},...]
				var html = "";
				$.each(data, function (i, obj) {
					var type = obj.type;
					if (type == null || type == "") {
						type = "";
					}
					var stage = obj.stage;
					var possibility = possibilityJson[stage];
					if (stage == null || stage == "") {
						possibility = "";
					}
					html += '<tr>';
					html += '<td><a href="workbench/transaction/detail?id=' + obj.id + '" style="text-decoration: none;">' + obj.name + '</a></td>';
					html += '<td>' + obj.money + '</td>';
					html += '<td>' + stage + '</td>';
					html += '<td>' + possibility + '</td>';
					html += '<td>' + obj.expectedDate + '</td>';
					html += '<td>' + type + '</td>';
					html += '<td><a href="javascript:void(0);" onclick="openRemoveTransactionModal(\'' + obj.id + '\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>';
					html += '</tr>';
				});
				$("#showTranTBody").html(html);
			}
		});

	}

	function openRemoveTransactionModal(id) {

		//给隐藏域赋id值
		$("#tranId").val(id);
		$("#removeTransactionModal").modal("show");

	}

	function addTran() {

		window.location.href = "workbench/transaction/add?intent=getContactsFullname&contactsId=${requestScope.contacts.id}";

	}

	function deleteTran() {

		var id = $("#tranId").val();
		$.ajax({
			url : "workbench/contacts/deleteTran",
			data : {
				"id" : id
			},
			type : "post",
			dataType : "json",
			success : function (data) {
				// {"success":true/false,"errorMsg":错误信息}
				if (data.success) {
					getTranList();
					$("#removeTransactionModal").modal("hide");
				} else {
					alert(data.errorMsg);
				}
			}
		});

	}

	function getActivityListByContactsId() {

		$.ajax({
			url : "workbench/contacts/getActivityListByContactsId",
			data : {
				"contactsId" : "${requestScope.contacts.id}"
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				// [{市场活动},...]
				var html = "";
				$.each(data, function (i, obj) {
					html += '<tr>';
					html += '<td><a href="workbench/activity/getActivityDetail?id=' + obj.id + '" style="text-decoration: none;">' + obj.name + '</a></td>';
					html += '<td>' + obj.startDate + '</td>';
					html += '<td>' + obj.endDate + '</td>';
					html += '<td>' + obj.owner + '</td>';
					html += '<td><a href="javascript:void(0);" onclick="unBindCarByActivityIdAndContactsId(\'' + obj.id + '\',\'${requestScope.contacts.id}\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
					html += '</tr>';
				});
				$("#showActivityTBody").html(html);
			}
		});

	}

	//打开关联市场活动的模态窗口
	function openBundActivityModal() {

		//清空文本框内容
		$("#activityName").val("");
		//取消总复选框的选中状态
		$("input[name='checkbox-manager']").prop("checked", false);
		$("#bundActivityModal").modal("show");
		//获取未关联的市场活动列表
		getNotBindActivityListByContactsId();

	}

	//获取未关联的市场活动列表
	function getNotBindActivityListByContactsId() {

		$.ajax({
			url : "workbench/contacts/getNotBindActivityListByContactsId",
			data : {
				"contactsId" : "${requestScope.contacts.id}"
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				// [{市场活动},...]
				var html = "";
				$.each(data, function (i, obj) {
					html += '<tr>';
					html += '<td><input name="checkbox-single" value="' + obj.id + '" type="checkbox"/></td>';
					html += '<td>' + obj.name + '</td>';
					html += '<td>' + obj.startDate + '</td>';
					html += '<td>' + obj.endDate + '</td>';
					html += '<td>' + obj.owner + '</td>';
					html += '</tr>';
				});
				$("#showSearchActivityTBody").html(html);
			}
		});

	}

	//通过名字获取未关联的市场活动列表
	function getNotBindActivityListByContactsIdAndName(name) {

		//取消总复选框的选中状态
		$("input[name='checkbox-manager']").prop("checked", false);
		$.ajax({
			url : "workbench/contacts/getNotBindActivityListByContactsIdAndName",
			data : {
				"contactsId" : "${requestScope.contacts.id}",
				"name" : $.trim(name)
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				//	data [{市场活动1},...]
				var html = "";
				$.each(data, function (i, obj) {
					html += '<tr>';
					html += '<td><input name="checkbox-single" value="' + obj.id + '" type="checkbox"/></td>';
					html += '<td>' + obj.name + '</td>';
					html += '<td>' + obj.startDate + '</td>';
					html += '<td>' + obj.endDate + '</td>';
					html += '<td>' + obj.owner + '</td>';
					html += '</tr>';
				});
				$("#showSearchActivityTBody").html(html);
			}
		});

	}

	//关联市场活动
	function bindActivityByContactsIdAndActivityIds() {

		var $checkbox = $("input[name='checkbox-single']:checked");
		var param = "contactsId=${requestScope.contacts.id}&";
		for (var i = 0; i < $checkbox.length; i++) {
			param += "aid=" + $($checkbox[i]).val();
			if (i < $checkbox.length - 1) {
				param += "&";
			}
		}
		$.ajax({
			url : "workbench/contacts/bindActivityByContactsIdAndActivityIds",
			data : param,
			type : "post",
			dataType : "json",
			success : function (data) {
				// {"success":true/false,"errorMsg":错误信息}
				if (data.success) {
					getActivityListByContactsId();
					getNotBindActivityListByContactsIdAndName($.trim($("#activityName").val()));
				} else {
					alert(data.errorMsg);
				}
			}
		});

	}

	//解除与联系人关联的市场活动
	function unBindCarByActivityIdAndContactsId(activityId, contactsId) {

		$.ajax({
			url : "workbench/contacts/unBindCarByActivityIdAndContactsId",
			data : {
				"activityId" : activityId,
				"contactsId" : contactsId
			},
			type : "post",
			dataType : "json",
			success : function (data) {
				// {"success":true/false,"errorMsg":错误信息}
				if (data.success) {
					getActivityListByContactsId();
				} else {
					alert(data.errorMsg);
				}
			}
		});

	}

	function openEditContactsModal(id) {

		$.ajax({
			url : "workbench/contacts/getUserListAndContactsById",
			data : {
				"contactsId" : id
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				// {"uList":[{用户},...],"contacts":{联系人}}
				var html = "";
				$.each(data.uList, function (i, obj) {
					if ("root" == obj.loginAct) {
						return true;
					}
					html += "<option value='" + obj.id + "'>" + obj.name +"</option>";
				});
				$("#edit-owner").html(html);

				$("#edit-owner").val(data.contacts.owner);
				$("#edit-source").val(data.contacts.source);
				$("#edit-fullname").val(data.contacts.fullname);
				$("#edit-appellation").val(data.contacts.appellation);
				$("#edit-job").val(data.contacts.job);
				$("#edit-mphone").val(data.contacts.mphone);
				$("#edit-email").val(data.contacts.email);
				$("#edit-birth").val(data.contacts.birth);
				$("#edit-customerId").val(data.contacts.customerId);
				$("#edit-description").val(data.contacts.description);
				$("#edit-contactSummary").val(data.contacts.contactSummary);
				$("#edit-nextContactTime").val(data.contacts.nextContactTime);
				$("#edit-address").val(data.contacts.address);
				$("#editContactsModal").modal("show");
			}
		});

	}

	function updateContacts() {

		//获取客户id
		var contactsId = "${requestScope.contacts.id}";
		$.ajax({
			url : "workbench/contacts/updateContacts",
			data : {
				"id" : contactsId,
				"owner" : $("#edit-owner").val(),
				"source" : $("#edit-source").val(),
				"fullname" : $("#edit-fullname").val(),
				"appellation" : $("#edit-appellation").val(),
				"job" : $("#edit-job").val(),
				"mphone" : $("#edit-mphone").val(),
				"email" : $("#edit-email").val(),
				"birth" : $("#edit-birth").val(),
				"customerId" : $("#edit-customerId").val(),
				"description" : $("#edit-description").val(),
				"contactSummary" : $("#edit-contactSummary").val(),
				"nextContactTime" : $("#edit-nextContactTime").val(),
				"address" : $("#edit-address").val()
			},
			type : "post",
			dataType : "json",
			success : function (data) {
				// {"success":true/false,"errorMsg":错误信息}
				if (data.success) {
					//关闭修改客户的模态窗口
					window.location.href = "workbench/contacts/detail?id=${requestScope.contacts.id}";
				} else {
					alert(data.errorMsg);
				}
			}
		});

	}

	function deleteContacts(id) {

		if (confirm("您确定要删除该联系人吗？")) {
			$.ajax({
				url : "workbench/contacts/deleteContacts",
				data : {
					"id" : id
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					// {"success":true/false,"errorMsg":错误信息}
					if (data.success) {
						window.location.href = "pages/workbench/contacts/index.jsp";
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

	<!-- 删除交易的模态窗口 -->
	<div class="modal fade" id="removeTransactionModal" role="dialog">
		<input type="hidden" id="tranId">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除交易</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除该交易吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button onclick="deleteTran()" type="button" class="btn btn-danger">删除</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改联系人备注的模态窗口 -->
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
							<label for="noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" onclick="updateContactsRemark()">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 解除联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="unbundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">解除关联</h4>
				</div>
				<div class="modal-body">
					<p>您确定要解除该关联关系吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" data-dismiss="modal">解除</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="bundActivityModal" role="dialog">
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
						    <input type="text" id="activityName" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable2" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
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
					<button type="button" onclick="bindActivityByContactsIdAndActivityIds()" class="btn btn-primary">关联</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								</select>
							</div>
							<label for="edit-source" class="col-sm-2 control-label">来源</label>
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
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${applicationScope.appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerId" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerId" placeholder="支持自动补全，输入客户不存在则新建">
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
									<input type="text" class="form-control" id="edit-nextContactTime">
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
					<button type="button" class="btn btn-primary" onclick="updateContacts()">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${requestScope.contacts.fullname}${requestScope.contacts.appellation} <small> - ${requestScope.contacts.customerId}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="openEditContactsModal('${requestScope.contacts.id}')"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" onclick="deleteContacts('${requestScope.contacts.id}')"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${requestScope.contacts.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${requestScope.contacts.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${requestScope.contacts.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${requestScope.contacts.fullname}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${requestScope.contacts.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${requestScope.contacts.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${requestScope.contacts.job}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>&nbsp;${requestScope.contacts.birth}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.contacts.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.contacts.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.contacts.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.contacts.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${requestScope.contacts.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${requestScope.contacts.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${requestScope.contacts.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    &nbsp;${requestScope.contacts.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 20px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" onclick="saveContactsRemark()">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable3" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="showTranTBody">
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0)" onclick="addTran()" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
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
				<a href="javascript:void(0);" onclick="openBundActivityModal()" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>