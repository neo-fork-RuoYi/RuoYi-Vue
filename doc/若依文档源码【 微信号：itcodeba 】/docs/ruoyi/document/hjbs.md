# 环境部署

## 准备工作

~~~
JDK >= 1.8 (推荐1.8版本)
Mysql >= 5.7.0 (推荐5.7版本)
Maven >= 3.0
~~~


## 运行系统

1、前往`Gitee`下载页面([https://gitee.com/y_project/RuoYi](https://gitee.com/y_project/RuoYi))下载解压到工作目录  
2、导入到`Eclipse`，菜单 `File` -> `Import`，然后选择 `Maven` -> `Existing Maven Projects`，点击 `Next`> 按钮，选择工作目录，然后点击 `Finish` 按钮，即可成功导入。  
`Eclipse`会自动加载`Maven`依赖包，初次加载会比较慢（根据自身网络情况而定）  
3、创建数据库`ry`并导入数据脚本`ry_2021xxxx.sql`，`quartz.sql`  
4、打开项目运行`com.ruoyi.RuoYiApplication.java`，出现如下图表示启动成功。 
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
5、打开浏览器，输入：([http://localhost:80](http://localhost:80)) （默认账户/密码 `admin/admin123`）  
若能正确展示登录页面，并能成功登录，菜单及页面展示正常，则表明环境搭建成功  

建议使用`Git`克隆，因为克隆的方式可以和`RuoYi`随时保持更新同步。使用`Git`命令克隆  
```
git clone https://gitee.com/y_project/RuoYi.git
```

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


## 常见问题

1. 如果使用`Mac`需要修改`application.yml`文件路径`profile`
2. 如果使用`Linux` 提示表不存在，设置大小写敏感配置在`/etc/my.cnf`添加`lower_case_table_names=1`，重启MYSQL服务
3. 如果提示当前权限不足，无法写入文件请检查`application.yml`中的`profile`路径或`logback.xml`中的`log.path`路径是否有可读可写操作权限

如遇到无法解决的问题请到[Issues](https://gitee.com/y_project/RuoYi/issues)反馈，会不定时进行解答。