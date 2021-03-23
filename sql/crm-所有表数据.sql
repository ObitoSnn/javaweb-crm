-- ----------------------------
-- Records of tbl_activity
-- ----------------------------
INSERT INTO `tbl_activity` VALUES ('14038b9d307e482488e3524c744cc751', '40f6cdea0bd34aceb77492a1656d9fb3', '测试市场活动01', '2021-03-22', '2021-03-25', '1000', '测试市场活动01', '2021-03-22 23:42:06', '张三', '2021-03-23 10:59:50', '张三');
INSERT INTO `tbl_activity` VALUES ('88db975370ea4ae6a06c914d6a7f6e47', '40f6cdea0bd34aceb77492a1656d9fb3', '测试市场活动02', '2021-03-22', '2021-03-26', '2000', '测试市场活动02', '2021-03-22 23:42:20', '张三', '2021-03-23 10:59:37', '张三');

-- ----------------------------
-- Records of tbl_activity_remark
-- ----------------------------
INSERT INTO `tbl_activity_remark` VALUES ('387ed9cf4d474046bfe03811523f5654', '备注01', '2021-03-22 23:47:55', '张三', null, null, '0', '88db975370ea4ae6a06c914d6a7f6e47');
INSERT INTO `tbl_activity_remark` VALUES ('6685781c0f474b5eafafdf6915329ccd', '备注02', '2021-03-22 23:48:26', '张三', null, null, '0', '14038b9d307e482488e3524c744cc751');
INSERT INTO `tbl_activity_remark` VALUES ('b0771d70bb044110acc49ad75918ed90', '备注02', '2021-03-22 23:48:13', '张三', null, null, '0', '88db975370ea4ae6a06c914d6a7f6e47');
INSERT INTO `tbl_activity_remark` VALUES ('d0272a730196489db3e1cfb54b4b9250', '备注01', '2021-03-22 23:48:23', '张三', null, null, '0', '14038b9d307e482488e3524c744cc751');

-- ----------------------------
-- Records of tbl_clue
-- ----------------------------
INSERT INTO `tbl_clue` VALUES ('25d39309ccb9408881a3ee48229e72b6', '测试线索01', '先生', '40f6cdea0bd34aceb77492a1656d9fb3', '测试线索公司01', 'CEO', 'test01@gamil.com', '010-11111111-1111', 'www.test01.com', '12222222222', '试图联系', '内部研讨会', '张三', '2021-03-22 23:46:15', '张三', '2021-03-23 10:57:33', '测试线索01', '测试线索01', '2021-03-22', '测试线索01');
INSERT INTO `tbl_clue` VALUES ('faefc519d472480d9157d2921413731f', '测试线索02', '夫人', '40f6cdea0bd34aceb77492a1656d9fb3', '测试线索公司02', 'CEO', 'test02@gmail.com', '010-22222222-2222', 'test@gmail.com', '13333333333', '虚假线索', '内部研讨会', '张三', '2021-03-22 23:47:20', '张三', '2021-03-23 10:58:28', '测试线索02', '测试线索02', '2021-03-25', '测试线索02');

-- ----------------------------
-- Records of tbl_clue_activity_relation
-- ----------------------------
INSERT INTO `tbl_clue_activity_relation` VALUES ('067508ff80aa436285d699b1a76c15ac', '25d39309ccb9408881a3ee48229e72b6', '14038b9d307e482488e3524c744cc751');
INSERT INTO `tbl_clue_activity_relation` VALUES ('5e24073a90a1443088cd06b156b2950c', 'faefc519d472480d9157d2921413731f', '88db975370ea4ae6a06c914d6a7f6e47');
INSERT INTO `tbl_clue_activity_relation` VALUES ('dbc4d824903d421a9306f1d54e487ea9', 'd366fa517a33490e8c2af7db9c0efa82', '1e90ff81f44e4816a566cf1e5d5ecff8');
INSERT INTO `tbl_clue_activity_relation` VALUES ('e1622e62178846daa8259d57657cf384', 'd366fa517a33490e8c2af7db9c0efa82', 'ef7f291166834c2c9ad280d8bd17641d');
INSERT INTO `tbl_clue_activity_relation` VALUES ('e624def760bd4510a6a9b049cc61a183', 'd366fa517a33490e8c2af7db9c0efa82', '8c892ea029b34a6c89733e808b22ad82');

