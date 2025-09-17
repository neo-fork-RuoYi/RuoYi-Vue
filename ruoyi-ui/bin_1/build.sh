#!/usr/bin/env sh
# 兼容 bash 和 zsh

echo
echo "[信息] 打包 Web 工程，生成 dist 文件。"
echo

# 切换到脚本所在目录
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$SCRIPT_DIR/.." || exit 1

# 执行构建
npm run build:prod

# 暂停等待用户回车
printf "\n按回车键继续..."
# 这里用 `read`，sh/zsh/bash 都兼容
read dummy