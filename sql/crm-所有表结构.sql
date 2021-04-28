drop table if exists tbl_activity;

drop table if exists tbl_activity_remark;

/*==============================================================*/
/* Table: tbl_activity                                          */
/*==============================================================*/
create table tbl_activity
(
    id                   char(32) not null,
    owner                char(32),
    name                 varchar(255),
    startDate            char(10),
    endDate              char(10),
    cost                 varchar(255),
    description          varchar(255),
    createTime           char(19),
    createBy             varchar(255),
    editTime             char(19),
    editBy               varchar(255),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_activity_remark                                   */
/*==============================================================*/
create table tbl_activity_remark
(
    id                   char(32) not null,
    noteContent          varchar(255),
    createTime           char(19),
    createBy             varchar(255),
    editTime             char(19),
    editBy               varchar(255),
    editFlag             char(1) comment '0表示未修改，1表示已修改',
    activityId           char(32),
    primary key (id)
);

drop table if exists tbl_dic_type;

drop table if exists tbl_dic_value;

/*==============================================================*/
/* Table: tbl_dic_type                                          */
/*==============================================================*/
create table tbl_dic_type
(
    code                 varchar(255) not null comment '编码是主键，不能为空，不能含有中文。',
    name                 varchar(255),
    description          varchar(255),
    primary key (code)
);

/*==============================================================*/
/* Table: tbl_dic_value                                         */
/*==============================================================*/
create table tbl_dic_value
(
    id                   char(32) not null comment '主键，采用UUID',
    value                varchar(255) comment '不能为空，并且要求同一个字典类型下字典值不能重复，具有唯一性。',
    text                 varchar(255) comment '可以为空',
    orderNo              varchar(255) comment '可以为空，但不为空的时候，要求必须是正整数',
    typeCode             varchar(255) comment '外键',
    primary key (id)
);

drop table if exists tbl_user;

/*==============================================================*/
/* Table: tbl_user                                              */
/*==============================================================*/
create table tbl_user
(
    id                   char(32) not null comment 'uuid
            ',
    loginAct             varchar(255),
    name                 varchar(255),
    loginPwd             varchar(255) comment '密码不能采用明文存储，采用密文，MD5加密之后的数据',
    email                varchar(255),
    expireTime           char(19) comment '失效时间为空的时候表示永不失效，失效时间为2018-10-10 10:10:10，则表示在该时间之前该账户可用。',
    lockState            char(1) comment '锁定状态为空时表示启用，为0时表示锁定，为1时表示启用。',
    deptno               char(4),
    allowIps             varchar(255) comment '允许访问的IP为空时表示IP地址永不受限，允许访问的IP可以是一个，也可以是多个，当多个IP地址的时候，采用半角逗号分隔。允许IP是192.168.100.2，表示该用户只能在IP地址为192.168.100.2的机器上使用。',
    createTime           char(19),
    createBy             varchar(255),
    editTime             char(19),
    editBy               varchar(255),
    primary key (id)
);

drop table if exists tbl_clue;

drop table if exists tbl_clue_activity_relation;

drop table if exists tbl_clue_remark;

drop table if exists tbl_contacts;

drop table if exists tbl_contacts_activity_relation;

drop table if exists tbl_contacts_remark;

drop table if exists tbl_customer;

drop table if exists tbl_customer_remark;

drop table if exists tbl_tran;

drop table if exists tbl_tran_history;

drop table if exists tbl_tran_remark;

/*==============================================================*/
/* Table: tbl_clue                                              */
/*==============================================================*/
create table tbl_clue
(
    id                   char(32) not null,
    fullname             varchar(255),
    appellation          varchar(255),
    owner                char(32),
    company              varchar(255),
    job                  varchar(255),
    email                varchar(255),
    phone                varchar(255),
    website              varchar(255),
    mphone               varchar(255),
    state                varchar(255),
    source               varchar(255),
    createBy             varchar(255),
    createTime           char(19),
    editBy               varchar(255),
    editTime             char(19),
    description          varchar(255),
    contactSummary       varchar(255),
    nextContactTime      char(10),
    address              varchar(255),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_clue_activity_relation                            */
/*==============================================================*/
create table tbl_clue_activity_relation
(
    id                   char(32) not null,
    clueId               char(32),
    activityId           char(32),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_clue_remark                                       */
/*==============================================================*/
create table tbl_clue_remark
(
    id                   char(32) not null,
    noteContent          varchar(255),
    createBy             varchar(255),
    createTime           char(19),
    editBy               varchar(255),
    editTime             char(19),
    editFlag             char(1),
    clueId               char(32),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_contacts                                          */
/*==============================================================*/
create table tbl_contacts
(
    id                   char(32) not null,
    owner                char(32),
    source               varchar(255),
    customerId           char(32),
    fullname             varchar(255),
    appellation          varchar(255),
    email                varchar(255),
    mphone               varchar(255),
    job                  varchar(255),
    birth                char(10),
    createBy             varchar(255),
    createTime           char(19),
    editBy               varchar(255),
    editTime             char(19),
    description          varchar(255),
    contactSummary       varchar(255),
    nextContactTime      char(10),
    address              varchar(255),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_contacts_activity_relation                        */
/*==============================================================*/
create table tbl_contacts_activity_relation
(
    id                   char(32) not null,
    contactsId           char(32),
    activityId           char(32),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_contacts_remark                                   */
/*==============================================================*/
create table tbl_contacts_remark
(
    id                   char(32) not null,
    noteContent          varchar(255),
    createBy             varchar(255),
    createTime           char(19),
    editBy               varchar(255),
    editTime             char(19),
    editFlag             char(1),
    contactsId           char(32),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_customer                                          */
/*==============================================================*/
create table tbl_customer
(
    id                   char(32) not null,
    owner                char(32),
    name                 varchar(255),
    website              varchar(255),
    phone                varchar(255),
    createBy             varchar(255),
    createTime           char(19),
    editBy               varchar(255),
    editTime             char(19),
    contactSummary       varchar(255),
    nextContactTime      char(10),
    description          varchar(255),
    address              varchar(255),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_customer_remark                                   */
/*==============================================================*/
create table tbl_customer_remark
(
    id                   char(32) not null,
    noteContent          varchar(255),
    createBy             varchar(255),
    createTime           char(19),
    editBy               varchar(255),
    editTime             char(19),
    editFlag             char(1),
    customerId           char(32),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_tran                                              */
/*==============================================================*/
create table tbl_tran
(
    id                   char(32) not null,
    owner                char(32),
    money                varchar(255),
    name                 varchar(255),
    expectedDate         char(10),
    customerId           char(32),
    stage                varchar(255),
    type                 varchar(255),
    source               varchar(255),
    activityId           char(32),
    contactsId           char(32),
    createBy             varchar(255),
    createTime           char(19),
    editBy               varchar(255),
    editTime             char(19),
    description          varchar(255),
    contactSummary       varchar(255),
    nextContactTime      char(10),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_tran_history                                      */
/*==============================================================*/
create table tbl_tran_history
(
    id                   char(32) not null,
    stage                varchar(255),
    money                varchar(255),
    expectedDate         char(10),
    createTime           char(19),
    createBy             varchar(255),
    tranId               char(32),
    primary key (id)
);

/*==============================================================*/
/* Table: tbl_tran_remark                                       */
/*==============================================================*/
create table tbl_tran_remark
(
    id                   char(32) not null,
    noteContent          varchar(255),
    createBy             varchar(255),
    createTime           char(19),
    editBy               varchar(255),
    editTime             char(19),
    editFlag             char(1),
    tranId               char(32),
    primary key (id)
);

drop table if exists tbl_dept;

-- ----------------------------
-- Table structure for tbl_dept
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dept`;
CREATE TABLE `tbl_dept` (
    `id` char(32) NOT NULL,
    `deptno` char(4) DEFAULT NULL,
    `name` varchar(255) DEFAULT NULL,
    `userId` char(32) DEFAULT NULL,
    `phone` varchar(255) DEFAULT NULL,
    `description` varchar(255) DEFAULT NULL,
    `createBy` varchar(255) DEFAULT NULL,
    `createTime` varchar(19) DEFAULT NULL,
    `editBy` varchar(255) DEFAULT NULL,
    `editTime` varchar(19) DEFAULT NULL,
    PRIMARY KEY (`id`)
);
