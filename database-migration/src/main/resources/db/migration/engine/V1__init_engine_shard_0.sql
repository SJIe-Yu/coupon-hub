
CREATE TABLE `t_coupon_template_remind`
(
    `user_id`            bigint(20) NOT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) NOT NULL COMMENT '券ID',
    `information`        bigint(20) DEFAULT NULL COMMENT '存储信息',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `start_time`         datetime DEFAULT NULL COMMENT '优惠券开抢时间',
    PRIMARY KEY (`user_id`, `coupon_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户预约提醒信息存储表';

CREATE TABLE `t_user_coupon_0`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030734 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_1`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030735 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_10`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493911642118 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_11`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225035 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_12`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493915836424 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_13`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030728 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_14`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493899059215 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_15`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030732 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_2`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225034 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_3`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030727 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_4`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493915836428 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_5`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493915836430 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_6`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493915836425 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_7`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225032 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_8`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493911642124 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_9`
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
) ENGINE=InnoDB AUTO_INCREMENT=1816074493907447818 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_log_0`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_1`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_10`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_11`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_12`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_13`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_14`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_15`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_2`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_3`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_4`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_5`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_6`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_7`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_8`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_9`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

