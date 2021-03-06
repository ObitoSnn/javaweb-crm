# javaweb-crm

整合ssm的web项目

<p>
  <a target="_blank" href="mailto:obitosnn@163.com">
    <img src="https://img-blog.csdnimg.cn/202103221907093.png" title="联系我"/>
  </a>
</p>

# 项目模块与主要功能

* 系统设置模块 setting
  * 用户模块：登录操作、登出操作、修改密码
  * 部门模块：分页显示、添加操作、修改操作、删除操作(可以批量删除)
  * 权限管理模块：分页显示(支持查询)、添加操作、删除操作
  * 数字字典模块
    * 字典类型：分页显示、添加操作、修改操作、删除操作
    * 字典值：分页显示、添加操作、修改操作、删除操作
* 工作台(核心业务) workbench
  * 市场活动模块
  * 线索模块：显示与线索相关联的市场活动列表、关联市场活动、解除关联的市场活动、转换线索操作
  * 客户模块：显示与客户相关的交易列表、新建交易、删除交易、显示与客户相关的联系人列表、新建联系人、删除联系人
  * 联系人模块：显示与联系人相关的交易列表、新建交易、删除交易、显示与联系人相关联的市场活动、关联市场活动、解除关联的市场活动
  * 交易模块：显示阶段图标、点击阶段图标修改阶段、显示阶段历史列表
  * 统计图表模块：使用ECharts显示交易统计图表
* 补充
  * 管理员账号：`root`，<font color=red>**管理员账号**</font>与<font color=red>**测试用户账号**</font>的密码均为`123`
  * 工作台下的所有模块，窗口中对于下拉框的处理由服务器缓存中的数据字典来填充
  * 除了统计图表模块，其余所有模块均有分页显示(支持查询)、添加操作、修改操作、删除操作(可以批量删除)、显示详情页(详情页均有修改和删除功能)、详情页显示备注消息列表功能

# 开发环境

* JDK版本：1.8
* 服务器：Tomcat-8.0.50
* 数据库管理系统：MySQL-5.5.36
* 项目构建工具：maven-3.3.9

# 应用截图

<table>
  <tr>
    <td><img src="https://img-blog.csdnimg.cn/20210323205150455.gif"/></td>
  </tr>
  <tr>
    <td><img src="https://img-blog.csdnimg.cn/20210323205835351.gif"/></td>
  </tr>
  <tr>
    <td><img src="https://img-blog.csdnimg.cn/20210323210508191.gif"/></td>
  </tr>
</table>