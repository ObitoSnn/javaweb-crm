<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../../common/base_css_jquery.jsp"%>
<meta charset="UTF-8">
	<script type="text/javascript">

		$(function () {

			getDicTypeCode();

		});

		function getDicTypeCode() {

			$.ajax({
				url : "settings/dictionary/getDicTypeCode",
				type : "get",
				dataType : "json",
				success : function (data) {
					// [{"code":字典类型编码,"name":字典类型编码名},...]
					var html = "<option></option>"
					$.each(data, function (i, obj) {
						html += "<option value='" + obj.code + "'>" + obj.name + "</option>"
					});
					$("#create-typeCode").html(html);
				}
			});

		}

		function saveDicValue() {

			var typeCode = $("#create-typeCode").val();
			var value = $.trim($("#create-value").val());
			var orderNo = $.trim($("#create-orderNo").val());
			var text = $.trim($("#create-text").val());
			if (typeCode == "" || value == "") {
				alert("请填写两项基本信息");
			} else {
				$.ajax({
					url : "settings/dictionary/saveDicValue",
					data : {
						"value" : value,
						"text" : text,
						"orderNo" : orderNo,
						"typeCode" : typeCode
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

		}
		
	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>新增字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" onclick="saveDicValue()" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="create-typeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-typeCode" style="width: 200%;">
				</select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-value" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-value" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-text" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-orderNo" style="width: 200%;">
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>