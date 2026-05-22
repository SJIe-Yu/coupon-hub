CREATE DATABASE IF NOT EXISTS coupon_hub_engine_1 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_16`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030730 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_17`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225030 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_18`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493915836432 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_19`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225027 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_20`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225029 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_21`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030736 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_22`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225026 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_23`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030726 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_24`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225033 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_25`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030729 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_26`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493882281996 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_27`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493911642125 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_28`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493915836431 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_29`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493899059211 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_30`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225031 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_31`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030722 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_16`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_17`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_18`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_19`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_20`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_21`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_22`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_23`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_24`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_25`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_26`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_27`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_28`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_29`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_30`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `coupon_hub_engine_1`.`t_user_coupon_log_31`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

