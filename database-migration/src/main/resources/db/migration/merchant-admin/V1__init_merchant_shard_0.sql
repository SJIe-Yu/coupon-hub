
CREATE TABLE `t_coupon_task`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `batch_id`           bigint(20) DEFAULT NULL COMMENT '批次ID',
    `task_name`          varchar(128) DEFAULT NULL COMMENT '优惠券批次任务名称',
    `file_address`       varchar(512) DEFAULT NULL COMMENT '文件地址',
    `send_num`           int(11) DEFAULT NULL COMMENT '发放优惠券数量',
    `fail_file_address`  varchar(512) DEFAULT NULL COMMENT '发放失败用户文件地址',
    `notify_type`        varchar(32)  DEFAULT NULL COMMENT '通知方式，可组合使用 0：站内信 1：弹框推送 2：邮箱 3：短信',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `send_type`          tinyint(1) DEFAULT NULL COMMENT '发送类型 0：立即发送 1：定时发送',
    `send_time`          datetime     DEFAULT NULL COMMENT '发送时间',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：待执行 1：执行中 2：执行失败 3：执行成功 4：取消',
    `completion_time`    datetime     DEFAULT NULL COMMENT '完成时间',
    `create_time`        datetime     DEFAULT NULL COMMENT '创建时间',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `update_time`        datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                  `idx_batch_id` (`batch_id`) USING BTREE,
    KEY                  `idx_coupon_template_id` (`coupon_template_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816362696870739971 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板发送任务表';

CREATE TABLE `t_coupon_task_fail`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `batch_id`    bigint(20) DEFAULT NULL COMMENT '批次ID',
    `json_object` text COMMENT '失败内容',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `t_coupon_template_0`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967816300515330 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_1`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967812836020227 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_2`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967817126793218 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_3`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967817122598915 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_4`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967797723942918 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_5`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967789205311493 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_6`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967789150785539 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_7`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967780615376898 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_log`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        varchar(64)   DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810714735922958339 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `t_coupon_template_log_0`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_1`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_2`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_3`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_4`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_5`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_6`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_7`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_user`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number` varchar(64)  DEFAULT NULL COMMENT '店铺编号',
    `username`    varchar(64)  DEFAULT NULL COMMENT '用户名',
    `password`    varchar(512) DEFAULT NULL COMMENT '密码',
    `phone`       varchar(128) DEFAULT NULL COMMENT '手机号',
    `mail`        varchar(512) DEFAULT NULL COMMENT '邮箱',
    `create_time` datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`    tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1810872207291752449 DEFAULT CHARSET=utf8mb4 COMMENT='商家用户表';

