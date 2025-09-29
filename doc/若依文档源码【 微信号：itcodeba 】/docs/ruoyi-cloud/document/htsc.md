# 后台手册

## 分页实现

### 前端调用实现

[参考前端调用实现](/ruoyi-vue/document/htsc.html#前端调用实现)

### 后台逻辑实现

[参考后台逻辑实现](/ruoyi/document/htsc.html#后台逻辑实现)


## 导入导出

在实际开发中经常需要使用导入导出功能来加快数据的操作。在项目中可以使用注解来完成此项功能。
在需要被导入导出的实体类属性添加`@Excel`注解，目前支持参数如下：

| 参数                           | 类型                                  | 默认值                       | 描述                                                       |
| ------------------------------ | ------------------------------------- | ---------------------------- | ---------------------------------------------------------- |
| sort                           | int                                   | Integer.MAX_VALUE            | 导出时在excel中排序                                        |
| name                           | String                                | 空                           | 导出到Excel中的名字                                        |
| dateFormat                     | String                                | 空                           | 日期格式, 如: yyyy-MM-dd                                   |
| readConverterExp               | String                                | 空                           | 读取内容转表达式 (如: 0=男,1=女,2=未知)                    |
| separator                      | String                                | ,                            | 分隔符，读取字符串组内容                                   |
| scale                          | int                                   | -1                           | BigDecimal 精度 默认:-1(默认不开启BigDecimal格式化)        |
| roundingMode                   | int                                   | BigDecimal.ROUND_HALF_EVEN   | BigDecimal 舍入规则 默认:BigDecimal.ROUND_HALF_EVEN        |
| columnType                     | Enum                                  | Type.STRING                  | 导出类型（0数字 1字符串 2图片）                            |
| height                         | String                                | 14                           | 导出时在excel中每个列的高度 单位为字符                     |
| width                          | String                                | 16                           | 导出时在excel中每个列的宽 单位为字符                       |
| suffix                         | String                                | 空                           | 文字后缀,如% 90 变成90%                                    |
| defaultValue                   | String                                | 空                           | 当值为空时,字段的默认值                                    |
| prompt                         | String                                | 空                           | 提示信息                                                   |
| combo                          | String                                | Null                         | 设置只能选择不能输入的列内容                               |
| targetAttr                     | String                                | 空                           | 另一个类中的属性名称,支持多级获取,以小数点隔开             |
| isStatistics                   | boolean                               | false                        | 是否自动统计数据,在最后追加一行统计数据总和                |
| type                           | Enum                                  | Type.ALL                     | 字段类型（0：导出导入；1：仅导出；2：仅导入）              |


### 导出实现流程

1、前端调用方法（参考如下）
```javascript
// 查询参数 queryParams
queryParams: {
  pageNum: 1,
  pageSize: 10,
  userName: undefined
},

/** 导出按钮操作 */
handleExport() {
  this.download('system/xxxx/export', {
	...this.queryParams
  }, `post_${new Date().getTime()}.xlsx`)
}
```

2、添加导出按钮事件
```html
<el-button
  type="warning"
  icon="el-icon-download"
  size="mini"
  @click="handleExport"
>导出</el-button>
```

3、在实体变量上添加@Excel注解
```java
@Excel(name = "用户序号", prompt = "用户编号")
private Long userId;

@Excel(name = "用户名称")
private String userName;
	
@Excel(name = "用户性别", readConverterExp = "0=男,1=女,2=未知")
private String sex;

@Excel(name = "最后登陆时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
private Date loginDate;
```

4、在Controller添加导出方法
```java
@Log(title = "用户管理", businessType = BusinessType.EXPORT)
@PreAuthorize(hasPermi = "system:user:export")
@PostMapping("/export")
public void export(HttpServletResponse response, SysUser user) throws IOException
{
	List<SysUser> list = userService.selectUserList(user);
	ExcelUtil<SysUser> util = new ExcelUtil<SysUser>(SysUser.class);
	util.exportExcel(response, list, "用户数据");
}
```

### 导入实现流程

[参考导入实现流程](/ruoyi-vue/document/htsc.html#导入实现流程)

## 上传下载

首先创建一张上传文件的表，例如：
```sql
drop table if exists sys_file_info;
create table sys_file_info (
  file_id           int(11)          not null auto_increment       comment '文件id',
  file_name         varchar(50)      default ''                    comment '文件名称',
  file_path         varchar(255)     default ''                    comment '文件路径',
  primary key (file_id)
) engine=innodb auto_increment=1 default charset=utf8 comment = '文件信息表';
```

### 上传实现流程

[参考上传实现流程](/ruoyi-vue/document/htsc.html#上传实现流程)

### 下载实现流程

[参考下载实现流程](/ruoyi-vue/document/htsc.html#下载实现流程)

## 权限注解

1) 数据权限示例。
```java
// 符合system:user:list权限要求
@PreAuthorize(hasPermi = "system:user:list")

// 不符合system:user:list权限要求
@PreAuthorize(lacksPermi = "system:user:list")

// 符合system:user:add或system:user:edit权限要求即可
@PreAuthorize(hasAnyPermi = { "system:user:add", "system:user:edit" })
```

2) 角色权限示例。
```java
// 属于user角色
@PreAuthorize(hasRole = "user")

// 不属于user角色
@PreAuthorize(lacksRole = "user")

// 属于user或者admin之一
@PreAuthorize(hasAnyRoles = { "user", "admin" })
```

## 事务管理

[参考事务管理实现](/ruoyi/document/htsc.html#事务管理)

## 异常处理

[参考异常处理实现](/ruoyi/document/htsc.html#异常处理)

## 参数验证

[参考参数验证](/ruoyi/document/htsc.html#参数验证)

## 系统日志

[参考系统日志实现](/ruoyi/document/htsc.html#系统日志)

## 数据权限

[参考数据权限实现](/ruoyi/document/htsc.html#数据权限)

## 多数据源

在实际开发中，经常可能遇到在一个应用中可能需要访问多个数据库的情况，微服务版本采用了`dynamic-datasource`动态多数据源组件，使用参考：

1、对应模块`pom`加入`ruoyi-common-datasource`依赖
```xml
<!-- RuoYi Common DataSource -->
<dependency>
    <groupId>com.ruoyi</groupId>
    <artifactId>ruoyi-common-datasource</artifactId>
</dependency>
```

2、以`ruoyi-system`模块集成`druid`为例，配置主从数据库，其他数据源可以参考组件文档。
```yml
# spring配置
spring: 
  datasource:
    druid:
      stat-view-servlet:
        enabled: true
        loginUsername: admin
        loginPassword: 123456
    dynamic:
      druid:
        initial-size: 5
        min-idle: 5
        maxActive: 20
        maxWait: 60000
        timeBetweenEvictionRunsMillis: 60000
        minEvictableIdleTimeMillis: 300000
        validationQuery: SELECT 1 FROM DUAL
        testWhileIdle: true
        testOnBorrow: false
        testOnReturn: false
        poolPreparedStatements: true
        maxPoolPreparedStatementPerConnectionSize: 20
        filters: stat,wall,slf4j
        connectionProperties: druid.stat.mergeSql\=true;druid.stat.slowSqlMillis\=5000
      datasource:
          # 主库数据源
          master:
            driver-class-name: com.mysql.cj.jdbc.Driver
            url: jdbc:mysql://localhost:3306/ry-cloud?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
            username: root
            password: password
          # 从库数据源
          # slave:
            # url: 
            # username: 
            # password: 
            # driver-class-name: 
```

3、`ruoyi-common-datasource`定义数据源注解，对应`datasource`配置的不同数据源节点

项目默认了主`Master`从`Slave`注解可以直接使用，其他的可以根据项目实际情况去添加。

4、使用注解在需要切换数据源的方法上或类上。
```java
@Master
public void insertA()
{
	return xxxxMapper.insertXxxx();
}

@Slave
public void insertB()
{
	return xxxxMapper.insertXxxx();
}
```

## 代码生成

[参考代码生成实现](/ruoyi/document/htsc.html#代码生成)

## 定时任务

[参考定时任务实现](/ruoyi/document/htsc.html#定时任务)

## 系统接口

[参考系统接口实现](/ruoyi/document/htsc.html#系统接口)

## 国际化支持

### 后台国际化流程

[参考后台国际化流程](/ruoyi/document/htsc.html#后台国际化流程)

### 前端国际化流程

[参考前端国际化流程](/ruoyi-vue/document/htsc.html#前端国际化流程)

## 新建子模块

Maven多模块下新建子模块流程案例。

1、在`ruoyi-modules`下新建业务模块目录，例如：`ruoyi-test`。

2、在`ruoyi-test`业务模块下新建`pom.xml`文件以及`src\main\java`，`src\main\resources`目录。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://maven.apache.org/POM/4.0.0"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <groupId>com.ruoyi</groupId>
        <artifactId>ruoyi-modules</artifactId>
        <version>x.x.x</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
	
    <artifactId>ruoyi-modules-test</artifactId>

    <description>
        ruoyi-modules-test系统模块
    </description>
	
    <dependencies>
    	
    	<!-- SpringCloud Alibaba Nacos -->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
        </dependency>
        
        <!-- SpringCloud Alibaba Nacos Config -->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
        </dependency>
        
    	<!-- SpringCloud Alibaba Sentinel -->
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-sentinel</artifactId>
        </dependency>
        
    	<!-- SpringBoot Actuator -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
		
        <!-- Mysql Connector -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>
        
        <!-- Ruoyi Common Security -->
        <dependency>
            <groupId>com.ruoyi</groupId>
            <artifactId>ruoyi-common-security</artifactId>
        </dependency>
        
        <!-- Ruoyi Common Swagger -->
        <dependency>
            <groupId>com.ruoyi</groupId>
            <artifactId>ruoyi-common-swagger</artifactId>
        </dependency>
		
		<!-- RuoYi Common Log -->
        <dependency>
            <groupId>com.ruoyi</groupId>
            <artifactId>ruoyi-common-log</artifactId>
        </dependency>
        
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
   
</project>
```

3、在`ruoyi-modules`目录下`pom.xml`模块节点modules添加业务模块
```xml
<module>ruoyi-test</module>
```

4、`src/main/resources`添加`bootstrap.yml`文件
```yml
# Tomcat
server:
  port: 9301

# Spring
spring: 
  application:
    # 应用名称
    name: ruoyi-test
  profiles:
    # 环境配置
    active: dev
  cloud:
    nacos:
      discovery:
        # 服务注册地址
        server-addr: 127.0.0.1:8848
      config:
        # 配置中心地址
        server-addr: 127.0.0.1:8848
        # 配置文件格式
        file-extension: yml
        # 共享配置
        shared-configs:
          - application-${spring.profiles.active}.${spring.cloud.nacos.config.file-extension}
```

5、com.ruoyi.test包下添加启动类
```java
package com.ruoyi.test;

import org.springframework.boot.SpringApplication;
import org.springframework.cloud.client.SpringCloudApplication;
import com.ruoyi.common.security.annotation.EnableCustomConfig;
import com.ruoyi.common.security.annotation.EnableRyFeignClients;
import com.ruoyi.common.swagger.annotation.EnableCustomSwagger2;

/**
 * 测试模块
 * 
 * @author ruoyi
 */
@EnableCustomConfig
@EnableCustomSwagger2
@EnableRyFeignClients
@SpringCloudApplication
public class RuoYiTestApplication
{
    public static void main(String[] args)
    {
        SpringApplication.run(RuoYiTestApplication.class, args);
        System.out.println("(♥◠‿◠)ﾉﾞ  测试模块启动成功   ლ(´ڡ`ლ)ﾞ  \n" +
                " .-------.       ____     __        \n" +
                " |  _ _   \\      \\   \\   /  /    \n" +
                " | ( ' )  |       \\  _. /  '       \n" +
                " |(_ o _) /        _( )_ .'         \n" +
                " | (_,_).' __  ___(_ o _)'          \n" +
                " |  |\\ \\  |  ||   |(_,_)'         \n" +
                " |  | \\ `'   /|   `-'  /           \n" +
                " |  |  \\    /  \\      /           \n" +
                " ''-'   `'-'    `-..-'              ");
    }
}
```