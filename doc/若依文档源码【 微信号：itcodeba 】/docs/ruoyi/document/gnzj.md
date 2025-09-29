# 功能组件

## 弹窗功能

弹框的功能不管是在传统开发中还是如今比较流行的前后端分离开发中都是比较常见的功能，如：添加、编辑、确认框提示等等(当前页可以直接打开新页面)，
为了解决这个问题，我们封装了弹框组件，根据使用场景的不同，框架做了继承开发，调用时只需要传入相应的参数即可。

函数主体：
```javascript
open: function (title, url, width, height, callback) {
	//如果是移动端，就使用自适应大小弹窗
	if ($.common.isMobile()) {
		width = 'auto';
		height = 'auto';
	}
	if ($.common.isEmpty(title)) {
		title = false;
	}
	if ($.common.isEmpty(url)) {
		url = "/404.html";
	}
	if ($.common.isEmpty(width)) {
		width = 800;
	}
	if ($.common.isEmpty(height)) {
		height = ($(window).height() - 50);
	}
	if ($.common.isEmpty(callback)) {
		callback = function(index, layero) {
			var iframeWin = layero.find('iframe')[0];
			iframeWin.contentWindow.submitHandler(index, layero);
		}
	}
	layer.open({
		type: 2,
		area: [width + 'px', height + 'px'],
		fix: false,
		//不固定
		maxmin: true,
		shade: 0.3,
		title: title,
		content: url,
		btn: ['确定', '关闭'],
		// 弹层外区域关闭
		shadeClose: true,
		yes: callback,
		cancel: function(index) {
			return true;
		}
	});
},
```

参数说明：
* `title`    弹窗标题，这个标题是在弹框的左上角显示的标题文字
* `url`      URL地址，这个是弹框调用的方法地址，比如添加、编辑时需要调用页面表单地址的方法
* `width`    弹窗宽度，一个数值(不传时默认弹窗自适应显示)
* `height`   弹窗高度，一个数值(不传时默认弹窗自适应显示)
* `callback` 回调函数，弹窗成功弹出之后会默认进行回调

调用方式：
```javascript
// 普通调用
$.modal.open("标题内容", url);

// 设置宽高
$.modal.open("标题内容", url, '770', '380');

// 设置回调函数
$.modal.open("标题内容", url, '770', '380', function(index, layero) {
	// 获取弹窗参数（方式一）
	var body = layer.getChildFrame('body', index);
	console.log(body.find('#id').val());
	// 获取弹窗参数（方式二）
    console.log($(layero).find("iframe")[0].contentWindow.document.getElementById("id").value);
});
```


## 新增功能

新增方法我们写一个共用的方法`add`，下面我们详细的描述下，新增时是如何弹出窗体的。

函数主体：
```javascript
// 添加信息
add: function(id) {
	table.set();
	$.modal.open("添加" + table.options.modalName, $.operate.addUrl(id));
},

// 添加访问地址
addUrl: function(id) {
	var url = $.common.isEmpty(id) ? table.options.createUrl.replace("{id}", "") : table.options.createUrl.replace("{id}", id);
	return url;
},
```

后端代码：
```java
// 添加方法（默认）
@GetMapping("/add")
public String add()
{
	return prefix + "/add";
}

// 添加方法（带id参数）
@GetMapping("/add/{xxId}")
public String add(@PathVariable("xxId") Long xxId, ModelMap mmap)
{
	mmap.put("xxxx", xxxxService.selectXxxxById(xxId));
	return prefix + "/add";
}
```

参数说明：
* `id`    需要传入到后台的唯一标识

总结：`add`方法里面进行了判断存在ID则进行内容替换，然后进行调用弹窗操作。  
操作`table.options.createUrl`地址，弹窗`table.options.modalName`标题


调用方式：
```javascript
// 普通调用
$.operate.add()

// 传参调用，例如：/system/user/add/{1} 会被替换为 /system/user/add/1
$.operate.add(1)
```


## 修改功能

修改方法我们写一个共用的方法`edit`，下面我们详细的描述下，修改时是如何弹出窗体的。

