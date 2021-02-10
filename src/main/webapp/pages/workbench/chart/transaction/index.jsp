<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <%@ include file="../../../common/base_css_jquery.jsp"%>
    <script type="text/javascript" src="static/echarts/echarts.min.js"></script>
    <script type="text/javascript">

        $(function () {

            getCharts();

        })

        function getCharts() {

            $.ajax({
                url : "workbench/transaction/getCharts",
                type : "get",
                dataType : "json",
                success : function (data) {
                    /*
                        data
                            [{value: xxx, name: 'xxx'},{},...]
                     */
                    // 基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));

                    // 指定图表的配置项和数据
                    var option = {
                        backgroundColor: '#FFFFFF',

                        title: {
                            text: '交易阶段统计图',
                            left: 'center',
                            top: 20,
                            textStyle: {
                                color: '#ccc'
                            }
                        },
                        tooltip: {
                            trigger: 'item'
                        },
                        series: [
                            {
                                name: '交易阶段',
                                type: 'pie',
                                radius: '55%',
                                center: ['50%', '50%'],
                                data : data.sort(function (a, b) { return a.value - b.value; }),
                                roseType: 'radius',
                                label: {
                                    color: '#2c343c'
                                },
                                labelLine: {
                                    lineStyle: {
                                        color: '#2c343c'
                                    },
                                    smooth: 0.2,
                                    length: 10,
                                    length2: 20
                                },
                                itemStyle: {
                                    color: '#c23531',
                                    shadowBlur: 200,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                },

                                animationType: 'scale',
                                animationEasing: 'elasticOut',
                                animationDelay: function (idx) {
                                    return Math.random() * 200;
                                }
                            }
                        ]
                    };

                    console.log(data);

                    // 使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);

                }
            });

        }

    </script>
</head>
<body>

    <!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
    <div id="main" style="width: 100%; height: 100%;"></div>

</body>
</html>