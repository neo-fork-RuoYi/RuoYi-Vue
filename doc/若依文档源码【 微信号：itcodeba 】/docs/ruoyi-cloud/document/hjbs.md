# 环境部署

## 准备工作

~~~
JDK >= 1.8 (推荐1.8版本)
Mysql >= 5.7.0 (推荐5.7版本)
Redis >= 3.0
Maven >= 3.0
Node >= 10
nacos >= 1.1.0 (ruoyi-cloud >= 3.0.0需要下载nacos >= 2.x.x版本)
sentinel >= 1.6.0
~~~


## 运行系统

### 后端运行
1、前往`Gitee`下载页面([https://gitee.com/y_project/RuoYi-Cloud](https://gitee.com/y_project/RuoYi-Cloud))下载解压到工作目录  
2、导入到`Eclipse`，菜单 `File` -> `Import`，然后选择 `Maven` -> `Existing Maven Projects`，点击 `Next`> 按钮，选择工作目录，然后点击 `Finish` 按钮，即可成功导入。  
`Eclipse`会自动加载`Maven`依赖包，初次加载会比较慢（根据自身网络情况而定）  
3、创建数据库`ry-cloud`并导入数据脚本`ry_2021xxxx.sql`（<font color=#FF0000>必须</font>），quartz.sql（<font color=#8A8A8A>可选</font>）  
4、创建数据库`ry-config`并导入数据脚本`ry_config_2021xxxx.sql`（<font color=#FF0000>必须</font>）  
5、配置`nacos`持久化，修改`conf/application.properties`文件，增加支持`mysql`数据源配置  
```yml
# db mysql
spring.datasource.platform=mysql
db.num=1
db.url.0=jdbc:mysql://localhost:3306/ry-config?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=UTC
db.user=root
db.password=password
```
::: tip 提示
配置文件`application.properties`是在下载的`nacos-server`包`conf`目录下。  
最新`RuoYi-Cloud`版本`>=3.0.0`需要下载的`nacos-server`必须`>=2.x.x`版本。  
默认配置单机模式，`nacos`集群/多集群部署模式参考 ([Nacos支持三种部署模式](https://nacos.io/zh-cn/docs/deployment.html))
:::
6、打开运行基础模块（启动没有先后顺序）
* RuoYiGatewayApplication （网关模块 <font color=#FF0000>必须</font>）
* RuoYiAuthApplication    （认证模块 <font color=#FF0000>必须</font>）
* RuoYiSystemApplication  （系统模块 <font color=#FF0000>必须</font>）
* RuoYiMonitorApplication （监控中心 <font color=#8A8A8A>可选</font>）
* RuoYiGenApplication     （代码生成 <font color=#8A8A8A>可选</font>）
* RuoYiJobApplication     （定时任务 <font color=#8A8A8A>可选</font>）
* RuoYFileApplication     （文件服务 <font color=#8A8A8A>可选</font>）

7、集成`seata`分布式事务（<font color=#8A8A8A>可选配置，默认不启用</font>）

创建数据库`ry-seata`并导入数据脚本`ry_seata_2021xxxx.sql`

[参考集成nacos配置中心](/ruoyi-cloud/cloud/seata.html#集成nacos配置中心)

::: tip 提示
运行前需要先启动`nacos`，运行成功可以通过([http://localhost:8080](http://localhost:8080))访问，但是不会出现静态页面，可以继续参考下面步骤部署`ruoyi-ui`前端，然后通过前端地址来访问。
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
git clone https://gitee.com/y_project/RuoYi-Cloud.git
```

::: tip 提示
因为本项目是前后端完全分离的，所以需要前后端都单独启动好，才能进行访问。  
前端安装完node后，最好设置下淘宝的镜像源，不建议使用cnpm（可能会出现奇怪的问题）
:::


## 部署系统

::: tip 提示
因为本项目是前后端分离的，所以需要前后端都部署好，才能进行访问
:::

### 后端部署

* 打包工程文件

在`ruoyi`项目的`bin`目录下执行`package.bat`打包Web工程，生成war/jar包文件。  
然后会在项目下生成`target`文件夹包含`war`或`jar`
::: tip 提示
不同模块版本会生成在`ruoyi/ruoyi-xxxx`模块下`target`文件夹
:::

* 部署工程文件
 
1、jar部署方式  
   使用命令行执行：`java –jar ruoyi-xxxx.jar` 或者执行脚本：`ruoyi/bin/run-xxxx.bat`  

2、war部署方式  
   `ruoyi/pom.xml`中的`packaging`修改为`war`，放入`tomcat`服务器`webapps`
``` xml
   <packaging>war</packaging>
```
::: tip 提示
不同模块版本在`ruoyi/ruoyi-xxxx`模块下修改`pom.xml`
:::

* `SpringBoot`去除内嵌`Tomcat`（PS：此步骤不重要，因为不排除也能在容器中部署`war`）

```xml
<!-- 排除内置tomcat -->
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
:::

```js
publicPath: './' //请根据自己路径来配置更改
```

```js
export default new Router({
  mode: 'hash', // hash模式
})
```

## 环境变量

[参考环境变量](/ruoyi-vue/document/hjbs.html#环境变量)

## Nginx配置

[参考nginx配置](/ruoyi-vue/document/hjbs.html#nginx配置)

## Tomcat配置

[参考tomcat配置](/ruoyi-vue/document/hjbs.html#tomcat配置)

## 常见问题

1. 如果使用`Mac`需要修改`nacos`配置`ruoyi-file-dev.yml`文件路径`path`
2. 如果使用`Linux` 提示表不存在，设置大小写敏感配置在`/etc/my.cnf`添加`lower_case_table_names=1`，重启MYSQL服务
3. 如果提示当前权限不足，无法写入文件请检查`ruoyi-file-dev.yml`中的`path`路径或`logback.xml`中的`log.path`路径是否有可读可写操作权限

如遇到无法解决的问题请到[Issues](https://gitee.com/y_project/RuoYi-Cloud/issues)反馈，会不定时进行解答。