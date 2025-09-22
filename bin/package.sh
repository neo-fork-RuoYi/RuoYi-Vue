#!/bin/sh

echo
echo "[信息] 打包 Web 工程，生成 war/jar 包文件。"
echo

# 切换到脚本所在目录
cd "$(dirname "$0")" || exit 1

# 切换到上一级目录
cd .. || exit 1

# 执行 maven 打包（跳过测试）
mvn clean package -Dmaven.test.skip=true

# 模拟 pause，等待用户回车
echo
read -r -p "按回车键继续..."