-- ----------------------------
-- Records of tbl_clue_remark
-- ----------------------------
INSERT INTO `tbl_clue_remark` VALUES ('441b374b84504020bf483702d835f8ec', '备注02', '张三', '2021-03-22 23:48:35', null, null, '0', '25d39309ccb9408881a3ee48229e72b6');
INSERT INTO `tbl_clue_remark` VALUES ('46abd1ecb3a84f57a7b3a11d7f1ce6ba', '我就是张三1', '张三', '2021-02-04 17:12:09', '张三', '2021-02-05 12:21:46', '1', 'aabe16ca48f74e4d82a53c5959cb907e');
INSERT INTO `tbl_clue_remark` VALUES ('4e41d55d5ceb4ea8923890c59803de2b', '备注01', '张三', '2021-03-22 23:48:33', null, null, '0', '25d39309ccb9408881a3ee48229e72b6');
INSERT INTO `tbl_clue_remark` VALUES ('56c684ed20c34586aa081ce409400f9b', '备注01', '张三', '2021-03-22 23:47:28', null, null, '0', 'faefc519d472480d9157d2921413731f');
INSERT INTO `tbl_clue_remark` VALUES ('5c889f156f5044a8b0687efd3626e95e', '嗯', '张三', '2021-02-04 18:02:28', null, null, '0', 'aabe16ca48f74e4d82a53c5959cb907e');
INSERT INTO `tbl_clue_remark` VALUES ('6054189673d74e8fbb581103e2e1d79b', '1', '张三', '2021-02-09 22:24:23', '张三', '2021-02-09 22:24:26', '1', 'aabe16ca48f74e4d82a53c5959cb907e');
INSERT INTO `tbl_clue_remark` VALUES ('a41c094b5a1d4297a3c01ea9e5526073', '备注02', '张三', '2021-03-22 23:47:33', null, null, '0', 'faefc519d472480d9157d2921413731f');
INSERT INTO `tbl_clue_remark` VALUES ('a6bdcdb1385448d5a5951e1581778ef3', '1', '张三', '2021-02-12 11:36:27', null, null, '0', 'd366fa517a33490e8c2af7db9c0efa82');
INSERT INTO `tbl_clue_remark` VALUES ('d230c979a12c4150898b55efce73f7c2', '再来一条', '张三', '2021-02-06 18:59:25', null, null, '0', 'aabe16ca48f74e4d82a53c5959cb907e');

-- ----------------------------
-- Records of tbl_contacts
-- ----------------------------
INSERT INTO `tbl_contacts` VALUES ('742942e5b73e43cd99bffcc0d11e6675', '40f6cdea0bd34aceb77492a1656d9fb3', '交易会', '65099c908d43401f91773660da431e6f', '测试联系人01', '先生', 'test01@gmail.com', '12222222222', 'CEO', '2021-03-23', '张三', '2021-03-23 10:54:41', '张三', '2021-03-23 11:01:57', '测试联系人01', '测试联系人01', '2021-03-23', '测试联系人01');
INSERT INTO `tbl_contacts` VALUES ('7dc25f8e123c42f2a40fe722e1e39a1a', '40f6cdea0bd34aceb77492a1656d9fb3', '交易会', '383c16b6bf95485eb02eb9a667d4cf36', '测试联系人03', '夫人', 'test03@gmail.com', '13333333333', 'CEO', '2021-03-22', '张三', '2021-03-23 16:21:50', '张三', '2021-03-23 16:22:06', '测试联系人03', '测试联系人03', '2021-03-23', '测试联系人03');
INSERT INTO `tbl_contacts` VALUES ('df162e005a4f485c982e63df9cb0fb66', '40f6cdea0bd34aceb77492a1656d9fb3', '交易会', '3e1ff493d09a4dac8b3dde4462500e71', '测试联系人02', '博士', 'test02@gmail.com', '13333333333', 'CEO', '2021-03-23', '张三', '2021-03-23 10:55:38', '张三', '2021-03-23 12:13:04', '测试联系人02', '测试联系人02', '2021-03-23', '测试联系人02');

