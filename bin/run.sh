#!/bin/sh

echo
echo "[信息] 使用 Jar 命令运行 Web 工程。"
echo

# 切换到脚本所在目录
cd "$(dirname "$0")" || exit 1

# 进入 ruoyi-admin/target 目录
cd ../ruoyi-admin/target || exit 1

# JVM 参数
JAVA_OPTS="-Xms256m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m"

# 启动 Jar 包
java $JAVA_OPTS -jar ruoyi-admin.jar

# 回到 bin 目录
cd ../../bin || exit 1

# 模拟 pause
echo
read -r -p "按回车键继续..."