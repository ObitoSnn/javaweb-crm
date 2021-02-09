<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/base_css_jquery.jsp"%>
    <script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="static/jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet"/>
<meta charset="UTF-8">
<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
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
        //页面加载完毕获取市场活动备注信息
        getActivityRemarkList();
        //使用on操控动态生成的备注的修改和删除按钮
        $("#remarkBody").on("mouseover",".remarkDiv",function(){
            $(this).children("div").children("div").show();
        })
        $("#remarkBody").on("mouseout",".remarkDiv",function(){
            $(this).children("div").children("div").hide();
        })

        //时间控件
        $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd', //显示格式
            autoclose: true,
            todayBtn: true,
            pickerPosition: "bottom-left"
        });

        //给保存市场活动备注按钮绑定单击事件
        $("#saveActivityRemarkBtn").click(function () {
            var noteContent = $.trim($("#remark").val());
            if (noteContent == "") {
                alert("请填写备注信息");
            } else {
                $.ajax({
                    url : "workbench/activity/saveActivityRemark",
                    data : {
                        "noteContent" : $.trim($("#remark").val()),
                        "activityId" : "${requestScope.activity.id}"
                    },
                    type : "post",
                    dataType : "json",
                    success : function (data) {

                        /*
                            data
                                {"success":true/false,"activityRemark":{市场活动备注}}
                         */
                        if (data.success) {
                            var html = "";
                            html += '<div id="' + data.activityRemark.id + '" class="remarkDiv" style="height: 60px;">';
                            html += '<img title="zhangsan" src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 id="h' + data.activityRemark.id + '">' + data.activityRemark.noteContent +'</h5>';
                            html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${requestScope.activity.name}</b> <small style="color: gray;" id="s' + data.activityRemark.id +'"> ' + data.activityRemark.createTime + '由' + data.activityRemark.createBy + '</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\'' + data.activityRemark.id + '\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\'' + data.activityRemark.id + '\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
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
            }

        });

        //给更新按钮绑定单击事件
        $("#updateRemarkBtn").click(function () {

            //从隐藏域中获取备注信息的id
            var id = $("#remarkId").val();

            $.ajax({
                url : "workbench/activity/updateActivityRemark",
                data : {
                    "id" : id,
                    "noteContent" : $.trim($("#noteContent").val())
                },
                type : "post",
                dataType : "json",
                success : function (data) {
                    /*
                        data
                            {"success":true/false,"activityRemark":{市场活动备注},"errorMsg":错误信息}
                     */
                    if (data.success) {
                        //修改成功
                        //修改h标签内容
                        $("#h" + id).html(data.activityRemark.noteContent);
                        //修改small标签内容
                        $("#s" + id).html(data.activityRemark.editTime + '由' + data.activityRemark.editBy);
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
        $("#editActivityBtn").click(function () {
            //获取市场活动id
            var id = "${requestScope.activity.id}";

            $.ajax({
                url : "workbench/activity/getUserListAndActivity",
                data : {
                    "id" : id
                },
                type : "get",
                dataType : "json",
                success : function (data) {
                    /*
                        data
                            {"uList":[{用户1},{用户2},...],"activity":"{市场活动}"}
                     */

                    var html = "";

                    $.each(data.uList, function (i, userObj) {
                        html += "<option value='" + userObj.id + "'>" + userObj.name + "</option>";
                    });
                    //填写下拉框信息
                    $("#edit-owner").html(html);

                    $("#edit-owner").val(data.activity.owner);
                    $("#edit-name").val(data.activity.name);
                    $("#edit-startDate").val(data.activity.startDate);
                    $("#edit-endDate").val(data.activity.endDate);
                    $("#edit-cost").val(data.activity.cost);
                    $("#edit-description").val(data.activity.description);


                }
            });
            //打开修改市场信息模态窗口
            $("#editActivityModal").modal("show");
        });

        //给更新市场活动按钮绑定单击事件
        $("#updateActivity").click(function () {

            var inputOwnerText = $.trim($("#edit-owner").val());
            var inputNameText = $.trim($("#edit-name").val());
            var inputStartDateText = $.trim($("#edit-startDate").val());
            var inputEndDateText = $.trim($("#edit-endDate").val());
            var inputCostText = $.trim($("#edit-cost").val());
            var inputDescriptionText = $.trim($("#edit-description").val());

            //检验文本框内容，不能为空
            if (inputOwnerText == "" || inputNameText == "" ||
                inputStartDateText == "" || inputStartDateText == "" ||
                inputEndDateText == "" || inputCostText == "" ||
                inputDescriptionText == "") {
                alert("请填写相关信息");
            } else {
                //获取市场活动id
                var id = "${requestScope.activity.id}";
                $.ajax({
                    url : "workbench/activity/updateActivity",
                    data : {
                        "id" : id,
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

                            //向服务器发起请求，刷新市场活动详情页面
                            location.href = "workbench/activity/getActivityDetail?id=${requestScope.activity.id}";

                        } else {
                            //更新失败后相关的操作
                            alert(data.errorMsg);
                        }
                    }
                });
            }

        });

        //给删除市场活动按钮绑定单击事件
        $("#deleteActivityBtn").click(function () {

            if (confirm("你确定要删除所选信息吗？")) {
                $.ajax({
                    url : "workbench/activity/deleteActivity",
                    data : {
                        "id" : "${requestScope.activity.id}"
                    },
                    type : "post",
                    dataType : "json",
                    success : function (data) {
                        if (data.success) {
                            location.href = "pages/workbench/activity/index.jsp";
                        } else {
                            alert(data.errorMsg);
                        }
                    }
                });
            }

        });

	});
	//获取市场活动备注信息
	function getActivityRemarkList() {

		$.ajax({
			url : "workbench/activity/getActivityRemarkList",
			data : {
				"id" : "${requestScope.activity.id}"
			},
			type : "get",
			dataType : "json",
			success : function (data) {
				/*
					data
						{"activityRemarkList":[{"市场活动备注1"},...]}
				 */
				var html = "";
				$.each(data.activityRemarkList, function (i, obj) {
				    /*
				        javascript:void(0);
				            将超链接禁用，只能以触发事件的形式来操作
				     */
					html += '<div id="' + obj.id + '" class="remarkDiv" style="height: 60px;">';
					html += '<img title="zhangsan" src="static/image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html += '<div style="position: relative; top: -40px; left: 40px;" >';
					html += '<h5 id="h' + obj.id + '">' + obj.noteContent +'</h5>';
					html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${requestScope.activity.name}</b> <small style="color: gray;" id="s' + obj.id +'"> ' + (obj.editFlag == 0 ? obj.createTime : obj.editTime) + '由' + (obj.editFlag == 0 ? obj.createBy : obj.editBy) + '</small>';
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

	function deleteRemark(id) {

        if (confirm("你确定要删除该备注吗？")) {

           $.ajax({
                url : "workbench/activity/deleteActivityRemark",
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

        //将市场活动备注信息的id保存至隐藏域中
        $("#remarkId").val(id);

        //给修改备注信息的文本域填写原来的备注信息
        $("#noteContent").val(noteContent);

        //打开模态窗口
        $("#editRemarkModal").modal("show");

    }

</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
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

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="ActivityModalLabel">修改市场活动</h4>
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
                                <textarea class="form-control" rows="3" id="edit-description"></textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="updateActivity" type="button" class="btn btn-primary">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.location.href = 'pages/workbench/activity/index.jsp';"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-${requestScope.activity.name} <small>${requestScope.activity.startDate} ~ ${requestScope.activity.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button id="editActivityBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button id="deleteActivityBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>${requestScope.activity.description}</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveActivityRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>