-- ----------------------------
-- Records of tbl_contacts_activity_relation
-- ----------------------------
INSERT INTO `tbl_contacts_activity_relation` VALUES ('03a4d971602845a494a5f065f23aee51', '53b22180e2104ba0be1b1198987e61d7', 'e683d2627103461b8fe5fab914e8286b');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('a35d1ece046d4fc3b315d13e3677f9fa', 'df162e005a4f485c982e63df9cb0fb66', '88db975370ea4ae6a06c914d6a7f6e47');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('a99e15bfac3c48129ccad502126d6485', '742942e5b73e43cd99bffcc0d11e6675', '14038b9d307e482488e3524c744cc751');

-- ----------------------------
-- Records of tbl_contacts_remark
-- ----------------------------
INSERT INTO `tbl_contacts_remark` VALUES ('20f335715108472eb7e0671250262297', '备注2', '张三', '2021-03-17 22:21:52', null, null, '0', '892307e66c1c48ed8ed85d0ca187bb49');
INSERT INTO `tbl_contacts_remark` VALUES ('217d329cdfaf486c91fcd76465d4ae9e', '备注1', '张三', '2021-02-06 23:31:36', null, null, '0', '0d0e95fb4fcb4a93b9798fae2b62828e');
INSERT INTO `tbl_contacts_remark` VALUES ('362902cb221842a492da4bbf0f71dea0', '备注1', '张三', '2021-03-17 22:21:47', null, null, '0', '892307e66c1c48ed8ed85d0ca187bb49');
INSERT INTO `tbl_contacts_remark` VALUES ('532af11c37034f46ae5867a0d691bd2a', '备注3', '张三', '2021-03-17 22:21:56', null, null, '0', '892307e66c1c48ed8ed85d0ca187bb49');
INSERT INTO `tbl_contacts_remark` VALUES ('63710d05ffcb4b1fa344262c88eeebf1', '备注3', '张三', '2021-02-06 23:31:36', null, null, '0', '0d0e95fb4fcb4a93b9798fae2b62828e');
INSERT INTO `tbl_contacts_remark` VALUES ('b2b11dae7eb0418cbd664817d6481f03', '备注2', '张三', '2021-02-06 23:31:36', null, null, '0', '0d0e95fb4fcb4a93b9798fae2b62828e');
INSERT INTO `tbl_contacts_remark` VALUES ('dab887c75cc14471bcb22b826431e2e9', '3', '张三', '2021-03-16 20:02:41', null, null, '0', '53b22180e2104ba0be1b1198987e61d7');

-- ----------------------------
-- Records of tbl_customer
-- ----------------------------
INSERT INTO `tbl_customer` VALUES ('383c16b6bf95485eb02eb9a667d4cf36', '40f6cdea0bd34aceb77492a1656d9fb3', '测试客户03', null, null, '张三', '2021-03-23 12:10:51', null, null, null, null, null, null);
INSERT INTO `tbl_customer` VALUES ('3e1ff493d09a4dac8b3dde4462500e71', '40f6cdea0bd34aceb77492a1656d9fb3', '测试客户02', 'www.test02.com', '010-22222222-2222', '张三', '2021-03-22 23:50:51', '张三', '2021-03-23 10:58:51', '测试客户02', '2021-03-22', '测试客户02', '测试客户02');
INSERT INTO `tbl_customer` VALUES ('65099c908d43401f91773660da431e6f', '40f6cdea0bd34aceb77492a1656d9fb3', '测试客户01', 'www.test01.com', '010-11111111-1111', '张三', '2021-03-22 23:49:14', '张三', '2021-03-23 10:58:43', '测试客户01', '2021-03-22', '测试客户01', '测试客户01');

