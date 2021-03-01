引用BootStrap分页插件bs_pagination：
* 添加css文件和js文件（注意：在添加插件js文件之前要确保添加了bootstrap本体js文件）

```jsp
<link href="static/jquery/bs_pagination/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="static/jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="static/jquery/bs_pagination/en.js"></script>

    $("#xxx").bs_pagination({
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
```

页面数据更新后，在哪一页还回到哪一页
关键代码

```jsp
pageList($("#xxx").bs_pagination('getOption', 'currentPage')
    ,$("#xxx").bs_pagination('getOption', 'rowsPerPage'));
    
    //$("#xxx").bs_pagination('getOption', 'currentPage')：操作后停留在当前页
    //$("#xxx").bs_pagination('getOption', 'rowsPerPage')：操作后维持已经设置好的每页展现记录数
```