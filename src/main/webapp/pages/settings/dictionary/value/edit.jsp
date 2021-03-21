<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../../common/base_css_jquery.jsp"%>
<meta charset="UTF-8">
	<script type="text/javascript">

		$(function () {

			getDicValueDetailById("${param.id}");
			getDicValueTypeCodeById("${param.id}");

		});

		function getDicValueDetailById(id) {

			$.ajax({
				url : "settings/dictionary/getDicValueDetailById",
				data : {
					"id" : id
				},
				type : "get",
				dataType : "json",
				success : function (data) {
					// {字典值}
					$("#edit-value").val(data.value);
					$("#edit-text").val(data.text);
					$("#edit-orderNo").val(data.orderNo);
					$("#edit-typeCode").val(data.typeCode);
				}
			});
			
		}

		function getDicValueTypeCodeById(id) {

			$.ajax({
				url : "settings/dictionary/getDicValueTypeCodeById",
				data : {
					"id" : id
				},
				type : "get",
				dataType : "text",
				success : function (data) {
					// typeCode
					$("#hidden-typeCode").val(data);
				}
			});

		}

		function updateDicValue() {

			$.ajax({
				url : "settings/dictionary/updateDicValue",
				data : {
					"id" : "${param.id}",
					"value" : $.trim($("#edit-value").val()),
					"text" : $.trim($("#edit-text").val()),
					"orderNo" : $.trim($("#edit-orderNo").val()),
					"typeCode" : $.trim($("#hidden-typeCode").val()),
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					// {"success":true/false,"errorMsg":错误信息}
					if (data.success) {
						window.history.back();
					} else {
						alert(data.errorMsg);
					}
				}
			});

		}

	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>修改字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" onclick="updateDicValue()" class="btn btn-primary">更新</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
		<div class="form-group">
			<label for="edit-typeCode" class="col-sm-2 control-label">字典类型编码</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-typeCode" style="width: 200%;" readonly>
				<input type="hidden" id="hidden-typeCode"/>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-value" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-value" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-text" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-orderNo" style="width: 200%;">
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>