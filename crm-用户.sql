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