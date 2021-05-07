<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<%@ include file="../../../common/base_css_jquery.jsp"%>
<link href="static/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript">

		$(function () {

			getDicTypeDetailByCode("${param.code}");

		});

		function getDicTypeDetailByCode(code) {

			$.ajax({
				url : "settings/dictionary/getDicTypeDetailByCode",
				data : {
					"code" : code
				},
				type : "get",
				dataType : "json",
				success : function (data) {
					// {字典类型}
					$("#edit-code").val(data.code);
					$("#edit-name").val(data.name);
					$("#edit-description").val(data.description);
				}
			});

		}

		function updateDicType() {

			$.ajax({
				url : "settings/dictionary/updateDicType",
				data : {
					"code" : "${param.code}",
					"name" : $.trim($("#edit-name").val()),
					"description" : $.trim($("#edit-description").val())
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
		<h3>修改字典类型</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" onclick="updateDicType()" class="btn btn-primary">更新</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="edit-code" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-code" style="width: 200%;" placeholder="编码作为主键，不能是中文" value="sex">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-name" class="col-sm-2 control-label">名称</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name" style="width: 200%;" value="性别">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 300px;">
				<textarea class="form-control" rows="3" id="edit-description" style="width: 200%;">描述信息</textarea>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>