函数主体：
```javascript
/ 修改信息
edit: function(id) {
	table.set();
	if($.common.isEmpty(id) && table.options.type == table_type.bootstrapTreeTable) {
		var row = $("#" + table.options.id).bootstrapTreeTable('getSelections')[0];
		if ($.common.isEmpty(row)) {
			$.modal.alertWarning("请至少选择一条记录");
			return;
		}
		var url = table.options.updateUrl.replace("{id}", row[table.options.uniqueId]);
		$.modal.open("修改" + table.options.modalName, url);
	} else {
		$.modal.open("修改" + table.options.modalName, $.operate.editUrl(id));
	}
},

// 修改访问地址
editUrl: function(id) {
	var url = "/404.html";
	if ($.common.isNotEmpty(id)) {
		url = table.options.updateUrl.replace("{id}", id);
	} else {
		var id = $.common.isEmpty(table.options.uniqueId) ? $.table.selectFirstColumns() : $.table.selectColumns(table.options.uniqueId);
		if (id.length == 0) {
			$.modal.alertWarning("请至少选择一条记录");
			return;
		}
		url = table.options.updateUrl.replace("{id}", id);
	}
	return url;
},
```

后端代码：
```java
// 修改方法
@GetMapping("/edit/{xxId}")
public String edit(@PathVariable("xxId") Long xxId, ModelMap mmap)
{
	mmap.put("xxxx", xxxxService.selectXxxxById(xxId));
	return prefix + "/edit";
}
```

参数说明：
* `id`    需要传入到后台的唯一标识

总结：`edit`方法里面进行了判断存在ID则进行内容替换，然后进行调用弹窗操作。  
优先级：`传参ID值` -> `选择uniqueId列值` -> `选择首列值`  
操作`table.options.updateUrl`地址，`table.options.uniqueId`唯一的标识符，弹窗`table.options.modalName`标题

调用方式：
```javascript
// 普通调用
$.operate.edit()

// 传参调用，例如：/system/user/edit/{1} 会被替换为 /system/user/edit/1
$.operate.edit(1)
```

## 删除功能

删除功能我们并不陌生，在大多数的数据列表中，都会有删除按钮的出现，顾名思义就是在有权限的前提下我们可以删除这条数据，点击删除会弹出删除确认框，
确定删除后才会发起网络请求，具体JS实现方法如下：

函数主体：
```javascript
// 删除信息
remove: function(id) {
	table.set();
	$.modal.confirm("确定删除该条" + table.options.modalName + "信息吗？", function() {
		var url = $.common.isEmpty(id) ? table.options.removeUrl : table.options.removeUrl.replace("{id}", id);
		if(table.options.type == table_type.bootstrapTreeTable) {
			$.operate.get(url);
		} else {
			var data = { "ids": id };
			$.operate.submit(url, "post", "json", data);
		}
	});
},
```

后端代码：
```java
// 删除方法
@GetMapping("/remove/{xxId}")
@ResponseBody
public AjaxResult remove(@PathVariable("xxId") Long xxId)
{
	return toAjax(xxxxService.deleteXxxxById(xxId));
}
```

参数说明：
* `id`    需要传入到后台的唯一标识

总结：`remove`方法里面进行了判断存在ID则进行内容替换，同时弹出确认提醒。  
操作`table.options.removeUrl`地址，弹窗`table.options.modalName`标题

调用方式：
```javascript
// 传参调用，例如：/system/user/remove/{1} 会被替换为 /system/user/remove/1
$.operate.remove(1)
```


## 批量删除

批量操作就是可以选择多条记录数据进行批量处理的方法，在我们使用中批量删除算是最常用的了，删除多条数据时一条条删除非常耗时，那么批量删除可以很好的帮我解决此问题。

函数主体：
```javascript
// 批量删除信息
removeAll: function() {
	table.set();
	var rows = $.common.isEmpty(table.options.uniqueId) ? $.table.selectFirstColumns() : $.table.selectColumns(table.options.uniqueId);
	if (rows.length == 0) {
		$.modal.alertWarning("请至少选择一条记录");
		return;
	}
	$.modal.confirm("确认要删除选中的" + rows.length + "条数据吗?", function() {
		var url = table.options.removeUrl;
		var data = { "ids": rows.join() };
		$.operate.submit(url, "post", "json", data);
	});
},
```

