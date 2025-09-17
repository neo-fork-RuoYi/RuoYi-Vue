#!/usr/bin/env sh
# 兼容 bash 和 zsh 的启动脚本

echo
echo "[信息] 使用 Vue CLI 命令运行 Web 工程。"
echo

# 切换到脚本所在目录
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd "$SCRIPT_DIR/.." || exit 1

# 启动开发服务
npm run dev

# 暂停等待用户回车（可选，模拟 Windows 的 pause）
printf "\n运行结束，按回车键退出..."
read dummy