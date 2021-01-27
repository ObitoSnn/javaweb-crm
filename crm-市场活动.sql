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
