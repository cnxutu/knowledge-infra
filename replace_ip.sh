#!/bin/bash

OLD_IP="192.168.1.108"

echo "🔍 正在搜索包含 '$OLD_IP' 的文件（已排除 logs, .git, log, data）..."
echo "----------------------------------------"

# 第一步：获取纯文件列表（用于后续替换）
files=$(grep -rl --exclude-dir={apps,logs,.git,log,data} "$OLD_IP" . | sort)

if [ -z "$files" ]; then
    echo "✅ 未找到包含 '$OLD_IP' 的文件。"
    exit 0
fi

# 第二步：展示具体匹配内容（带文件名和行号）
echo "📄 将被替换的内容预览："
echo "----------------------------------------"
grep -rn --exclude-dir={apps,logs,.git,log,data} "$OLD_IP" .
echo "----------------------------------------"
echo "共涉及 $(echo "$files" | wc -l) 个文件。"

# 第三步：提示用户输入新 IP
read -p "请输入要替换成的新 IP 地址: " NEW_IP

if [ -z "$NEW_IP" ]; then
    echo "❌ 新 IP 不能为空。退出。"
    exit 1
fi

echo "🔄 即将把 '$OLD_IP' 替换为 '$NEW_IP' ..."

# 第四步：执行替换（使用纯文件列表）
echo "$files" | xargs sed -i "s/$OLD_IP/$NEW_IP/g"

echo "✅ 替换完成！"

# 第五步：验证结果
echo "🔍 验证替换后的内容："
echo "----------------------------------------"
grep -rn --exclude-dir={apps,logs,.git,log,data} "$NEW_IP" .
echo "----------------------------------------"
echo "💡 建议运行 'git diff' 查看详细变更。"