后端代码：
```java
// 批量删除方法
@PostMapping("/remove")
@ResponseBody
public AjaxResult remove(String ids)
{
    return toAjax(xxxxService.deleteXxxxByIds(ids));
}
```

总结：`removeAll`方法里面默认会找到选择的第一列，其他情况可以设置指定列`uniqueId`即可。  
操作`table.options.removeUrl`地址，弹窗`table.options.modalName`标题

调用方式：
```javascript
$.operate.removeAll()
```

## 查看详情

查看记录数据的详情在我们项目研发中也是非常多见的，因此基于使用频率，我们也内置集成了查看详情的功能。

函数主体：
```javascript
// 详细信息
detail: function(id, width, height) {
	table.set();
	var _url = $.operate.detailUrl(id);
	var _width = $.common.isEmpty(width) ? "800" : width; 
	var _height = $.common.isEmpty(height) ? ($(window).height() - 50) : height;
	//如果是移动端，就使用自适应大小弹窗
	if ($.common.isMobile()) {
		_width = 'auto';
		_height = 'auto';
	}
	var options = {
		title: table.options.modalName + "详细",
		width: _width,
		height: _height,
		url: _url,
		skin: 'layui-layer-gray', 
		btn: ['关闭'],
		yes: function (index, layero) {
			layer.close(index);
		}
	};
	$.modal.openOptions(options);
},

// 详细访问地址
detailUrl: function(id) {
	var url = "/404.html";
	if ($.common.isNotEmpty(id)) {
		url = table.options.detailUrl.replace("{id}", id);
	} else {
		var id = $.common.isEmpty(table.options.uniqueId) ? $.table.selectFirstColumns() : $.table.selectColumns(table.options.uniqueId);
		if (id.length == 0) {
			$.modal.alertWarning("请至少选择一条记录");
			return;
		}
		url = table.options.detailUrl.replace("{id}", id);
	}
	return url;
},
```

后端代码：
```java
// 查询详细方法
@GetMapping("/detail/{xxId}")
public String detail(@PathVariable("xxId") Long xxId, ModelMap mmap)
{
	mmap.put("xxxx", xxxxService.selectXxxxById(xxId));
	return prefix + "/detail";
}
```

参数说明：
* `id`       需要传入到后台的唯一标识
* `width`    弹窗宽度，一个数值(不传时默认弹窗自适应显示)
* `height`   弹窗高度，一个数值(不传时默认弹窗自适应显示)

总结：`detail`方法里面进行了判断存在ID则进行内容替换，同时可以传入指定宽度高度。  
操作`table.options.detailUrl`地址，弹窗`table.options.modalName`标题


调用方式：
```javascript
// 传参调用，例如：/system/user/detail/{1} 会被替换为 /system/user/detail/1
$.operate.detail(1)

// 设置宽高
$.operate.detail(1, '770', '380');
```


## 搜索功能

对于大量的数据列表而言，我们常常需要根据条件获得我们所需要的数据源，这是条件搜索就可以帮助我们实现，正如很多模块我们所看到的那样在数据列表上方有很多的条件筛选框，
这是我们可以选择我们所需要查询的条件，然后去定向搜索，鉴于此框架也做了常规的集成。

函数主体：
```javascript
// 搜索-默认第一个form
search: function(formId, tableId) {
	table.set(tableId);
	table.options.formId = $.common.isEmpty(formId) ? $('form').attr('id') : formId;
	var params = $.common.isEmpty(tableId) ? $("#" + table.options.id).bootstrapTable('getOptions') : $("#" + tableId).bootstrapTable('getOptions');
	if($.common.isNotEmpty(tableId)){
		$("#" + tableId).bootstrapTable('refresh', params);
	} else{
		$("#" + table.options.id).bootstrapTable('refresh', params);
	}
},
```

后端代码：
```java
// 查询方法
@PostMapping("/list")
@ResponseBody
public TableDataInfo list(Xxxx xxxx)
{
	startPage();
	List<Xxxx> list = xxxxService.selectXxxxList(xxxx);
	return getDataTable(list);
}
```