-- ----------------------------
-- Records of tbl_customer_remark
-- ----------------------------
INSERT INTO `tbl_customer_remark` VALUES ('221e012ce5da412bb4f01b60bc508104', '备注02', '张三', '2021-03-22 23:51:01', null, null, '0', '65099c908d43401f91773660da431e6f');
INSERT INTO `tbl_customer_remark` VALUES ('8a35280a6b644985aa6f97a76692b7a3', '2', '张三', '2021-02-12 12:15:37', null, null, '0', '73f9117d1206431da05463b8f232ea8b');
INSERT INTO `tbl_customer_remark` VALUES ('9b735cf97e924893b693bc7ab3e943d7', '备注01', '张三', '2021-03-22 23:50:56', null, null, '0', '65099c908d43401f91773660da431e6f');
INSERT INTO `tbl_customer_remark` VALUES ('c94310b932984e109efea4d1fa88d8d3', '555', '张三', '2021-02-12 12:15:35', '张三', '2021-02-12 12:35:22', '1', '73f9117d1206431da05463b8f232ea8b');
INSERT INTO `tbl_customer_remark` VALUES ('e245fca96c9d4a48bd20bb2b6f42434b', '3', '张三', '2021-02-12 12:15:38', null, null, '0', '73f9117d1206431da05463b8f232ea8b');

-- ----------------------------
-- Records of tbl_dept
-- ----------------------------
INSERT INTO `tbl_dept` VALUES ('1cc1efd5c39843e3a3f0a19359d2da95', '1120', '销售部', '06f5fc056eac41558a964f96daa7f27c', '010-84846006', 'info', '管理员', '2021-03-01 21:12:38', null, null);
INSERT INTO `tbl_dept` VALUES ('8ce7222f6af549cfac5851bcc5a053e8', '1110', '财务部', '06f5fc056eac41558a964f96daa7f27c', '010-84846005', 'info', '管理员', '2021-03-01 15:01:20', null, null);

-- ----------------------------
-- Records of tbl_dic_type
-- ----------------------------
INSERT INTO `tbl_dic_type` VALUES ('appellation', '称呼', '');
INSERT INTO `tbl_dic_type` VALUES ('clueState', '线索状态', '');
INSERT INTO `tbl_dic_type` VALUES ('returnPriority', '回访优先级', '');
INSERT INTO `tbl_dic_type` VALUES ('returnState', '回访状态', '');
INSERT INTO `tbl_dic_type` VALUES ('source', '来源', '');
INSERT INTO `tbl_dic_type` VALUES ('stage', '阶段', '');
INSERT INTO `tbl_dic_type` VALUES ('transactionType', '交易类型', '');

