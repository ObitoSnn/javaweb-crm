<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="pages/common/base_css_jquery.jsp"%>
    <title>Title</title>
    <script type="text/javascript">
        $(function () {
            $.ajax({
                url : "",
                data : {

                },
                type : "get/post",//二选一
                dataType : "json",
                success : function (data) {

                }
            });
        });
    </script>
</head>
<body>

</body>
</html>