参数说明：
* `formId`    查询表单ID
* `tableId`   查询表格ID

总结：默认查询第一个表单`form`以及表格`table.options.id`，`search`方法里面也进行了判断`formId`，`tableId`可以传入指定表单ID，表格ID查询。  

调用方式：
```javascript
// 普通查询调用
$.table.search()

// 查询指定表单ID
$.table.search('formId')

// 查询查询表单ID，表格ID
$.table.search('formId', 'tableId')
```


## 导入功能

对于数据量大，导入可以大大提高使用者的使用效率，鉴于此框架也做了常规的集成。

函数主体：
```javascript
// 导入数据
importExcel: function(formId, width, height) {
	table.set();
	var currentId = $.common.isEmpty(formId) ? 'importTpl' : formId;
	var _width = $.common.isEmpty(width) ? "400" : width;
	var _height = $.common.isEmpty(height) ? "230" : height;
	layer.open({
		type: 1,
		area: [_width + 'px', _height + 'px'],
		fix: false,
		//不固定
		maxmin: true,
		shade: 0.3,
		title: '导入' + table.options.modalName + '数据',
		content: $('#' + currentId).html(),
		btn: ['<i class="fa fa-check"></i> 导入', '<i class="fa fa-remove"></i> 取消'],
		// 弹层外区域关闭
		shadeClose: true,
		btn1: function(index, layero){
			var file = layero.find('#file').val();
			if (file == '' || (!$.common.endWith(file, '.xls') && !$.common.endWith(file, '.xlsx'))){
				$.modal.msgWarning("请选择后缀为 “xls”或“xlsx”的文件。");
				return false;
			}
			var index = layer.load(2, {shade: false});
			$.modal.disable();
			var formData = new FormData(layero.find('form')[0]);
			$.ajax({
				url: table.options.importUrl,
				data: formData,
				cache: false,
				contentType: false,
				processData: false,
				type: 'POST',
				success: function (result) {
					if (result.code == web_status.SUCCESS) {
						$.modal.closeAll();
						$.modal.alertSuccess(result.msg);
						$.table.refresh();
					} else if (result.code == web_status.WARNING) {
						layer.close(index);
						$.modal.enable();
						$.modal.alertWarning(result.msg)
					} else {
						layer.close(index);
						$.modal.enable();
						$.modal.alertError(result.msg);
					}
				}
			});
		}
	});
},
```

后端代码：
```java
// 导入方法
@PostMapping("/importData")
@ResponseBody
public AjaxResult importData(MultipartFile file, boolean updateSupport) throws Exception
{
	ExcelUtil<Xxxx> util = new ExcelUtil<Xxxx>(Xxxx.class);
	List<Xxxx> xxxxList = util.importExcel(file.getInputStream());
	String message = xxxxService.importXxxx(xxxxList, updateSupport);
	return AjaxResult.success(message);
}
```

参数说明：
* `formId`    显示指定表单ID元素内容
* `width`     弹窗宽度，一个数值(不传时默认弹窗400显示)
* `height`    弹窗高度，一个数值(不传时默认弹窗230显示)

总结：`importExcel`方法里面进行了判断不存在`formId`参数则使用默认的`importTpl`，同时在回调函数实现了文件上传的ajax请求。  
操作`table.options.importUrl`地址，弹窗`table.options.modalName`标题  

调用方式：
```javascript
// 普通查询调用
$.table.importExcel()

// 显示指定表单ID
$.table.importExcel('formId')

// 显示指定表单ID，同时设置宽高
$.table.importExcel('formId', '770', '380');
```


## 下载模板

对于一些情况在导入前需要下载自定义模块的情况，也做了常规的集成。

函数主体：
```javascript
// 下载模板
importTemplate: function() {
	table.set();
	$.get(table.options.importTemplateUrl, function(result) {
		if (result.code == web_status.SUCCESS) {
			window.location.href = ctx + "common/download?fileName=" + encodeURI(result.msg) + "&delete=" + true;
		} else if (result.code == web_status.WARNING) {
			$.modal.alertWarning(result.msg)
		} else {
			$.modal.alertError(result.msg);
		}
	});
},
```

