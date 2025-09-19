#!/usr/bin/env sh
# 兼容 bash 和 zsh 的菜单脚本

# 开启所需端口
port() {
	firewall-cmd --add-port=80/tcp --permanent
	firewall-cmd --add-port=8080/tcp --permanent
	firewall-cmd --add-port=8848/tcp --permanent
	firewall-cmd --add-port=9848/tcp --permanent
	firewall-cmd --add-port=9849/tcp --permanent
	firewall-cmd --add-port=6379/tcp --permanent
	firewall-cmd --add-port=3306/tcp --permanent
	firewall-cmd --add-port=9100/tcp --permanent
	firewall-cmd --add-port=9200/tcp --permanent
	firewall-cmd --add-port=9201/tcp --permanent
	firewall-cmd --add-port=9202/tcp --permanent
	firewall-cmd --add-port=9203/tcp --permanent
	firewall-cmd --add-port=9300/tcp --permanent
	service firewalld restart
}

# 启动基础环境（必须）
base() {
	docker-compose up -d redis redisinsight mysql phpmyadmin
}

# 启动程序模块（必须）
modules() {
	docker-compose up -d ruoyi-admin ruoyi-app
}

nginx(){
	docker-compose up -d webadmin webmobile
}


# 关闭所有环境/模块
stop() {
	docker-compose stop
}

# 删除所有环境/模块
rm() {
	docker-compose rm
}

menu() {
	echo "========================"
	echo "  RuoYi 服务管理菜单"
	echo "========================"
	echo "1) 启动 port 服务"
	echo "2) 启动 base 服务"
	echo "3) 启动 modules 服务"
	echo "4) 启动 nginx 服务"	
	echo "5) 停止所有服务"
	echo "6) 删除所有服务"
	echo "0) 退出"
	echo "========================"
}

while true; do
	menu
	printf "👉 请选择操作: "
	read choice

	case "$choice" in
	1)
		echo "[执行] 启动 port 服务..."
		port
		;;
	2)
		echo "[执行] 启动 base 服务..."
		base
		;;
	3)
		echo "[执行] 启动 modules 服务..."
		modules
		;;
	4)
		echo "[执行] 启动 nginx 服务..."
		nginx
		;;		
	5)
		echo "[执行] 停止所有服务..."
		stop
		;;
	6)
		echo "[执行] 删除所有服务..."
		rm
		;;
	0)
		echo "退出脚本。"
		exit 0
		;;
	*)
		echo "❌ 无效选项，请重新选择。"
		;;
	esac
done