-- ----------------------------
-- Records of tbl_dic_value
-- ----------------------------
INSERT INTO `tbl_dic_value` VALUES ('06e3cbdf10a44eca8511dddfc6896c55', '虚假线索', '虚假线索', '4', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('0fe33840c6d84bf78df55d49b169a894', '销售邮件', '销售邮件', '8', 'source');
INSERT INTO `tbl_dic_value` VALUES ('12302fd42bd349c1bb768b19600e6b20', '交易会', '交易会', '11', 'source');
INSERT INTO `tbl_dic_value` VALUES ('1615f0bb3e604552a86cde9a2ad45bea', '最高', '最高', '2', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('176039d2a90e4b1a81c5ab8707268636', '教授', '教授', '5', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('1e0bd307e6ee425599327447f8387285', '将来联系', '将来联系', '2', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2173663b40b949ce928db92607b5fe57', '丢失线索', '丢失线索', '5', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2876690b7e744333b7f1867102f91153', '未启动', '未启动', '1', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('29805c804dd94974b568cfc9017b2e4c', '07成交', '07成交', '7', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('310e6a49bd8a4962b3f95a1d92eb76f4', '试图联系', '试图联系', '1', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('31539e7ed8c848fc913e1c2c93d76fd1', '博士', '博士', '4', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('37ef211719134b009e10b7108194cf46', '01资质审查', '01资质审查', '1', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('391807b5324d4f16bd58c882750ee632', '08丢失的线索', '08丢失的线索', '8', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('3a39605d67da48f2a3ef52e19d243953', '聊天', '聊天', '14', 'source');
INSERT INTO `tbl_dic_value` VALUES ('474ab93e2e114816abf3ffc596b19131', '低', '低', '3', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('48512bfed26145d4a38d3616e2d2cf79', '广告', '广告', '1', 'source');
INSERT INTO `tbl_dic_value` VALUES ('4d03a42898684135809d380597ed3268', '合作伙伴研讨会', '合作伙伴研讨会', '9', 'source');
INSERT INTO `tbl_dic_value` VALUES ('59795c49896947e1ab61b7312bd0597c', '先生', '先生', '1', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('5c6e9e10ca414bd499c07b886f86202a', '高', '高', '1', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('67165c27076e4c8599f42de57850e39c', '夫人', '夫人', '2', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('68a1b1e814d5497a999b8f1298ace62b', '09因竞争丢失关闭', '09因竞争丢失关闭', '9', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('6b86f215e69f4dbd8a2daa22efccf0cf', 'web调研', 'web调研', '13', 'source');
INSERT INTO `tbl_dic_value` VALUES ('72f13af8f5d34134b5b3f42c5d477510', '合作伙伴', '合作伙伴', '6', 'source');
INSERT INTO `tbl_dic_value` VALUES ('7c07db3146794c60bf975749952176df', '未联系', '未联系', '6', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('86c56aca9eef49058145ec20d5466c17', '内部研讨会', '内部研讨会', '10', 'source');
INSERT INTO `tbl_dic_value` VALUES ('9095bda1f9c34f098d5b92fb870eba17', '进行中', '进行中', '3', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('954b410341e7433faa468d3c4f7cf0d2', '已有业务', '已有业务', '1', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('966170ead6fa481284b7d21f90364984', '已联系', '已联系', '3', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('96b03f65dec748caa3f0b6284b19ef2f', '推迟', '推迟', '2', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('97d1128f70294f0aac49e996ced28c8a', '新业务', '新业务', '2', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('9ca96290352c40688de6596596565c12', '完成', '完成', '4', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('9e6d6e15232549af853e22e703f3e015', '需要条件', '需要条件', '7', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('9ff57750fac04f15b10ce1bbb5bb8bab', '02需求分析', '02需求分析', '2', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('a70dc4b4523040c696f4421462be8b2f', '等待某人', '等待某人', '5', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('a83e75ced129421dbf11fab1f05cf8b4', '推销电话', '推销电话', '2', 'source');
INSERT INTO `tbl_dic_value` VALUES ('ab8472aab5de4ae9b388b2f1409441c1', '常规', '常规', '5', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('ab8c2a3dc05f4e3dbc7a0405f721b040', '05提案/报价', '05提案/报价', '5', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('b924d911426f4bc5ae3876038bc7e0ad', 'web下载', 'web下载', '12', 'source');
INSERT INTO `tbl_dic_value` VALUES ('c13ad8f9e2f74d5aa84697bb243be3bb', '03价值建议', '03价值建议', '3', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('c83c0be184bc40708fd7b361b6f36345', '最低', '最低', '4', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('db867ea866bc44678ac20c8a4a8bfefb', '员工介绍', '员工介绍', '3', 'source');
INSERT INTO `tbl_dic_value` VALUES ('e44be1d99158476e8e44778ed36f4355', '04确定决策者', '04确定决策者', '4', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('e5f383d2622b4fc0959f4fe131dafc80', '女士', '女士', '3', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('e81577d9458f4e4192a44650a3a3692b', '06谈判/复审', '06谈判/复审', '6', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('fb65d7fdb9c6483db02713e6bc05dd19', '在线商场', '在线商场', '5', 'source');
INSERT INTO `tbl_dic_value` VALUES ('fd677cc3b5d047d994e16f6ece4d3d45', '公开媒介', '公开媒介', '7', 'source');
INSERT INTO `tbl_dic_value` VALUES ('ff802a03ccea4ded8731427055681d48', '外部介绍', '外部介绍', '4', 'source');

-- ----------------------------
-- Records of tbl_tran
-- ----------------------------
INSERT INTO `tbl_tran` VALUES ('332ddee9fe87495aabb3fddae1aee64e', '40f6cdea0bd34aceb77492a1656d9fb3', '1111', '测试交易05', '2021-03-08', '3e1ff493d09a4dac8b3dde4462500e71', '05提案/报价', '新业务', '内部研讨会', '14038b9d307e482488e3524c744cc751', 'df162e005a4f485c982e63df9cb0fb66', '张三', '2021-03-23 16:53:26', '张三', '2021-03-23 16:53:42', '测试交易05', '测试交易05', '2021-03-23');
INSERT INTO `tbl_tran` VALUES ('5d5ea957e7d94b5e8c14ae93f20f60a2', '40f6cdea0bd34aceb77492a1656d9fb3', '1000', '测试交易03', '2021-03-23', '383c16b6bf95485eb02eb9a667d4cf36', '03价值建议', '已有业务', '广告', '88db975370ea4ae6a06c914d6a7f6e47', 'df162e005a4f485c982e63df9cb0fb66', '张三', '2021-03-23 16:09:35', '张三', '2021-03-23 16:51:49', '测试交易03', '测试交易03', '2021-03-23');
INSERT INTO `tbl_tran` VALUES ('9283797b9a9843d59139641ba61e68ab', '40f6cdea0bd34aceb77492a1656d9fb3', '1000', '测试交易02', '2021-03-23', '3e1ff493d09a4dac8b3dde4462500e71', '04确定决策者', '已有业务', '内部研讨会', '88db975370ea4ae6a06c914d6a7f6e47', 'df162e005a4f485c982e63df9cb0fb66', '张三', '2021-03-23 10:56:16', '张三', '2021-03-23 16:52:00', '测试交易02', '测试交易02', '2021-03-23');
INSERT INTO `tbl_tran` VALUES ('95733758bc114cfeba50bdf43ea35dce', '40f6cdea0bd34aceb77492a1656d9fb3', '2000', '测试交易01', '2021-03-23', '65099c908d43401f91773660da431e6f', '06谈判/复审', '已有业务', '交易会', '88db975370ea4ae6a06c914d6a7f6e47', '742942e5b73e43cd99bffcc0d11e6675', '张三', '2021-03-23 11:02:47', '张三', '2021-03-23 16:51:56', '测试交易01', '测试交易01', '2021-03-23');
INSERT INTO `tbl_tran` VALUES ('a7ef106bfc9d4bcaa4bfecd5207a970f', '40f6cdea0bd34aceb77492a1656d9fb3', '1111', '测试交易04', '2021-03-08', '383c16b6bf95485eb02eb9a667d4cf36', '03价值建议', '已有业务', '交易会', '14038b9d307e482488e3524c744cc751', 'df162e005a4f485c982e63df9cb0fb66', '张三', '2021-03-23 16:52:40', null, null, '测试交易04', '测试交易04', '2021-03-23');

-- ----------------------------
-- Records of tbl_tran_history
-- ----------------------------
INSERT INTO `tbl_tran_history` VALUES ('208ab4f0412b412f84d875866c180eef', '03价值建议', '1000', '1000', '2021-03-23 16:51:49', '张三', '5d5ea957e7d94b5e8c14ae93f20f60a2');
INSERT INTO `tbl_tran_history` VALUES ('507f570318a14f04b84cfebeba3a492c', '06谈判/复审', '2000', '2000', '2021-03-23 16:51:56', '张三', '95733758bc114cfeba50bdf43ea35dce');
INSERT INTO `tbl_tran_history` VALUES ('5be3fb998d1440c1a9ca8be71e6fabf2', '03价值建议', '1111', '2021-03-08', '2021-03-23 16:53:26', '张三', '332ddee9fe87495aabb3fddae1aee64e');
INSERT INTO `tbl_tran_history` VALUES ('698a29dbefc74085ac52ed04a5deb810', '03价值建议', '1111', '2021-03-08', '2021-03-23 16:52:40', '张三', 'a7ef106bfc9d4bcaa4bfecd5207a970f');
INSERT INTO `tbl_tran_history` VALUES ('7c797181ddda4be98b8ee25b6dc6b1df', '04确定决策者', '1000', '1000', '2021-03-23 16:51:47', '张三', '5d5ea957e7d94b5e8c14ae93f20f60a2');
INSERT INTO `tbl_tran_history` VALUES ('857d4fa0618e4f97b8e9e4d8536488f1', '05提案/报价', '1111', '1111', '2021-03-23 16:53:42', '张三', '332ddee9fe87495aabb3fddae1aee64e');
INSERT INTO `tbl_tran_history` VALUES ('b483b134c75342218ec74830034cd47e', '04确定决策者', '1000', '1000', '2021-03-23 16:52:00', '张三', '9283797b9a9843d59139641ba61e68ab');
INSERT INTO `tbl_tran_history` VALUES ('fe332f9f4e5d43fab1f7133a6b286bbc', '05提案/报价', '1000', '1000', '2021-03-23 16:51:49', '张三', '5d5ea957e7d94b5e8c14ae93f20f60a2');

-- ----------------------------
-- Records of tbl_tran_remark
-- ----------------------------
INSERT INTO `tbl_tran_remark` VALUES ('16e37596527d41a5bd43fceb34ae33d4', '1', '张三', '2021-02-09 22:22:53', null, null, '0', '0923c83f5dca49a789824c91b80cef50');
INSERT INTO `tbl_tran_remark` VALUES ('7653fb83c52e446da1ce823cb021d0ce', '3', '张三', '2021-02-09 21:39:50', '张三', '2021-02-09 21:40:08', '1', '240d9c846057402589a2da7fa6133534');
INSERT INTO `tbl_tran_remark` VALUES ('7c4df89d5c594f68bee7a3899bf6b838', '2', '张三', '2021-02-09 21:40:06', null, null, '0', '240d9c846057402589a2da7fa6133534');
INSERT INTO `tbl_tran_remark` VALUES ('a84b2ca7859f4285982581c56a983a64', '2', '张三', '2021-03-16 17:54:31', null, null, '0', 'd925306857664dd78cc1ec887a063843');
INSERT INTO `tbl_tran_remark` VALUES ('aad0788e61d648fca32e168d54b0f892', '1', '张三', '2021-02-12 11:37:30', null, null, '0', '26a846d195ea490ca28d7b7a5138b5eb');
INSERT INTO `tbl_tran_remark` VALUES ('e4c4b03267514c9b8617de07e047a78f', '1', '张三', '2021-02-10 18:53:01', null, null, '0', '54f87a540a9745d68731ae09236a2fa1');

-- ----------------------------
-- Records of tbl_user
-- ----------------------------
INSERT INTO `tbl_user` VALUES ('06f5fc056eac41558a964f96daa7f27c', 'ls', '李四', '202cb962ac59075b964b07152d234b70', 'ls@gmail.com', '2022-11-30 23:50:55', '1', '1120', '192.168.1.1,,127.0.0.1', '2018-11-22 12:11:40', '李四', null, null);
INSERT INTO `tbl_user` VALUES ('40f6cdea0bd34aceb77492a1656d9fb3', 'zs', '张三', '202cb962ac59075b964b07152d234b70', 'zs@gmail.com', '2022-11-30 23:50:55', '1', '1110', '192.168.1.1,192.168.1.2,127.0.0.1', '2018-11-22 11:37:34', '张三', null, null);
INSERT INTO `tbl_user` VALUES ('e503978efdf8462182e5dd1548a6480b', 'root', '管理员', '202cb962ac59075b964b07152d234b70', 'root@gmail.com', '2022-11-30 23:50:55', '1', '', '127.0.0.1', '2018-11-22 11:37:59', null, null, null);
