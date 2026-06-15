# 运维助手

## 临时记住git用户信息
git config --global credential.helper 'cache --timeout=28800'


# 日志查询常用命令

## 递归查询所有 log 文件中的关键字

```bash
# 基本查询 - 递归查找多个目录下的所有 log 文件
grep -rn "关键字" --include="*.log" /dir1 /dir2 /dir3

# 忽略大小写
grep -rin "keyword" --include="*.log" /dir1 /dir2

# 多关键字查询 (OR关系)
grep -rn -E "ERROR|WARN" --include="*.log" /dir1 /dir2

# 排除特定目录
grep -rn "keyword" --include="*.log" --exclude-dir=target /dir1 /dir2

# 查询并显示上下文 (前3行和后3行)
grep -rn -C 3 "keyword" --include="*.log" /dir1 /dir2

# 结合压缩日志查询
grep -rn "keyword" --include="*.log" /dir1 /dir2
zgrep -rn "keyword" /dir1 /dir2/**/*.log.gz

# 统计匹配行数量
grep -rc "keyword" --include="*.log" /dir1 /dir2
```

## 参数说明

- `-r`: 递归遍历子目录
- `-n`: 显示匹配行的行号
- `-i`: 忽略大小写差异
- `-E`: 使用扩展正则表达式
- `-C`: 显示匹配行上下文(前后各N行)
- `-c`: 只输出匹配行的数量
- `--include="*.log"`: 只搜索指定模式的文件
- `--exclude-dir=target`: 排除特定目录