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
