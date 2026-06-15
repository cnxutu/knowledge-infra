#!/bin/bash
set -e
usage() {
    echo "用法: $0 <关键词> [日志目录] [文件匹配模式] [上下文行数]"
    echo ""
    echo "参数:"
    echo "  关键词          搜索关键词（必填）"
    echo "  日志目录        搜索目录（默认: 当前目录）"
    echo "  文件匹配模式    文件过滤（默认: *.log）"
    echo "  上下文行数      显示匹配后行数（默认: 100）"
    echo ""
    echo "示例:"
    echo "  $0 '2406765d-c9fa-405c-98f9-0d48c86590f6'"
    echo "  $0 'ERROR' /var/logs 'error.log' 50"
    exit 1
}
if [ $# -lt 1 ]; then
    usage
fi
KEYWORD="$1"
LOG_DIR="${2:-.}"
FILE_PATTERN="${3:-*error.log}"
CONTEXT="${4:-100}"
echo "============================================"
echo "搜索关键词: $KEYWORD"
echo "搜索目录:   $LOG_DIR"
echo "文件模式:   $FILE_PATTERN"
echo "上下文行数: $CONTEXT"
echo "============================================"
echo ""
grep -r "$KEYWORD" "$LOG_DIR" -A "$CONTEXT" --include="$FILE_PATTERN" 2>/dev/null | \
    awk -v keyword="$KEYWORD" '
    BEGIN { 
        RS = "" 
        count = 0
    }
    $0 ~ keyword { 
        count++
        print $0
        print "\n--------------------------------------------\n"
    }
    END { 
        print "共找到 " count " 个匹配项"
    }
'
