#!/usr/bin/env sh
# 兼容 bash 和 zsh 的安装脚本

echo
echo "[信息] 安装 Web 工程，生成 node_modules 文件。"
echo

# 切换到脚本所在目录
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$SCRIPT_DIR/.." || exit 1

# 安装依赖，使用 npmmirror 源
npm install --registry=https://registry.npmmirror.com

# 暂停等待用户回车（可选，模拟 Windows 的 pause）
printf "\n安装完成，按回车键退出..."
read dummy
