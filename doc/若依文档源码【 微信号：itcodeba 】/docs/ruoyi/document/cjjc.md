# 插件集成

为了让开发者更加方便和快速的满足需求，提供了各种插件集成实现方案。

## 集成redis实现集群会话

目前的会话信息通过`ehcache`存储在本地，不方便集群会话管理，由于不少小伙伴需要，所以抽时间整合了一下。如果有需要可以参考我的步骤去集成。改动比较多，请根据实际情况调整。

1、由于切换成`redis`，可以删除一些处理类（不在同步到数据库表）和`ehcache`相关内容。
```xml
// 删除的java类
ruoyi-framework\src\main\java\com\ruoyi\framework\shiro\service\SysShiroService.java
ruoyi-framework\src\main\java\com\ruoyi\framework\shiro\session\OnlineSessionDAO.java
ruoyi-framework\src\main\java\com\ruoyi\framework\shiro\web\filter\online\OnlineSessionFilter.java
ruoyi-framework\src\main\java\com\ruoyi\framework\shiro\web\filter\sync\SyncOnlineSessionFilter.java
ruoyi-framework\src\main\java\com\ruoyi\framework\shiro\web\session\OnlineWebSessionManager.java
ruoyi-framework\src\main\java\com\ruoyi\framework\shiro\web\session\SpringSessionValidationScheduler.java
ruoyi-system\src\main\java\com\ruoyi\system\mapper\SysUserOnlineMapper.java
ruoyi-system\src\main\java\com\ruoyi\system\service\ISysUserOnlineService.java
ruoyi-system\src\main\java\com\ruoyi\system\service\impl\SysUserOnlineServiceImpl.java

// 删除mybatis的数据库操作
ruoyi-system\src\main\resources\mapper\system\SysUserOnlineMapper.xml

// 删除ehcache配置
ruoyi-admin\src\main\resources\ehcache\ehcache-shiro.xml

// 删除ruoyi-common\pom.xml中的shiro-ehcache依赖
<!-- Shiro使用EhCache缓存框架 -->
<dependency>
	<groupId>org.apache.shiro</groupId>
	<artifactId>shiro-ehcache</artifactId>
</dependency>
```

2、`ruoyi-common\pom.xml`模块添加整合依赖
```xml
<!-- shiro整合redis -->
<dependency>
	<groupId>org.crazycake</groupId>
	<artifactId>shiro-redis</artifactId>
	<version>3.3.1</version>
</dependency>

<!-- springboot整合redis -->
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

3、`ruoyi-admin`文件`application-druid.yml`，添加redis配置
```yml
# 数据源配置
spring:
    # redis配置
    redis:
      database: 0
      host: 127.0.0.1
      port: 6379
      password: 
      timeout: 6000ms           # 连接超时时长（毫秒）
      lettuce:
        pool:
          max-active: 1000  # 连接池最大连接数（使用负值表示没有限制）
          max-wait: -1ms    # 连接池最大阻塞等待时间（使用负值表示没有限制）
          max-idle: 10      # 连接池中的最大空闲连接
          min-idle: 5       # 连接池中的最小空闲连接
```

4、下载插件相关包和代码实现覆盖到工程中

:::tip 提示
插件相关包和代码实现`ruoyi/集成redis实现集群会话管理.zip`

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt
:::

5、测试验证会话集群，在线用户，缓存监控等功能是否正常。


## 集成jwt实现登录授权访问

`jwt`适用于前后端分离，但是不分离版本对外提供接口有时候也需要。不少小伙伴有提过要求，最近抽空整合了一下方案，参考步骤如下。

1、`ruoyi-framework\pom.xml`添加`jwt`依赖
```xml
<!-- jwt jar-->
<dependency>
	<groupId>com.auth0</groupId>
	<artifactId>java-jwt</artifactId>
	<version>3.4.0</version>
</dependency>
```

2、下载插件相关包和代码实现覆盖到工程中

:::tip 提示
插件相关包和代码实现`ruoyi/集成jwt实现权限登录授权.zip`

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt
:::

3、添加测试接口类

`ruoyi-admin\ApiController.java`
```java
package com.ruoyi.web.controller.system;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.domain.AjaxResult;

@RestController
@RequestMapping("/api")
public class ApiController
{
    /**
     * 无权限访问
     * 
     * @return
     */
    @GetMapping("/list")
    public AjaxResult list()
    {
        return AjaxResult.success("list success");
    }

    /**
     * 菜单权限 system:user:list
     */
    @GetMapping("/user/list")
    @RequiresPermissions("system:user:list")
    public AjaxResult userlist()
    {
        return AjaxResult.success("user list success");
    }

    /**
     * 角色权限 admin
     */
    @GetMapping("/role/list")
    @RequiresRoles("admin")
    public AjaxResult rolelist()
    {
        return AjaxResult.success("role list success");
    }
}
```

4、测试权限登录访问请求

登录访问（返回token）
`POST` / `http://localhost:80/jwt/login?username=ry&password=admin123`

测试任意权限（header携带token）
`GET` / `http://localhost:80/api/list`

测试菜单权限（header携带token）
`GET` / `http://localhost:80/api/user/list`

测试角色权限（header携带token）
`GET` / `http://localhost:80/api/role/list`


## 集成cas实现单点登录认证

单点登录（Single Sign On），简称为`SSO`，是比较流行的企业业务整合的解决方案之一。`SSO`的定义是在多个应用系统中，用户只需要登录一次就可以访问所有相互信任的应用系统。

1、下载cas-overlay-template搭建cas服务器

下载项目`https://github.com/apereo/cas-overlay-template.git`

```sh
# 构建项目（需要安装gradle环境）
gradlew.bat clean build

# 解压
gradlew.bat explodeWar
```

此时将会在`bulid`目录下生成一个`cas-resources`文件夹，我们把里面的文件全部拷贝到`cas-overlay-template/src/main/resources`，将`/etc/cas/thekeystore`也拷贝到该目录下

修改配置application.properties
```sh
server.ssl.key-store=classpath:thekeystore
```

为了方便测试直接屏蔽了`ssl`，端口改成了8080
```sh
server.ssl.enabled=false
server.port=8080
```

在内嵌的Tomcat中运行cas
```sh
gradlew.bat run
```

