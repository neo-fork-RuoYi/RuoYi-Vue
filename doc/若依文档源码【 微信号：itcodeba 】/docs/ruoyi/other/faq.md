# 常见问题

## 如何不登录直接访问

在`ShiroConfig`中设置`filterChainDefinitionMap`配置`url=anon`
```
	/admins/**=anon               # 表示该 uri 可以匿名访问
	/admins/**=auth               # 表示该 uri 需要认证才能访问
	/admins/**=authcBasic         # 表示该 uri 需要 httpBasic 认证
	/admins/**=perms[user:add:*]  # 表示该 uri 需要认证用户拥有 user:add:* 权限才能访问
	/admins/**=port[8080]         # 表示该 uri 需要使用 8080 端口
	/admins/**=roles[admin]       # 表示该 uri 需要认证用户拥有 admin 角色才能访问
	/admins/**=ssl                # 表示该 uri 需要使用 https 协议
	/admins/**=user               # 表示该 uri 需要认证或通过记住我认证才能访问
	/logout=logout                # 表示注销,可以当作固定配置
	
	注意：
	anon，authcBasic，authc，user 是认证过滤器。
	perms，roles，ssl，rest，port 是授权过滤器。
```

## 如何更换项目包路径

> 懒人可以使用[若依框架包名修改器](https://gitee.com/lpf_project/common-tools)一键替换。

1、更换目录名称
~~~
├── xxxxx
│       └── xxxxx-admin
│       └── xxxxx-common
│       └── xxxxx-framework
│       └── xxxxx-generator
│       └── xxxxx-quartz
│       └── xxxxx-system
│       └── pom.xml
~~~

2、更换顶级目录中的`pom.xml`
```xml
<modules>
	<module>xxxxx-admin</module>
	<module>xxxxx-framework</module>
	<module>xxxxx-system</module>
	<module>xxxxx-quartz</module>
	<module>xxxxx-generator</module>
	<module>xxxxx-common</module>
</modules>
```

3、更换项目所有包名称`com.ruoyi.xxx`换成`com.xxxxx.xxx`

::: tip 提示
DataScopeAspect，DataSourceAspect，LogAspect
这三个类@Pointcut注解上面的包路径也需要替换com.xxxxx

CaptchaConfig
这个类验证码文本生成器参数KAPTCHA_TEXTPRODUCER_IMPL的包路径也需要替换com.xxxxx

ApplicationConfig
这个类@MapperScan注解上面的包路径也需要替换com.xxxxx
:::

4、更换`application.yml`指定要扫描的`Mapper`类的包的路径`typeAliasesPackage`包路径名称替换`com.xxxxx`
```yml{4}
# MyBatis
mybatis:
    # 搜索指定包别名
    typeAliasesPackage: com.你的包名.**.domain
```

5、更换`mapper`文件的`namespace`包路径
```xml
ruoyi-system/resources/mapper/system/* 
ruoyi-quartz/resources/mapper/quartz/* 
ruoyi-generator/resources/mapper/generator/*
``` 
`xml`包路径名称替换`com.xxxxx`

6、更换`pom`文件内容
::: tip 提示
以下`pom.xml`文件中包含`ruoyi`的关键字替换成`xxxxx`
~~~
├── xxxxx
│       └── xxxxx-admin      pom.xml
│       └── xxxxx-common     pom.xml
│       └── xxxxx-framework  pom.xml
│       └── xxxxx-generator  pom.xml
│       └── xxxxx-quartz     pom.xml
│       └── xxxxx-system     pom.xml
│       └── pom.xml
~~~
:::

7、更换日志路径
- 更换`application.yml`文件`logging`属性为`com.xxxxx: debug`
- 更换`logback.xml`文件为`com.xxxxx`

8、启动项目验证
::: tip 提示
到此步骤如能正常启动，表示更换完成。剩余的小细节可以自行调整。
:::

## 业务模块访问出现404

1、单应用检查  
- 确认此用户是否已经配置菜单
- 确认此角色是否已经配置菜单权限
- 确认此菜单`url`是否和`后台地址`一致

如参数管理，后台地址配置`@RequestMapping("/system/config")`对应参数管理`url`为`/system/config`

2、多模块检查（多了几个步骤）  
- `pom.xml` 引入了业务子系统
- `ruoyi-admin` 添加业务子模块的依赖
- `ruoyi-xxxxx` 新增业务模块pom检查配置是否正确

PS：IDEA可能存在缓存，需要清理下缓存在编译。

::: tip 提示
如果业务模块和项目的包名不一致，需要在启动类上指定扫描包路径，如
`@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class }, scanBasePackages = { "com.ruoyi.*", "com.test.*" })`
或者加上`@ComponentScan({ "com.ruoyi.*", "com.test.*" })`
:::

## IDEA更改页面不重启

经常有小伙伴问到这个问题，为什么我的用IDEA修改html页面之后不实时生效呢？

1、修改IDEA设置
`File` -> `Settings` -> `Build Execution Deployment` ->  `Build Project automatically` 勾选

2、勾选Running
`Ctrl` + `Shift` + `Alt` + `/` 然后选择 `Registry`，勾上 `Compiler.autoMake.allow.when.app.running`

PS：Eclipse开发工具无需任何配置。


## 如何使用多数据源

对于只有两个数据源直接配置`slave`加入注解即可。

1. 在 `resources` 目录下修改```application-druid.yml```
```yaml
# 从库数据源
slave:
    # 开启从库
    enabled: true
    url: 数据源
    username: 用户名
    password: 密码
```

2. 在`Service`实现中添加`DataSource`注解
```java{1}
@DataSource(value = DataSourceType.SLAVE)
public List<User> selectUserList()
{
    return mapper.selectUserList();
}
```

如果涉及到两个以上数据源，参考配置 [多数据源](/ruoyi/document/htsc.html#多数据源)


## 如何更换主题皮肤

1、项目主页-个人信息中选择切换主题

2、修改主框架页-默认皮肤，在菜单`参数设置`修改参数键名`sys.index.skinName`支持如下几种皮肤

- 蓝色 skin-blue
- 绿色 skin-green
- 紫色 skin-purple
- 红色 skin-red
- 黄色 skin-yellow

3、修改主框架页-侧边栏主题，在菜单`参数设置`修改参数键名`sys.index.sideTheme`支持如下几种主题
 
- 深色主题theme-dark
- 浅色主题theme-light

注：如需新增修改皮肤主题可以在`skins.css`中调整

:::tip 提示
顶部默认主题颜色在`skins.css`
```css
/** 蓝色主题 skin-blue **/
.navbar, .skin-blue .navbar {
	background-color: #3c8dbc
}
```

左侧默认主题颜色在`static\css\style.css`
```css
.navbar-static-side {
    background: #2f4050;
}

nav .logo {
    background-color: #367fa9;
}
```
:::


## 如何使用横向菜单

默认的导航菜单都是在左侧，如果需要横向导航菜单可以做如下配置。

1、点击顶部最右侧个人中心头像，切换为横向菜单。（局部设置）

2、在参数管理设置`主框架页-菜单导航显示风格`，键值为`topnav`为顶部导航菜单。（全局设置）


## 如何获取用户登录信息

1. 第一种方法
```java
// 获取当前的用户信息
User currentUser = ShiroUtils.getSysUser();
// 获取当前的用户名称
String userName = currentUser.getUserName();
```

2. 第二种方法（子模块可使用）
```java
// 获取当前的用户名称
String userName = (String) PermissionUtils.getPrincipalProperty("userName");
```

3、界面获取当前用户信息（支持任意th标签）
```html
<input th:value="${@permission.getPrincipalProperty('userName')}">
```

4、js中获取当前用户信息
```javascript
var userName = [[${@permission.getPrincipalProperty('userName')}]];
```


## 如何防止请求重复提交

1. 前端通过`js`控制
```javascript
// 禁用按钮
$.modal.disable();
// 启用按钮
$.modal.enable();
```

2. 后端通过`@RepeatSubmit`注解控制
```java
/**
 * 在对应方法添加注解 @RepeatSubmit
 */
@RepeatSubmit
public AjaxResult editSave()
```


## 如何配置允许跨域访问

现在开发的项目一般都是前后端分离的项目，所以跨域访问会经常使用。  

1、单个控制器方法`CORS`注解  
```java
@RestController
@RequestMapping("/system/test")
public class TestController {

    @CrossOrigin
    @GetMapping("/{id}")
    public AjaxResult getUser(@PathVariable Integer userId) {
        // ...
    }
	
	@DeleteMapping("/{userId}")
    public AjaxResult delete(@PathVariable Integer userId) {
        // ...
    }
}
```

2、整个控制器启用`CORS`注解  
```java
@CrossOrigin(origins = "http://ruoyi.vip", maxAge = 3600)
@RestController
@RequestMapping("/system/test")
public class TestController {

    @GetMapping("/{id}")
    public AjaxResult getUser(@PathVariable Integer userId) {
        // ...
    }
	
	@DeleteMapping("/{userId}")
    public AjaxResult delete(@PathVariable Integer userId) {
        // ...
    }
}
```

3、全局`CORS`配置（在`ResourcesConfig`重写`addCorsMappings`方法）  
```java
/**
 * web跨域访问配置
 */
@Override
public void addCorsMappings(CorsRegistry registry)
{
	// 设置允许跨域的路径
	registry.addMapping("/**")
			// 设置允许跨域请求的域名
			.allowedOrigins("*")
			// 是否允许证书
			.allowCredentials(true)
			// 设置允许的方法
			.allowedMethods("GET", "POST", "DELETE", "PUT")
			// 设置允许的header属性
			.allowedHeaders("*")
			// 跨域允许时间
			.maxAge(3600);
}
```

## 如何实现滑块验证码

[参考集成aj-captcha实现滑块验证码](/ruoyi/document/cjjc.html#集成aj-captcha实现滑块验证码)

## 日期插件精确到时分秒

1、界面设置时间格式`data-format`，选择类型`data-type`属性。
```html
<!-- data-type="date"（年）| data-type="month（月）| data-type="date"（日）| data-type="time"（时、分、秒）| data-type="datetime"（年、月、日、时、分、秒） -->
<li class="select-time">
<label>创建时间： </label>
<input type="text" class="time-input" placeholder="开始时间" name="params[beginTime]" data-type="datetime" data-format="yyyy-MM-dd HH:mm:ss"/>
<span>-</span>
<input type="text" class="time-input" placeholder="结束时间" name="params[endTime]" data-type="month" data-format="yyyy-MM"/>
</li>
```

2、通过js函数设置	
`datetimepicker`日期控件可以设置```format```
```javascript
$('.input-group.date').datetimepicker({
    format: 'yyyy-mm-dd hh:ii:ss',
    autoclose: true,
    minView: 0,
    minuteStep:1
});
```

`laydate`日期控件可以设置`common.js` 配置`type=datetime`
```javascript
layui.use('laydate', function() {
	var laydate = layui.laydate;
	var startDate = laydate.render({
		elem: '#startTime',
		max: $('#endTime').val(),
		theme: 'molv',
		trigger: 'click',
		type : 'datetime',
		done: function(value, date) {
			// 结束时间大于开始时间
			if (value !== '') {
				endDate.config.min.year = date.year;
				endDate.config.min.month = date.month - 1;
				endDate.config.min.date = date.date;
			} else {
				endDate.config.min.year = '';
				endDate.config.min.month = '';
				endDate.config.min.date = '';
			}
		}
	});
	var endDate = laydate.render({
		elem: '#endTime',
		min: $('#startTime').val(),
		theme: 'molv',
		trigger: 'click',
		type : 'datetime',
		done: function(value, date) {
			// 开始时间小于结束时间
			if (value !== '') {
				startDate.config.max.year = date.year;
				startDate.config.max.month = date.month - 1;
				startDate.config.max.date = date.date;
			} else {
				startDate.config.max.year = '';
				startDate.config.max.month = '';
				startDate.config.max.date = '';
			}
		}
	});
});
```


## 代码生成不显示新建表

默认条件需要表注释，特殊情况可在`GenMapper.xml`去除`table_comment`条件
```xml
<select id="selectTableByName" parameterType="String" resultMap="TableInfoResult">
	<include refid="selectGenVo"/>
	where table_comment <> '' and table_schema = (select database())
</select>
```
::: tip 提示
如果版本>=4.0不需要表注解，在代码生成页面导入即可。
:::


## 提示您没有数据的权限

这种情况都属于权限标识配置不对在```菜单管理```配置好权限标识（菜单&按钮）
1. 确认此用户是否已经配置角色
2. 确认此角色是否已经配置菜单权限
3. 确认此菜单权限标识是否和后台代码一致  

如参数管理  
后台配置```@RequiresPermissions("system:config:view")```对应参数管理权限标识为```system:config:view```

注：如需要角色权限，配置角色权限字符 使用```@RequiresRoles("admin")```


## 富文本编辑器文件上传

富文本控件采用的`summernote`，图片上传处理需要设置`callbacks`函数
```javascript
$('.summernote').summernote({
	height : '220px',
	lang : 'zh-CN',
	callbacks: {
		onImageUpload: function(files, editor, $editable) {
			var formData = new FormData();
			formData.append("file", files[0]);
			$.ajax({
	            type: "POST",
	            url: ctx + "common/upload",
	            data: data,
	            cache: false,
	            contentType: false,
	            processData: false,
	            dataType: 'json',
	            success: function(result) {
	                if (result.code == web_status.SUCCESS) {
	                	$(obj).summernote('editor.insertImage', result.url, result.fileName);
					} else {
						$.modal.alertError(result.msg);
					}
	            },
	            error: function(error) {
	                $.modal.alertWarning("图片上传失败。");
	            }
	        });
		}
	}
});
```


## 富文本编辑器底部回弹

富文本控件采用的`summernote`，如果不需要底部回弹设置`followingToolbar: false`
```javascript
$('.summernote').summernote({
	placeholder: '请输入公告内容',
	height : 192,
	lang : 'zh-CN',
	followingToolbar: false,
	callbacks: {
		onImageUpload: function (files) {
			sendFile(files[0], this);
		}
	}
});
```

## 富文本对话框回弹顶部

富文本控件采用的`summernote`，点击下方的各种按钮的弹框时，页面会回到顶部，滚到顶部会使用户体验很不好，如需要置于弹框的`body`中，可以设置`dialogsInBody: true`
```javascript
$('.summernote').summernote({
	placeholder: '请输入公告内容',
	height : 192,
	lang : 'zh-CN',
	dialogsInBody: true,
	callbacks: {
		onImageUpload: function (files) {
			sendFile(files[0], this);
		}
	}
});
```


## 如何创建新的菜单页签

创建新的页签有以下两种方式（js&html）
```javascript
// 方式1 打开新的选项卡
function dept() {
	var url = ctx + "system/dept";
	$.modal.openTab("部门管理", url);
	// 如果需要打开并刷新 $.modal.openTab("部门管理", url, true);
}

// 方式2 选卡页同一页签打开
function dept() {
	var url = ctx + "system/dept";
	$.modal.parentTab("部门管理", url);
}

// 方式3 html创建
<a class="menuItem" href="/system/dept">部门管理</a>
// 如果需要打开并刷新 
<a class="menuItem" data-refresh="true" href="/system/dept">部门管理</a>
```


## 表格数据进行汇总统计

对于某些数据需要对金额，数量等进行汇总，可以配置`showFooter: true`表示尾部统计
```javascript
// options 选项中添加尾部统计
showFooter: true, 
// columns 中添加   
{
	field : 'balance',
	title : '余额',
	sortable: true,
	footerFormatter:function (value) {
		var sumBalance = 0;
		for (var i in value) {
			sumBalance += parseFloat(value[i].balance);
		}
		return "总金额：" + sumBalance;
	}
},
```


## 表格设置行列单元格样式

1、`options`参数中配置属性
```javascript
rowStyle: rowStyle,
```
2、对应js添加响应方法（根据`row`或`index`定义规则）即可
```javascript
function rowStyle(row, index) {
	var style = { css: { 'color': '#ed5565' } };
	return style;
}
```


## 如何去除数据监控广告

服务监控中使用的`Driud`，默认底部有阿里的广告。如果是一个商业项目这个是很不雅也是不允许的
1. 找到本地maven库中的对应的druid-1.1.xx.jar文件，用压缩包软件打开
2. 找到support/http/resource/js/common.js, 打开找到 buildFooter 方法
```javascript
this.buildFooter();
buildFooter : function() {
	var html ='此处省略一些相关JS代码';
	$(document.body).append(html);
},
```
3. 删除此函数和及初始方法后覆盖文件
4. 重启项目后，广告就会消失了


## 如何支持多类型数据库

对于某些特殊需要支持不同数据库，参考以下支持```oracle``` ```mysql```配置
```xml
<!--oracle驱动-->
<dependency>
	<groupId>com.oracle</groupId>
	<artifactId>ojdbc6</artifactId>
	<version>11.2.0.3</version>
</dependency>
```		
```yaml
# 数据源配置
spring:
    datasource:
        type: com.alibaba.druid.pool.DruidDataSource
        druid:
            # 主库数据源
            master:
                url: jdbc:mysql://127.0.0.1:3306/ry?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
                username: root
                password: password
            # 从库数据源
            slave:
                # 从数据源开关/默认关闭
                enabled: true
                url: jdbc:oracle:thin:@127.0.0.1:1521:oracle
                username: root
                password: password
```

`对于不同数据源造成的驱动问题，可以删除driverClassName。会自动识别驱动`  
`如需要对不同数据源分页需要操作application.yml中的pagehelper配置 删除helperDialect: mysql 会自动识别数据源 新增autoRuntimeDialect=true 表示运行时获取数据源`


## 如何实现翻页保留选择

1. 配置`checkbox`选项`field`属性为`state`
```javascript
{
	field: 'state',
	checkbox: true
},
```

2. 表格选项`options`添加`rememberSelected`
```javascript
rememberSelected: true,
```


## 如何实现跳转至指定页

1. 表格选项`options`添加`showPageGo`
```javascript
showPageGo: true,
```


## 如何自定义查询条件参数

1、在`options`中添加`queryParams`参数
```javascript
var options = {
	url: prefix + "/list",
	queryParams: queryParams,
	columns: [{
		field: 'id',
		title: '主键'
	},
	{
		field: 'name',
		title: '名称'
	}]
};
$.table.init(options);
```
2、在当前页添加`queryParams`方法设置自定义查询条件如`userName`
```javascript
function queryParams(params) {
	var search = $.table.queryParams(params);
	search.userName = $("#userName").val();
	return search;
}
```
请求后台参数为：pageSize、pageNum、searchValue、orderByColumn、isAsc、`userName`

3、如果是表格树，添加参数`ajaxParams`参数
```javascript
var options = {
	code: "deptId",
	parentCode: "parentId",
	uniqueId: "deptId",
	url: prefix + "/list",
	ajaxParams: {
		"userId": "1",
		"userName": "ruoyi"
	},
	columns: [{
		field: 'id',
		title: '主键'
	},
	{
		field: 'name',
		title: '名称'
	}]
};
$.treeTable.init(options);
```


## 如何让表格某些列隐藏掉

1、在`options`中`columns`设置`visible`
```javascript
visible: false,  // 隐藏某列（列选项可见）
ignore: true,    // 列选项不可见
```
对于需要列选项不可见状态可以设置`ignore`


## 如何给默认的表格加边框

`table-striped` 换成 `table-bordered`

```html
<div class="col-sm-12 select-table table-bordered">
    <table id="bootstrap-table"></table>
</div>
```

::: tip 提示
如果是表格树加边框还需要在`options`添加`bordered:true`
:::

## 普通用户创建文件无权限

常见的有几种错误，对应去调整即可。

1、修改`logback.xml`，value路径
```xml
<!-- 日志存放路径 -->
<property name="log.path" value="/home/ruoyi/logs" />
```

2、修改`ehcache-shiro.xml`，path路径
```xml
<diskStore path="java.io.tmpdir"/>
```

3、修改`tomcat`临时的日志目录
```yml
server:
  tomcat:
    basedir: /home/ruoyi/temp
```


## 如何降低mysql驱动版本

1、在`pom.xml`中`properties`新增节点如：
```xml
<mysql.version>6.0.6</mysql.version>
```

2、单应用可以不添加，多模块需要在`dependencyManagement`声明依赖
```xml
<!-- Mysql驱动包 -->
<dependency>
	<groupId>mysql</groupId>
	<artifactId>mysql-connector-java</artifactId>
	<version>${mysql.version}</version>
</dependency>
```

注意：如果是6以下的版本需要修改`application-druid.yml`中`driverClassName`  
com.mysql.jdbc.Driver     是 mysql-connector-java 5中的  
com.mysql.cj.jdbc.Driver  是 mysql-connector-java 6中的  


## 如何配置tomcat访问日志

1、修改`application.yml`中的`server`开发环境配置
```yml
# 开发环境配置
server:
  # 服务器的HTTP端口，默认为80
  port: 80
  servlet:
    # 应用的访问路径
    context-path: /
  tomcat:
    # 存放Tomcat的日志目录
    basedir: D:/tomcat
    accesslog: 
        # 开启日志记录
        enabled: true
        # 访问日志存放目录
        directory: logs
    # tomcat的URI编码
    uri-encoding: UTF-8
    # tomcat最大线程数，默认为200
    max-threads: 800
    # Tomcat启动初始化的线程数，默认值25
    min-spare-threads: 30
```
2、重启项目后，在`D:/tomcat/logs`目录就可以看到服务器访问日志了


## 如何配置项目访问根路径

目前项目后台访问默认路径是：`http://localhost:80`，如果需要自定义`项目名`或`端口`可以修改配置文件`src/main/resources/application.yml`
```yml
server:
  port: 8080
  servlet:
     context-path: /ruoyi
```
此配置后访问的默认路径是：`http://localhost:8080/ruoyi`

## 如何汉化系统接口Swagger

想必很多小伙伴都曾经使用过`Swagger`，但是打开UI界面是纯英文的界面并不太友好，作为国人还是习惯中文界面。
1. 找到m2/repository/io/springfox/springfox-swagger-ui/x.x.x/springfox-swagger-ui-x.x.x.jar
2. 修改对应springfox-swagger-ui-x.x.x.jar包内`resources`目录下`swagger-ui.html`，添加如下JS代码
```html
<!-- 选择中文版 -->
<script src='webjars/springfox-swagger-ui/lang/translator.js' type='text/javascript'></script>
<script src='webjars/springfox-swagger-ui/lang/zh-cn.js' type='text/javascript'></script>
```
2. 本地修改结束后，在覆盖压缩包文件重启就实现汉化了

## Swagger接口出现转换错误

```json
{
  "msg": "Failed to convert property value of type 'java.lang.String' to required type 'java.util.Map' for property 'params'; nested exception is java.lang.IllegalStateException: Cannot convert value of type 'java.lang.String' to required type 'java.util.Map' for property 'params': no matching editors or conversion strategy found",
  "code": 500
}
```
一般在`Swagger`页面执行查询接口时出现。`params`是`BaseEntity.java`的属性，请求的时候把默认的值`{}`置空就行了。

如果不想看到他，`BaseEntity.java`中的`params`参数加上`@ApiModelProperty(hidden = true)`
```java
/** 请求参数 */
@ApiModelProperty(hidden = true)
private Map<String, Object> params;
```


## 如何在html页面格式化日期

Thymeleaf主要使用`org.thymeleaf.expression.Dates`这个类来处理日期，在模板中使用"#dates"来表示这个对象。 
 
1、格式化日期  
`[[${#dates.format(date)}]]` 或 `th:text="${#dates.format(date)}`  
`[[${#dates.formatISO(date)}]]` 或 `th:text="${#dates.formatISO(date)}`  
`[[${#dates.format(date, 'yyyy-MM-dd HH:mm:ss')}]]` 或 `th:text="${#dates.format(date, 'yyyy-MM-dd HH:mm:ss')}`  

2、获取日期字段  
获取当前的年份：`[[${#dates.year(date)}]]`  
获取当前的月份：`[[${#dates.month(date)}]]`  
获取当月的天数：`[[${#dates.day(date)}]]`  
获取当前的小时：`[[${#dates.hour(date)}]]`  
获取当前的分钟：`[[${#dates.minute(date)}]]`  
获取当前的秒数：`[[${#dates.second(date)}]]`  
获取当前的毫秒：`[[${#dates.millisecond(date)}]]`  
获取当前的月份名称：`[[${#dates.monthName(date)}]]`  
获取当前是星期几：`[[${#dates.dayOfWeek(date)-1}]]`  


## 如何在表格中实现图片预览

对于某些图片需要在表格中显示，可以使用```imageView```方法
```javascript
// 在columns中格式化对应相关的列属性
{
	field: 'avatar',
	title: '用户头像',
	formatter: function(value, row, index) {
		return $.table.imageView(value, '/profile/avatar');
	}
},
```

多图片预览可以自己实现，示例。
```js
// 传入value 图片地址数组
previewImg: function(value) {
    var data = [];
    for (var key of value) {
        var json = {};
        json.src = key;
        data.push(json);
    }
    layer.photos({
        photos: {
            "data": data
        },
        anim: 6 // 0-6的选择，指定弹出图片动画类型，默认随机
    });
},
```


## 如何去掉页脚及左侧菜单栏

1、去除页脚`修改style.css`，同时删除`index.html`元素
```css
#content-main {
    height: calc(100% - 91px);
    overflow: hidden;
}
```

```html
<div class="footer">
    <div class="pull-right">© [[${copyrightYear}]] RuoYi Copyright </div>
</div>
```

2、去左侧菜单栏（收起时隐藏左侧菜单）`修改style.css`  
```css
body.fixed-sidebar.mini-navbar #page-wrapper {
    margin: 0 0 0 0px;
}

body.body-small.fixed-sidebar.mini-navbar #page-wrapper {
    margin: 0 0 0 0px;
}
```

3、去左侧菜单栏（收起时隐藏左侧菜单）`修改index.js`  
```js
function() {
    if ($(this).width() < 769) {
        $('body').addClass('mini-navbar');
        $('.navbar-static-side').fadeIn(); // 换成 $('.navbar-static-side').hide();
        $(".sidebar-collapse .logo").addClass("hide");
    }
});

function SmoothlyMenu() {
    if (!$('body').hasClass('mini-navbar')) {
    	$(".navbar-static-side").show();  // 添加显示这一行
        $('#side-menu').hide();
        $(".sidebar-collapse .logo").removeClass("hide");
        setTimeout(function() {
            $('#side-menu').fadeIn(500);
        },
        100);
    } else if ($('body').hasClass('fixed-sidebar')) {
    	$(".navbar-static-side").hide();  // 添加隐藏这一行
        $('#side-menu').hide();
        $(".sidebar-collapse .logo").addClass("hide");
        setTimeout(function() {
            $('#side-menu').fadeIn(500);
        },
        300);
    } else {
        $('#side-menu').removeAttr('style');
    }
}
```

4、隐藏左侧菜单，需要添加`.canvas-menu`到body元素
```css
<body class = "canvas-menu"> 
```


## 登录页如何开启注册用户功能

在菜单`参数设置`修改参数键名`sys.account.registerUser`设置`true`即可。默认为`false`关闭。


## 如何限制账户只能一个人登录

在`application.yml`设置`maxSession`为`1`即可。

```yml
# Shiro
shiro:
  session:
    # 同一个用户最大会话数，比如2的意思是同一个账号允许最多同时两个人登录（默认-1不限制）
    maxSession: 1
    # 踢出之前登录的/之后登录的用户，默认踢出之前登录的用户
    kickoutAfter: false
```


## 登录页面如何不显示验证码

在`application.yml`设置`captchaEnabled`为`false`即可

```yml
# Shiro
shiro:
  user:
    # 验证码开关
    captchaEnabled: false
```


## 如何Excel导出子对象多个字段

```java
// 单个字段导出
@Excel(name = "部门名称", targetAttr = "deptName", type = Type.EXPORT)
private Dept dept;

// 多个字段导出
@Excels({
    @Excel(name = "部门名称", targetAttr = "deptName", type = Type.EXPORT),
    @Excel(name = "部门负责人", targetAttr = "leader", type = Type.EXPORT)
})
private Dept dept;
```


## 更多操作字符串参数读取问题

事件中需要传递字符串参数，可以参考`resetPwd`传递方式。
```js
onclick=resetPwd(" + row.userId + ',' + "'" + row.userName + "'" + ")
```
完整代码
```js
formatter: function(value, row, index) {
	var actions = [];
	actions.push('<a class="btn btn-success btn-xs ' + editFlag + '" href="javascript:void(0)" onclick="$.operate.editTab(\'' + row.userId + '\')"><i class="fa fa-edit"></i>编辑</a> ');
	actions.push('<a class="btn btn-danger btn-xs ' + removeFlag + '" href="javascript:void(0)" onclick="$.operate.remove(\'' + row.userId + '\')"><i class="fa fa-remove"></i>删除</a> ');
	var more = [];
	more.push("<a class='btn btn-default btn-xs " + resetPwdFlag + "' href='javascript:void(0)' onclick=resetPwd(" + row.userId + ',' + "'" + row.userName + "'" + ")><i class='fa fa-key'></i>重置密码</a> ");
	more.push("<a class='btn btn-default btn-xs " + editFlag + "' href='javascript:void(0)' onclick='authRole(" + row.userId + ")'><i class='fa fa-check-square-o'></i>分配角色</a>");
	actions.push('<a tabindex="0" class="btn btn-info btn-xs" role="button" data-container="body" data-placement="left" data-toggle="popover" data-html="true" data-trigger="hover" data-content="' + more.join('') + '"><i class="fa fa-chevron-circle-right"></i>更多操作</a>');
	return actions.join('');
}
```


## 单元格内容过长显示处理方法

1、使用系统自带的方法格式化处理
```java
{
	field: 'remark',
	title: '备注',
	align: 'center',
	formatter: function(value, row, index) {
		return $.table.tooltip(value);
	}
},
```

2、添加css控制
```css
.select-table table {
    table-layout:fixed;
}

.select-table .table td {
	/* 超出部分隐藏 */
	overflow:hidden;
	/* 超出部分显示省略号 */
    text-overflow:ellipsis;
    /*规定段落中的文本不进行换行 */
    white-space:nowrap;
    /* 配合宽度来使用 */
	height:40px;
}
```

## 表格禁用某列复选框选择方法

条件成立禁用checkbox返回（disabled : true）即可。
```js
{
	checkbox: true,
	formatter: function (value, row, index) {
		if($.common.equals("ry", row.loginName)){
			return { disabled : true}
		} else {
			return { disabled : false}
		}
	}
},
```

## 表格默认勾选某列复选框方法

条件成立禁用checkbox返回（disabled : true）即可。
```js
{
	checkbox: true,
	formatter: function (value, row, index) {
		if($.common.equals("ry", row.loginName)){
			return { checked : true}
		} else {
			return { checked : false}
		}
	}
},
```

::: tip 提示
如果默认勾选，并且配置了 `rememberSelected: true,` 需要特殊处理下。参考demo
```html
<!DOCTYPE html>
<html lang="zh" xmlns:th="http://www.thymeleaf.org" xmlns:shiro="http://www.pollix.at/thymeleaf/shiro">
<head>
	<th:block th:include="include :: header('翻页记住选择')" />
</head>
<body class="gray-bg">
     <div class="container-div">
     	<div class="btn-group-sm" id="toolbar" role="group">
	        <a class="btn btn-success" onclick="checkItem()">
	            <i class="fa fa-check"></i> 选中项
	        </a>
        </div>
		<div class="row">
			<div class="col-sm-12 select-table table-striped">
				<table id="bootstrap-table"></table>
			</div>
		</div>
	</div>
    <div th:include="include :: footer"></div>
    <script th:inline="javascript">
        var prefix = ctx + "demo/table";
        var datas = [[${@dict.getType('sys_normal_disable')}]];

        $(function() {
            var options = {
                uniqueId: "userCode",
                url: prefix + "/list",
		        rememberSelected: true,
                columns: [{
                	field: 'state',
		            checkbox: true,
		            formatter: function(value, row, index) {
		            	if($.inArray(row.userCode, table.rememberSelectedIds[table.options.id]) !== -1 || row.userCode == 1000001 || row.userCode == 1000002){
		            		if($.inArray(row.userCode, uncheckUserCode) !== -1)
		            		{
		            			return { checked : false };
		            		}
		            		var selectedRows = table.rememberSelecteds[table.options.id];
		            		func = $.inArray('check', ['check', 'check-all']) > -1 ? 'union' : 'difference';
		            		if($.common.isNotEmpty(selectedRows)) {
		            			table.rememberSelecteds[table.options.id] = _[func](selectedRows, row);
	            			} else {
	            				table.rememberSelecteds[table.options.id] = _[func]([], row);
	            			}
		            		return { checked : true };
		            	}
		            	return { checked : false };
		        	}
		        },
				{
					field : 'userId', 
					title : '用户ID'
				},
				{
					field : 'userCode', 
					title : '用户编号'
				},
				{
					field : 'userName', 
					title : '用户姓名'
				},
				{
					field : 'userPhone', 
					title : '用户手机'
				},
				{
					field : 'userEmail', 
					title : '用户邮箱'
				},
				{
				    field : 'userBalance',
				    title : '用户余额'
				},
				{
                    field: 'status',
                    title: '用户状态',
                    align: 'center',
                    formatter: function(value, row, index) {
                    	return $.table.selectDictLabel(datas, value);
                    }
                },
		        {
		            title: '操作',
		            align: 'center',
		            formatter: function(value, row, index) {
		            	var actions = [];
		            	actions.push('<a class="btn btn-success btn-xs" href="#"><i class="fa fa-edit"></i>编辑</a> ');
                        actions.push('<a class="btn btn-danger btn-xs" href="#"><i class="fa fa-remove"></i>删除</a>');
						return actions.join('');
		            }
		        }]
            };
            $.table.init(options);
        });
        
        
        var uncheckUserCode = [];
    	$("#bootstrap-table").on("uncheck.bs.table uncheck-all.bs.table", function (e, rows) {
    		if(rows.length > 0) {
    			for (var index in rows) {
    				uncheckUserCode.unshift(rows[index].userCode);
   		        }
    		} else {
    			uncheckUserCode.unshift(rows.userCode);
    		}
    	});
        
    	$("#bootstrap-table").on("check.bs.table check-all.bs.table", function (e, rows) {
    		if(rows.length > 0) {
    			for (var index in rows) {
    				deleteItem(rows[index].userCode);
   		        }
    		} else {
    			deleteItem(rows.userCode);
    		}
    	});
    	
    	function deleteItem(item) {
    	    for (var key in uncheckUserCode) {
    	        if (uncheckUserCode[key] === item) {
    	        	uncheckUserCode.splice(key, 1)
    	        }
    	    }
    	}
        
        // 选中数据
        function checkItem(){
        	// var arrays = $.table.selectColumns("userId");
        	var arrays = $.table.selectColumns("userCode");
        	alert(arrays);
        }
    </script>
</body>
</html>
```
:::


## 页面如何一次初始化多个表格

在`options`中添加`id`参数，如果有按钮组也需要添加`toolbar`。

```javascript
// 表格1
var options = {
	id: "bootstrap-table1",
    toolbar: "toolbar1",
	// 省略 ....
};
$.table.init(options);

// 表格2
var options = {
	id: "bootstrap-table2",
    toolbar: "toolbar2",
	// 省略 ....
};
$.table.init(options);
```


## 表格底部合计列拖动显示问题

在`options`中添加`onLoadSuccess`参数。
```javascript
onLoadSuccess: onLoadSuccess,

```
```javascript
// 监听表体fixed-table-body滚动事件，赋值给表尾fixed-table-footer
function onLoadSuccess() {
	$(".fixed-table-body").on("scroll",function(){
		var sl=this.scrollLeft;
		$(this).next()[0].scrollLeft = sl;
	})
}
```


## 表格操作列传递行数据的对象

传递JSON字符串
```js
actions.push('<a class="btn btn-success btn-xs href="javascript:void(0)" onclick="edit(' + JSON.stringify(row).replace(/"/g, '&quot;') + ')"><i class="fa fa-edit"></i>编辑</a> ');
```

传递JSON对象
```js
actions.push("<a class='btn btn-success btn-xs href='javascript:void(0)' onclick='edit(" + JSON.stringify(row) + ")'><i class='fa fa-edit'></i>编辑</a> ");
```

获取xxxx字段
```js
function edit(row) {
    alert(row.xxxx);
}
```

## 日期控件初始化时间并格式化

使用thymeleaf在页面直接获取当前时间并格式化输出

```html
<input type="text" th:value="${#dates.format(new java.util.Date(), 'yyyy-MM-dd')}" />
<a th:text="${#dates.format(new java.util.Date().getTime(), 'yyyy-MM-dd HH:mm:ss')}">time</a>
```

## 如何调整首页左侧菜单栏宽度

调整`style.css`对应样式宽度，例如宽度200修改成250

```css
body.fixed-sidebar .navbar-static-side, body.canvas-menu .navbar-static-side {
    width: 250px;
}
```

```css
nav .logo {
	width: 250px;
}
```

```css
#page-wrapper {
    margin: 0 0 0 250px;
}
```

## 如何默认显示表格卡片视图

在`options`中添加 `mobileResponsive` `cardView` 参数

```js
mobileResponsive: false,
cardView: true,
```

## 编辑和删除操作按钮不可用

这种情况一般是因为第一列不是唯一键或formatter序号造成的。解决方案如下，指定唯一列属性 配合删除/修改使用 未指定则使用表格行首列

在`options`中添加 `uniqueId`参数，`userId`修改成你表的唯一列字段。

```js
uniqueId: 'userId',
```


## Tomcat部署多个War包项目异常

`default-domain`的值不一样就可以了
在`application.yml`里面配置上
```yml
spring:
  jmx:
    default-domain: applicationname
```


## 部署多个项目Ehcache缓存异常

同一服务器部署多个项目，有可能会导致`shiro-activeSessionCache`缓存冲突。
```
net.sf.ehcache.ObjectExistsException: Cache shiro-activeSessionCache already exists
```

可以在`ShiroConfig`设置不同名称区分一下就可以了。
```java
public OnlineSessionDAO sessionDAO()
{
        OnlineSessionDAO sessionDAO = new OnlineSessionDAO();
        sessionDAO.setActiveSessionsCacheName("缓存名字");
        return sessionDAO;
}
```


## Tomcat临时目录tmp抛错误异常

首先，我们应该知道，对于http POST请求来说，它需要使用这个临时目录来存储post数据。  
其次，因为该目录是挂在到/temp目录下的临时文件，那么对于一些OS系统，像centOS将经常删除这个临时目录，所有导致该目录不存在了  

**解决方案**

1.在`application.yml`文件中设置`multipart` `location` ，并重启项目
```yml
spring:
  http:
    multipart:
      location: /data/upload_tmp
```

2.在`application.yml`文件中设置
```yml
server
  tomcat:
     basedir: /tmp/tomcat
```

3.在配置文件添加`bean`
```java
@Bean
public MultipartConfigElement multipartConfigElement() {
　　MultipartConfigFactory factory = new MultipartConfigFactory();
　　factory.setLocation("/tmp/tomcat");
　　return factory.createMultipartConfig();
}
```

4.添加启动参数`-java.tmp.dir=/path/to/application/temp/`，并重启。


## 如何部署配置支持https访问

`Nginx` 配置为例，完整流程如下

**申请下载ssl证书** 证书有很多种，申请成功后会得到一个压缩包，里面有2个证书

1、安装`OpenSSL`
`yum -y install openssl openssl-devel`

2、运行添加`ssl`模块  
`./configure --prefix=/usr/local/nginx --with-http_ssl_module`

3、配置完成后，运行命令
`make`

4、然后将刚刚编译好的`nginx`覆盖掉原有的`nginx`（这个时候nginx要停止状态）  
`cp objs/nginx /usr/local/nginx/sbin/`

5、复制`crt`证书文件和`key`私钥文件到`Nginx`服务器`/usr/local/nginx/conf`目录（此处为 `Nginx` 默认安装目录，请根据实际情况操作）下。

6、编辑 `Nginx` 根目录下的 `conf/nginx.conf` 文件。添加内容如下：
```
# https 服务配置
server {
	# 侦听80端口
	listen 443 default ssl;
	ssl on;
	#证书文件名称
	ssl_certificate 1_ruoyi.vip_bundle.crt; 
	#私钥文件名称
	ssl_certificate_key 2_ruoyi.vip.key; 
	# 定义访问域名
	server_name ruoyi.vip;
	location / {
		# 存放了静态页面的根目录
		root   /home/ruoyi/projects/static-web;
		# 默认主页
		index index.html;
	}
}
```

7、重启`Nginx`通过`https`访问 `https://ruoyi.vip`

8、如需把`http`的域名请求转成`https`，添加`rewrite`
```
rewrite ^(.*) https://$server_name$1 permanent;
```

9、解决重定向后https变成了http 的问题
```
proxy_redirect http:// https://; 
```

## 特殊字符串被过滤的解决办法

默认所有的都会过滤脚本，可以在`application.yml`配置`xss.excludes`属性排除`URL`

```yml
# 防止XSS攻击
xss: 
  # 过滤开关
  enabled: true
  # 排除链接（多个用逗号分隔）
  excludes: /system/notice/*
  # 匹配链接
  urlPatterns: /system/*,/monitor/*,/tool/*
```


## 进入首页如何自动展开某菜单

例如，进入自动打开用户管理，调用`applyPath`，填入你请求菜单对应的url地址。
```js
applyPath("/system/role")
```


## 进入首页如何默认记忆控制台

例如用户退出后，下次登陆系统，能默认打开之前工作路径。

可以在`index.html`，`index-topnav.html`，去掉`window.performance.navigation.type == 1`
```js
if($.common.equals("history", mode) && window.performance.navigation.type == 1)
```
换成
```js
if($.common.equals("history", mode))
```


## 打包如何分离jar包和资源文件

特殊情况需要分离`lib`和`resouce`可以修改`ruoyi-admin` 参考如下

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>ruoyi</artifactId>
        <groupId>com.ruoyi</groupId>
        <version>4.4.0</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
	<packaging>jar</packaging>
    <artifactId>ruoyi-admin</artifactId>
	
	<description>
	    web服务入口
	</description>

    <dependencies>
    
        <!-- SpringBoot集成thymeleaf模板 -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>

        <!-- spring-boot-devtools -->
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-devtools</artifactId>
			<optional>true</optional> <!-- 表示依赖不会传递 -->
		</dependency>

		<!-- swagger2-->
		<dependency>
			<groupId>io.springfox</groupId>
			<artifactId>springfox-swagger2</artifactId>
		</dependency>
		
		<!--防止进入swagger页面报类型转换错误，排除2.9.2中的引用，手动增加1.5.21版本-->
        <dependency>
            <groupId>io.swagger</groupId>
            <artifactId>swagger-annotations</artifactId>
            <version>1.5.21</version>
        </dependency>
        
        <dependency>
            <groupId>io.swagger</groupId>
            <artifactId>swagger-models</artifactId>
            <version>1.5.21</version>
        </dependency>
		
		<!-- swagger2-UI-->
		<dependency>
			<groupId>io.springfox</groupId>
			<artifactId>springfox-swagger-ui</artifactId>
		</dependency>
		 
    	 <!-- Mysql驱动包 -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>

		<!-- 核心模块-->
        <dependency>
            <groupId>com.ruoyi</groupId>
            <artifactId>ruoyi-framework</artifactId>
        </dependency>
        
        <!-- 定时任务-->
        <dependency>
            <groupId>com.ruoyi</groupId>
            <artifactId>ruoyi-quartz</artifactId>
        </dependency>
        
        <!-- 代码生成-->
        <dependency>
            <groupId>com.ruoyi</groupId>
            <artifactId>ruoyi-generator</artifactId>
        </dependency>
        
    </dependencies>

     <build>
        <!-- jar包名 -->
        <finalName>${project.artifactId}</finalName>
        <plugins>
            <!-- 分离lib -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-dependency-plugin</artifactId>
                <executions>
                    <execution>
                        <id>copy-dependencies</id>
                        <phase>package</phase>
                        <goals>
                            <goal>copy-dependencies</goal>
                        </goals>
                        <configuration>
                            <!-- 依赖包输出目录，将来不打进jar包里 -->
                            <outputDirectory>${project.build.directory}/lib</outputDirectory>
                            <excludeTransitive>false</excludeTransitive>
                            <stripVersion>false</stripVersion>
                            <includeScope>runtime</includeScope>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <!-- copy资源文件 -->
            <plugin>
                <artifactId>maven-resources-plugin</artifactId>
                <executions>
                    <execution>
                        <id>copy-resources</id>
                        <phase>package</phase>
                        <goals>
                            <goal>copy-resources</goal>
                        </goals>
                        <configuration>
                            <resources>
                                <resource>
                                    <directory>src/main/resources</directory>
                                </resource>
                            </resources>
                            <outputDirectory>${project.build.directory}/resources</outputDirectory>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <!-- 打jar包时忽略配置文件 -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <configuration>
                    <excludes>
                        <exclude>**/*.yml</exclude>
                        <exclude>**/*.xml</exclude>
                    </excludes>
                </configuration>
            </plugin>
            <!-- spring boot repackage -->
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <layout>ZIP</layout>
                    <includes>
                        <include>
                            <groupId>non-exists</groupId>
                            <artifactId>non-exists</artifactId>
                        </include>
                    </includes>
                </configuration>
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

::: tip 提示
启动命令java -jar -Dloader.path=resources,lib ruoyi-admin.jar
:::


## Linux系统验证码乱码解决方法

在云服务器（少许），或者干净的服务器上，服务器没有安装字体。

1、上传本地的 [Arial.ttf](http://ruoyi.vip/font/Arial.ttf) 字体

2、此时执行以下三个命令：（建立字体索引信息，更新字体缓存）  
`mkfontscale` `mkfontdir` `fc-cache -fv`

3、重新刷新你的页面


## 公共数据库定时任务没有被执行

经常会有小伙伴遇到定时任务没有被执行，或者执行了但是报错找不到对应的方法。

定时任务是`分布式`的，如果多个机器链接同一个数据库，定时任务会随机在某个机器上跑，所以有时候不是没有被执行，而是被其他机器上执行了。如果你的方法只在本机有，所以会提示找不到对应定时任务的方法。

这种情况或只有一台机器的话可以注释掉`ScheduleConfig.java`，这样的话就只会走本机（`quartz`相关定时任务的表也不需要），它也不会在去读`quartz`表走集群操作。

## 如何设置用户登录会话超时时间

找到`ruoyi-admin\src\main\resources`下面的`application.yml`配置文件

```yml
# Shiro
shiro:
  session:
    # Session超时时间，-1代表永不过期（默认30分钟）
    expireTime: 30
```

## 如何实现用户免密登录配置方法

免密使用的场景，例如短信验证码，第三方应用登录等。下面列出一个简单的实现方法，当然还有更多实现方式可以自己尝试。

1、新增一个登录类型枚举类`LoginType`

```java
package com.ruoyi.framework.shiro.token;

/**
 * 登录类型枚举类
 * 
 * @author ruoyi
 */
public enum LoginType
{
    /**
     * 密码登录
     */
    PASSWORD("password"),
    /**
     * 免密码登录
     */
    NOPASSWD("nopasswd");

    private String desc;

    LoginType(String desc)
    {
        this.desc = desc;
    }

    public String getDesc()
    {
        return desc;
    }
}
```

2、自定义登录`Token`

```java
package com.ruoyi.framework.shiro.token;

import org.apache.shiro.authc.UsernamePasswordToken;

/**
 * 自定义登录Token
 * 
 * @author ruoyi
 */
public class UserToken extends UsernamePasswordToken
{
    private static final long serialVersionUID = 1L;

    private LoginType type;

    public UserToken()
    {
    }

    public UserToken(String username, String password, LoginType type, boolean rememberMe)
    {
        super(username, password, rememberMe);
        this.type = type;
    }

    public UserToken(String username, LoginType type)
    {
        super(username, "", false, null);
        this.type = type;
    }

    public UserToken(String username, String password, LoginType type)
    {
        super(username, password, false, null);
        this.type = type;
    }

    public LoginType getType()
    {
        return type;
    }

    public void setType(LoginType type)
    {
        this.type = type;
    }
}
```

3、对应`Realm`中添加登录类型判断，例如`UserRealm`（这里演示公用一个`realm`，如单独有免密`realm`不需要）

```java
/**
 * 登录认证
 */
@Override
protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException
{
	UserToken upToken = (UserToken) token;
	LoginType type = upToken.getType();
	String username = upToken.getUsername();
	String password = "";
	if (upToken.getPassword() != null)
	{
		password = new String(upToken.getPassword());
	}

	User user = null;
	try
	{
		if (LoginType.PASSWORD.equals(type))
		{
			user = loginService.login(username, password);
		}
		else if (LoginType.NOPASSWD.equals(type))
		{
			user = loginService.login(username);
		}
	}
	catch (CaptchaException e)
	{
		throw new AuthenticationException(e.getMessage(), e);
	}
	catch (UserNotExistsException e)
	{
		throw new UnknownAccountException(e.getMessage(), e);
	}
	catch (UserPasswordNotMatchException e)
	{
		throw new IncorrectCredentialsException(e.getMessage(), e);
	}
	catch (UserPasswordRetryLimitExceedException e)
	{
		throw new ExcessiveAttemptsException(e.getMessage(), e);
	}
	catch (UserBlockedException e)
	{
		throw new LockedAccountException(e.getMessage(), e);
	}
	catch (RoleBlockedException e)
	{
		throw new LockedAccountException(e.getMessage(), e);
	}
	catch (Exception e)
	{
		log.info("对用户[" + username + "]进行登录验证..验证未通过{}", e.getMessage());
		throw new AuthenticationException(e.getMessage(), e);
	}
	SimpleAuthenticationInfo info = new SimpleAuthenticationInfo(user, password, getName());
	return info;
}
```

4、`LoginService`添加`login`方法，去掉密码验证。

```java
/**
 * 登录
 */
public User login(String username)
{
	// 验证码校验
	if (!StringUtils.isEmpty(ServletUtils.getRequest().getAttribute(ShiroConstants.CURRENT_CAPTCHA)))
	{
		AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL, MessageUtils.message("user.jcaptcha.error")));
		throw new CaptchaException();
	}
	// 用户名或密码为空 错误
	if (StringUtils.isEmpty(username))
	{
		AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL, MessageUtils.message("not.null")));
		throw new UserNotExistsException();
	}

	// 用户名不在指定范围内 错误
	if (username.length() < UserConstants.USERNAME_MIN_LENGTH
			|| username.length() > UserConstants.USERNAME_MAX_LENGTH)
	{
		AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL, MessageUtils.message("user.password.not.match")));
		throw new UserPasswordNotMatchException();
	}

	// 查询用户信息
	User user = userService.selectUserByLoginName(username);

	if (user == null)
	{
		AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL, MessageUtils.message("user.not.exists")));
		throw new UserNotExistsException();
	}
	
	if (UserStatus.DELETED.getCode().equals(user.getDelFlag()))
	{
		AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL, MessageUtils.message("user.password.delete")));
		throw new UserDeleteException();
	}
	
	if (UserStatus.DISABLE.getCode().equals(user.getStatus()))
	{
		AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL, MessageUtils.message("user.blocked", user.getRemark())));
		throw new UserBlockedException();
	}

	AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_SUCCESS, MessageUtils.message("user.login.success")));
	recordLoginInfo(user);
	return user;
}
```

5、在对应的登录方法中传入`LoginType.NOPASSWD`调用

```java
UserToken token = new UserToken(username, LoginType.NOPASSWD);
Subject subject = SecurityUtils.getSubject();
subject.login(token);
```

## 如何处理Long类型精度丢失问题

当字段实体类为`Long`类型且值超过前端`js`显示的长度范围时会导致前端回显错误，解决方案如下

1、使用`JsonSerialize`注解序列化的时候把Long自动转为`String`（针对单个属性）

```java
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;

@JsonSerialize(using = ToStringSerializer.class)
private Long xxx;
```

2、添加`JacksonConfig`配置全局序列化（针对所有属性）

```java
package com.ruoyi.framework.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;

/**
 * Jackson配置
 * 
 * @author ruoyi
 *
 */
@Configuration
public class JacksonConfig
{
    @Bean
    public MappingJackson2HttpMessageConverter jackson2HttpMessageConverter()
    {
        final Jackson2ObjectMapperBuilder builder = new Jackson2ObjectMapperBuilder();
        builder.serializationInclusion(JsonInclude.Include.NON_NULL);
        final ObjectMapper objectMapper = builder.build();
        SimpleModule simpleModule = new SimpleModule();
        // Long 转为 String 防止 js 丢失精度
        simpleModule.addSerializer(Long.class, ToStringSerializer.instance);
        objectMapper.registerModule(simpleModule);
        // 忽略 transient 关键词属性
        objectMapper.configure(MapperFeature.PROPAGATE_TRANSIENT_MARKER, true);
        return new MappingJackson2HttpMessageConverter(objectMapper);
    }
}
```


## 如何修改超级管理员登录密码

1、如果是自己知道超级管理员的密码且需要修改的情况。  
默认口令 `admin/admin123`，可以登录后在首页个人中心修改密码。

2、如果自己忘记了超级管理员的密码可以重新生成秘钥替换数据库密码。
```java
public static void main(String[] args)
{
    // 第一个参数为账户名 第二个参数为密码 第三个参数为盐对应用户表salt（如果没有可以不用填）
	System.out.println(new PasswordService().encryptPassword("admin", "admin123", "111111"));
}
```


## 如何修改数据监控登录账户密码

控制台管理用户名和密码默认为`ruoyi/123456`

找到`ruoyi-admin\src\main\resources`下面的`application-druid.yml`配置文件

找到如下节点配置，设置控制台账号密码
```yml
# 控制台管理用户名和密码
login-username: 你的监控台账号
login-password: 你的监控台密码
```


## 分页插件如何手写count查询支持

增加`countSuffix` count 查询后缀配置参数，该参数是针对`PageInterceptor`配置的，默认值为`_COUNT`。

分页插件会优先通过当前查询的`msId + countSuffix`查找手写的分页查询。

如果存在就使用手写的`count`查询，如果不存在，仍然使用之前的方式自动创建`count`查询。

例如，如果存在下面两个查询：
```xml
<select id="selectLeftjoin" resultType="com.github.pagehelper.model.User">
    select a.id,b.name,a.py from user a
    left join user b on a.id = b.id
    order by a.id
</select>

<select id="selectLeftjoin_COUNT" resultType="Long">
    select count(distinct a.id) from user a
    left join user b on a.id = b.id
</select>
```
上面的`countSuffix`使用的默认值`_COUNT`，分页插件会自动获取到`selectLeftjoin_COUNT`查询，这个查询需要自己保证结果数正确。

返回值的类型必须是`resultType="Long"`，入参使用的和`selectLeftjoin`查询相同的参数，所以在`SQL`中要按照`selectLeftjoin`的入参来使用。

因为`selectLeftjoin_COUNT`方法是自动调用的，所以不需要在接口提供相应的方法，如果需要单独调用，也可以提供。


## 如何修改成自定义的Cookie名称

在`ShiroConfig`中`sessionManager`方法添加，其中`ruoyi`为设置的`Cookie`名称

```java
// 自定义 Cookie
manager.setSessionIdCookie(new SimpleCookie("ruoyi"));
```

## 如何格式化前端日期时间戳内容

对应一些时间格式需要在前端进行格式化操作情况，解决方案如下

1、后端使用`JsonFormat`注解格式化日期，时间戳`yyyy-MM-dd HH:mm:ss`

```java
/** 创建时间 */
@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
private Date time;
```

2、前端使用`dateFormat`方法格式化日期，时间戳`yyyy-MM-dd HH:mm:ss`

```javascript
{
	field: 'createTime',
	title: '创建时间',
	formatter: function(value, row, index) {
		return $.common.dateFormat(value, "yyyy-MM-dd HH-mm-ss");
	}
},
```


## 使用Velocity模板引擎兼容$符号

当我们服务器端使用`velocity`模板来渲染前端页面的时候，而前端使用jquery,vue,angular等等也使用$运算符渲染变量，那么就会产生冲突，
对于这种特殊情况需要加入新的指令`#[[您前端不需要让velocity处理的内容]]`，可以完美解决这个问题。

示例：
```javascript
// 无法解析
let list = (params) => vm.$u.get("/${moduleName}/${businessName}/list", params);

// 正常解析
let list = (params) => vm.#[[$u]]#.get("/${moduleName}/${businessName}/list", params);
```

## 如何解决多数据源事务的一致性

[参考集成atomikos实现分布式事务](/ruoyi/document/cjjc.html#集成atomikos实现分布式事务)

## 如何优雅的关闭后台系统服务

[参考集成actuator实现优雅关闭应用](/ruoyi/document/cjjc.html#集成actuator实现优雅关闭应用)

## 如何使用Redis实现集群会话管理

[参考集成Redis实现集群会话](/ruoyi/document/cjjc.html#参考集成Redis实现集群会话)

## 如何使用Jwt实现登录授权访问控制

[参考集成Jwt实现登录授权访问](/ruoyi/document/cjjc.html#集成Jwt实现登录授权访问)

## 如何解决导出使用下载插件出现异常

导出文件的逻辑是先创建一个临时文件，等待前端请求下载结束后马上删除这个临时文件。但是有些下载插件，例如迅雷（他们是二次下载），这个时候文件已经删除，会导致异常，找不到文件。

解决方案：如果有硬性要求话，可以把所有的导出都改成流的形式返回给前端，不采用临时文件的方法。

```java
// 默认的post请求 生成临时文件
@PostMapping("/export")
@ResponseBody
public AjaxResult export(Xxxx xxxx)
{
	List<Xxxx> list = xxxxService.selectXxxxList(xxxx);
	ExcelUtil<Xxxx> util = new ExcelUtil<Xxxx>(Xxxx.class);
	return util.exportExcel(list, "xxxx");
}
```

修改相关导出文件`java`代码和`ry-ui.js`通用导出方法

```java
// 通过流的形式返回给前端
@GetMapping("/export")
@ResponseBody
public void export(HttpServletResponse response, Xxxx xxxx) throws IOException
{
	List<Xxxx> list = xxxxService.selectXxxxList(xxxx);
	ExcelUtil<Xxxx> util = new ExcelUtil<Xxxx>(Xxxx.class);
	util.exportExcel(response, list, "xxxx");
}
```

```js
// ry-ui.js导出数据修改成get请求方式
exportExcel: function(formId) {
	table.set();
	$.modal.confirm("确定导出所有" + table.options.modalName + "吗？", function() {
		var currentId = $.common.isEmpty(formId) ? $('form').attr('id') : formId;
		var params = $("#" + table.options.id).bootstrapTable('getOptions');
		var dataParam = $("#" + currentId).serializeArray();
		dataParam.push({ "name": "orderByColumn", "value": params.sortName });
		dataParam.push({ "name": "isAsc", "value": params.sortOrder });
		window.location.href = table.options.exportUrl + "?" + $.param(dataParam);
	});
},
```


## 如何解决请求地址存在中文出现异常

`shrio1.7.0`版本才会出现，对于请求地址需要中文的情况下可以做以下处理。

1、自定义`CustomShiroFilterFactoryBean.java`，设置`setBlockNonAscii`属性为`false`
```java
package com.ruoyi.framework.config;

import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.web.filter.InvalidRequestFilter;
import org.apache.shiro.web.filter.mgt.DefaultFilter;
import org.apache.shiro.web.filter.mgt.FilterChainManager;
import org.apache.shiro.web.filter.mgt.FilterChainResolver;
import org.apache.shiro.web.filter.mgt.PathMatchingFilterChainResolver;
import org.apache.shiro.web.mgt.WebSecurityManager;
import org.apache.shiro.web.servlet.AbstractShiroFilter;
import org.apache.shiro.mgt.SecurityManager;
import org.springframework.beans.factory.BeanInitializationException;
import javax.servlet.Filter;
import java.util.Map;

/**
 * 自定义ShiroFilterFactoryBean解决资源中文路径问题
 * 
 * @author ruoyi
 */
public class CustomShiroFilterFactoryBean extends ShiroFilterFactoryBean
{
    @Override
    public Class<MySpringShiroFilter> getObjectType()
    {
        return MySpringShiroFilter.class;
    }

    @Override
    protected AbstractShiroFilter createInstance() throws Exception
    {

        SecurityManager securityManager = getSecurityManager();
        if (securityManager == null)
        {
            String msg = "SecurityManager property must be set.";
            throw new BeanInitializationException(msg);
        }

        if (!(securityManager instanceof WebSecurityManager))
        {
            String msg = "The security manager does not implement the WebSecurityManager interface.";
            throw new BeanInitializationException(msg);
        }

        FilterChainManager manager = createFilterChainManager();
        // Expose the constructed FilterChainManager by first wrapping it in a
        // FilterChainResolver implementation. The AbstractShiroFilter implementations
        // do not know about FilterChainManagers - only resolvers:
        PathMatchingFilterChainResolver chainResolver = new PathMatchingFilterChainResolver();
        chainResolver.setFilterChainManager(manager);

        Map<String, Filter> filterMap = manager.getFilters();
        Filter invalidRequestFilter = filterMap.get(DefaultFilter.invalidRequest.name());
        if (invalidRequestFilter instanceof InvalidRequestFilter)
        {
            // 此处是关键,设置false跳过URL携带中文400，servletPath中文校验bug
            ((InvalidRequestFilter) invalidRequestFilter).setBlockNonAscii(false);
        }
        // Now create a concrete ShiroFilter instance and apply the acquired SecurityManager and built
        // FilterChainResolver. It doesn't matter that the instance is an anonymous inner class
        // here - we're just using it because it is a concrete AbstractShiroFilter instance that accepts
        // injection of the SecurityManager and FilterChainResolver:
        return new MySpringShiroFilter((WebSecurityManager) securityManager, chainResolver);
    }

    private static final class MySpringShiroFilter extends AbstractShiroFilter
    {
        protected MySpringShiroFilter(WebSecurityManager webSecurityManager, FilterChainResolver resolver)
        {
            if (webSecurityManager == null)
            {
                throw new IllegalArgumentException("WebSecurityManager property cannot be null.");
            }
            else
            {
                this.setSecurityManager(webSecurityManager);
                if (resolver != null)
                {
                    this.setFilterChainResolver(resolver);
                }

            }
        }
    }
}
```

2、替换`ShiroConfig.java`中的过滤器配置为自定义
```java
// 默认的
ShiroFilterFactoryBean shiroFilterFactoryBean = new ShiroFilterFactoryBean();

ShiroFilterFactoryBean更换为CustomShiroFilterFactoryBean

// 自定义的
CustomShiroFilterFactoryBean shiroFilterFactoryBean = new CustomShiroFilterFactoryBean();
```

