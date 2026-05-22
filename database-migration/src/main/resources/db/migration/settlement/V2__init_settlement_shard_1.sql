CREATE DATABASE IF NOT EXISTS coupon_hub_settlement_1 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;


CREATE TABLE `coupon_hub_settlement_1`.`t_coupon_settlement_8`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `coupon_hub_settlement_1`.`t_coupon_settlement_9`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `coupon_hub_settlement_1`.`t_coupon_settlement_10`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `coupon_hub_settlement_1`.`t_coupon_settlement_11`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `coupon_hub_settlement_1`.`t_coupon_settlement_12`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `coupon_hub_settlement_1`.`t_coupon_settlement_13`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `coupon_hub_settlement_1`.`t_coupon_settlement_14`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `coupon_hub_settlement_1`.`t_coupon_settlement_15`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

