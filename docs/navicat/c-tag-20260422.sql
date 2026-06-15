/*
 Navicat Premium Dump SQL

 Source Server         : 基座2.0DEV-iot
 Source Server Type    : MySQL
 Source Server Version : 50744 (5.7.44)
 Source Host           : 192.168.1.104:3306
 Source Schema         : c-tag

 Target Server Type    : MySQL
 Target Server Version : 50744 (5.7.44)
 File Encoding         : 65001

 Date: 22/04/2026 11:01:56
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for c_tag
-- ----------------------------
DROP TABLE IF EXISTS `c_tag`;
CREATE TABLE `c_tag`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tag_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签全路径编码(如: abcd-8h3e-9xyz)',
  `tag_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签显示名称',
  `level` tinyint(4) NOT NULL DEFAULT 1 COMMENT '当前层级深度(1-根节点)',
  `parent_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '父节点tag_code',
  `alias_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务别名/外部编码(如国标行政区划码)',
  `alias_parent_code` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '父级别名路径(冗余字段,用于外部系统对接)',
  `children_count` int(11) NOT NULL DEFAULT 0 COMMENT '直接子节点数量',
  `full_path` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '完整路径名称(如: /北京市/海淀区/中关村)',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '同级排序号',
  `source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual' COMMENT '数据来源(inner-系统内置,manual-手工创建,import-外部导入)',
  `config` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '业务自定义配置',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建者ID',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '更新者ID',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除(0-未删除,1-已删除)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tag_code`(`tag_code`) USING BTREE,
  INDEX `idx_parent_code`(`parent_code`) USING BTREE,
  INDEX `idx_alias_code`(`alias_code`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_sort`(`parent_code`, `sort_order`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '标签节点定义表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for c_tag_permission
-- ----------------------------
DROP TABLE IF EXISTS `c_tag_permission`;
CREATE TABLE `c_tag_permission`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tag_root_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标签树根节点Code(授权边界)',
  `subject_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主体类型(USER, ROLE, DEPT, USER_GROUP等)',
  `subject_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '主体ID',
  `permission_scope` tinyint(4) NOT NULL COMMENT '权限范围(1-全部, 2-仅指定节点, 3-当前及下级, 4-指定节点集合)',
  `target_tag_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '目标节点Code(Scope=ALL时为根节点Code)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建者ID',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '更新者ID',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除(0-未删除,1-已删除)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_subject_target`(`subject_type`, `subject_id`, `target_tag_code`) USING BTREE,
  INDEX `idx_tag_root_code`(`tag_root_code`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '标签数据权限配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for c_tag_relation
-- ----------------------------
DROP TABLE IF EXISTS `c_tag_relation`;
CREATE TABLE `c_tag_relation`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tag_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '关联的标签编码',
  `resource_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '业务资源唯一标识',
  `resource_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源类型(DEVICE/USER/ORG等)',
  `resource_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资源名称快照(冗余,便于展示)',
  `bind_user` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '绑定操作人',
  `source` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'manual' COMMENT '数据来源(inner-系统内置,manual-手工创建,import-外部导入)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建者ID',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '更新者ID',
  `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除(0-未删除,1-已删除)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_tag_resource`(`tag_code`, `resource_code`, `resource_type`, `deleted`) USING BTREE,
  INDEX `idx_resource`(`resource_code`, `resource_type`, `deleted`) USING BTREE,
  INDEX `idx_type`(`resource_type`, `deleted`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '标签资源关联表' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
