<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	Map<String, String> pMap = (Map<String, String>) application.getAttribute("possibility");
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/base_css_jquery.jsp"%>
<meta charset="UTF-8">

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	

<script type="text/javascript">

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

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){

		var stage = "${requestScope.tran.stage}";
		var possibility = json[stage];
		//给可能性文本框赋值
		$("#possibility").html(possibility);

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
		
		
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });

		//页面加载完毕获取交易备注信息
		getTranRemarkList();
		//使用on操控动态生成的备注的修改和删除按钮
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		//页面加载完毕显示交易历史列表
		showTranHistoryList();

		//给保存交易备注按钮绑定单击事件，保存交易备注
		$("#saveTranRemarkBtn").click(function () {

			$.ajax({
				url : "workbench/transaction/saveTranRemark",
				data : {
					"noteContent" : $.trim($("#remark").val()),
					"tranId" : "${requestScope.tran.id}"
				},
				type : "post",
				dataType : "json",
				success : function (data) {

					/*
                        data
                            {"success":true/false,"tranRemark":{线索备注}}
                     */
					if (data.success) {
						var html = "";
						html += '<div id="' + data.tranRemark.id + '" class="remarkDiv" style="height: 60px;">';
						html += '<img src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						html += '<h5 id="h' + data.tranRemark.id + '">' + data.tranRemark.noteContent +'</h5>';
						html += '<font color="gray">交易</font> <font color="gray">-</font> <b>${requestScope.tran.customerId}-${requestScope.tran.name}</b> <small style="color: gray;" id="s' + data.tranRemark.id +'"> ' + data.tranRemark.createTime + '由' + data.tranRemark.createBy + '</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.tranRemark.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + data.tranRemark.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
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
				url : "workbench/transaction/updateTranRemark",
				data : {
					"id" : id,
					"noteContent" : $.trim($("#noteContent").val())
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					/*
                        data
                            {"success":true/false,"tranRemark":{交易备注},"errorMsg":错误信息}
                     */
					if (data.success) {
						//修改成功
						//修改h标签内容
						$("#h" + id).html(data.tranRemark.noteContent);
						//修改small标签内容
						$("#s" + id).html(data.tranRemark.editTime + '由' + data.tranRemark.editBy);
						//关闭模态窗口
						$("#editRemarkModal").modal("hide");
					} else {
						//修改失败
						alert(data.errorMsg);
					}
				}
			});

		});


	});

	function showTranHistoryList() {
		$.ajax({
			url : "workbench/transaction/getTranHistoryListByTranId",
			data : {
				"tranId" : "${requestScope.tran.id}"
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				/*
					data
						[{交易历史},...]
				 */
				var html = "";
				$.each(data, function (i, obj) {
					html += '<tr>';
					html += '<td>'+ obj.stage + '</td>';
					html += '<td>'+ obj.money + '</td>';
					html += '<td>' + json[obj.stage] + '</td>';
					html += '<td>'+ obj.expectedDate + '</td>';
					html += '<td>'+ obj.createTime + '</td>';
					html += '<td>'+ obj.createBy + '</td>';
					html += '</tr>';
				});
				$("#showTranHistoryTBody").html(html);
			}
		});

	}

	//获取交易备注信息
	function getTranRemarkList() {

		$.ajax({
			url : "workbench/transaction/getTranRemarkList",
			data : {
				"id" : "${requestScope.tran.id}"
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				/*
					data
						{"tranRemarkList":[{"交易备注1"},...]}
				 */
				var html = "";
				$.each(data.tranRemarkList, function (i, obj) {
					/*
                        javascript:void(0);
                            将超链接禁用，只能以触发事件的形式来操作
                     */
					html += '<div id="' + obj.id + '" class="remarkDiv" style="height: 60px;">';
					html += '<img src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5 id="h' + obj.id + '">' + obj.noteContent +'</h5>';
					html += '<font color="gray">交易</font> <font color="gray">-</font> <b>${requestScope.tran.customerId}-${requestScope.tran.name}</b> <small style="color: gray;" id="s' + obj.id +'"> ' + (obj.editFlag == 0 ? obj.createTime : obj.editTime) + '由' + (obj.editFlag == 0 ? obj.createBy : obj.editBy) + '</small>';
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

	//删除交易备注
	function deleteRemark(id) {

		if (confirm("你确定要删除该备注吗？")) {

			$.ajax({
				url : "workbench/transaction/deleteTranRemark",
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

	function editRemark(id) {

		//从h标签中获取备注内容
		var noteContent = $("#h" + id).html();

		//将交易备注信息的id保存至隐藏域中
		$("#remarkId").val(id);

		//给修改备注信息的文本域填写原来的备注信息
		$("#noteContent").val(noteContent);

		//打开模态窗口
		$("#editRemarkModal").modal("show");

	}

	function edit() {

		window.location.href="pages/workbench/transaction/edit.jsp?id=${requestScope.tran.id}";

	}

</script>

</head>
<body>

	<!-- 修改交易备注的模态窗口 -->
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${requestScope.tran.customerId}-${requestScope.tran.name} <small>￥${requestScope.tran.money}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="edit()"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-----------
		<span class="closingDate">${requestScope.tran.expectedDate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.owner}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.money}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.name}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.expectedDate}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.customerId}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.stage}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.type}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.source}&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.activityId}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.contactsId}&nbsp;</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.tran.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.tran.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.tran.description}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.tran.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveTranRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="showTranHistoryTBody">
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>