# 常见问题

## 如何不登录直接访问

登录`nacos`在`配置管理`中`配置列表`，修改`ruoyi-gateway-dev.yml`

在`ignore`中设置`whites`，表示允许匿名访问

```yml
# 不校验白名单
security:
  ignore:
    whites:
      - /auth/logout
      - /auth/login
      - /*/v2/api-docs
      - /csrf
```


## 如何获取用户登录信息

1. 后端获取当前用户信息
```java
// 获取当前用户名
String username = SecurityUtils.getUsername();

// 获取当前用户ID
Long userid = SecurityUtils.getUserId();

// 获取当前的用户信息
@Autowired
private TokenService tokenService;

LoginUser loginUser = tokenService.getLoginUser(ServletUtils.getRequest());
```

2、vue中获取当前用户信息
```javascript
var username = this.$store.state.user.name;
```

## 如何更换项目包路径

> 可以使用[若依框架包名修改器](https://gitee.com/lpf_project/common-tools)一键替换。


## 提示您没有数据的权限

这种情况都属于权限标识配置不对在```菜单管理```配置好权限标识（菜单&按钮）
1. 确认此用户是否已经配置角色
2. 确认此角色是否已经配置菜单权限
3. 确认此菜单权限标识是否和后台代码一致  

如参数管理  
后台配置`@PreAuthorize(hasPermi = "system:config:list")`对应参数管理权限标识为`system:config:list`

注：如需要角色权限，配置角色权限字符 使用`@PreAuthorize(hasRole = "admin")`


## 登录页面如何不显示验证码

登录`nacos`在`配置管理`中`配置列表`，修改`ruoyi-gateway-dev.yml`

在`captcha`中设置`enabled`属性（`true`开启、`false`关闭）

```yml
# 验证码
security:
  captcha:
    enabled: false
```


## 特殊字符串被过滤的解决办法

默认所有的都会过滤脚本，可以在`ruoyi-gateway-dev.yml`配置`xss.excludeUrls`属性排除`URL`
```yml
# 安全配置
security:
  xss:
    enabled: true
    excludeUrls:
      - /system/notice
```


## 更多项目常见问题查询

微服务版本问题和分离版本大多数雷同。

[RuoYi-Vue分离版本常见问题点我进入](/ruoyi-vue/other/faq.html)

