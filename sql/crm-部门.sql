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