后端代码：
```java
// 下载模板
@GetMapping("/importTemplate")
@ResponseBody
public AjaxResult importTemplate()
{
	ExcelUtil<Xxxx> util = new ExcelUtil<Xxxx>(Xxxx.class);
	return util.importTemplateExcel("xx数据");
}
```

总结：`importTemplate`会直接请求后端接口，生成模块成功后进行下载操作。  
操作`table.options.importTemplateUrl`地址。 


调用方式：
```javascript
$.table.importTemplate();
```
		

## 导出功能

项目中经常需要使用导入导出功能来加快数据的操作，框架实现的方式是先读取数据后上传到本地，等文件生成后，将文件传送到存储在本地磁盘（也可以改成CDN）进行存储，然后返回上传后的存储地址。
前端需要调用下载请求后再进行处理。对于高耗时的下载请求时，会有一定的优化。

函数主体：
```javascript
// 导出数据
exportExcel: function(formId) {
	table.set();
	$.modal.confirm("确定导出所有" + table.options.modalName + "吗？", function() {
		var currentId = $.common.isEmpty(formId) ? $('form').attr('id') : formId;
		var params = $("#" + table.options.id).bootstrapTable('getOptions');
		var dataParam = $("#" + currentId).serializeArray();
		dataParam.push({ "name": "orderByColumn", "value": params.sortName });
		dataParam.push({ "name": "isAsc", "value": params.sortOrder });
		$.modal.loading("正在导出数据，请稍后...");
		$.post(table.options.exportUrl, dataParam, function(result) {
			if (result.code == web_status.SUCCESS) {
				window.location.href = ctx + "common/download?fileName=" + encodeURI(result.msg) + "&delete=" + true;
			} else if (result.code == web_status.WARNING) {
				$.modal.alertWarning(result.msg)
			} else {
				$.modal.alertError(result.msg);
			}
			$.modal.closeLoading();
		});
	});
},
```

后端代码：
```java
// 导出数据
@PostMapping("/export")
@ResponseBody
public AjaxResult export(Xxxx xxxx)
{
	List<Xxxx> list = xxxxService.selectXxxxList(xxxx);
	ExcelUtil<Xxxx> util = new ExcelUtil<Xxxx>(Xxxx.class);
	return util.exportExcel(list, "xx数据");
}
```

参数说明：
* `formId`    显示指定表单ID元素内容

总结：`exportExcel`默认导出参数为第一个表单`form`，同时也可以传入指定`formId`。  
操作`table.options.exportUrl`地址，弹窗`table.options.modalName`标题  

调用方式：
```javascript
// 普通查询调用
$.table.exportExcel()

// 导出指定表单参数
$.table.exportExcel('formId')
```

## 提交功能

提交功能我们并不陌生，在新增和修改页面中，都会有提交按钮的出现，顾名思义就是提交这条数据到后台处理。

函数主体：
```javascript
// 提交数据
save: function(url, data, callback) {
	var config = {
		url: url,
		type: "post",
		dataType: "json",
		data: data,
		beforeSend: function () {
			$.modal.loading("正在处理中，请稍后...");
			$.modal.disable();
		},
		success: function(result) {
			if (typeof callback == "function") {
				callback(result);
			}
			$.operate.successCallback(result);
		}
	};
	$.ajax(config)
},
```

后端代码：
```java
// 新增提交
@PostMapping("/add")
@ResponseBody
public AjaxResult addSave(@Validated Xxxx xxxx)
{
	return toAjax(xxxxService.insertXxxx(xxxx));
}

// 修改提交
@PostMapping("/edit")
@ResponseBody
public AjaxResult editSave(@Validated Xxxx xxxx)
{
	return toAjax(xxxxService.updateXxxx(xxxx));
}
```

参数说明：
* `url`         提交的后台地址
* `data`        提交到后台的数据
* `callback`    回调函数，提交成功之后会默认进行回调

调用方式：
```javascript
// 普通调用
$.operate.save(prefix + "/add",  $('#form-xxxx').serialize());

// 提交设置回调函数
$.operate.save(prefix + "/add",  $('#form-xxxx').serialize(), function(result) {
    // 状态码
	console.log(result.code);
	// 消息内容
    console.log(result.msg);
});
```
