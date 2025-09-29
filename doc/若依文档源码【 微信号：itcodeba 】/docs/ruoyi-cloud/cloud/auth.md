# 认证中心

## 基本介绍

* 什么是认证中心

身份认证，就是判断一个用户是否为合法用户的处理过程。最常用的简单身份认证方式是系统通过核对用户输入的用户名和口令，看其是否与系统中存储的该用户的用户名和口令一致，来判断用户身份是否正确。

* 为什么要使用认证中心

登录请求后台接口，为了安全认证，所有请求都携带`token`信息进行安全认证，比如使用`vue`、`react`后者`h5`开发的`app`，用于控制可访问系统的资源。

## 使用认证

1、添加依赖
```xml
<!-- ruoyi common security-->
<dependency>
	<groupId>com.ruoyi</groupId>
	<artifactId>ruoyi-common-security</artifactId>
</dependency>
```

2、认证启动类
```java
public static void main(String[] args)
{
	SpringApplication.run(RuoYiAuthApplication.class, args);
	System.out.println("(♥◠‿◠)ﾉﾞ  认证授权中心启动成功   ლ(´ڡ`ლ)ﾞ  \n" +
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
```
::: tip 提示
目前已经存在`ruoyi-auth`认证授权中心，用于登录认证，系统退出，刷新令牌。
:::

## 登录认证

顾名思义，就是对系统登录用户的进行认证过程。

`TokenController`控制器`login`方法会进行用户验证，如果验证通过会保存登录日志并返回`token`，同时缓存中会存入`login_tokens:xxxxxx`（包含用户、权限信息）。

用户登录接口地址 `http://localhost:9200/login`

请求头`Content-Type - application/json`，请求方式`Post`
```json
{
    "username": "admin",
    "password": "admin123"
}
```
响应结果
```json
{
    "code": 200,
    "data": {
        "access_token": "f840488c-68a9-4272-acc9-c34d3b66a943",
        "expires_in": 43200
    }
}
```

通过用户验证登录后获取`access_token`，通过网关访问其他应用数据时必须携带此参数值。


## 刷新令牌

顾名思义，就是对系统操作用户的进行缓存刷新，防止过期。

`TokenController`控制器`refresh`方法会在用户调用时更新令牌有效期。

刷新令牌接口地址 `http://localhost:9200/refresh`

请求头`Authorization - f840488c-68a9-4272-acc9-c34d3b66a943`，请求方式`Post`

响应结果
```json
{
    "code": 200,
}
```

刷新后有效期为默720（分钟）。

## 系统退出

顾名思义，就是对系统登用户的退出过程。

`TokenController`控制器`logout`方法会在用户退出时删除缓存信息同时保存用户退出日志。

系统退出接口地址 `http://localhost:9200/logout`

请求头`Authorization - f840488c-68a9-4272-acc9-c34d3b66a943`，请求方式`Delete`
```json
{
    "username": "admin",
    "password": "admin123"
}
```
响应结果
```json
{
    "code": 200,
}
```

