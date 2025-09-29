# 环境部署

## 准备工作

~~~
JDK >= 1.8 (推荐1.8版本)
Mysql >= 5.7.0 (推荐5.7版本)
Redis >= 3.0
Maven >= 3.0
Node >= 10
~~~

::: tip 提示
前端安装完node后，最好设置下淘宝的镜像源，不建议使用cnpm（可能会出现奇怪的问题）
:::


## 运行系统

前往`Gitee`下载页面([https://gitee.com/y_project/RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue))下载解压到工作目录  

### 后端运行

1、导入到`Eclipse`，菜单 `File` -> `Import`，然后选择 `Maven` -> `Existing Maven Projects`，点击 `Next`> 按钮，选择工作目录，然后点击 `Finish` 按钮，即可成功导入。  
`Eclipse`会自动加载`Maven`依赖包，初次加载会比较慢（根据自身网络情况而定）  
2、创建数据库`ry-vue`并导入数据脚本`ry_2021xxxx.sql`，`quartz.sql`  
3、打开项目运行`com.ruoyi.RuoYiApplication.java`，出现如下图表示启动成功。 
```
(♥◠‿◠)ﾉﾞ  若依启动成功   ლ(´ڡ`ლ)ﾞ  
 .-------.       ____     __        
 |  _ _   \      \   \   /  /    
 | ( ' )  |       \  _. /  '       
 |(_ o _) /        _( )_ .'         
 | (_,_).' __  ___(_ o _)'          
 |  |\ \  |  ||   |(_,_)'         
 |  | \ `'   /|   `-'  /           
 |  |  \    /  \      /           
 ''-'   `'-'    `-..-'    
``` 

::: tip 提示
后端运行成功可以通过([http://localhost:8080](http://localhost:8080))访问，但是不会出现静态页面，可以继续参考下面步骤部署`ruoyi-ui`前端，然后通过前端地址来访问。
:::


### 前端运行

```bash
# 进入项目目录
cd ruoyi-ui

# 安装依赖
npm install

# 强烈建议不要用直接使用 cnpm 安装，会有各种诡异的 bug，可以通过重新指定 registry 来解决 npm 安装速度慢的问题。
npm install --registry=https://registry.npm.taobao.org

# 本地开发 启动项目
npm run dev
```

4、打开浏览器，输入：([http://localhost:80](http://localhost:80)) 默认账户/密码 `admin/admin123`）  
若能正确展示登录页面，并能成功登录，菜单及页面展示正常，则表明环境搭建成功  

建议使用`Git`克隆，因为克隆的方式可以和`RuoYi`随时保持更新同步。使用`Git`命令克隆  
```
git clone https://gitee.com/y_project/RuoYi-Vue.git
```

::: tip 提示
因为本项目是前后端完全分离的，所以需要前后端都单独启动好，才能进行访问。  
前端安装完node后，最好设置下淘宝的镜像源，不建议使用cnpm（可能会出现奇怪的问题）
:::

## 必要配置

* 修改数据库连接，编辑`resources`目录下的`application-druid.yml`
``` yml {9-11}
# 数据源配置
spring:
    datasource:
        type: com.alibaba.druid.pool.DruidDataSource
        driverClassName: com.mysql.cj.jdbc.Driver
        druid:
            # 主库数据源
            master:
                url: 数据库地址
                username: 数据库账号
                password: 数据库密码
```
   
* 修改服务器配置，`编辑resources目录下的application.yml`
``` yml {4-7}
# 开发环境配置
server:
  # 服务器的HTTP端口，默认为80
  port: 端口
  servlet:
    # 应用的访问路径
    context-path: /应用路径
```


## 部署系统

::: tip 提示
因为本项目是前后端完全分离的，所以需要前后端都单独部署好，才能进行访问。
:::

### 后端部署

* 打包工程文件

在`ruoyi`项目的`bin`目录下执行`package.bat`打包Web工程，生成war/jar包文件。  
然后会在项目下生成`target`文件夹包含`war`或`jar`
::: tip 提示
多模块版本会生成在`ruoyi/ruoyi-admin`模块下`target`文件夹
:::

* 部署工程文件
 
1、jar部署方式  
   使用命令行执行：`java –jar ruoyi.jar` 或者执行脚本：`ruoyi/bin/run.bat`  

2、war部署方式  
   `ruoyi/pom.xml`中的`packaging`修改为`war`，放入`tomcat`服务器`webapps`
``` xml
   <packaging>war</packaging>
```
::: tip 提示
多模块版本在`ruoyi/ruoyi-admin`模块下修改`pom.xml`
:::

* `SpringBoot`去除内嵌`Tomcat`（PS：此步骤不重要，因为不排除也能在容器中部署`war`）

```xml
<!-- 多模块排除内置tomcat -->
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-web</artifactId>
	<exclusions>
		<exclusion>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-tomcat</artifactId>
		</exclusion>
	</exclusions>
</dependency>
		
<!-- 单应用排除内置tomcat -->		
<exclusions>
	<exclusion>
		<artifactId>spring-boot-starter-tomcat</artifactId>
		<groupId>org.springframework.boot</groupId>
	</exclusion>
</exclusions>
```

### 前端部署

当项目开发完毕，只需要运行一行命令就可以打包你的应用

```bash
# 打包正式环境
npm run build:prod

# 打包预发布环境
npm run build:stage
```

构建打包成功之后，会在根目录生成 `dist` 文件夹，里面就是构建打包好的文件，通常是 `***.js` 、`***.css`、`index.html` 等静态文件。

通常情况下 `dist` 文件夹的静态文件发布到你的 nginx 或者静态服务器即可，其中的 `index.html` 是后台服务的入口页面。

::: tip outputDir 提示
如果需要自定义构建，比如指定 `dist` 目录等，则需要通过 [config](https://gitee.com/y_project/RuoYi-Vue/blob/master/ruoyi-ui/vue.config.js)的 `outputDir` 进行配置。
:::

::: tip publicPath 提示
部署时改变页面js 和 css 静态引入路径 ,只需修改 `vue.config.js` 文件资源路径即可。
```js
publicPath: './' //请根据自己路径来配置更改
```

```js
export default new Router({
  mode: 'hash', // hash模式
})
```
:::


## 环境变量

所有测试环境或者正式环境变量的配置都在 [.env.development](https://gitee.com/y_project/RuoYi-Vue/blob/master/ruoyi-ui/.env.development)等 `.env.xxxx`文件中。

它们都会通过 `webpack.DefinePlugin` 插件注入到全局。

::: tip 注意！！！
环境变量必须以`VUE_APP_`为开头。如:`VUE_APP_API`、`VUE_APP_TITLE`

你在代码中可以通过如下方式获取:

```js
console.log(process.env.VUE_APP_xxxx)
```

:::

<br>

## Tomcat配置

修改`server.xml`，`Host`节点下添加
```xml
<Context docBase="" path="/" reloadable="true" source=""/>
```

`dist`目录的文件夹下新建`WEB-INF`文件夹，并在里面添加`web.xml`文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" 
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
        http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
        version="3.1" metadata-complete="true">
     <display-name>Router for Tomcat</display-name>
     <error-page>
        <error-code>404</error-code>
        <location>/index.html</location>
    </error-page>
</web-app>
```

## Nginx配置

```conf
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;

		location / {
            root   /home/ruoyi/projects/ruoyi-ui;
			try_files $uri $uri/ /index.html;
            index  index.html index.htm;
        }
		
		location /prod-api/{
			proxy_set_header Host $http_host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header REMOTE-HOST $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_pass http://localhost:8080/;
		}

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}
```

::: details 建议开启Gzip压缩
在`http.server`中加入如下代码对相应的资源进行压缩，可以减少文件体积和加快网页访问速度。
```conf
# 开启gzip压缩
gzip on;
# 不压缩临界值，大于1K的才压缩，一般不用改
gzip_min_length 1k;
# 压缩缓冲区
gzip_buffers 16 64K;
# 压缩版本（默认1.1，前端如果是squid2.5请使用1.0）
gzip_http_version 1.1;
# 压缩级别，1-10，数字越大压缩的越好，时间也越长
gzip_comp_level 5;
# 进行压缩的文件类型
gzip_types text/plain application/x-javascript text/css application/xml application/javascript;
# 跟Squid等缓存服务有关，on的话会在Header里增加"Vary: Accept-Encoding"
gzip_vary on;
# IE6对Gzip不怎么友好，不给它Gzip了
gzip_disable "MSIE [1-6]\.";
```
:::
<br>

## 常见问题

1. 如果使用`Mac`需要修改`application.yml`文件路径`profile`
2. 如果使用`Linux` 提示表不存在，设置大小写敏感配置在`/etc/my.cnf`添加`lower_case_table_names=1`，重启MYSQL服务
3. 如果提示当前权限不足，无法写入文件请检查`application.yml`中的`profile`路径或`logback.xml`中的`log.path`路径是否有可读可写操作权限

如遇到无法解决的问题请到[Issues](https://gitee.com/y_project/RuoYi-Vue/issues)反馈，会不定时进行解答。