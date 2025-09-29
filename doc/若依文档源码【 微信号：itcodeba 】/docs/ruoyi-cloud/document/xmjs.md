# 项目介绍

## 文件结构

### 后端结构

~~~
com.ruoyi     
├── ruoyi-ui              // 前端框架 [80]
├── ruoyi-gateway         // 网关模块 [8080]
├── ruoyi-auth            // 认证中心 [9200]
├── ruoyi-api             // 接口模块
│       └── ruoyi-api-system                          // 系统接口
├── ruoyi-common          // 通用模块
│       └── ruoyi-common-core                         // 核心模块
│       └── ruoyi-common-datascope                    // 权限范围
│       └── ruoyi-common-datasource                   // 多数据源
│       └── ruoyi-common-log                          // 日志记录
│       └── ruoyi-common-redis                        // 缓存服务
│       └── ruoyi-common-security                     // 安全模块
│       └── ruoyi-common-swagger                      // 系统接口
├── ruoyi-modules         // 业务模块
│       └── ruoyi-system                              // 系统模块 [9201]
│       └── ruoyi-gen                                 // 代码生成 [9202]
│       └── ruoyi-job                                 // 定时任务 [9203]
│       └── ruoyi-file                                // 文件服务 [9300]
├── ruoyi-visual          // 图形化管理模块
│       └── ruoyi-visual-monitor                      // 监控中心 [9100]
├──pom.xml                // 公共依赖
~~~

### 前端结构

~~~  
├── build                      // 构建相关  
├── bin                        // 执行脚本
├── public                     // 公共文件
│   ├── favicon.ico            // favicon图标
│   └── index.html             // html模板
├── src                        // 源代码
│   ├── api                    // 所有请求
│   ├── assets                 // 主题 字体等静态资源
│   ├── components             // 全局公用组件
│   ├── directive              // 全局指令
│   ├── layout                 // 布局
│   ├── router                 // 路由
│   ├── store                  // 全局 store管理
│   ├── utils                  // 全局公用方法
│   ├── views                  // view
│   ├── App.vue                // 入口页面
│   ├── main.js                // 入口 加载组件 初始化等
│   ├── permission.js          // 权限管理
│   └── settings.js            // 系统配置
├── .editorconfig              // 编码格式
├── .env.development           // 开发环境配置
├── .env.production            // 生产环境配置
├── .env.staging               // 测试环境配置
├── .eslintignore              // 忽略语法检查
├── .eslintrc.js               // eslint 配置项
├── .gitignore                 // git 忽略项
├── babel.config.js            // babel.config.js
├── package.json               // package.json
└── vue.config.js              // vue.config.js
~~~


## 核心技术

::: tip
* 前端技术栈 ES6、vue、vuex、vue-router、vue-cli、axios、element-ui
* 后端技术栈 Spring Boot、Spring Cloud & Alibaba、Nacos、Sentinel
:::

### 后端技术

#### SpringBoot框架

1、介绍  
`Spring Boot`是一款开箱即用框架，提供各种默认配置来简化项目配置。让我们的`Spring`应用变的更轻量化、更快的入门。
在主程序执行`main`函数就可以运行。你也可以打包你的应用为`jar`并通过使用`java -jar`来运行你的Web应用。它遵循"约定优先于配置"的原则，
使用`SpringBoot`只需很少的配置，大部分的时候直接使用默认的配置即可。同时可以与`Spring Cloud`的微服务无缝结合。  
::: tip 提示
`Spring Boot2.x`版本环境要求必须是`jdk8`或以上版本，服务器`Tomcat8`或以上版本
:::

2、优点
* 使编码变得简单： 推荐使用注解。
* 使配置变得简单： 自动配置、快速集成新技术能力 没有冗余代码生成和XML配置的要求  
* 使部署变得简单： 内嵌Tomcat、Jetty、Undertow等web容器，无需以war包形式部署
* 使监控变得简单： 提供运行时的应用监控
* 使集成变得简单： 对主流开发框架的无配置集成。
* 使开发变得简单： 极大地提高了开发快速构建项目、部署效率。

#### SpringCloud框架

1、介绍  
`Spring Cloud`是一系列框架的有序集合。它利用`Spring Boot`的开发便利性巧妙地简化了分布式系统基础设施的开发，
如服务发现注册、配置中心、消息总线、负载均衡、断路器、数据监控等，都可以用`Spring Boot`的开发风格做到一键启动和部署。
`Spring Cloud`并没有重复制造轮子，它只是将目前各家公司开发的比较成熟、经得起实际考验的服务框架组合起来，
通过`Spring Boot`风格进行再封装屏蔽掉了复杂的配置和实现原理，最终给开发者留出了一套简单易懂、易部署和易维护的分布式系统开发工具包。

2、优点  
把模块拆分，使用接口通信，降低模块之间的耦合度。  
把项目拆分成若干个子项目，不同的团队负责不同的子项目。  
增加功能时只需要再增加一个子项目，调用其他系统的接口就可以。  
可以灵活的进行分布式部署。  

#### Spring Security安全控制

1、介绍  
`Spring Security`是一个能够为基于`Spring`的企业应用系统提供声明式的安全访问控制解决方案的安全框架。

2、功能  
`Authentication` 认证，就是用户登录  
`Authorization`  授权，判断用户拥有什么权限，可以访问什么资源  
安全防护，跨站脚本攻击，`session`攻击等  
非常容易结合`Spring`进行使用

3、`Spring Security`与`Shiro`的区别
> 相同点

1、认证功能  
2、授权功能  
3、加密功能  
4、会话管理  
5、缓存支持  
6、rememberMe功能  
....

> 不同点

优点：

1、Spring Security基于Spring开发，项目如果使用Spring作为基础，配合Spring Security做权限更加方便。而Shiro需要和Spring进行整合开发  
2、Spring Security功能比Shiro更加丰富，例如安全防护方面  
3、Spring Security社区资源相对比Shiro更加丰富  

缺点：

1）Shiro的配置和使用比较简单，Spring Security上手复杂些  
2）Shiro依赖性低，不需要依赖任何框架和容器，可以独立运行。Spring Security依赖Spring容器


### 前端技术

* npm：node.js的包管理工具，用于统一管理我们前端项目中需要用到的包、插件、工具、命令等，便于开发和维护。
* ES6：Javascript的新版本，ECMAScript6的简称。利用ES6我们可以简化我们的JS代码，同时利用其提供的强大功能来快速实现JS逻辑。
* vue-cli：Vue的脚手架工具，用于自动生成Vue项目的目录及文件。
* vue-router： Vue提供的前端路由工具，利用其我们实现页面的路由控制，局部刷新及按需加载，构建单页应用，实现前后端分离。
* vuex：Vue提供的状态管理工具，用于统一管理我们项目中各种数据的交互和重用，存储我们需要用到数据对象。
* element-ui：基于MVVM框架Vue开源出来的一套前端ui组件。