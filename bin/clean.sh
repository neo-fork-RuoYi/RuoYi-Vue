#!/bin/sh

echo
echo "[信息] 清理工程 target 生成路径。"
echo

# 切换到脚本所在目录
cd "$(dirname "$0")" || exit 1

# 切换到上一级目录
cd .. || exit 1

# 执行 maven clean
mvn clean

# 等待用户按回车后退出
echo
read -r -p "按回车键继续..."