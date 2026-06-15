-- c-tag 标签资源管理组件数据库表结构
-- 基于设计文档: docs_c-tag 标签资源管理公共组件设计方案.md

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. 如果存在则删除（慎用：这会清空该数据库下所有已有数据）
DROP
DATABASE IF EXISTS `c-tag`;
-- 2. 创建数据库，并显式指定编码格式（推荐 utf8mb4）
CREATE
DATABASE `c-tag` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- 3. 切换并使用该数据库
-- 选择刚刚创建的数据库
USE `c-tag`;

-- ----------------------------
-- 标签节点定义表
-- ----------------------------
DROP TABLE IF EXISTS `c_tag`;
CREATE TABLE `c_tag` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',

    `tag_code` VARCHAR(255) NOT NULL COMMENT '标签全路径编码(如: abcd-8h3e-9xyz)',
    `tag_name` VARCHAR(100) NOT NULL COMMENT '标签显示名称',
    `level` TINYINT NOT NULL DEFAULT 1 COMMENT '当前层级深度(1-根节点)',
    `parent_code` VARCHAR(255) DEFAULT NULL COMMENT '父节点tag_code',

    `alias_code` VARCHAR(100) DEFAULT NULL COMMENT '业务别名/外部编码(如国标行政区划码)',
    `alias_parent_code` VARCHAR(500) DEFAULT NULL COMMENT '父级别名路径(冗余字段,用于外部系统对接)',


    `children_count` INT NOT NULL DEFAULT 0 COMMENT '直接子节点数量',
    `full_path` VARCHAR(1000) DEFAULT NULL COMMENT '完整路径名称(如: /北京市/海淀区/中关村)',
    `sort_order` INT DEFAULT 0 COMMENT '同级排序号',

    `source` VARCHAR(32) NOT NULL DEFAULT 'manual' COMMENT '数据来源(inner-系统内置,manual-手工创建,import-外部导入)',
    `config` VARCHAR(1000) DEFAULT NULL COMMENT '业务自定义配置',

    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `creator` VARCHAR(64) DEFAULT NULL COMMENT '创建者ID',
    `updater` VARCHAR(64) DEFAULT NULL COMMENT '更新者ID',
    `deleted` BIT(1) NOT NULL DEFAULT 0 COMMENT '是否删除(0-未删除,1-已删除)',

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_tag_code` (`tag_code`),

    KEY `idx_parent_code` (`parent_code`),
    KEY `idx_alias_code` (`alias_code`),

    KEY `idx_create_time` (`create_time`),
    KEY `idx_sort` (`parent_code`, `sort_order`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='标签节点定义表';

-- ----------------------------
-- 资源-标签关联表
-- ----------------------------
DROP TABLE IF EXISTS `c_tag_relation`;
CREATE TABLE `c_tag_relation` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',

    `tag_code` VARCHAR(255) NOT NULL COMMENT '关联的标签编码',
    `resource_code` VARCHAR(64) NOT NULL COMMENT '业务资源唯一标识',
    `resource_type` VARCHAR(32) NOT NULL COMMENT '资源类型(DEVICE/USER/ORG等)',
    `resource_name` VARCHAR(128) DEFAULT NULL COMMENT '资源名称快照(冗余,便于展示)',

    `bind_user` VARCHAR(64) DEFAULT NULL COMMENT '绑定操作人',
    `source` VARCHAR(32) NOT NULL DEFAULT 'manual' COMMENT '数据来源(inner-系统内置,manual-手工创建,import-外部导入)',

    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `creator` VARCHAR(64) DEFAULT NULL COMMENT '创建者ID',
    `updater` VARCHAR(64) DEFAULT NULL COMMENT '更新者ID',
    `deleted` BIT(1) NOT NULL DEFAULT 0 COMMENT '是否删除(0-未删除,1-已删除)',

    PRIMARY KEY (`id`),

    UNIQUE KEY `uk_tag_resource` (`tag_code`, `resource_code`, `resource_type`, `deleted`),

    KEY `idx_resource` (`resource_code`, `resource_type`, `deleted`),
    KEY `idx_type` (`resource_type`, `deleted`),
    KEY `idx_create_time` (`create_time`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='标签资源关联表';

-- ----------------------------
-- 标签数据权限配置表
-- ----------------------------
DROP TABLE IF EXISTS `c_tag_permission`;
CREATE TABLE `c_tag_permission` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',

    `tag_root_code` VARCHAR(255) NOT NULL COMMENT '标签树根节点Code(授权边界)',
    `subject_type` VARCHAR(32) NOT NULL COMMENT '主体类型(USER, ROLE, DEPT, USER_GROUP等)',
    `subject_id` VARCHAR(64) NOT NULL COMMENT '主体ID',
    `permission_scope` TINYINT NOT NULL COMMENT '权限范围(1-全部, 2-仅指定节点, 3-当前及下级, 4-指定节点集合)',
    `target_tag_code` VARCHAR(255) NOT NULL COMMENT '目标节点Code(Scope=ALL时为根节点Code)',

    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `creator` VARCHAR(64) DEFAULT NULL COMMENT '创建者ID',
    `updater` VARCHAR(64) DEFAULT NULL COMMENT '更新者ID',
    `deleted` BIT(1) NOT NULL DEFAULT 0 COMMENT '是否删除(0-未删除,1-已删除)',

    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_subject_target` (`subject_type`, `subject_id`, `target_tag_code`),
    KEY `idx_tag_root_code` (`tag_root_code`),
    KEY `idx_create_time` (`create_time`)

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='标签数据权限配置表';

INSERT INTO `c_tag` (`id`, `tag_code`, `tag_name`, `level`, `parent_code`, `alias_code`, `alias_parent_code`, `children_count`, `full_path`, `sort_order`, `source`, `config`, `create_time`, `update_time`, `creator`, `updater`, `deleted`) VALUES (1, '0001', '空间管理', 1, '0', NULL, NULL, 6, 'space', 0, 'manual', NULL, NOW(), NOW(), NULL, NULL, b'0');

SET FOREIGN_KEY_CHECKS = 1;
