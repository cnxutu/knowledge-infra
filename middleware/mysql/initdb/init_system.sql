/*
 Navicat Premium Data Transfer

 Source Server         : 127.0.0.1 MySQL
 Source Server Type    : MySQL
 Source Server Version : 80200 (8.2.0)
 Source Host           : 127.0.0.1:3306
 Source Schema         : c-system

 Target Server Type    : MySQL
 Target Server Version : 80200 (8.2.0)
 File Encoding         : 65001

 Date: 12/05/2025 09:09:45
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
-- 1. 如果存在则删除（慎用：这会清空该数据库下所有已有数据）
DROP DATABASE IF EXISTS `c-system`;
-- 2. 创建数据库，并显式指定编码格式（推荐 utf8mb4）
CREATE DATABASE `c-system` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- 3. 切换并使用该数据库
USE `c-system`;

-- ----------------------------
-- Table structure for system_dept
-- ----------------------------
DROP TABLE IF EXISTS `system_dept`;
CREATE TABLE `system_dept`
(
    `id`             bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
    `name`           varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '部门名称',
    `code`           varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '部门编码',
    `parent_id`      bigint(20) NOT NULL DEFAULT 0 COMMENT '父部门id',
    `sort`           int(11) NOT NULL DEFAULT 0 COMMENT '显示顺序',
    `leader_user_id` bigint(20) NULL DEFAULT NULL COMMENT '负责人',
    `phone`          varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
    `email`          varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
    `status`         tinyint(4) NOT NULL COMMENT '部门状态（0正常 1停用）',
    `creator`        varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time`    datetime                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`        varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time`    datetime                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`        bit(1)                                                       NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`      bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 118 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `system_dict_data`;
CREATE TABLE `system_dict_data`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
    `sort`        int(11) NOT NULL DEFAULT 0 COMMENT '字典排序',
    `label`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典标签',
    `value`       varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典键值',
    `dict_type`   varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典类型',
    `status`      tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态（0正常 1停用）',
    `color_type`  varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '颜色类型',
    `css_class`   varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT 'css 样式',
    `remark`      varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
    `is_sync`     tinyint(1) NOT NULL DEFAULT 1 COMMENT '同步状态（0：字典发现服务同步 1：页面新增）',
    `app_code`    varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '应用编码',
    `creator`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time` datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time` datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`     bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `idx_idx_label_dict_tyoe`(`dict_type`, `label`,`value`) USING BTREE,
    INDEX `idx_is_sync`(`is_sync`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3058 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `system_dict_type`;
CREATE TABLE `system_dict_type`
(
    `id`           bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
    `name`         varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典名称',
    `type`         varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '字典类型',
    `status`       tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态（0正常 1停用）',
    `remark`       varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
    `is_sync`      tinyint(1) NOT NULL DEFAULT 1 COMMENT '同步状态（0：字典发现服务同步 1：页面新增）',
    `app_code`     varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '应用编码',
    `creator`      varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time`  datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`      varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time`  datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`      bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `deleted_time` datetime NULL DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `idx_is_sync`(`is_sync`) USING BTREE,
    UNIQUE INDEX `uk_type`(`type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1031 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_login_log
-- ----------------------------
DROP TABLE IF EXISTS `system_login_log`;
CREATE TABLE `system_login_log`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
    `log_type`    bigint(20) NOT NULL COMMENT '日志类型',
    `trace_id`    varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT '' COMMENT '链路追踪编号',
    `user_id`     bigint(20) NOT NULL DEFAULT 0 COMMENT '用户编号',
    `user_type`   tinyint(4) NOT NULL DEFAULT 0 COMMENT '用户类型',
    `username`    varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL DEFAULT '' COMMENT '用户账号',
    `result`      tinyint(4) NOT NULL COMMENT '登陆结果',
    `user_ip`     varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '用户 IP',
    `user_agent`  varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '浏览器 UA',
    `creator`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time` datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time` datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`     bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`   bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4929 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for system_menu
-- ----------------------------
DROP TABLE IF EXISTS `system_menu`;
CREATE TABLE `system_menu`
(
    `id`             bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
    `app_id`         varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NULL DEFAULT '' COMMENT '菜单归属系统（应用ID）',
    `identifier`     varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NULL DEFAULT '' COMMENT '菜单唯一业务标识符',
    `name`           varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '菜单名称',
    `permission`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '权限标识',
    `type`           tinyint(4) NOT NULL COMMENT '菜单类型',
    `menu_sub_type`  tinyint(4)  NULL COMMENT '菜单子类型：1=应用内置菜单, 2=用户自定义菜单, 3=外链',
    `sort`           int(11) NOT NULL DEFAULT 0 COMMENT '显示顺序',
    `parent_id`      bigint(20) NOT NULL DEFAULT 0 COMMENT '父菜单ID',
    `path`           varchar(8000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '路由地址',
    `icon`           varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '菜单图标',
    `app_logo`       varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '应用图标',
    `component`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件路径',
    `component_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '组件名',
    `status`         tinyint(4) NOT NULL DEFAULT 0 COMMENT '菜单状态',
    `visible`        bit(1)                                                        NOT NULL DEFAULT b'1' COMMENT '是否可见',
    `keep_alive`     bit(1)                                                        NOT NULL DEFAULT b'1' COMMENT '是否缓存',
    `always_show`    bit(1)                                                        NOT NULL DEFAULT b'1' COMMENT '是否总是显示',
    `iframe`         bit(1)                                                        NOT NULL DEFAULT b'1' COMMENT '是否是内嵌页面',
    `creator`        varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time`    datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`        varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time`    datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`        bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5152 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;



-- ----------------------------
-- Table structure for system_oauth2_access_token
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_access_token`;
CREATE TABLE `system_oauth2_access_token`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
    `user_id`       bigint(20) NOT NULL COMMENT '用户编号',
    `user_type`     tinyint(4) NOT NULL COMMENT '用户类型',
    `user_info`     varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户信息',
    `access_token`  varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '访问令牌',
    `refresh_token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '刷新令牌',
    `client_id`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
    `scopes`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '授权范围',
    `expires_time`  datetime                                                      NOT NULL COMMENT '过期时间',
    `creator`       varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time`   datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`       varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time`   datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`     bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE,
    INDEX           `idx_access_token`(`access_token`) USING BTREE,
    INDEX           `idx_refresh_token`(`refresh_token`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31735 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 访问令牌' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_oauth2_approve
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_approve`;
CREATE TABLE `system_oauth2_approve`
(
    `id`           bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
    `user_id`      bigint(20) NOT NULL COMMENT '用户编号',
    `user_type`    tinyint(4) NOT NULL COMMENT '用户类型',
    `client_id`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
    `scope`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '授权范围',
    `approved`     bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否接受',
    `expires_time` datetime                                                      NOT NULL COMMENT '过期时间',
    `creator`      varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time`  datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`      varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time`  datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`      bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`    bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 批准表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_oauth2_client
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_client`;
CREATE TABLE `system_oauth2_client`
(
    `id`                             bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
    `client_id`                      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
    `secret`                         varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端密钥',
    `name`                           varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用名',
    `logo`                           varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '应用图标',
    `description`                    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '应用描述',
    `status`                         tinyint(4) NOT NULL COMMENT '状态',
    `access_token_validity_seconds`  int(11) NOT NULL COMMENT '访问令牌的有效期',
    `refresh_token_validity_seconds` int(11) NOT NULL COMMENT '刷新令牌的有效期',
    `redirect_uris`                  varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '可重定向的 URI 地址',
    `authorized_grant_types`         varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '授权类型',
    `scopes`                         varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '授权范围',
    `auto_approve_scopes`            varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '自动通过的授权范围',
    `authorities`                    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '权限',
    `resource_ids`                   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资源',
    `additional_information`         varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '附加信息',
    `creator`                        varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time`                    datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`                        varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time`                    datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`                        bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 客户端表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_oauth2_code
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_code`;
CREATE TABLE `system_oauth2_code`
(
    `id`           bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
    `user_id`      bigint(20) NOT NULL COMMENT '用户编号',
    `user_type`    tinyint(4) NOT NULL COMMENT '用户类型',
    `code`         varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '授权码',
    `client_id`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
    `scopes`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '授权范围',
    `expires_time` datetime                                                      NOT NULL COMMENT '过期时间',
    `redirect_uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '可重定向的 URI 地址',
    `state`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '状态',
    `creator`      varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time`  datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`      varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time`  datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`      bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`    bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 授权码表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_oauth2_refresh_token
-- ----------------------------
DROP TABLE IF EXISTS `system_oauth2_refresh_token`;
CREATE TABLE `system_oauth2_refresh_token`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
    `user_id`       bigint(20) NOT NULL COMMENT '用户编号',
    `refresh_token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '刷新令牌',
    `user_type`     tinyint(4) NOT NULL COMMENT '用户类型',
    `client_id`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端编号',
    `scopes`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '授权范围',
    `expires_time`  datetime                                                      NOT NULL COMMENT '过期时间',
    `creator`       varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time`   datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`       varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time`   datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`       bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`     bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3058 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'OAuth2 刷新令牌' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_operate_log
-- ----------------------------
DROP TABLE IF EXISTS `system_operate_log`;
CREATE TABLE `system_operate_log`
(
    `id`             bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
    `trace_id`       varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   NOT NULL DEFAULT '' COMMENT '链路追踪编号',
    `user_id`        bigint(20) NOT NULL COMMENT '用户编号',
    `user_type`      tinyint(4) NOT NULL DEFAULT 0 COMMENT '用户类型',
    `type`           varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   NOT NULL COMMENT '操作模块类型',
    `sub_type`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   NOT NULL COMMENT '操作名',
    `biz_id`         bigint(20) NOT NULL COMMENT '操作数据模块编号',
    `action`         varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '操作内容',
    `success`        bit(1)                                                         NOT NULL DEFAULT b'1' COMMENT '操作结果',
    `extra`          varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '拓展字段',
    `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求方法名',
    `request_url`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '请求地址',
    `user_ip`        varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户 IP',
    `user_agent`     varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '浏览器 UA',
    `creator`        varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time`    datetime                                                       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`        varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time`    datetime                                                       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`        bit(1)                                                         NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`      bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 112 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志记录 V2 版本' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_post
-- ----------------------------
DROP TABLE IF EXISTS `system_post`;
CREATE TABLE `system_post`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
    `code`        varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位编码',
    `name`        varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '岗位名称',
    `sort`        int(11) NOT NULL COMMENT '显示顺序',
    `status`      tinyint(4) NOT NULL COMMENT '状态（0正常 1停用）',
    `remark`      varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
    `creator`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time` datetime                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time` datetime                                                     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`     bit(1)                                                       NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`   bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_role
-- ----------------------------
DROP TABLE IF EXISTS `system_role`;
CREATE TABLE `system_role`
(
    `id`                  bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
    `name`                varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '角色名称',
    `code`                varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色权限字符串',
    `sort`                int(11) NOT NULL COMMENT '显示顺序',
    `data_scope`          tinyint(4) NOT NULL DEFAULT 1 COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
    `data_scope_dept_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '数据范围(指定部门数组)',
    `status`              tinyint(4) NOT NULL COMMENT '角色状态（0正常 1停用）',
    `type`                tinyint(4) NOT NULL COMMENT '角色类型',
    `remark`              varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
    `creator`             varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time`         datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`             varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time`         datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`             bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`           bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 161 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `system_role_menu`;
CREATE TABLE `system_role_menu`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
    `role_id`     bigint(20) NOT NULL COMMENT '角色ID',
    `menu_id`     bigint(20) NOT NULL COMMENT '菜单ID',
    `creator`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`     bit(1)   NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`   bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6328 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for system_user_post
-- ----------------------------
DROP TABLE IF EXISTS `system_user_post`;
CREATE TABLE `system_user_post`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
    `user_id`     bigint(20) NOT NULL DEFAULT 0 COMMENT '用户ID',
    `post_id`     bigint(20) NOT NULL DEFAULT 0 COMMENT '岗位ID',
    `creator`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`     bit(1)   NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`   bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 127 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户岗位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_user_role
-- ----------------------------
DROP TABLE IF EXISTS `system_user_role`;
CREATE TABLE `system_user_role`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增编号',
    `user_id`     bigint(20) NOT NULL COMMENT '用户ID',
    `role_id`     bigint(20) NOT NULL COMMENT '角色ID',
    `creator`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`     bit(1) NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`   bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for system_users
-- ----------------------------
DROP TABLE IF EXISTS `system_users`;
CREATE TABLE `system_users`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `username`    varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '用户账号',
    `password`    varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码',
    `nickname`    varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '用户昵称',
    `remark`      varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
    `dept_id`     bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
    `post_ids`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '岗位编号数组',
    `email`       varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '用户邮箱',
    `mobile`      varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '手机号码',
    `region_code` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '国家/地区码',
    `phone_e164`  varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '手机号码 E164 标准',
    `sex`         tinyint(4) NULL DEFAULT 0 COMMENT '用户性别',
    `avatar`      varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '头像地址',
    `status`      tinyint(4) NOT NULL DEFAULT 0 COMMENT '帐号状态（0正常 1停用）',
    `login_ip`    varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '最后登录IP',
    `login_date`  datetime NULL DEFAULT NULL COMMENT '最后登录时间',
    `creator`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time` datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time` datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`     bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id`   bigint(20) NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 145 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for infra_config
-- ----------------------------
DROP TABLE IF EXISTS `infra_config`;
CREATE TABLE `infra_config`
(
    `id`          bigint                                                        NOT NULL AUTO_INCREMENT COMMENT '参数主键',
    `category`    varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '参数分组',
    `type`        tinyint                                                       NOT NULL COMMENT '参数类型',
    `name`        varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '参数名称',
    `config_key`  varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '参数键名',
    `value`       varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '参数键值',
    `visible`     bit(1)                                                        NOT NULL COMMENT '是否可见',
    `remark`      varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
    `creator`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time` datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time` datetime                                                      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`     bit(1)                                                        NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `config_key`(`config_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '参数配置表';

-- ----------------------------
-- Records of infra_config
-- ----------------------------

-- ----------------------------
-- Table structure for infra_file
-- ----------------------------
DROP TABLE IF EXISTS `infra_file`;
CREATE TABLE `infra_file`
(
    `id`          bigint                                                         NOT NULL AUTO_INCREMENT COMMENT '文件编号',
    `config_id`   bigint NULL DEFAULT NULL COMMENT '配置编号',
    `name`        varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件名',
    `path`        varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci  NOT NULL COMMENT '文件路径',
    `url`         varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件 URL',
    `type`        varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件类型',
    `size`        int                                                            NOT NULL COMMENT '文件大小',
    `creator`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time` datetime                                                       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time` datetime                                                       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`     bit(1)                                                         NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1898 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文件表';

-- ----------------------------
-- Records of infra_file
-- ----------------------------

-- ----------------------------
-- Table structure for infra_file_config
-- ----------------------------
DROP TABLE IF EXISTS `infra_file_config`;
CREATE TABLE `infra_file_config`
(
    `id`          bigint                                                         NOT NULL AUTO_INCREMENT COMMENT '编号',
    `name`        varchar(63) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci   NOT NULL COMMENT '配置名',
    `storage`     tinyint                                                        NOT NULL COMMENT '存储器',
    `remark`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
    `master`      bit(1)                                                         NOT NULL COMMENT '是否为主配置',
    `config`      varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '存储配置',
    `creator`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '创建者',
    `create_time` datetime                                                       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`     varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '更新者',
    `update_time` datetime                                                       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`     bit(1)                                                         NOT NULL DEFAULT b'0' COMMENT '是否删除',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文件配置表';

-- 优化批量插入性能
SET autocommit=0;
SET unique_checks=0;
SET foreign_key_checks=0;

BEGIN;

INSERT INTO `system_dict_type` (`name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`, `is_sync`, `app_code`)
VALUES ('国家代码', 'phone_country_code', '1', NULL, '1', NOW(), '1', NOW(), b'0', NULL, '1', NULL);
INSERT INTO `system_dict_type` (`name`, `type`, `status`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES ('系统状态', 'common_status', '1', NULL, '1', 'c-system', 'system', NOW(), 'system', NOW(), b'0', NULL);
INSERT INTO `system_dict_type` (`name`, `type`, `status`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`) VALUES ('存储器类型', 'storage_type', 1, NULL, 1, '', 'system', NOW(), 'system', NOW(), b'0', NULL);




-- 国家代码字典数据
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('10', 'AC', '247', 'phone_country_code', '1', 'default', '', '阿森松岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('20', 'AD', '376', 'phone_country_code', '1', 'default', '', '安道尔', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('30', 'AE', '971', 'phone_country_code', '1', 'default', '', '阿联酋', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('40', 'AF', '93', 'phone_country_code', '1', 'default', '', '阿富汗', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('50', 'AL', '355', 'phone_country_code', '1', 'default', '', '阿尔巴尼亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('60', 'AM', '374', 'phone_country_code', '1', 'default', '', '亚美尼亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('70', 'AO', '244', 'phone_country_code', '1', 'default', '', '安哥拉', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('80', 'AQ', '672', 'phone_country_code', '1', 'default', '', '南极洲/诺福克', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('90', 'AR', '54', 'phone_country_code', '1', 'default', '', '阿根廷', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('100', 'AT', '43', 'phone_country_code', '1', 'default', '', '奥地利', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('110', 'AU', '61', 'phone_country_code', '1', 'default', '', '澳大利亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('120', 'AW', '297', 'phone_country_code', '1', 'default', '', '阿鲁巴', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('130', 'AZ', '994', 'phone_country_code', '1', 'default', '', '阿塞拜疆', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('140', 'BA', '387', 'phone_country_code', '1', 'default', '', '波黑', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('150', 'BD', '880', 'phone_country_code', '1', 'default', '', '孟加拉国', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('160', 'BE', '32', 'phone_country_code', '1', 'default', '', '比利时', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('170', 'BF', '226', 'phone_country_code', '1', 'default', '', '布基纳法索', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('180', 'BG', '359', 'phone_country_code', '1', 'default', '', '保加利亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('190', 'BH', '973', 'phone_country_code', '1', 'default', '', '巴林', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('200', 'BI', '257', 'phone_country_code', '1', 'default', '', '布隆迪', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('210', 'BJ', '229', 'phone_country_code', '1', 'default', '', '贝宁', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('220', 'BN', '673', 'phone_country_code', '1', 'default', '', '文莱', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('230', 'BO', '591', 'phone_country_code', '1', 'default', '', '玻利维亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('240', 'BR', '55', 'phone_country_code', '1', 'default', '', '巴西', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('250', 'BT', '975', 'phone_country_code', '1', 'default', '', '不丹', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('260', 'BW', '267', 'phone_country_code', '1', 'default', '', '博茨瓦纳', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('270', 'BY', '375', 'phone_country_code', '1', 'default', '', '白俄罗斯', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('280', 'BZ', '501', 'phone_country_code', '1', 'default', '', '伯利兹', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('290', 'CD', '243', 'phone_country_code', '1', 'default', '', '刚果民主共和国', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('300', 'CF', '236', 'phone_country_code', '1', 'default', '', '中非共和国', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('310', 'CG', '242', 'phone_country_code', '1', 'default', '', '刚果共和国', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('320', 'CH', '41', 'phone_country_code', '1', 'default', '', '瑞士', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('330', 'CI', '225', 'phone_country_code', '1', 'default', '', '科特迪瓦', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('340', 'CK', '682', 'phone_country_code', '1', 'default', '', '库克群岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('350', 'CL', '56', 'phone_country_code', '1', 'default', '', '智利', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('360', 'CM', '237', 'phone_country_code', '1', 'default', '', '喀麦隆', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('370', 'CN', '86', 'phone_country_code', '1', 'primary', '', '中国', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('380', 'CO', '57', 'phone_country_code', '1', 'default', '', '哥伦比亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('390', 'CR', '506', 'phone_country_code', '1', 'default', '', '哥斯达黎加', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('400', 'CU', '53', 'phone_country_code', '1', 'default', '', '古巴', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('410', 'CV', '238', 'phone_country_code', '1', 'default', '', '佛得角', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('420', 'CW', '599', 'phone_country_code', '1', 'default', '', '库拉索', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('430', 'CY', '357', 'phone_country_code', '1', 'default', '', '塞浦路斯', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('440', 'CZ', '420', 'phone_country_code', '1', 'default', '', '捷克', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('450', 'DE', '49', 'phone_country_code', '1', 'default', '', '德国', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('460', 'DJ', '253', 'phone_country_code', '1', 'default', '', '吉布提', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('470', 'DK', '45', 'phone_country_code', '1', 'default', '', '丹麦', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('480', 'DZ', '213', 'phone_country_code', '1', 'default', '', '阿尔及利亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('490', 'EC', '593', 'phone_country_code', '1', 'default', '', '厄瓜多尔', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('500', 'EE', '372', 'phone_country_code', '1', 'default', '', '爱沙尼亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('510', 'EG', '20', 'phone_country_code', '1', 'default', '', '埃及', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('520', 'ER', '291', 'phone_country_code', '1', 'default', '', '厄立特里亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('530', 'ES', '34', 'phone_country_code', '1', 'default', '', '西班牙', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('540', 'ET', '251', 'phone_country_code', '1', 'default', '', '埃塞俄比亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('550', 'FI', '358', 'phone_country_code', '1', 'default', '', '芬兰', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('560', 'FJ', '679', 'phone_country_code', '1', 'default', '', '斐济', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('570', 'FK', '500', 'phone_country_code', '1', 'default', '', '福克兰群岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('580', 'FM', '691', 'phone_country_code', '1', 'default', '', '密克罗尼西亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('590', 'FO', '298', 'phone_country_code', '1', 'default', '', '法罗群岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('600', 'FR', '33', 'phone_country_code', '1', 'default', '', '法国', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('610', 'GA', '241', 'phone_country_code', '1', 'default', '', '加蓬', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('620', 'GB', '44', 'phone_country_code', '1', 'default', '', '英国', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('630', 'GE', '995', 'phone_country_code', '1', 'default', '', '格鲁吉亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('640', 'GF', '594', 'phone_country_code', '1', 'default', '', '法属圭亚那', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('650', 'GH', '233', 'phone_country_code', '1', 'default', '', '加纳', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('660', 'GI', '350', 'phone_country_code', '1', 'default', '', '直布罗陀', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('670', 'GL', '299', 'phone_country_code', '1', 'default', '', '格陵兰', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('680', 'GM', '220', 'phone_country_code', '1', 'default', '', '冈比亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('690', 'GN', '224', 'phone_country_code', '1', 'default', '', '几内亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('700', 'GP', '590', 'phone_country_code', '1', 'default', '', '瓜德罗普', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('710', 'GQ', '240', 'phone_country_code', '1', 'default', '', '赤道几内亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('720', 'GR', '30', 'phone_country_code', '1', 'default', '', '希腊', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('730', 'GT', '502', 'phone_country_code', '1', 'default', '', '危地马拉', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('740', 'GW', '245', 'phone_country_code', '1', 'default', '', '几内亚比绍', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('750', 'GY', '592', 'phone_country_code', '1', 'default', '', '圭亚那', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('760', 'HK', '852', 'phone_country_code', '1', 'default', '', '中国香港', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('770', 'HN', '504', 'phone_country_code', '1', 'default', '', '洪都拉斯', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('780', 'HR', '385', 'phone_country_code', '1', 'default', '', '克罗地亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('790', 'HT', '509', 'phone_country_code', '1', 'default', '', '海地', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('800', 'HU', '36', 'phone_country_code', '1', 'default', '', '匈牙利', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('810', 'ID', '62', 'phone_country_code', '1', 'default', '', '印度尼西亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('820', 'IE', '353', 'phone_country_code', '1', 'default', '', '爱尔兰', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('830', 'IL', '972', 'phone_country_code', '1', 'default', '', '以色列', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('840', 'IN', '91', 'phone_country_code', '1', 'default', '', '印度', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('850', 'IO', '246', 'phone_country_code', '1', 'default', '', '英属印度洋领地', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('860', 'IQ', '964', 'phone_country_code', '1', 'default', '', '伊拉克', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('870', 'IR', '98', 'phone_country_code', '1', 'default', '', '伊朗', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('880', 'IS', '354', 'phone_country_code', '1', 'default', '', '冰岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('890', 'IT', '39', 'phone_country_code', '1', 'default', '', '意大利', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('900', 'JM', '1876', 'phone_country_code', '1', 'default', '', '牙买加', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('905', 'JO', '962', 'phone_country_code', '1', 'default', '', '约旦', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('910', 'JP', '81', 'phone_country_code', '1', 'default', '', '日本', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('920', 'KE', '254', 'phone_country_code', '1', 'default', '', '肯尼亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('930', 'KG', '996', 'phone_country_code', '1', 'default', '', '吉尔吉斯斯坦', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('940', 'KH', '855', 'phone_country_code', '1', 'default', '', '柬埔寨', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('950', 'KI', '686', 'phone_country_code', '1', 'default', '', '基里巴斯', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('960', 'KM', '269', 'phone_country_code', '1', 'default', '', '科摩罗', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('970', 'KN', '1869', 'phone_country_code', '1', 'default', '', '圣基茨和尼维斯', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('975', 'KP', '850', 'phone_country_code', '1', 'default', '', '朝鲜', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('980', 'KR', '82', 'phone_country_code', '1', 'default', '', '韩国', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('990', 'KW', '965', 'phone_country_code', '1', 'default', '', '科威特', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1000', 'KY', '1345', 'phone_country_code', '1', 'default', '', '开曼群岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1005', 'LA', '856', 'phone_country_code', '1', 'default', '', '老挝', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1010', 'LB', '961', 'phone_country_code', '1', 'default', '', '黎巴嫩', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1020', 'LC', '1758', 'phone_country_code', '1', 'default', '', '圣卢西亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1025', 'LI', '423', 'phone_country_code', '1', 'default', '', '列支敦士登', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1030', 'LK', '94', 'phone_country_code', '1', 'default', '', '斯里兰卡', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1040', 'LR', '231', 'phone_country_code', '1', 'default', '', '利比里亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1050', 'LS', '266', 'phone_country_code', '1', 'default', '', '莱索托', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1060', 'LT', '370', 'phone_country_code', '1', 'default', '', '立陶宛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1070', 'LU', '352', 'phone_country_code', '1', 'default', '', '卢森堡', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1080', 'LV', '371', 'phone_country_code', '1', 'default', '', '拉脱维亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1090', 'LY', '218', 'phone_country_code', '1', 'default', '', '利比亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1100', 'MA', '212', 'phone_country_code', '1', 'default', '', '摩洛哥', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1110', 'MC', '377', 'phone_country_code', '1', 'default', '', '摩纳哥', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1120', 'MD', '373', 'phone_country_code', '1', 'default', '', '摩尔多瓦', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1130', 'ME', '382', 'phone_country_code', '1', 'default', '', '黑山', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1140', 'MG', '261', 'phone_country_code', '1', 'default', '', '马达加斯加', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1150', 'MH', '692', 'phone_country_code', '1', 'default', '', '马绍尔群岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1160', 'MK', '389', 'phone_country_code', '1', 'default', '', '北马其顿', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1170', 'ML', '223', 'phone_country_code', '1', 'default', '', '马里', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1180', 'MM', '95', 'phone_country_code', '1', 'default', '', '缅甸', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1190', 'MN', '976', 'phone_country_code', '1', 'default', '', '蒙古', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1200', 'MO', '853', 'phone_country_code', '1', 'default', '', '中国澳门', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1210', 'MP', '1670', 'phone_country_code', '1', 'default', '', '北马里亚纳群岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1215', 'MQ', '596', 'phone_country_code', '1', 'default', '', '马提尼克', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1220', 'MR', '222', 'phone_country_code', '1', 'default', '', '毛里塔尼亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1230', 'MS', '1664', 'phone_country_code', '1', 'default', '', '蒙特塞拉特', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1235', 'MT', '356', 'phone_country_code', '1', 'default', '', '马耳他', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1240', 'MU', '230', 'phone_country_code', '1', 'default', '', '毛里求斯', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1250', 'MV', '960', 'phone_country_code', '1', 'default', '', '马尔代夫', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1260', 'MW', '265', 'phone_country_code', '1', 'default', '', '马拉维', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1270', 'MX', '52', 'phone_country_code', '1', 'default', '', '墨西哥', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1280', 'MY', '60', 'phone_country_code', '1', 'default', '', '马来西亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1290', 'MZ', '258', 'phone_country_code', '1', 'default', '', '莫桑比克', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1300', 'NA', '264', 'phone_country_code', '1', 'default', '', '纳米比亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1310', 'NC', '687', 'phone_country_code', '1', 'default', '', '新喀里多尼亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1320', 'NE', '227', 'phone_country_code', '1', 'default', '', '尼日尔', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1330', 'NF', '672', 'phone_country_code', '1', 'default', '', '诺福克岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1330', 'NG', '234', 'phone_country_code', '1', 'default', '', '尼日利亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1340', 'NI', '505', 'phone_country_code', '1', 'default', '', '尼加拉瓜', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1350', 'NL', '31', 'phone_country_code', '1', 'default', '', '荷兰', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1360', 'NO', '47', 'phone_country_code', '1', 'default', '', '挪威', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1370', 'NP', '977', 'phone_country_code', '1', 'default', '', '尼泊尔', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1380', 'NR', '674', 'phone_country_code', '1', 'default', '', '瑙鲁', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1390', 'NU', '683', 'phone_country_code', '1', 'default', '', '纽埃', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1400', 'NZ', '64', 'phone_country_code', '1', 'default', '', '新西兰', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1410', 'OM', '968', 'phone_country_code', '1', 'default', '', '阿曼', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1420', 'PA', '507', 'phone_country_code', '1', 'default', '', '巴拿马', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1430', 'PE', '51', 'phone_country_code', '1', 'default', '', '秘鲁', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1440', 'PF', '689', 'phone_country_code', '1', 'default', '', '法属波利尼西亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1450', 'PG', '675', 'phone_country_code', '1', 'default', '', '巴布亚新几内亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1460', 'PH', '63', 'phone_country_code', '1', 'default', '', '菲律宾', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1470', 'PK', '92', 'phone_country_code', '1', 'default', '', '巴基斯坦', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1480', 'PL', '48', 'phone_country_code', '1', 'default', '', '波兰', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1490', 'PM', '508', 'phone_country_code', '1', 'default', '', '圣皮埃尔和密克隆', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1500', 'PN', '870', 'phone_country_code', '1', 'default', '', '皮特凯恩群岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1502', 'PR', '1787', 'phone_country_code', '1', 'default', '', '波多黎各', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1504', 'PS', '970', 'phone_country_code', '1', 'default', '', '巴勒斯坦', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1510', 'PT', '351', 'phone_country_code', '1', 'default', '', '葡萄牙', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1520', 'PW', '680', 'phone_country_code', '1', 'default', '', '帕劳', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1530', 'PY', '595', 'phone_country_code', '1', 'default', '', '巴拉圭', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1540', 'QA', '974', 'phone_country_code', '1', 'default', '', '卡塔尔', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1550', 'RE', '262', 'phone_country_code', '1', 'default', '', '留尼汪', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1560', 'RO', '40', 'phone_country_code', '1', 'default', '', '罗马尼亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1570', 'RS', '381', 'phone_country_code', '1', 'default', '', '塞尔维亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1580', 'RU', '7', 'phone_country_code', '1', 'default', '', '俄罗斯/哈萨克斯坦', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1590', 'RW', '250', 'phone_country_code', '1', 'default', '', '卢旺达', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1600', 'SA', '966', 'phone_country_code', '1', 'default', '', '沙特阿拉伯', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1610', 'SB', '677', 'phone_country_code', '1', 'default', '', '所罗门群岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1620', 'SC', '248', 'phone_country_code', '1', 'default', '', '塞舌尔', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1630', 'SD', '249', 'phone_country_code', '1', 'default', '', '苏丹', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1640', 'SE', '46', 'phone_country_code', '1', 'default', '', '瑞典', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1650', 'SG', '65', 'phone_country_code', '1', 'default', '', '新加坡', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1660', 'SH', '290', 'phone_country_code', '1', 'default', '', '圣赫勒拿', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1670', 'SI', '386', 'phone_country_code', '1', 'default', '', '斯洛文尼亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1680', 'SK', '421', 'phone_country_code', '1', 'default', '', '斯洛伐克', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1690', 'SL', '232', 'phone_country_code', '1', 'default', '', '塞拉利昂', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1700', 'SM', '378', 'phone_country_code', '1', 'default', '', '圣马力诺', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1710', 'SN', '221', 'phone_country_code', '1', 'default', '', '塞内加尔', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1720', 'SO', '252', 'phone_country_code', '1', 'default', '', '索马里', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1730', 'SR', '597', 'phone_country_code', '1', 'default', '', '苏里南', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1740', 'SS', '211', 'phone_country_code', '1', 'default', '', '南苏丹', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1745', 'ST', '239', 'phone_country_code', '1', 'default', '', '圣多美和普林西比', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1750', 'SV', '503', 'phone_country_code', '1', 'default', '', '萨尔瓦多', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1760', 'SX', '1721', 'phone_country_code', '1', 'default', '', '荷属圣马丁', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1765', 'SY', '963', 'phone_country_code', '1', 'default', '', '叙利亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1770', 'SZ', '268', 'phone_country_code', '1', 'default', '', '斯威士兰', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1780', 'TC', '1649', 'phone_country_code', '1', 'default', '', '特克斯和凯科斯群岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1780', 'TD', '235', 'phone_country_code', '1', 'default', '', '乍得', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1790', 'TF', '262', 'phone_country_code', '1', 'default', '', '法属南部领地', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1795', 'TG', '228', 'phone_country_code', '1', 'default', '', '多哥', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1800', 'TH', '66', 'phone_country_code', '1', 'default', '', '泰国', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1810', 'TJ', '992', 'phone_country_code', '1', 'default', '', '塔吉克斯坦', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1820', 'TK', '690', 'phone_country_code', '1', 'default', '', '托克劳', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1830', 'TL', '670', 'phone_country_code', '1', 'default', '', '东帝汶', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1840', 'TM', '993', 'phone_country_code', '1', 'default', '', '土库曼斯坦', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1850', 'TN', '216', 'phone_country_code', '1', 'default', '', '突尼斯', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1860', 'TO', '676', 'phone_country_code', '1', 'default', '', '汤加', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1870', 'TR', '90', 'phone_country_code', '1', 'default', '', '土耳其', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1880', 'TT', '1868', 'phone_country_code', '1', 'default', '', '特立尼达和多巴哥', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1880', 'TV', '688', 'phone_country_code', '1', 'default', '', '图瓦卢', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1890', 'TW', '886', 'phone_country_code', '1', 'default', '', '中国台湾', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1900', 'TZ', '255', 'phone_country_code', '1', 'default', '', '坦桑尼亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1910', 'UA', '380', 'phone_country_code', '1', 'default', '', '乌克兰', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1920', 'UG', '256', 'phone_country_code', '1', 'default', '', '乌干达', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1930', 'US', '1', 'phone_country_code', '1', 'default', '', '美国/加拿大', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1940', 'UY', '598', 'phone_country_code', '1', 'default', '', '乌拉圭', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1950', 'UZ', '998', 'phone_country_code', '1', 'default', '', '乌兹别克斯坦', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1960', 'VA', '379', 'phone_country_code', '1', 'default', '', '梵蒂冈', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1970', 'VC', '1784', 'phone_country_code', '1', 'default', '', '圣文森特和格林纳丁斯', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1975', 'VE', '58', 'phone_country_code', '1', 'default', '', '委内瑞拉', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1980', 'VG', '1284', 'phone_country_code', '1', 'default', '', '英属维尔京群岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1983', 'VI', '1340', 'phone_country_code', '1', 'default', '', '美属维尔京群岛', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1986', 'VN', '84', 'phone_country_code', '1', 'default', '', '越南', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('1990', 'VU', '678', 'phone_country_code', '1', 'default', '', '瓦努阿图', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('2000', 'WF', '681', 'phone_country_code', '1', 'default', '', '瓦利斯和富图纳', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('2010', 'WS', '685', 'phone_country_code', '1', 'default', '', '萨摩亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('2020', 'XK', '383', 'phone_country_code', '1', 'default', '', '科索沃', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('2030', 'YE', '967', 'phone_country_code', '1', 'default', '', '也门', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('2040', 'YT', '262', 'phone_country_code', '1', 'default', '', '马约特', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('2045', 'ZA', '27', 'phone_country_code', '1', 'default', '', '南非', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('2050', 'ZM', '260', 'phone_country_code', '1', 'default', '', '赞比亚', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('2060', 'ZW', '263', 'phone_country_code', '1', 'default', '', '津巴布韦', '1', NULL, 'system', NOW(), 'system', NOW(), b'0');

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('0', '开启', '1', 'common_status', '1', '', '', NULL, '1', 'c-system', 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ('0', '关闭', '0', 'common_status', '1', '', '', NULL, '1', 'c-system', 'system', NOW(), 'system', NOW(), b'0');

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ( 0, '本地磁盘', '10', 'storage_type', '1', '', '', '', 1, '', 'system', NOW(), 'system', NOW(), b'0');
INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `is_sync`, `app_code`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES ( 1, 'S3 对象存储', '20', 'storage_type', '1', '', '', '', 1, '', 'system', NOW(), 'system', NOW(), b'0');




INSERT INTO `system_users`
VALUES ('1', 'sys_xmkj_admin', '$2a$10$LdObNZd89LEO/AIeJA.wsekmBJP.pmaiQL8tscJUMGu0cU7WsxbzC', '超级管理员', '超级管理员', '103', '',
        '', '', NULL,NULL, '1', 'http://192.168.1.183:9000/cloud-bucket/system/a2e305e6cdc43223cc631598b8391e04.jpeg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=minioadmin%2F20251016%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20251016T055910Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=d08577fa7b9cb3303e684d14fea35a4df7aa57338f06e46f63039f8b2ed6d2d5',
        '1', '192.168.1.83', NOW(), 'admin', NOW(), NULL, NOW(), b'0', '1');

INSERT INTO `system_role`
VALUES (1, '超级管理员', 'super_admin', 1, 1, '', 1, 1, '超级管理员', 'admin', NOW(), '',
        NOW(), b'0', 1);

INSERT INTO `system_user_role`
VALUES (1, 1, 1, '', NOW(), '', NOW(), b'0', 1);

INSERT INTO `system_oauth2_client`
VALUES (1, 'default', 'admin123', '芋道源码', 'http://test.yudao.iocoder.cn/20250502/sort2_1746189740718.png',
        '我是描述', 1, 1800, 1800, '["https://www.iocoder.cn","https://doc.iocoder.cn"]',
        '["password","authorization_code","implicit","refresh_token"]', '["user.read","user.write"]', '[]',
        '["user.read","user.write"]', '[]', '{}', '1', NOW(), '1', NOW(), b'0');




INSERT INTO `infra_config` (`id`, `category`, `type`, `name`, `config_key`, `value`, `visible`, `remark`, `creator`,
                            `create_time`, `updater`, `update_time`, `deleted`)
VALUES (2, 'biz', 1, '用户管理-账号初始密码', 'system.user.init-password', 'abc@123', b'0', '初始化密码 abc@123', 'admin',
        NOW(), '1', NOW(), b'0');
INSERT INTO `infra_config` (`id`, `category`, `type`, `name`, `config_key`, `value`, `visible`, `remark`, `creator`,
                            `create_time`, `updater`, `update_time`, `deleted`)
VALUES (101, 'branding', 1, '品牌视图-系统名称', 'branding.name', '', b'0', NULL, '', NOW(), '',
        NOW(), b'0');
INSERT INTO `infra_config` (`id`, `category`, `type`, `name`, `config_key`, `value`, `visible`, `remark`, `creator`,
                            `create_time`, `updater`, `update_time`, `deleted`)
VALUES (102, 'branding', 1, '品牌视图-系统logo', 'branding.logo', '', b'0', NULL, '', NOW(), '',
        NOW(), b'0');
INSERT INTO `infra_config` (`id`, `category`, `type`, `name`, `config_key`, `value`, `visible`, `remark`, `creator`,
                            `create_time`, `updater`, `update_time`, `deleted`)
VALUES (103, 'branding', 1, '品牌视图-浏览器页签', 'branding.icon', '', b'0', NULL, '', NOW(), '',
        NOW(), b'0');
INSERT INTO `infra_config` (`id`, `category`, `type`, `name`, `config_key`, `value`, `visible`, `remark`, `creator`,
                            `create_time`, `updater`, `update_time`, `deleted`)
VALUES (104, 'branding', 1, '品牌视图-加载图', 'branding.loading', '', b'0', NULL, '', NOW(), '',
        NOW(), b'0');
INSERT INTO `infra_config` (`id`, `category`, `type`, `name`, `config_key`, `value`, `visible`, `remark`, `creator`,
                            `create_time`, `updater`, `update_time`, `deleted`)
VALUES (105, 'branding', 1, '品牌视图-登录背景', 'branding.background', '', b'0', NULL, '', NOW(), '',
        NOW(), b'0');

INSERT INTO `infra_config` (`category`, `type`, `name`, `config_key`, `value`, `visible`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES ('map', 1,'地图配置', 'map.config', '{"provider":"","serviceKey":"","secureKey":"","centerLng":116.397428,"centerLat":39.90923,"initialZoom":10}',
        b'0', '地图默认配置', 'system', NOW(), 'system', NOW(), b'0');

INSERT INTO `c-system`.`infra_file_config` (`id`, `name`, `storage`, `remark`, `master`, `config`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES (1, '本地', 10, '', b'1', '{\"@class\":\"com.xmkj.common.system.infra.core.framework.file.core.client.local.LocalFileClientConfig\",\"basePath\":\"/app/files\",\"domain\":\"http://192.168.1.108\"}', '1', NOW(), '1', NOW(), b'0');
COMMIT;

-- 恢复设置
SET autocommit=1;
SET unique_checks=1;
SET foreign_key_checks=1;