启动完成后浏览器中打开([http://localhost:8080/cas/login](http://localhost:8080/cas/login))就可以访问了。

在登录也面输入用户名和密码：`casuser/Mellon`，出现界面表明`cas`已经部署成功。

2、cas服务端整合Mysql数据库，添加service-registry依赖

修改`build.gradle`文件，加入mysql驱动配置
```xml{14-16}
dependencies {
    // Add modules in format compatible with overlay casModules property
    if (project.hasProperty("casModules")) {
        def dependencies = project.getProperty("casModules").split(",")
        dependencies.each {
            def projectsToAdd = rootProject.subprojects.findAll {project ->
                project.name == "cas-server-core-${it}" || project.name == "cas-server-support-${it}"
            }
            projectsToAdd.each {implementation it}
        }
    }
    // CAS dependencies/modules may be listed here statically...
    implementation "org.apereo.cas:cas-server-webapp-init:${casServerVersion}"
    implementation "org.apereo.cas:cas-server-support-json-service-registry:${casServerVersion}"
    implementation "org.apereo.cas:cas-server-support-jdbc:${casServerVersion}"
    implementation "org.apereo.cas:cas-server-support-jdbc-drivers:${casServerVersion}"
    implementation "mysql:mysql-connector-java:8.0.22"
}
```

修改`resources/application.properties`文件，加入数据库连接配置
```
# 取消静态配置
# cas.authn.accept.users=casuser::Mellon
# cas.authn.accept.name=Static Credentials

# 本地的数据库配置信息
cas.authn.jdbc.query[0].url=jdbc:mysql://localhost:3306/ry?serverTimezone=UTC&allowMultiQueries=true
cas.authn.jdbc.query[0].user=root
cas.authn.jdbc.query[0].password=password
cas.authn.jdbc.query[0].sql=select password from sys_user where login_name= ?
cas.authn.jdbc.query[0].fieldPassword=password
cas.authn.jdbc.query[0].driverClass=com.mysql.jdbc.Driver
cas.authn.jdbc.query[0].passwordEncoder.type=DEFAULT
cas.authn.jdbc.query[0].passwordEncoder.characterEncoding=UTF-8
cas.authn.jdbc.query[0].passwordEncoder.encodingAlgorithm=MD5
```

3、设置允许http访问

修改`resources/application.properties`开启识别`json`
```
# 开启识别json文件配置
cas.tgc.secure=false
cas.service-registry.init-from-json=true
cas.service-registry.json.location=classpath:/services
```

修改`services/HTTPSandIMAPS-10000001.json`，加入`http`
```json{3}
{
  "@class": "org.apereo.cas.services.RegexRegisteredService",
  "serviceId": "^(https|http|imaps)://.*",
  "name": "HTTPS and IMAPS",
  "id": 10000001,
  "description": "This service definition authorizes all application urls that support HTTPS and IMAPS protocols.",
  "evaluationOrder": 10000
}
```

4、`ruoyi-framework\pom.xml`添加`pac4j`依赖
```xml
<!-- pac4j安全引擎 -->
<dependency>
	<groupId>org.pac4j</groupId>
	<artifactId>pac4j-cas</artifactId>
	<version>3.0.2</version>
</dependency>

<dependency>
	<groupId>io.buji</groupId>
	<artifactId>buji-pac4j</artifactId>
	<version>4.0.0</version>
</dependency>
```

5、下载插件相关包和代码实现覆盖到工程中

:::tip 提示
插件相关包和代码实现`ruoyi/集成cas实现单点登录认证.zip`

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt
:::

6、测试单点登录访问请求，是否正常登陆以及退出，同时能访问多个不同系统。


## 集成docker实现一键部署

`Docker`是一个虚拟环境容器，可以将你的开发环境、代码、配置文件等一并打包到这个容器中，最终只需要一个命令即可打包发布应用到任意平台中。

1、安装docker
```sh
yum install https://download.docker.com/linux/fedora/30/x86_64/stable/Packages/containerd.io-1.2.6-3.3.fc30.x86_64.rpm
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

2、检查`docker`和`docker-compose`是否安装成功
```sh
docker version
docker-compose --version
```

3、文件授权
```sh
chmod +x /usr/local/bin/docker-compose
```

4、下载若依docker插件，上传到自己的服务器目录

插件相关脚本实现`ruoyi/集成docker实现一键部署.zip`

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt

* 其中`db目录`存放`ruoyi数据库脚本`
* 其中`jar目录`存放打包好的`jar应用文件`
* 数据库`mysql`地址需要修改成`ruoyi-mysql`
* 数据库脚本头部需要添加`SET NAMES 'utf8';`（防止乱码）

5、启动docker
```sh
systemctl start docker
```

6、构建docker服务
```sh
docker-compose build
```

7、启动docker容器
```sh
docker-compose up -d
```

8、访问应用地址

打开浏览器，输入：([http://localhost:80](http://localhost:80))，若能正确展示页面，则表明环境搭建成功。

:::tip 提示
启动服务的容器`docker-compose up ruoyi-mysql ruoyi-server`

停止服务的容器`docker-compose stop ruoyi-mysql ruoyi-server`
:::


## 集成websocket实现实时通信

`WebSocket`是一种通信协议，可在单个`TCP`连接上进行全双工通信。`WebSocket`使得客户端和服务器之间的数据交换变得更加简单，允许服务端主动向客户端推送数据。在`WebSocket API`中，浏览器和服务器只需要完成一次握手，两者之间就可以建立持久性的连接，并进行双向数据传输。

1、`ruoyi-framework/pom.xml`文件添加`websocket`依赖。
```xml
<!-- SpringBoot Websocket -->
<dependency>  
   <groupId>org.springframework.boot</groupId>  
   <artifactId>spring-boot-starter-websocket</artifactId>  
</dependency>
```

2、配置匿名访问（可选）
```java
// 如果需要不登录也可以访问，需要在`ShiroConfig.java`中设置匿名访问
filterChainDefinitionMap.put("/websocket/**", "anon");
```

3、下载插件相关包和代码实现覆盖到工程中

:::tip 提示
插件相关包和代码实现`ruoyi/集成websocket实现实时通信.zip`

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt
:::

4、测试验证

如果要测试验证可以把`websocket.html`内容复制到`login.html`，点击连接发送消息测试返回结果。


## 集成atomikos实现分布式事务

在一些复杂的应用开发中，一个应用可能会涉及到连接多个数据源，所谓多数据源这里就定义为至少连接两个及以上的数据库了。
对于这种多数据的应用中，数据源就是一种典型的分布式场景，因此系统在多个数据源间的数据操作必须做好事务控制。在`SpringBoot`的官网推荐我们使用[Atomikos](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-jta.html)。
当然分布式事务的作用并不仅仅应用于多数据源。例如：在做数据插入的时候往一个`kafka`消息队列写消息，如果信息很重要同样需要保证分布式数据的一致性。

**若依框架已经通过`Druid`实现了多数据源切换，但是`Spring`开启事务后会维护一个ConnectionHolder，保证在整个事务下，都是用同一个数据库连接。所以我们需要`Atomikos`解决多数据源事务的一致性问题**

1、`ruoyi-framework/pom.xml`文件添加`atomikos`依赖。
```xml
<!-- atomikos分布式事务 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jta-atomikos</artifactId>
</dependency>
```

2、下载插件相关包和代码实现覆盖到工程中

:::tip 提示
插件相关包和代码实现`ruoyi/集成atomikos实现分布式事务.zip`

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt
:::

3、测试验证

加入多数据源，如果不会使用可以[参考多数据源实现](/ruoyi/document/htsc.html#多数据源)。

对应需要操作多数据源方法加入`@Transactional`测试一致性，例如。
```java
@Transactional
public void insert()
{
	SpringUtils.getAopProxy(this).insertA();
	SpringUtils.getAopProxy(this).insertB();
}

@DataSource(DataSourceType.MASTER)
public void insertA()
{
	return xxxxMapper.insertXxxx();
}

@DataSource(DataSourceType.SLAVE)
public void insertB()
{
	return xxxxMapper.insertXxxx();
}
```
**到此我们项目多个数据源的事务控制生效了**


## 使用undertow来替代tomcat容器

`SpingBoot`中我们既可以使用`Tomcat`作为`Http`服务，也可以用`Undertow`来代替。`Undertow`在高并发业务场景中，性能优于`Tomcat`。所以，如果我们的系统是高并发请求，不妨使用一下`Undertow`，你会发现你的系统性能会得到很大的提升。

1、`ruoyi-framework\pom.xml`模块修改web容器依赖，使用undertow来替代tomcat容器
```xml
 <!-- SpringBoot Web容器 -->
 <dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-web</artifactId>
	 <exclusions>
		 <exclusion>
			 <artifactId>spring-boot-starter-tomcat</artifactId>
			 <groupId>org.springframework.boot</groupId>
		 </exclusion>
	 </exclusions>
</dependency>

<!-- web 容器使用 undertow -->
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-undertow</artifactId>
</dependency>
```

2、修改`application.yml`，使用undertow来替代tomcat容器
```yml
# 开发环境配置
server:
  # 服务器的HTTP端口，默认为80
  port: 80
  servlet:
    # 应用的访问路径
    context-path: /
  # undertow 配置
  undertow:
    # HTTP post内容的最大大小。当值为-1时，默认值为大小是无限的
    max-http-post-size: -1
    # 以下的配置会影响buffer,这些buffer会用于服务器连接的IO操作,有点类似netty的池化内存管理
    # 每块buffer的空间大小,越小的空间被利用越充分
    buffer-size: 512
    # 设置IO线程数, 它主要执行非阻塞的任务,它们会负责多个连接, 默认设置每个CPU核心一个线程
    io-threads: 8
    # 阻塞任务线程池, 当执行类似servlet请求阻塞操作, undertow会从这个线程池中取得线程,它的值设置取决于系统的负载
    worker-threads: 256
    # 是否分配的直接内存
    direct-buffers: true
```

3、修改文件上传工具类`FileUploadUtils.java`
```java
private static final File getAbsoluteFile(String uploadDir, String fileName) throws IOException
{
	File desc = new File(uploadDir + File.separator + fileName);

	if (!desc.getParentFile().exists())
	{
		desc.getParentFile().mkdirs();
	}
	// undertow文件上传，因底层实现不同,无需创建新文件
	// if (!desc.exists())
	// {
	//    desc.createNewFile();
	// }
	return desc;
}
```


## 集成actuator实现优雅关闭应用

优雅停机主要应用在版本更新的时候，为了等待正在工作的线程全部执行完毕，然后再停止。我们可以使用`SpringBoot`提供的`Actuator`

1、`pom.xml`中引入`actuator`依赖
```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

2、配置文件中`endpoint`开启`shutdown`
```yml
management:
  endpoint:
    shutdown:
      enabled: true
  endpoints:
    web:
      exposure:
        include: "shutdown"
      base-path: /monitor
```

3、在`ShiroConfig`中设置`filterChainDefinitionMap`配置`url=anon`
```java
filterChainDefinitionMap.put("/monitor/shutdown", "anon");
```

4、`Post`请求测试验证优雅停机
curl -X POST http://localhost:80/monitor/shutdown


## 集成aj-captcha实现滑块验证码

集成以`AJ-Captcha`滑块验证码为例，不需要键盘手动输入，极大优化了传统验证码用户体验不佳的问题。目前对外提供两种类型的验证码，其中包含滑动拼图、文字点选。

1、`ruoyi-framework\pom.xml`添加依赖
```xml
<!-- 滑块验证码  -->
<dependency>
	<groupId>com.github.anji-plus</groupId>
	<artifactId>captcha-spring-boot-starter</artifactId>
	<version>1.2.7</version>
</dependency>
```

2、修改`application.yml`，加入`aj-captcha`配置
```yml
# 滑块验证码
aj:
   captcha:
      # blockPuzzle滑块 clickWord文字点选  default默认两者都实例化
      type: blockPuzzle
      # 右下角显示字
      water-mark: ruoyi.vip
      # 校验滑动拼图允许误差偏移量(默认5像素)
      slip-offset: 5
      # aes加密坐标开启或者禁用(true|false)
      aes-status: true
      # 滑动干扰项(0/1/2)
      interference-options: 2
```

3、下载插件相关包和代码实现覆盖到工程中

:::tip 提示
下载前端插件相关包和代码实现`ruoyi/集成滑动验证码.zip`

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt
:::

4、测试验证登录和注册页面滑块验证使用是否正常。


## 集成sharding-jdbc实现分库分表

`sharding-jdbc`是由当当捐入给`apache`的一款分布式数据库中间件，支持垂直分库、垂直分表、水平分库、水平分表、读写分离、分布式事务和高可用等相关功能。

1、`ruoyi-framework\pom.xml`模块添加sharding-jdbc整合依赖
```xml
<!-- sharding-jdbc分库分表 -->
<dependency>
	<groupId>org.apache.shardingsphere</groupId>
	<artifactId>sharding-jdbc-core</artifactId>
	<version>4.1.1</version>
</dependency>
```

2、创建两个测试数据库
```sql
create database `ry-order1`;
create database `ry-order2`;
```

3、创建两个测试订单表
```sql
-- ----------------------------
-- 订单信息表sys_order_0
-- ----------------------------
drop table if exists sys_order_0;
create table sys_order_0
(
  order_id      bigint(20)      not null                   comment '订单ID',
  user_id       bigint(64)      not null                   comment '用户编号',
  status        char(1)         not null                   comment '状态（0交易成功 1交易失败）',
  order_no      varchar(64)     default null               comment '订单流水',
  primary key (order_id)
) engine=innodb comment = '订单信息表';

-- ----------------------------
-- 订单信息表sys_order_1
-- ----------------------------
drop table if exists sys_order_1;
create table sys_order_1
(
  order_id      bigint(20)      not null                   comment '订单ID',
  user_id       bigint(64)      not null                   comment '用户编号',
  status        char(1)         not null                   comment '状态（0交易成功 1交易失败）',
  order_no      varchar(64)     default null               comment '订单流水',
  primary key (order_id)
) engine=innodb comment = '订单信息表';

```

4、配置文件`application-druid.yml`添加测试数据源
```yml{12-23}
# 数据源配置
spring:
    datasource:
        type: com.alibaba.druid.pool.DruidDataSource
        driverClassName: com.mysql.cj.jdbc.Driver
        druid:
            # 主库数据源
            master:
                url: jdbc:mysql://localhost:3306/ry?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
                username: root
                password: password
            # 订单库1
            order1:
                enabled: true
                url: jdbc:mysql://localhost:3306/ry-order1?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
                username: root
                password: password
            # 订单库2
            order2:
                enabled: true
                url: jdbc:mysql://localhost:3306/ry-order2?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
                username: root
                password: password
            ...................
```

5、下载插件相关包和代码实现覆盖到工程中

:::tip 提示
下载插件相关包和代码实现`ruoyi/集成sharding-jdbc实现分库分表.zip`

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt
:::

6、测试验证

访问`http://localhost/order/add/1`入库到`ry-order2`

访问`http://localhost/order/add/2`入库到`ry-order1`

同时根据订单号`order_id % 2`入库到`sys_order_0`或者`sys_order_1`


## 集成just-auth实现第三方授权登录

对于一些想使用第三方平台授权登录可以使用`JustAuth`，支持Github、Gitee、微博、钉钉、百度、Coding、腾讯云开发者平台、OSChina、支付宝、QQ、微信、淘宝、Google、Facebook、抖音、领英、小米、微软、今日头条、Teambition、StackOverflow、Pinterest、人人、华为、企业微信、酷家乐、Gitlab、美团、饿了么和推特等第三方平台的授权登录。

1、`ruoyi-common\pom.xml`模块添加整合依赖
```xml
<!-- 第三方授权登录 -->
<dependency>
	<groupId>me.zhyd.oauth</groupId>
	<artifactId>JustAuth</artifactId>
	<version>1.15.6</version>
</dependency>

<!-- HttpClient -->
<dependency>
	<groupId>org.apache.httpcomponents</groupId>
	<artifactId>httpclient</artifactId>
</dependency>
```

2、新建第三方登录授权表
```sql
-- ----------------------------
-- 第三方授权表
-- ----------------------------
drop table if exists sys_auth_user;
create table sys_auth_user (
  auth_id           bigint(20)      not null auto_increment    comment '授权ID',
  uuid              varchar(500)    not null                   comment '第三方平台用户唯一ID',
  user_id           bigint(20)      not null                   comment '系统用户ID',
  login_name        varchar(30)     not null                   comment '登录账号',
  user_name         varchar(30)     default ''                 comment '用户昵称',
  avatar            varchar(500)    default ''                 comment '头像地址',
  email             varchar(255)    default ''                 comment '用户邮箱',
  source            varchar(255)    default ''                 comment '用户来源',
  create_time       datetime                                   comment '创建时间',
  primary key (auth_id)
) engine=innodb auto_increment=100 comment = '第三方授权表';
```

3、下载插件相关包和代码实现覆盖到工程中

:::tip 提示
下载前端插件相关包和代码实现`ruoyi/集成JustAuth实现第三方授权登录.zip`

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt
:::

4、测试登录页面第三方授权登录，个人中心授权及取消功能是否正常使用。


## 集成mybatis-plus实现mybatis增强

`Mybatis-Plus`是在`Mybatis`的基础上进行扩展，只做增强不做改变，可以兼容`Mybatis`原生的特性。同时支持通用CRUD操作、多种主键策略、分页、性能分析、全局拦截等。极大帮助我们简化开发工作。

1、`ruoyi-common\pom.xml`模块添加整合依赖
```xml
<!-- mybatis-plus 增强CRUD -->
<dependency>
	<groupId>com.baomidou</groupId>
	<artifactId>mybatis-plus-boot-starter</artifactId>
	<version>3.4.2</version>
</dependency>
```

2、`ruoyi-admin`文件`application.yml`，修改mybatis配置为mybatis-plus
```yml
# MyBatis Plus配置
mybatis-plus:
  # 搜索指定包别名
  typeAliasesPackage: com.ruoyi.**.domain
  # 配置mapper的扫描，找到所有的mapper.xml映射文件
  mapperLocations: classpath*:mapper/**/*Mapper.xml
  # 加载全局的配置文件
  configLocation: classpath:mybatis/mybatis-config.xml
```

3、添加`Mybatis Plus`配置`MybatisPlusConfig.java`。 
**PS：原来的`MyBatisConfig.java`需要删除掉**
```java
package com.ruoyi.framework.config;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.BlockAttackInnerInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.OptimisticLockerInnerInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * Mybatis Plus 配置
 * 
 * @author ruoyi
 */
@EnableTransactionManagement(proxyTargetClass = true)
@Configuration
public class MybatisPlusConfig
{
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor()
    {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        // 分页插件
        interceptor.addInnerInterceptor(paginationInnerInterceptor());
        // 乐观锁插件
        interceptor.addInnerInterceptor(optimisticLockerInnerInterceptor());
        // 阻断插件
        interceptor.addInnerInterceptor(blockAttackInnerInterceptor());
        return interceptor;
    }

    /**
     * 分页插件，自动识别数据库类型 https://baomidou.com/guide/interceptor-pagination.html
     */
    public PaginationInnerInterceptor paginationInnerInterceptor()
    {
        PaginationInnerInterceptor paginationInnerInterceptor = new PaginationInnerInterceptor();
        // 设置数据库类型为mysql
        paginationInnerInterceptor.setDbType(DbType.MYSQL);
        // 设置最大单页限制数量，默认 500 条，-1 不受限制
        paginationInnerInterceptor.setMaxLimit(-1L);
        return paginationInnerInterceptor;
    }

    /**
     * 乐观锁插件 https://baomidou.com/guide/interceptor-optimistic-locker.html
     */
    public OptimisticLockerInnerInterceptor optimisticLockerInnerInterceptor()
    {
        return new OptimisticLockerInnerInterceptor();
    }

    /**
     * 如果是对全表的删除或更新操作，就会终止该操作 https://baomidou.com/guide/interceptor-block-attack.html
     */
    public BlockAttackInnerInterceptor blockAttackInnerInterceptor()
    {
        return new BlockAttackInnerInterceptor();
    }
}
```

4、添加测试表和菜单信息
```sql
drop table if exists sys_student;
create table sys_student (
  student_id           int(11)         auto_increment    comment '编号',
  student_name         varchar(30)     default ''        comment '学生名称',
  student_age          int(3)          default null      comment '年龄',
  student_hobby        varchar(30)     default ''        comment '爱好（0代码 1音乐 2电影）',
  student_sex          char(1)         default '0'       comment '性别（0男 1女 2未知）',
  student_status       char(1)         default '0'       comment '状态（0正常 1停用）',
  student_birthday     datetime                          comment '生日',
  primary key (student_id)
) engine=innodb auto_increment=1 comment = '学生信息表';

-- 菜单 sql
insert into sys_menu (menu_name, parent_id, order_num, url, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生信息', '3', '1', '/system/student', 'c', '0', 'system:student:view', '#', 'admin', sysdate(), '', null, '学生信息菜单');

-- 按钮父菜单id
select @parentid := last_insert_id();

-- 按钮 sql
insert into sys_menu (menu_name, parent_id, order_num, url, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生信息查询', @parentid, '1',  '#',  'f', '0', 'system:student:list',         '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, url, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生信息新增', @parentid, '2',  '#',  'f', '0', 'system:student:add',          '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, url, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生信息修改', @parentid, '3',  '#',  'f', '0', 'system:student:edit',         '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, url, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生信息删除', @parentid, '4',  '#',  'f', '0', 'system:student:remove',       '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, url, menu_type, visible, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生信息导出', @parentid, '5',  '#',  'f', '0', 'system:student:export',       '#', 'admin', sysdate(), '', null, '');
```

5、新增测试代码验证
新增 **ruoyi-system\com\ruoyi\system\controller\SysStudentController.java**
```java
package com.ruoyi.system.controller;

import java.util.Arrays;
import java.util.List;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.SysStudent;
import com.ruoyi.system.service.ISysStudentService;

/**
 * 学生信息Controller
 * 
 * @author ruoyi
 */
@Controller
@RequestMapping("/system/student")
public class SysStudentController extends BaseController
{
    private String prefix = "system/student";

    @Autowired
    private ISysStudentService sysStudentService;

    @RequiresPermissions("system:student:view")
    @GetMapping()
    public String student()
    {
        return prefix + "/student";
    }

    /**
     * 查询学生信息列表
     */
    @RequiresPermissions("system:student:list")
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(SysStudent sysStudent)
    {
        startPage();
        List<SysStudent> list = sysStudentService.queryList(sysStudent);
        return getDataTable(list);
    }

    /**
     * 导出学生信息列表
     */
    @RequiresPermissions("system:student:export")
    @Log(title = "学生信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(SysStudent sysStudent)
    {
        List<SysStudent> list = sysStudentService.queryList(sysStudent);
        ExcelUtil<SysStudent> util = new ExcelUtil<SysStudent>(SysStudent.class);
        return util.exportExcel(list, "student");
    }

    /**
     * 新增学生信息
     */
    @GetMapping("/add")
    public String add()
    {
        return prefix + "/add";
    }

    /**
     * 新增保存学生信息
     */
    @RequiresPermissions("system:student:add")
    @Log(title = "学生信息", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(SysStudent sysStudent)
    {
        return toAjax(sysStudentService.save(sysStudent));
    }

    /**
     * 修改学生信息
     */
    @GetMapping("/edit/{studentId}")
    public String edit(@PathVariable("studentId") Long studentId, ModelMap mmap)
    {
        SysStudent sysStudent = sysStudentService.getById(studentId);
        mmap.put("sysStudent", sysStudent);
        return prefix + "/edit";
    }

    /**
     * 修改保存学生信息
     */
    @RequiresPermissions("system:student:edit")
    @Log(title = "学生信息", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    @ResponseBody
    public AjaxResult editSave(SysStudent sysStudent)
    {
        return toAjax(sysStudentService.updateById(sysStudent));
    }

    /**
     * 删除学生信息
     */
    @RequiresPermissions("system:student:remove")
    @Log(title = "学生信息", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    @ResponseBody
    public AjaxResult remove(String ids)
    {
        return toAjax(sysStudentService.removeByIds(Arrays.asList(ids)));
    }
}
```

新增 **ruoyi-system\com\ruoyi\system\domain\SysStudent.java**
```java
package com.ruoyi.system.domain;

import java.io.Serializable;
import java.util.Date;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ruoyi.common.annotation.Excel;

/**
 * 学生信息对象 sys_student
 * 
 * @author ruoyi
 */
@TableName(value = "sys_student")
public class SysStudent implements Serializable
{
    @TableField(exist = false)
    private static final long serialVersionUID = 1L;

    /** 编号 */
    @TableId(type = IdType.AUTO)
    private Long studentId;

    /** 学生名称 */
    @Excel(name = "学生名称")
    private String studentName;

    /** 年龄 */
    @Excel(name = "年龄")
    private Integer studentAge;

    /** 爱好（0代码 1音乐 2电影） */
    @Excel(name = "爱好", readConverterExp = "0=代码,1=音乐,2=电影")
    private String studentHobby;

    /** 性别（0男 1女 2未知） */
    @Excel(name = "性别", readConverterExp = "0=男,1=女,2=未知")
    private String studentSex;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String studentStatus;

    /** 生日 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "生日", width = 30, dateFormat = "yyyy-MM-dd")
    private Date studentBirthday;

    public void setStudentId(Long studentId) 
    {
        this.studentId = studentId;
    }

    public Long getStudentId() 
    {
        return studentId;
    }
    public void setStudentName(String studentName) 
    {
        this.studentName = studentName;
    }

    public String getStudentName() 
    {
        return studentName;
    }
    public void setStudentAge(Integer studentAge) 
    {
        this.studentAge = studentAge;
    }

    public Integer getStudentAge() 
    {
        return studentAge;
    }
    public void setStudentHobby(String studentHobby) 
    {
        this.studentHobby = studentHobby;
    }

    public String getStudentHobby() 
    {
        return studentHobby;
    }
    public void setStudentSex(String studentSex) 
    {
        this.studentSex = studentSex;
    }

    public String getStudentSex() 
    {
        return studentSex;
    }
    public void setStudentStatus(String studentStatus) 
    {
        this.studentStatus = studentStatus;
    }

    public String getStudentStatus() 
    {
        return studentStatus;
    }
    public void setStudentBirthday(Date studentBirthday) 
    {
        this.studentBirthday = studentBirthday;
    }

    public Date getStudentBirthday() 
    {
        return studentBirthday;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("studentId", getStudentId())
            .append("studentName", getStudentName())
            .append("studentAge", getStudentAge())
            .append("studentHobby", getStudentHobby())
            .append("studentSex", getStudentSex())
            .append("studentStatus", getStudentStatus())
            .append("studentBirthday", getStudentBirthday())
            .toString();
    }
}
```

新增 **ruoyi-system\com\ruoyi\system\mapper\SysStudentMapper.java**
```java
package com.ruoyi.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.system.domain.SysStudent;

/**
 * 学生信息Mapper接口
 * 
 * @author ruoyi
 */
public interface SysStudentMapper extends BaseMapper<SysStudent>
{

}
```

新增 **ruoyi-system\com\ruoyi\system\service\ISysStudentService.java**
```java
package com.ruoyi.system.service;

import java.util.List;
import com.baomidou.mybatisplus.extension.service.IService;
import com.ruoyi.system.domain.SysStudent;

/**
 * 学生信息Service接口
 * 
 * @author ruoyi
 */
public interface ISysStudentService extends IService<SysStudent>
{
    /**
     * 查询学生信息列表
     * 
     * @param sysStudent 学生信息
     * @return 学生信息集合
     */
    public List<SysStudent> queryList(SysStudent sysStudent);
}
```

新增 **ruoyi-system\com\ruoyi\system\service\impl\SysStudentServiceImpl.java**
```java
package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysStudent;
import com.ruoyi.system.mapper.SysStudentMapper;
import com.ruoyi.system.service.ISysStudentService;

/**
 * 学生信息Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class SysStudentServiceImpl extends ServiceImpl<SysStudentMapper, SysStudent> implements ISysStudentService
{
    @Override
    public List<SysStudent> queryList(SysStudent sysStudent)
    {
        // 注意：mybatis-plus lambda 模式不支持 eclipse 的编译器
        // LambdaQueryWrapper<SysStudent> queryWrapper = Wrappers.lambdaQuery();
        // queryWrapper.eq(SysStudent::getStudentName, sysStudent.getStudentName());
        QueryWrapper<SysStudent> queryWrapper = Wrappers.query();
        if (StringUtils.isNotEmpty(sysStudent.getStudentName()))
        {
            queryWrapper.eq("student_name", sysStudent.getStudentName());
        }
        if (StringUtils.isNotNull(sysStudent.getStudentAge()))
        {
            queryWrapper.eq("student_age", sysStudent.getStudentAge());
        }
        if (StringUtils.isNotEmpty(sysStudent.getStudentHobby()))
        {
            queryWrapper.eq("student_hobby", sysStudent.getStudentHobby());
        }
        return this.list(queryWrapper);
    }
}
```

新增 **ruoyi-system\templates\system\student\add.html**
```html
<!DOCTYPE html>
<html lang="zh" xmlns:th="http://www.thymeleaf.org" >
<head>
    <th:block th:include="include :: header('新增学生信息')" />
    <th:block th:include="include :: datetimepicker-css" />
</head>
<body class="white-bg">
    <div class="wrapper wrapper-content animated fadeInRight ibox-content">
        <form class="form-horizontal m" id="form-student-add">
            <div class="form-group">    
                <label class="col-sm-3 control-label">学生名称：</label>
                <div class="col-sm-8">
                    <input name="studentName" class="form-control" type="text">
                </div>
            </div>
            <div class="form-group">    
                <label class="col-sm-3 control-label">年龄：</label>
                <div class="col-sm-8">
                    <input name="studentAge" class="form-control" type="text">
                </div>
            </div>
            <div class="form-group">    
                <label class="col-sm-3 control-label">爱好：</label>
                <div class="col-sm-8">
                    <input name="studentHobby" class="form-control" type="text">
                </div>
            </div>
            <div class="form-group">    
                <label class="col-sm-3 control-label">性别：</label>
                <div class="col-sm-8">
                    <select name="studentSex" class="form-control m-b">
                        <option value="">所有</option>
                    </select>
                    <span class="help-block m-b-none"><i class="fa fa-info-circle"></i> 代码生成请选择字典属性</span>
                </div>
            </div>
            <div class="form-group">    
                <label class="col-sm-3 control-label">状态：</label>
                <div class="col-sm-8">
                    <div class="radio-box">
                        <input type="radio" name="studentStatus" value="">
                        <label th:for="studentStatus" th:text="未知"></label>
                    </div>
                    <span class="help-block m-b-none"><i class="fa fa-info-circle"></i> 代码生成请选择字典属性</span>
                </div>
            </div>
            <div class="form-group">    
                <label class="col-sm-3 control-label">生日：</label>
                <div class="col-sm-8">
                    <div class="input-group date">
                        <input name="studentBirthday" class="form-control" placeholder="yyyy-MM-dd" type="text">
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <th:block th:include="include :: footer" />
    <th:block th:include="include :: datetimepicker-js" />
    <script th:inline="javascript">
        var prefix = ctx + "system/student"
        $("#form-student-add").validate({
            focusCleanup: true
        });

        function submitHandler() {
            if ($.validate.form()) {
                $.operate.save(prefix + "/add", $('#form-student-add').serialize());
            }
        }

        $("input[name='studentBirthday']").datetimepicker({
            format: "yyyy-mm-dd",
            minView: "month",
            autoclose: true
        });
    </script>
</body>
</html>
```

新增 **ruoyi-system\templates\system\student\edit.html**
```html
<!DOCTYPE html>
<html lang="zh" xmlns:th="http://www.thymeleaf.org" >
<head>
    <th:block th:include="include :: header('修改学生信息')" />
    <th:block th:include="include :: datetimepicker-css" />
</head>
<body class="white-bg">
    <div class="wrapper wrapper-content animated fadeInRight ibox-content">
        <form class="form-horizontal m" id="form-student-edit" th:object="${sysStudent}">
            <input name="studentId" th:field="*{studentId}" type="hidden">
            <div class="form-group">    
                <label class="col-sm-3 control-label">学生名称：</label>
                <div class="col-sm-8">
                    <input name="studentName" th:field="*{studentName}" class="form-control" type="text">
                </div>
            </div>
            <div class="form-group">    
                <label class="col-sm-3 control-label">年龄：</label>
                <div class="col-sm-8">
                    <input name="studentAge" th:field="*{studentAge}" class="form-control" type="text">
                </div>
            </div>
            <div class="form-group">    
                <label class="col-sm-3 control-label">爱好：</label>
                <div class="col-sm-8">
                    <input name="studentHobby" th:field="*{studentHobby}" class="form-control" type="text">
                </div>
            </div>
            <div class="form-group">    
                <label class="col-sm-3 control-label">性别：</label>
                <div class="col-sm-8">
                    <select name="studentSex" class="form-control m-b">
                        <option value="">所有</option>
                    </select>
                    <span class="help-block m-b-none"><i class="fa fa-info-circle"></i> 代码生成请选择字典属性</span>
                </div>
            </div>
            <div class="form-group">    
                <label class="col-sm-3 control-label">状态：</label>
                <div class="col-sm-8">
                    <div class="radio-box">
                        <input type="radio" name="studentStatus" value="">
                        <label th:for="studentStatus" th:text="未知"></label>
                    </div>
                    <span class="help-block m-b-none"><i class="fa fa-info-circle"></i> 代码生成请选择字典属性</span>
                </div>
            </div>
            <div class="form-group">    
                <label class="col-sm-3 control-label">生日：</label>
                <div class="col-sm-8">
                    <div class="input-group date">
                        <input name="studentBirthday" th:value="${#dates.format(sysStudent.studentBirthday, 'yyyy-MM-dd')}" class="form-control" placeholder="yyyy-MM-dd" type="text">
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <th:block th:include="include :: footer" />
    <th:block th:include="include :: datetimepicker-js" />
    <script th:inline="javascript">
        var prefix = ctx + "system/student";
        $("#form-student-edit").validate({
            focusCleanup: true
        });

        function submitHandler() {
            if ($.validate.form()) {
                $.operate.save(prefix + "/edit", $('#form-student-edit').serialize());
            }
        }

        $("input[name='studentBirthday']").datetimepicker({
            format: "yyyy-mm-dd",
            minView: "month",
            autoclose: true
        });
    </script>
</body>
</html>
```

新增 **ruoyi-system\templates\system\student\student.html**
```html
<!DOCTYPE html>
<html lang="zh" xmlns:th="http://www.thymeleaf.org" xmlns:shiro="http://www.pollix.at/thymeleaf/shiro">
<head>
    <th:block th:include="include :: header('学生信息列表')" />
</head>
<body class="gray-bg">
     <div class="container-div">
        <div class="row">
            <div class="col-sm-12 search-collapse">
                <form id="formId">
                    <div class="select-list">
                        <ul>
                            <li>
                                <label>学生名称：</label>
                                <input type="text" name="studentName"/>
                            </li>
                            <li>
                                <label>年龄：</label>
                                <input type="text" name="studentAge"/>
                            </li>
                            <li>
                                <label>爱好：</label>
                                <input type="text" name="studentHobby"/>
                            </li>
                            <li>
                                <label>性别：</label>
                                <select name="studentSex">
                                    <option value="">所有</option>
                                    <option value="-1">代码生成请选择字典属性</option>
                                </select>
                            </li>
                            <li>
                                <label>状态：</label>
                                <select name="studentStatus">
                                    <option value="">所有</option>
                                    <option value="-1">代码生成请选择字典属性</option>
                                </select>
                            </li>
                            <li>
                                <label>生日：</label>
                                <input type="text" class="time-input" placeholder="请选择生日" name="studentBirthday"/>
                            </li>
                            <li>
                                <a class="btn btn-primary btn-rounded btn-sm" onclick="$.table.search()"><i class="fa fa-search"></i>&nbsp;搜索</a>
                                <a class="btn btn-warning btn-rounded btn-sm" onclick="$.form.reset()"><i class="fa fa-refresh"></i>&nbsp;重置</a>
                            </li>
                        </ul>
                    </div>
                </form>
            </div>

            <div class="btn-group-sm" id="toolbar" role="group">
                <a class="btn btn-success" onclick="$.operate.add()" shiro:hasPermission="system:student:add">
                    <i class="fa fa-plus"></i> 添加
                </a>
                <a class="btn btn-primary single disabled" onclick="$.operate.edit()" shiro:hasPermission="system:student:edit">
                    <i class="fa fa-edit"></i> 修改
                </a>
                <a class="btn btn-danger multiple disabled" onclick="$.operate.removeAll()" shiro:hasPermission="system:student:remove">
                    <i class="fa fa-remove"></i> 删除
                </a>
                <a class="btn btn-warning" onclick="$.table.exportExcel()" shiro:hasPermission="system:student:export">
                    <i class="fa fa-download"></i> 导出
                </a>
            </div>
            <div class="col-sm-12 select-table table-striped">
                <table id="bootstrap-table"></table>
            </div>
        </div>
    </div>
    <th:block th:include="include :: footer" />
    <script th:inline="javascript">
        var editFlag = [[${@permission.hasPermi('system:student:edit')}]];
        var removeFlag = [[${@permission.hasPermi('system:student:remove')}]];
        var prefix = ctx + "system/student";

        $(function() {
            var options = {
                url: prefix + "/list",
                createUrl: prefix + "/add",
                updateUrl: prefix + "/edit/{id}",
                removeUrl: prefix + "/remove",
                exportUrl: prefix + "/export",
                modalName: "学生信息",
                columns: [{
                    checkbox: true
                },
                {
                    field: 'studentId',
                    title: '编号',
                    visible: false
                },
                {
                    field: 'studentName',
                    title: '学生名称'
                },
                {
                    field: 'studentAge',
                    title: '年龄'
                },
                {
                    field: 'studentHobby',
                    title: '爱好'
                },
                {
                    field: 'studentSex',
                    title: '性别'
                },
                {
                    field: 'studentStatus',
                    title: '状态'
                },
                {
                    field: 'studentBirthday',
                    title: '生日'
                },
                {
                    title: '操作',
                    align: 'center',
                    formatter: function(value, row, index) {
                        var actions = [];
                        actions.push('<a class="btn btn-success btn-xs ' + editFlag + '" href="javascript:void(0)" onclick="$.operate.edit(\'' + row.studentId + '\')"><i class="fa fa-edit"></i>编辑</a> ');
                        actions.push('<a class="btn btn-danger btn-xs ' + removeFlag + '" href="javascript:void(0)" onclick="$.operate.remove(\'' + row.studentId + '\')"><i class="fa fa-remove"></i>删除</a>');
                        return actions.join('');
                    }
                }]
            };
            $.table.init(options);
        });
    </script>
</body>
</html>
```

6、登录系统测试学生菜单增删改查功能。

:::tip 提示
下载相关代码实现示例 `ruoyi/集成mybatisplus实现mybatis增强.zip`

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt
:::


## 集成easyexcel实现excel表格增强

如果默认的`excel`注解已经满足不了你的需求，可以使用`excel`的增强解决方案`easyexcel`，它是阿里巴巴开源的一个`excel`处理框架，使用简单、功能特性多、以节省内存著称。

1、`ruoyi-common\pom.xml`模块添加整合依赖
```xml
<!-- easyexcel -->
<dependency>
	<groupId>com.alibaba</groupId>
	<artifactId>easyexcel</artifactId>
	<version>2.2.6</version>
</dependency>
```

2、`ExcelUtil.java`新增`easyexcel`导出导入方法
```java
import com.alibaba.excel.EasyExcel;

/**
 * 对excel表单默认第一个索引名转换成list（EasyExcel）
 * 
 * @param is 输入流
 * @return 转换后集合
 */
public List<T> importEasyExcel(InputStream is) throws Exception
{
	return EasyExcel.read(is).head(clazz).sheet().doReadSync();
}

/**
 * 对list数据源将其里面的数据导入到excel表单（EasyExcel）
 * 
 * @param list 导出数据集合
 * @param sheetName 工作表的名称
 * @return 结果
 */
public AjaxResult exportEasyExcel(List<T> list, String sheetName)
{
	String filename = encodingFilename(sheetName);
	EasyExcel.write(getAbsoluteFile(filename), clazz).sheet(sheetName).doWrite(list);
	return AjaxResult.success(filename);
}
```

3、模拟测试，以操作日志为例，修改相关类。

**SysOperlogController.java**改为`exportEasyExcel`
```java{9}
@Log(title = "操作日志", businessType = BusinessType.EXPORT)
@RequiresPermissions("monitor:operlog:export")
@PostMapping("/export")
@ResponseBody
public AjaxResult export(SysOperLog operLog)
{
	List<SysOperLog> list = operLogService.selectOperLogList(operLog);
	ExcelUtil<SysOperLog> util = new ExcelUtil<SysOperLog>(SysOperLog.class);
	return util.exportEasyExcel(list, "操作日志");
}
```

**SysOperLog.java**修改为`@ExcelProperty`注解
```java
package com.ruoyi.system.domain;

import java.util.Date;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.alibaba.excel.annotation.ExcelIgnoreUnannotated;
import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.format.DateTimeFormat;
import com.alibaba.excel.annotation.write.style.ColumnWidth;
import com.alibaba.excel.annotation.write.style.HeadFontStyle;
import com.alibaba.excel.annotation.write.style.HeadRowHeight;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.system.domain.read.BusiTypeStringNumberConverter;
import com.ruoyi.system.domain.read.OperTypeConverter;
import com.ruoyi.system.domain.read.StatusConverter;

/**
 * 操作日志记录表 oper_log
 * 
 * @author ruoyi
 */
@ExcelIgnoreUnannotated
@ColumnWidth(16)
@HeadRowHeight(14)
@HeadFontStyle(fontHeightInPoints = 11)
public class SysOperLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 日志主键 */
    @ExcelProperty(value = "操作序号")
    private Long operId;

    /** 操作模块 */
    @ExcelProperty(value = "操作模块")
    private String title;

    /** 业务类型（0其它 1新增 2修改 3删除） */
    @ExcelProperty(value = "业务类型", converter = BusiTypeStringNumberConverter.class)
    private Integer businessType;

    /** 业务类型数组 */
    private Integer[] businessTypes;

    /** 请求方法 */
    @ExcelProperty(value = "请求方法")
    private String method;

    /** 请求方式 */
    @ExcelProperty(value = "请求方式")
    private String requestMethod;

    /** 操作类别（0其它 1后台用户 2手机端用户） */
    @ExcelProperty(value = "操作类别", converter = OperTypeConverter.class)
    private Integer operatorType;

    /** 操作人员 */
    @ExcelProperty(value = "操作人员")
    private String operName;

    /** 部门名称 */
    @ExcelProperty(value = "部门名称")
    private String deptName;

    /** 请求url */
    @ExcelProperty(value = "请求地址")
    private String operUrl;

    /** 操作地址 */
    @ExcelProperty(value = "操作地址")
    private String operIp;

    /** 操作地点 */
    @ExcelProperty(value = "操作地点")
    private String operLocation;

    /** 请求参数 */
    @ExcelProperty(value = "请求参数")
    private String operParam;

    /** 返回参数 */
    @ExcelProperty(value = "返回参数")
    private String jsonResult;

    /** 操作状态（0正常 1异常） */
    @ExcelProperty(value = "状态", converter = StatusConverter.class)
    private Integer status;

    /** 错误消息 */
    @ExcelProperty(value = "错误消息")
    private String errorMsg;

    /** 操作时间 */
    @DateTimeFormat("yyyy-MM-dd HH:mm:ss")
    @ExcelProperty(value = "操作时间")
    private Date operTime;

    public Long getOperId()
    {
        return operId;
    }

    public void setOperId(Long operId)
    {
        this.operId = operId;
    }

    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public Integer getBusinessType()
    {
        return businessType;
    }

    public void setBusinessType(Integer businessType)
    {
        this.businessType = businessType;
    }

    public Integer[] getBusinessTypes()
    {
        return businessTypes;
    }

    public void setBusinessTypes(Integer[] businessTypes)
    {
        this.businessTypes = businessTypes;
    }

    public String getMethod()
    {
        return method;
    }

    public void setMethod(String method)
    {
        this.method = method;
    }

    public String getRequestMethod()
    {
        return requestMethod;
    }

    public void setRequestMethod(String requestMethod)
    {
        this.requestMethod = requestMethod;
    }

    public Integer getOperatorType()
    {
        return operatorType;
    }

    public void setOperatorType(Integer operatorType)
    {
        this.operatorType = operatorType;
    }

    public String getOperName()
    {
        return operName;
    }

    public void setOperName(String operName)
    {
        this.operName = operName;
    }

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }

    public String getOperUrl()
    {
        return operUrl;
    }

    public void setOperUrl(String operUrl)
    {
        this.operUrl = operUrl;
    }

    public String getOperIp()
    {
        return operIp;
    }

    public void setOperIp(String operIp)
    {
        this.operIp = operIp;
    }

    public String getOperLocation()
    {
        return operLocation;
    }

    public void setOperLocation(String operLocation)
    {
        this.operLocation = operLocation;
    }

    public String getOperParam()
    {
        return operParam;
    }

    public void setOperParam(String operParam)
    {
        this.operParam = operParam;
    }

    public String getJsonResult()
    {
        return jsonResult;
    }

    public void setJsonResult(String jsonResult)
    {
        this.jsonResult = jsonResult;
    }

    public Integer getStatus()
    {
        return status;
    }

    public void setStatus(Integer status)
    {
        this.status = status;
    }

    public String getErrorMsg()
    {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg)
    {
        this.errorMsg = errorMsg;
    }

    public Date getOperTime()
    {
        return operTime;
    }

    public void setOperTime(Date operTime)
    {
        this.operTime = operTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("operId", getOperId())
            .append("title", getTitle())
            .append("businessType", getBusinessType())
            .append("businessTypes", getBusinessTypes())
            .append("method", getMethod())
            .append("requestMethod", getRequestMethod())
            .append("operatorType", getOperatorType())
            .append("operName", getOperName())
            .append("deptName", getDeptName())
            .append("operUrl", getOperUrl())
            .append("operIp", getOperIp())
            .append("operLocation", getOperLocation())
            .append("operParam", getOperParam())
            .append("status", getStatus())
            .append("errorMsg", getErrorMsg())
            .append("operTime", getOperTime())
            .toString();
    }
}
```

添加字符串翻译内容

**ruoyi-system\com\ruoyi\system\domain\read\BusiTypeStringNumberConverter.java**
```java
package com.ruoyi.system.domain.read;

import com.alibaba.excel.converters.Converter;
import com.alibaba.excel.enums.CellDataTypeEnum;
import com.alibaba.excel.metadata.CellData;
import com.alibaba.excel.metadata.GlobalConfiguration;
import com.alibaba.excel.metadata.property.ExcelContentProperty;

/**
 * 业务类型字符串处理
 *
 * @author ruoyi
 */
@SuppressWarnings("rawtypes")
public class BusiTypeStringNumberConverter implements Converter<Integer>
{
    @Override
    public Class supportJavaTypeKey()
    {
        return Integer.class;
    }

    @Override
    public CellDataTypeEnum supportExcelTypeKey()
    {
        return CellDataTypeEnum.STRING;
    }

    @Override
    public Integer convertToJavaData(CellData cellData, ExcelContentProperty contentProperty,
            GlobalConfiguration globalConfiguration)
    {
        Integer value = 0;
        String str = cellData.getStringValue();
        if ("新增".equals(str))
        {
            value = 1;
        }
        else if ("修改".equals(str))
        {
            value = 2;
        }
        else if ("删除".equals(str))
        {
            value = 3;
        }
        else if ("授权".equals(str))
        {
            value = 4;
        }
        else if ("导出".equals(str))
        {
            value = 5;
        }
        else if ("导入".equals(str))
        {
            value = 6;
        }
        else if ("强退".equals(str))
        {
            value = 7;
        }
        else if ("生成代码".equals(str))
        {
            value = 8;
        }
        else if ("清空数据".equals(str))
        {
            value = 9;
        }
        return value;
    }

    @Override
    public CellData convertToExcelData(Integer value, ExcelContentProperty contentProperty,
            GlobalConfiguration globalConfiguration)
    {
        String str = "其他";
        if (1 == value)
        {
            str = "新增";
        }
        else if (2 == value)
        {
            str = "修改";
        }
        else if (3 == value)
        {
            str = "删除";
        }
        else if (4 == value)
        {
            str = "授权";
        }
        else if (5 == value)
        {
            str = "导出";
        }
        else if (6 == value)
        {
            str = "导入";
        }
        else if (7 == value)
        {
            str = "强退";
        }
        else if (8 == value)
        {
            str = "生成代码";
        }
        else if (9 == value)
        {
            str = "清空数据";
        }
        return new CellData(str);
    }
}
```

**ruoyi-system\com\ruoyi\system\domain\read\OperTypeConverter.java**
```java
package com.ruoyi.system.domain.read;

import com.alibaba.excel.converters.Converter;
import com.alibaba.excel.enums.CellDataTypeEnum;
import com.alibaba.excel.metadata.CellData;
import com.alibaba.excel.metadata.GlobalConfiguration;
import com.alibaba.excel.metadata.property.ExcelContentProperty;

/**
 * 操作类别字符串处理
 *
 * @author ruoyi
 */
@SuppressWarnings("rawtypes")
public class OperTypeConverter implements Converter<Integer>
{
    @Override
    public Class supportJavaTypeKey()
    {
        return Integer.class;
    }

    @Override
    public CellDataTypeEnum supportExcelTypeKey()
    {
        return CellDataTypeEnum.STRING;
    }

    @Override
    public Integer convertToJavaData(CellData cellData, ExcelContentProperty contentProperty,
            GlobalConfiguration globalConfiguration)
    {
        Integer value = 0;
        String str = cellData.getStringValue();
        if ("后台用户".equals(str))
        {
            value = 1;
        }
        else if ("手机端用户".equals(str))
        {
            value = 2;
        }
        return value;
    }

    @Override
    public CellData convertToExcelData(Integer value, ExcelContentProperty contentProperty,
            GlobalConfiguration globalConfiguration)
    {
        String str = "其他";
        if (1 == value)
        {
            str = "后台用户";
        }
        else if (2 == value)
        {
            str = "手机端用户";
        }
        return new CellData(str);
    }
}
```

**ruoyi-system\com\ruoyi\system\domain\read\StatusConverter.java**
```java
package com.ruoyi.system.domain.read;

import com.alibaba.excel.converters.Converter;
import com.alibaba.excel.enums.CellDataTypeEnum;
import com.alibaba.excel.metadata.CellData;
import com.alibaba.excel.metadata.GlobalConfiguration;
import com.alibaba.excel.metadata.property.ExcelContentProperty;

/**
 * 状态字符串处理
 *
 * @author ruoyi
 */
@SuppressWarnings("rawtypes")
public class StatusConverter implements Converter<Integer>
{
    @Override
    public Class supportJavaTypeKey()
    {
        return Integer.class;
    }

    @Override
    public CellDataTypeEnum supportExcelTypeKey()
    {
        return CellDataTypeEnum.STRING;
    }

    @Override
    public Integer convertToJavaData(CellData cellData, ExcelContentProperty contentProperty,
            GlobalConfiguration globalConfiguration)
    {
        return "正常".equals(cellData.getStringValue()) ? 1 : 0;
    }

    @Override
    public CellData convertToExcelData(Integer value, ExcelContentProperty contentProperty,
            GlobalConfiguration globalConfiguration)
    {
        return new CellData(0 == value ? "正常" : "异常");
    }
}
```


4、登录系统，进入系统管理-日志管理-操作日志-执行导出功能


## 集成knife4j实现swagger文档增强

如果不习惯使用`swagger`可以使用`前端UI`的增强解决方案`knife4j`，对比`swagger`相比有以下优势，友好界面，离线文档，接口排序，安全控制，在线调试，文档清晰，注解增强，容易上手。

1、`ruoyi-admin\pom.xml`模块添加整合依赖
```xml
<!-- knife4j -->
<dependency>
	<groupId>com.github.xiaoymin</groupId>
	<artifactId>knife4j-spring-boot-starter</artifactId>
	<version>3.0.3</version>
</dependency>
```

2、`SwaggerController.java`修改跳转访问地址
```java
// 默认swagger-ui.html前端ui访问地址
public String index()
{
	return redirect("/swagger-ui.html");
}
// 修改成knife4j前端ui访问地址doc.html
public String index()
{
	return redirect("/doc.html");
}
```

3、登录系统，访问菜单系统工具/系统接口，出现如下图表示成功。

![knife4j](https://oscimg.oschina.net/oscnet/up-655dda1db8c211aa94768f68941565ef3b2.png)

:::tip 提示
引用`knife4j-spring-boot-starter`依赖，项目中的`swagger`依赖可以删除。
:::


## 集成ueditor实现富文本编辑器增强

`UEditor`是由百度前端研发部开发所见即所得富文本web编辑器，具有轻量、可定制、注重用户体验等特点。可以很好的满足国内用户的需求。

1、下载UEditor前端插件

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt

`ruoyi/集成ueditor实现富文本编辑器增强.zip`

`ruoyi-admin\src\main\resources\static\ajax\libs\ueditor` 复制插件文件到自己的项目

2、`ruoyi-admin\include.html`添加ueditor
```html
<!-- ueditor富文本编辑器插件 -->
<div th:fragment="ueditor-js">
	<script th:src="@{/ajax/libs/ueditor/ueditor.config.js}"></script>
	<script th:src="@{/ajax/libs/ueditor/ueditor.all.min.js}"></script>
	<script th:src="@{/ajax/libs/ueditor/lang/zh-cn/zh-cn.js}"></script>
</div>
```

3、修改通知公告相关页面

修改 **templates\system\notice\add.html**
```html
<!DOCTYPE html>
<html lang="zh" xmlns:th="http://www.thymeleaf.org" >
<head>
	<th:block th:include="include :: header('新增通知公告')" />
</head>
<body class="white-bg">
    <div class="wrapper wrapper-content animated fadeInRight ibox-content">
        <form class="form-horizontal m" id="form-notice-add">
			<div class="form-group">	
				<label class="col-sm-2 control-label is-required">公告标题：</label>
				<div class="col-sm-10">
					<input id="noticeTitle" name="noticeTitle" class="form-control" type="text" required>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">公告类型：</label>
				<div class="col-sm-10">
					<select name="noticeType" class="form-control m-b" th:with="type=${@dict.getType('sys_notice_type')}">
	                    <option th:each="dict : ${type}" th:text="${dict.dictLabel}" th:value="${dict.dictValue}"></option>
	                </select>
				</div>
			</div>
			<div class="form-group">	
				<label class="col-sm-2 control-label">公告内容：</label>
				<div class="col-sm-10">
				    <script id="editor" name="noticeContent" type="text/plain" style="height: 300px;"></script>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">公告状态：</label>
				<div class="col-sm-10">
				    <div class="radio-box" th:each="dict : ${@dict.getType('sys_notice_status')}">
						<input type="radio" th:id="${dict.dictCode}" name="status" th:value="${dict.dictValue}" th:checked="${dict.default}">
						<label th:for="${dict.dictCode}" th:text="${dict.dictLabel}"></label>
					</div>
				</div>
			</div>
		</form>
	</div>
    <th:block th:include="include :: footer" />
    <th:block th:include="include :: ueditor-js" />
    <script type="text/javascript">
        var prefix = ctx + "system/notice";
        
        var ue = UE.getEditor('editor');

        function getContentTxt() {
            return UE.getEditor('editor').getContentTxt();
        }
        
		$("#form-notice-add").validate({
			focusCleanup: true
		});
		
		function submitHandler() {
	        if ($.validate.form()) {
	        	var text = getContentTxt();
	            if (text == '' || text.length == 0) {
	                $.modal.alertWarning("请输入公告内容！");
	                return;
	            }
				$.operate.save(prefix + "/add", $('#form-notice-add').serialize());
	        }
	    }
	</script>
</body>
</html>
```

修改 **templates\system\notice\edit.html**
```html
<!DOCTYPE html>
<html lang="zh" xmlns:th="http://www.thymeleaf.org" >
<head>
	<th:block th:include="include :: header('修改通知公告')" />
</head>
<body class="white-bg">
    <div class="wrapper wrapper-content animated fadeInRight ibox-content">
        <form class="form-horizontal m" id="form-notice-edit" th:object="${notice}">
            <input id="noticeId" name="noticeId" th:field="*{noticeId}"  type="hidden">
            <div class="form-group">	
                <label class="col-sm-2 control-label is-required">公告标题：</label>
                <div class="col-sm-10">
                    <input id="noticeTitle" name="noticeTitle" th:field="*{noticeTitle}" class="form-control" type="text" required>
                </div>
            </div>
            <div class="form-group">
				<label class="col-sm-2 control-label">公告类型：</label>
				<div class="col-sm-10">
					<select name="noticeType" class="form-control m-b" th:with="type=${@dict.getType('sys_notice_type')}">
	                    <option th:each="dict : ${type}" th:text="${dict.dictLabel}" th:value="${dict.dictValue}" th:field="*{noticeType}"></option>
	                </select>
				</div>
			</div>
            <div class="form-group">	
                <label class="col-sm-2 control-label">公告内容：</label>
                <div class="col-sm-10">
                    <script id="editor" name="noticeContent" type="text/plain" style="height: 300px;"></script>
                    <textarea id="noticeContent" style="display: none;">[[*{noticeContent}]]</textarea>
                </div>
            </div>
            <div class="form-group">
				<label class="col-sm-2 control-label">公告状态：</label>
				<div class="col-sm-10">
					<div class="radio-box" th:each="dict : ${@dict.getType('sys_notice_status')}">
						<input type="radio" th:id="${dict.dictCode}" name="status" th:value="${dict.dictValue}" th:field="*{status}">
						<label th:for="${dict.dictCode}" th:text="${dict.dictLabel}"></label>
					</div>
				</div>
			</div>
		</form>
    </div>
    <th:block th:include="include :: footer" />
    <th:block th:include="include :: ueditor-js" />
    <script type="text/javascript">
        var prefix = ctx + "system/notice";
        
        $(function () {
            var text = $("#noticeContent").text();
            var ue = UE.getEditor('editor');
            ue.ready(function () {
                ue.setContent(text);
            });
        })

        function getContentTxt() {
            return UE.getEditor('editor').getContentTxt();
        }
	    
		$("#form-notice-edit").validate({
			focusCleanup: true
		});
		
		function submitHandler() {
	        if ($.validate.form()) {
	        	var text = getContentTxt();
	            if (text == '' || text.length == 0) {
	                $.modal.alertWarning("请输入通知内容！");
	                return;
	            }
				$.operate.save(prefix + "/edit", $('#form-notice-edit').serialize());
	        }
	    }
	</script>
</body>
</html>
```

4、添加配置文件到`ruoyi-admin\src\main\resources`

新增 **ueditor-config.json**
```json
/* 前后端通信相关的配置,注释只允许使用多行方式 */
{
    /* 上传图片配置项 */
    "imageActionName": "uploadimage", /* 执行上传图片的action名称 */
    "imageFieldName": "upfile", /* 提交的图片表单名称 */
    "imageMaxSize": 2048000, /* 上传大小限制，单位B */
    "imageAllowFiles": [".png", ".jpg", ".jpeg", ".gif", ".bmp"], /* 上传图片格式显示 */
    "imageCompressEnable": true, /* 是否压缩图片,默认是true */
    "imageCompressBorder": 1600, /* 图片压缩最长边限制 */
    "imageInsertAlign": "none", /* 插入的图片浮动方式 */
    "imageUrlPrefix": "", /* 图片访问路径前缀 */
    "imagePathFormat": "/ueditor/jsp/upload/image/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
                                /* {filename} 会替换成原文件名,配置这项需要注意中文乱码问题 */
                                /* {rand:6} 会替换成随机数,后面的数字是随机数的位数 */
                                /* {time} 会替换成时间戳 */
                                /* {yyyy} 会替换成四位年份 */
                                /* {yy} 会替换成两位年份 */
                                /* {mm} 会替换成两位月份 */
                                /* {dd} 会替换成两位日期 */
                                /* {hh} 会替换成两位小时 */
                                /* {ii} 会替换成两位分钟 */
                                /* {ss} 会替换成两位秒 */
                                /* 非法字符 \ : * ? " < > | */
                                /* 具请体看线上文档: fex.baidu.com/ueditor/#use-format_upload_filename */

    /* 涂鸦图片上传配置项 */
    "scrawlActionName": "uploadscrawl", /* 执行上传涂鸦的action名称 */
    "scrawlFieldName": "upfile", /* 提交的图片表单名称 */
    "scrawlPathFormat": "/ueditor/jsp/upload/image/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
    "scrawlMaxSize": 2048000, /* 上传大小限制，单位B */
    "scrawlUrlPrefix": "", /* 图片访问路径前缀 */
    "scrawlInsertAlign": "none",

    /* 截图工具上传 */
    "snapscreenActionName": "uploadimage", /* 执行上传截图的action名称 */
    "snapscreenPathFormat": "/ueditor/jsp/upload/image/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
    "snapscreenUrlPrefix": "", /* 图片访问路径前缀 */
    "snapscreenInsertAlign": "none", /* 插入的图片浮动方式 */

    /* 抓取远程图片配置 */
    "catcherLocalDomain": ["127.0.0.1", "localhost", "img.baidu.com"],
    "catcherActionName": "catchimage", /* 执行抓取远程图片的action名称 */
    "catcherFieldName": "source", /* 提交的图片列表表单名称 */
    "catcherPathFormat": "/ueditor/jsp/upload/image/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
    "catcherUrlPrefix": "", /* 图片访问路径前缀 */
    "catcherMaxSize": 2048000, /* 上传大小限制，单位B */
    "catcherAllowFiles": [".png", ".jpg", ".jpeg", ".gif", ".bmp"], /* 抓取图片格式显示 */

    /* 上传视频配置 */
    "videoActionName": "uploadvideo", /* 执行上传视频的action名称 */
    "videoFieldName": "upfile", /* 提交的视频表单名称 */
    "videoPathFormat": "/ueditor/jsp/upload/video/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
    "videoUrlPrefix": "", /* 视频访问路径前缀 */
    "videoMaxSize": 102400000, /* 上传大小限制，单位B，默认100MB */
    "videoAllowFiles": [
        ".flv", ".swf", ".mkv", ".avi", ".rm", ".rmvb", ".mpeg", ".mpg",
        ".ogg", ".ogv", ".mov", ".wmv", ".mp4", ".webm", ".mp3", ".wav", ".mid"], /* 上传视频格式显示 */

    /* 上传文件配置 */
    "fileActionName": "uploadfile", /* controller里,执行上传视频的action名称 */
    "fileFieldName": "upfile", /* 提交的文件表单名称 */
    "filePathFormat": "/ueditor/jsp/upload/file/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
    "fileUrlPrefix": "", /* 文件访问路径前缀 */
    "fileMaxSize": 51200000, /* 上传大小限制，单位B，默认50MB */
    "fileAllowFiles": [
        ".png", ".jpg", ".jpeg", ".gif", ".bmp",
        ".flv", ".swf", ".mkv", ".avi", ".rm", ".rmvb", ".mpeg", ".mpg",
        ".ogg", ".ogv", ".mov", ".wmv", ".mp4", ".webm", ".mp3", ".wav", ".mid",
        ".rar", ".zip", ".tar", ".gz", ".7z", ".bz2", ".cab", ".iso",
        ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".pdf", ".txt", ".md", ".xml"
    ], /* 上传文件格式显示 */

    /* 列出指定目录下的图片 */
    "imageManagerActionName": "listimage", /* 执行图片管理的action名称 */
    "imageManagerListPath": "/ueditor/jsp/upload/image/", /* 指定要列出图片的目录 */
    "imageManagerListSize": 20, /* 每次列出文件数量 */
    "imageManagerUrlPrefix": "", /* 图片访问路径前缀 */
    "imageManagerInsertAlign": "none", /* 插入的图片浮动方式 */
    "imageManagerAllowFiles": [".png", ".jpg", ".jpeg", ".gif", ".bmp"], /* 列出的文件类型 */

    /* 列出指定目录下的文件 */
    "fileManagerActionName": "listfile", /* 执行文件管理的action名称 */
    "fileManagerListPath": "/ueditor/jsp/upload/file/", /* 指定要列出文件的目录 */
    "fileManagerUrlPrefix": "", /* 文件访问路径前缀 */
    "fileManagerListSize": 20, /* 每次列出文件数量 */
    "fileManagerAllowFiles": [
        ".png", ".jpg", ".jpeg", ".gif", ".bmp",
        ".flv", ".swf", ".mkv", ".avi", ".rm", ".rmvb", ".mpeg", ".mpg",
        ".ogg", ".ogv", ".mov", ".wmv", ".mp4", ".webm", ".mp3", ".wav", ".mid",
        ".rar", ".zip", ".tar", ".gz", ".7z", ".bz2", ".cab", ".iso",
        ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".pdf", ".txt", ".md", ".xml"
    ] /* 列出的文件类型 */

}
```

5、新增`Ueditor`请求处理控制器

新增 `ruoyi-admin\controller\common\UeditorController.java`
```java
package com.ruoyi.web.controller.common;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.config.ServerConfig;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.utils.file.FileUploadUtils;

/**
 * Ueditor 请求处理
 *
 * @author ruoyi
 */
@SuppressWarnings("serial")
@Controller
@RequestMapping("/ajax/libs/ueditor")
public class UeditorController extends BaseController
{
    private final String METHOD_HEAD = "ueditor";
    private final String IMGE_PATH = "/ueditor/images/";
    private final String VIDEO_PATH = "/ueditor/videos/";
    private final String FILE_PATH = "/ueditor/files/";

    @Autowired
    private ServerConfig serverConfig;

    /**
     * ueditor
     */
    @ResponseBody
    @RequestMapping(value = "/ueditor/controller")
    public Object ueditor(HttpServletRequest request, @RequestParam(value = "action", required = true) String action,
            MultipartFile upfile) throws Exception
    {
        List<Object> param = new ArrayList<Object>()
        {
            {
                add(action);
                add(upfile);
            }
        };
        Method method = this.getClass().getMethod(METHOD_HEAD + action, List.class, String.class);
        return method.invoke(this.getClass().newInstance(), param, serverConfig.getUrl());
    }

    /**
     * 读取配置文件
     */
    public JSONObject ueditorconfig(List<Object> param, String fileSuffixUrl) throws Exception
    {
        ClassPathResource classPathResource = new ClassPathResource("ueditor-config.json");
        String jsonString = new BufferedReader(new InputStreamReader(classPathResource.getInputStream())).lines().parallel().collect(Collectors.joining(System.lineSeparator()));
        JSONObject json = JSON.parseObject(jsonString, JSONObject.class);
        return json;
    }

    /**
     * 上传图片
     */
    public JSONObject ueditoruploadimage(List<Object> param, String fileSuffixUrl) throws Exception
    {
        JSONObject json = new JSONObject();
        json.put("state", "SUCCESS");
        json.put("url", ueditorcore(param, IMGE_PATH, false, fileSuffixUrl));
        return json;
    }

    /**
     * 上传视频
     */
    public JSONObject ueditoruploadvideo(List<Object> param, String fileSuffixUrl) throws Exception
    {
        JSONObject json = new JSONObject();
        json.put("state", "SUCCESS");
        json.put("url", ueditorcore(param, VIDEO_PATH, false, fileSuffixUrl));
        return json;
    }

    /**
     * 上传附件
     */
    public JSONObject ueditoruploadfile(List<Object> param, String fileSuffixUrl) throws Exception
    {
        JSONObject json = new JSONObject();
        json.put("state", "SUCCESS");
        json.put("url", ueditorcore(param, FILE_PATH, true, fileSuffixUrl));
        return json;
    }

    public String ueditorcore(List<Object> param, String path, boolean isFileName, String fileSuffixUrl)
            throws Exception
    {
        MultipartFile upfile = (MultipartFile) param.get(1);
        // 上传文件路径
        String filePath = RuoYiConfig.getUploadPath();
        String fileName = FileUploadUtils.upload(filePath, upfile);
        String url = fileSuffixUrl + fileName;
        return url;
    }
}
```

6、登录系统，进入通知公告菜单测试富文本操作。


## 集成ip2region实现离线IP地址定位

离线IP地址定位库主要用于内网或想减少对外访问`http`带来的资源消耗。`（代码已兼容支持jar包部署）`

1、引入依赖
```xml
<!-- 离线IP地址定位库 -->
<dependency>
	<groupId>org.lionsoul</groupId>
	<artifactId>ip2region</artifactId>
	<version>1.7.2</version>
</dependency>
```

2、添加工具类`RegionUtil.java`
```java
package com.ruoyi.common.utils;

import java.io.File;
import java.io.InputStream;
import java.lang.reflect.Method;
import org.apache.commons.io.FileUtils;
import org.lionsoul.ip2region.DataBlock;
import org.lionsoul.ip2region.DbConfig;
import org.lionsoul.ip2region.DbSearcher;
import org.lionsoul.ip2region.Util;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ClassPathResource;

/**
 * 根据ip离线查询地址
 *
 * @author ruoyi
 */
public class RegionUtil
{
    private static final Logger log = LoggerFactory.getLogger(RegionUtil.class);

    private static final String JAVA_TEMP_DIR = "java.io.tmpdir";

    static DbConfig config = null;
    static DbSearcher searcher = null;

    /**
     * 初始化IP库
     */
    static
    {
        try
        {
            // 因为jar无法读取文件,复制创建临时文件
            String dbPath = RegionUtil.class.getResource("/ip2region/ip2region.db").getPath();
            File file = new File(dbPath);
            if (!file.exists())
            {
                String tmpDir = System.getProperties().getProperty(JAVA_TEMP_DIR);
                dbPath = tmpDir + "ip2region.db";
                file = new File(dbPath);
                ClassPathResource cpr = new ClassPathResource("ip2region" + File.separator + "ip2region.db");
                InputStream resourceAsStream = cpr.getInputStream();
                if (resourceAsStream != null)
                {
                    FileUtils.copyInputStreamToFile(resourceAsStream, file);
                }
            }
            config = new DbConfig();
            searcher = new DbSearcher(config, dbPath);
            log.info("bean [{}]", config);
            log.info("bean [{}]", searcher);
        }
        catch (Exception e)
        {
            log.error("init ip region error:{}", e);
        }
    }

    /**
     * 解析IP
     *
     * @param ip
     * @return
     */
    public static String getRegion(String ip)
    {
        try
        {
            // db
            if (searcher == null || StringUtils.isEmpty(ip))
            {
                log.error("DbSearcher is null");
                return StringUtils.EMPTY;
            }
            long startTime = System.currentTimeMillis();
            // 查询算法
            int algorithm = DbSearcher.MEMORY_ALGORITYM;
            Method method = null;
            switch (algorithm)
            {
                case DbSearcher.BTREE_ALGORITHM:
                    method = searcher.getClass().getMethod("btreeSearch", String.class);
                    break;
                case DbSearcher.BINARY_ALGORITHM:
                    method = searcher.getClass().getMethod("binarySearch", String.class);
                    break;
                case DbSearcher.MEMORY_ALGORITYM:
                    method = searcher.getClass().getMethod("memorySearch", String.class);
                    break;
            }

            DataBlock dataBlock = null;
            if (Util.isIpAddress(ip) == false)
            {
                log.warn("warning: Invalid ip address");
            }
            dataBlock = (DataBlock) method.invoke(searcher, ip);
            String result = dataBlock.getRegion();
            long endTime = System.currentTimeMillis();
            log.debug("region use time[{}] result[{}]", endTime - startTime, result);
            return result;

        }
        catch (Exception e)
        {
            log.error("error:{}", e);
        }
        return StringUtils.EMPTY;
    }

}
```

3、修改`AddressUtils.java`
```java
package com.ruoyi.common.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.ruoyi.common.config.RuoYiConfig;

/**
 * 获取地址类
 * 
 * @author ruoyi
 */
public class AddressUtils
{
    private static final Logger log = LoggerFactory.getLogger(AddressUtils.class);

    // 未知地址
    public static final String UNKNOWN = "XX XX";

    public static String getRealAddressByIP(String ip)
    {
        String address = UNKNOWN;
        // 内网不查询
        if (IpUtils.internalIp(ip))
        {
            return "内网IP";
        }
        if (RuoYiConfig.isAddressEnabled())
        {
            try
            {
                String rspStr = RegionUtil.getRegion(ip);
                if (StringUtils.isEmpty(rspStr))
                {
                    log.error("获取地理位置异常 {}", ip);
                    return UNKNOWN;
                }
                String[] obj = rspStr.split("\\|");
                String region = obj[2];
                String city = obj[3];

                return String.format("%s %s", region, city);
            }
            catch (Exception e)
            {
                log.error("获取地理位置异常 {}", e);
            }
        }
        return address;
    }
}
```

4、添加离线IP地址库插件

下载前端插件相关包和代码实现`ruoyi/集成ip2region离线地址定位.zip`

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt

5、添加离线IP地址库

在`src/main/resources`下新建`ip2region`复制文件`ip2region.db`到目录下。


## 集成jsencrypt实现密码加密传输方式

目前登录接口密码是明文传输，如果安全性有要求，可以调整成加密方式传输。参考如下

1、修改前端login.js对密码进行rsa加密。
```js
// 密钥对生成 http://web.chacuo.net/netrsakeypair

const publicKey = 'MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKoR8mX0rGKLqzcWmOzbfj64K8ZIgOdH\n' +
  'nzkXSOVOZbFu/TJhZ7rFAN+eaGkl3C4buccQd/EjEsj9ir7ijT7h96MCAwEAAQ=='

// 加密
function encrypt(txt) {
  const encryptor = new JSEncrypt()
  encryptor.setPublicKey(publicKey) // 设置公钥
  return encryptor.encrypt(txt) // 对数据进行加密
}

$(function() {
    validateKickout();
    validateRule();
    $('.imgcode').click(function() {
        var url = ctx + "captcha/captchaImage?type=" + captchaType + "&s=" + Math.random();
        $(".imgcode").attr("src", url);
    });
});

$.validator.setDefaults({
    submitHandler: function() {
        login();
    }
});

function login() {
    $.modal.loading($("#btnSubmit").data("loading"));
    var username = $.common.trim($("input[name='username']").val());
    var password = $.common.trim($("input[name='password']").val());
    var validateCode = $("input[name='validateCode']").val();
    var rememberMe = $("input[name='rememberme']").is(':checked');
    $.ajax({
        type: "post",
        url: ctx + "login",
        data: {
            "username": username,
            "password": encrypt(password),
            "validateCode": validateCode,
            "rememberMe": rememberMe
        },
        success: function(r) {
            if (r.code == web_status.SUCCESS) {
                location.href = ctx + 'index';
            } else {
            	$.modal.closeLoading();
            	$('.imgcode').click();
            	$(".code").val("");
            	$.modal.msg(r.msg);
            }
        }
    });
}

function validateRule() {
    var icon = "<i class='fa fa-times-circle'></i> ";
    $("#signupForm").validate({
        rules: {
            username: {
                required: true
            },
            password: {
                required: true
            }
        },
        messages: {
            username: {
                required: icon + "请输入您的用户名",
            },
            password: {
                required: icon + "请输入您的密码",
            }
        }
    })
}

function validateKickout() {
    if (getParam("kickout") == 1) {
        layer.alert("<font color='red'>您已在别处登录，请您修改密码或重新登录</font>", {
            icon: 0,
            title: "系统提示"
        },
        function(index) {
            //关闭弹窗
            layer.close(index);
            if (top != self) {
                top.location = self.location;
            } else {
                var url  =  location.search;
                if (url) {
                    var oldUrl  = window.location.href;
                    var newUrl  = oldUrl.substring(0,  oldUrl.indexOf('?'));
                    self.location  = newUrl;
                }
            }
        });
    }
}

function getParam(paramName) {
    var reg = new RegExp("(^|&)" + paramName + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return decodeURI(r[2]);
    return null;
}
```

2、修改login.html文件，引入jsencrypt插件
```html
<script src="../static/js/jsencrypt.min.js" th:src="@{/js/jsencrypt.min.js}"></script>
```

3、工具类sign包下添加RsaUtils.java，用于RSA加密解密。
```java
package com.ruoyi.common.utils.security;

import org.apache.commons.codec.binary.Base64;
import javax.crypto.Cipher;
import java.security.*;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

/**
 * RSA加密解密
 * 
 * @author ruoyi
 **/
public class RsaUtils
{
    // Rsa 私钥
    public static String privateKey = "MIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAqhHyZfSsYourNxaY"
            + "7Nt+PrgrxkiA50efORdI5U5lsW79MmFnusUA355oaSXcLhu5xxB38SMSyP2KvuKN"
            + "PuH3owIDAQABAkAfoiLyL+Z4lf4Myxk6xUDgLaWGximj20CUf+5BKKnlrK+Ed8gA"
            + "kM0HqoTt2UZwA5E2MzS4EI2gjfQhz5X28uqxAiEA3wNFxfrCZlSZHb0gn2zDpWow"
            + "cSxQAgiCstxGUoOqlW8CIQDDOerGKH5OmCJ4Z21v+F25WaHYPxCFMvwxpcw99Ecv"
            + "DQIgIdhDTIqD2jfYjPTY8Jj3EDGPbH2HHuffvflECt3Ek60CIQCFRlCkHpi7hthh"
            + "YhovyloRYsM+IS9h/0BzlEAuO0ktMQIgSPT3aFAgJYwKpqRYKlLDVcflZFCKY7u3" + "UP8iWi1Qw0Y=";

    /**
     * 私钥解密
     *
     * @param privateKeyString 私钥
     * @param text 待解密的文本
     * @return 解密后的文本
     */
    public static String decryptByPrivateKey(String text) throws Exception
    {
        return decryptByPrivateKey(privateKey, text);
    }

    /**
     * 公钥解密
     *
     * @param publicKeyString 公钥
     * @param text 待解密的信息
     * @return 解密后的文本
     */
    public static String decryptByPublicKey(String publicKeyString, String text) throws Exception
    {
        X509EncodedKeySpec x509EncodedKeySpec = new X509EncodedKeySpec(Base64.decodeBase64(publicKeyString));
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PublicKey publicKey = keyFactory.generatePublic(x509EncodedKeySpec);
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.DECRYPT_MODE, publicKey);
        byte[] result = cipher.doFinal(Base64.decodeBase64(text));
        return new String(result);
    }

    /**
     * 私钥加密
     *
     * @param privateKeyString 私钥
     * @param text 待加密的信息
     * @return 加密后的文本
     */
    public static String encryptByPrivateKey(String privateKeyString, String text) throws Exception
    {
        PKCS8EncodedKeySpec pkcs8EncodedKeySpec = new PKCS8EncodedKeySpec(Base64.decodeBase64(privateKeyString));
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = keyFactory.generatePrivate(pkcs8EncodedKeySpec);
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.ENCRYPT_MODE, privateKey);
        byte[] result = cipher.doFinal(text.getBytes());
        return Base64.encodeBase64String(result);
    }

    /**
     * 私钥解密
     *
     * @param privateKeyString 私钥
     * @param text 待解密的文本
     * @return 解密后的文本
     */
    public static String decryptByPrivateKey(String privateKeyString, String text) throws Exception
    {
        PKCS8EncodedKeySpec pkcs8EncodedKeySpec5 = new PKCS8EncodedKeySpec(Base64.decodeBase64(privateKeyString));
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PrivateKey privateKey = keyFactory.generatePrivate(pkcs8EncodedKeySpec5);
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] result = cipher.doFinal(Base64.decodeBase64(text));
        return new String(result);
    }

    /**
     * 公钥加密
     *
     * @param publicKeyString 公钥
     * @param text 待加密的文本
     * @return 加密后的文本
     */
    public static String encryptByPublicKey(String publicKeyString, String text) throws Exception
    {
        X509EncodedKeySpec x509EncodedKeySpec2 = new X509EncodedKeySpec(Base64.decodeBase64(publicKeyString));
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PublicKey publicKey = keyFactory.generatePublic(x509EncodedKeySpec2);
        Cipher cipher = Cipher.getInstance("RSA");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] result = cipher.doFinal(text.getBytes());
        return Base64.encodeBase64String(result);
    }

    /**
     * 构建RSA密钥对
     *
     * @return 生成后的公私钥信息
     */
    public static RsaKeyPair generateKeyPair() throws NoSuchAlgorithmException
    {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA");
        keyPairGenerator.initialize(1024);
        KeyPair keyPair = keyPairGenerator.generateKeyPair();
        RSAPublicKey rsaPublicKey = (RSAPublicKey) keyPair.getPublic();
        RSAPrivateKey rsaPrivateKey = (RSAPrivateKey) keyPair.getPrivate();
        String publicKeyString = Base64.encodeBase64String(rsaPublicKey.getEncoded());
        String privateKeyString = Base64.encodeBase64String(rsaPrivateKey.getEncoded());
        return new RsaKeyPair(publicKeyString, privateKeyString);
    }

    /**
     * RSA密钥对对象
     */
    public static class RsaKeyPair
    {
        private final String publicKey;
        private final String privateKey;

        public RsaKeyPair(String publicKey, String privateKey)
        {
            this.publicKey = publicKey;
            this.privateKey = privateKey;
        }

        public String getPublicKey()
        {
            return publicKey;
        }

        public String getPrivateKey()
        {
            return privateKey;
        }
    }
}
```

4、登录方法SysLoginController.java，对密码进行rsa解密。
```java
package com.ruoyi.web.controller.system;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.ServletUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.security.RsaUtils;

/**
 * 登录验证
 * 
 * @author ruoyi
 */
@Controller
public class SysLoginController extends BaseController
{
    @GetMapping("/login")
    public String login(HttpServletRequest request, HttpServletResponse response)
    {
        // 如果是Ajax请求，返回Json字符串。
        if (ServletUtils.isAjaxRequest(request))
        {
            return ServletUtils.renderString(response, "{\"code\":\"1\",\"msg\":\"未登录或登录超时。请重新登录\"}");
        }

        return "login";
    }

    @PostMapping("/login")
    @ResponseBody
    public AjaxResult ajaxLogin(String username, String password, Boolean rememberMe)
    {
        try
        {
            UsernamePasswordToken token = new UsernamePasswordToken(username, RsaUtils.decryptByPrivateKey(password), rememberMe);
            Subject subject = SecurityUtils.getSubject();
            subject.login(token);
            return success();
        }
        catch (Exception e)
        {
            String msg = "用户或密码错误";
            if (StringUtils.isNotEmpty(e.getMessage()))
            {
                msg = e.getMessage();
            }
            return error(msg);
        }
    }

    @GetMapping("/unauth")
    public String unauth()
    {
        return "error/unauth";
    }
}
```

4、测试访问验证

访问 http://localhost/login 登录页面。提交时检查密码是否为加密传输，且后台也能正常解密。

下载前端插件相关包和代码实现`ruoyi/集成jsencrypt实现密码加密传输方式.zip`

链接: https://pan.baidu.com/s/13JVC9jm-Dp9PfHdDDylLCQ 提取码: y9jt


## 集成druid实现数据库密码加密功能

数据库密码直接写在配置中，对运维安全来说，是一个很大的挑战。可以使用`Druid`为此提供一种数据库密码加密的手段`ConfigFilter`。项目已经集成`druid`所以只需按要求配置即可。

1、执行命令加密数据库密码
```sh
java -cp druid-1.2.4.jar com.alibaba.druid.filter.config.ConfigTools password
```
`password`输入你的数据库密码，输出的是加密后的结果。
```
privateKey:MIIBVAIBADANBgkqhkiG9w0BAQEFAASCAT4wggE6AgEAAkEAuLMVAFmcew+mPfVnzI6utEvhHWO2s6e4R1bVW3a9IpH+pEypeNV6KtZ/w9PuysPfdPxW5fN3BmnKFZUAIMvWhQIDAQABAkA6rnsfr1juKFyzFsMx1KthETKmucWUctczoz0KYEFbN+joNsd/ApQqsS/2MVG1QWbDJLUsSLWkchvRbtiqOlVJAiEA6KmgVeLR2qUU9gv6DJfuWk4Ol1M9GJnTamgyDttsSGcCIQDLOdjcht29s954vApG1fiPTP/kMvZ5aLrccw1lEuEGMwIhAKoe3c3u++MTsi/2se9jaDU/vguIIbRLRfsYFQIoDxUhAiAnCm/cvZPvk5RTgVxAC276qIIoJpou7K2pF/kkx6Gu/QIgKUVFiM8GVZkOWZC+nUm3UIfpGjrKXjvGrlHNvt89uBA=
publicKey:MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALizFQBZnHsPpj31Z8yOrrRL4R1jtrOnuEdW1Vt2vSKR/qRMqXjVeirWf8PT7srD33T8VuXzdwZpyhWVACDL1oUCAwEAAQ==
password:gkYlljNHKe0/4z7bbJxD7v/txWJIFbiGWwsIPo176Q7fG0UjcSizNxuRUI2ll27ZPQf2ekiHFptus2/Rc4cmvA==
```

2、配置数据源，提示`Druid`数据源需要对数据库密码进行解密。
```yml
# 数据源配置
spring:
    datasource:
        type: com.alibaba.druid.pool.DruidDataSource
        driverClassName: com.mysql.cj.jdbc.Driver
        druid:
            # 主库数据源
            master:
                url: jdbc:mysql://localhost:3306/ry?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
                username: root
                password: gkYlljNHKe0/4z7bbJxD7v/txWJIFbiGWwsIPo176Q7fG0UjcSizNxuRUI2ll27ZPQf2ekiHFptus2/Rc4cmvA==
            # 从库数据源
            slave:
                # 从数据源开关/默认关闭
                enabled: false
                url: 
                username: 
                password: 
            # 初始连接数
            initialSize: 5
            # 最小连接池数量
            minIdle: 10
            # 最大连接池数量
            maxActive: 20
            # 配置获取连接等待超时的时间
            maxWait: 60000
            # 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒
            timeBetweenEvictionRunsMillis: 60000
            # 配置一个连接在池中最小生存的时间，单位是毫秒
            minEvictableIdleTimeMillis: 300000
            # 配置一个连接在池中最大生存的时间，单位是毫秒
            maxEvictableIdleTimeMillis: 900000
            # 配置检测连接是否有效
            validationQuery: SELECT 1 FROM DUAL
            testWhileIdle: true
            testOnBorrow: false
            testOnReturn: false
            connectProperties: config.decrypt=true;config.decrypt.key=MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALizFQBZnHsPpj31Z8yOrrRL4R1jtrOnuEdW1Vt2vSKR/qRMqXjVeirWf8PT7srD33T8VuXzdwZpyhWVACDL1oUCAwEAAQ==
            webStatFilter: 
                enabled: true
            statViewServlet:
                enabled: true
                # 设置白名单，不填则允许所有访问
                allow:
                url-pattern: /druid/*
                # 控制台管理用户名和密码
                login-username: 
                login-password: 
            filter:
                config:
                    # 是否配置加密
                    enabled: true
                stat:
                    enabled: true
                    # 慢SQL记录
                    log-slow-sql: true
                    slow-sql-millis: 1000
                    merge-sql: true
                wall:
                    config:
                        multi-statement-allow: true
```

3、`DruidProperties`配置`connectProperties`属性
```java
package com.ruoyi.framework.config.properties;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import com.alibaba.druid.pool.DruidDataSource;

/**
 * druid 配置属性
 * 
 * @author ruoyi
 */
@Configuration
public class DruidProperties
{
    @Value("${spring.datasource.druid.initialSize}")
    private int initialSize;

    @Value("${spring.datasource.druid.minIdle}")
    private int minIdle;

    @Value("${spring.datasource.druid.maxActive}")
    private int maxActive;

    @Value("${spring.datasource.druid.maxWait}")
    private int maxWait;

    @Value("${spring.datasource.druid.timeBetweenEvictionRunsMillis}")
    private int timeBetweenEvictionRunsMillis;

    @Value("${spring.datasource.druid.minEvictableIdleTimeMillis}")
    private int minEvictableIdleTimeMillis;

    @Value("${spring.datasource.druid.maxEvictableIdleTimeMillis}")
    private int maxEvictableIdleTimeMillis;

    @Value("${spring.datasource.druid.validationQuery}")
    private String validationQuery;

    @Value("${spring.datasource.druid.testWhileIdle}")
    private boolean testWhileIdle;

    @Value("${spring.datasource.druid.testOnBorrow}")
    private boolean testOnBorrow;

    @Value("${spring.datasource.druid.testOnReturn}")
    private boolean testOnReturn;

    @Value("${spring.datasource.druid.connectProperties}")
    private String connectProperties;

    public DruidDataSource dataSource(DruidDataSource datasource)
    {
        /** 配置初始化大小、最小、最大 */
        datasource.setInitialSize(initialSize);
        datasource.setMaxActive(maxActive);
        datasource.setMinIdle(minIdle);

        /** 配置获取连接等待超时的时间 */
        datasource.setMaxWait(maxWait);

        /** 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒 */
        datasource.setTimeBetweenEvictionRunsMillis(timeBetweenEvictionRunsMillis);

        /** 配置一个连接在池中最小、最大生存的时间，单位是毫秒 */
        datasource.setMinEvictableIdleTimeMillis(minEvictableIdleTimeMillis);
        datasource.setMaxEvictableIdleTimeMillis(maxEvictableIdleTimeMillis);

        /**
         * 用来检测连接是否有效的sql，要求是一个查询语句，常用select 'x'。如果validationQuery为null，testOnBorrow、testOnReturn、testWhileIdle都不会起作用。
         */
        datasource.setValidationQuery(validationQuery);
        /** 建议配置为true，不影响性能，并且保证安全性。申请连接的时候检测，如果空闲时间大于timeBetweenEvictionRunsMillis，执行validationQuery检测连接是否有效。 */
        datasource.setTestWhileIdle(testWhileIdle);
        /** 申请连接时执行validationQuery检测连接是否有效，做了这个配置会降低性能。 */
        datasource.setTestOnBorrow(testOnBorrow);
        /** 归还连接时执行validationQuery检测连接是否有效，做了这个配置会降低性能。 */
        datasource.setTestOnReturn(testOnReturn);

        /** 为数据库密码提供加密功能 */
        datasource.setConnectionProperties(connectProperties);
        return datasource;
    }
}
```

4、启动应用程序测试验证加密结果

:::tip 提示
如若忘记密码可以使用工具类解密（传入生成的公钥+密码）
```java
public static void main(String[] args) throws Exception
{
	String password = ConfigTools.decrypt(
			"MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALizFQBZnHsPpj31Z8yOrrRL4R1jtrOnuEdW1Vt2vSKR/qRMqXjVeirWf8PT7srD33T8VuXzdwZpyhWVACDL1oUCAwEAAQ==",
			"gkYlljNHKe0/4z7bbJxD7v/txWJIFbiGWwsIPo176Q7fG0UjcSizNxuRUI2ll27ZPQf2ekiHFptus2/Rc4cmvA==");
	System.out.println("解密密码：" + password);
}
```
:::


## 集成yuicompressor实现(CSS/JS压缩)

在`Maven`打包的时候可以使用`YUI Compressor`（压缩CSS/JS）文件，使用`yuicompressor-maven-plugin`插件进行压缩后会减小体积，提高请求速度。

在`pom.xml`文件中增加该插件的定义，示例如下：
```xml
<build>
	<plugins>
		<!-- YUI Compressor (CSS/JS压缩) -->
		<plugin>
			<groupId>net.alchim31.maven</groupId>
			<artifactId>yuicompressor-maven-plugin</artifactId>
			<version>1.5.1</version>
			<executions>
				<execution>
					<phase>prepare-package</phase>
					<goals>
						<goal>compress</goal>
					</goals>
				</execution>
			</executions>
			<configuration>
				<!-- 读取js,css文件采用UTF-8编码 -->
				<encoding>UTF-8</encoding>
				<!-- 是否忽略警告 -->
				<jswarn>false</jswarn>
				<!-- 是否添加.min后缀 -->
				<nosuffix>true</nosuffix>
				<!-- 压缩多少字节换行 -->
				<linebreakpos>50000</linebreakpos>
				<!-- 源目录，即需压缩的根目录 -->
				<sourceDirectory>src/main/resources/static</sourceDirectory>
				<!-- 若存在已压缩的文件，会先对比源文件是否有改动。有改动便压缩，无改动就不压缩 -->
				<force>true</force>
				<includes>
					<include>**/*.js</include>
					<include>**/*.css</include>
				</includes>
				<excludes>
					<exclude>**/*.min.js</exclude>
					<exclude>**/*.min.css</exclude>
					<exclude>**/fileinput.js</exclude>
					<exclude>**/bootstrap-treetable.js</exclude>
				</excludes>
			</configuration>
		</plugin> 
	</plugins>
</build>
```
