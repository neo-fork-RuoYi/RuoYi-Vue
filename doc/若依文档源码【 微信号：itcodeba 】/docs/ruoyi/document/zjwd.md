# 组件文档

## bootstrap-datetimepicker

* 基于`bootstrap`的一款时间插件[bootstrap-datetimepicker](https://github.com/smalot/bootstrap-datetimepicker)，已经做了汉化处理。

代码演示参考 若依系统 → 实例演示 → 表单元素 → 日期与时间 `form/datetime.html`（项目使用需要引入css和js）  

1、<th:block th:include="include :: datetimepicker-css" />  
2、<th:block th:include="include :: datetimepicker-js" />  

| 属性                 | 默认值         | 描述                                                    | 备注                                                         | 
| -------------------- |--------------- | ------------------------------------------------------- |------------------------------------------------------------- | 
| format               | mm/dd/yyyy     | 日期格式                                                | 任意时间日期格式组合搭配，满足不同需求 yyyy mm dd hh ii ss   |
| weekStart            | 0              | 一周从哪一天开始                                        | 0（星期日）到6（星期六）                                     |
| startDate            | 无             | 开始时间                                                | 可以选择的最早日期，将禁用所有较早日期                       |
| endDate              | 无             | 结束时间                                                | 可以选择的最晚日期，所有较迟的日期都将被禁用                 |
| daysOfWeekDisabled   | []             | 每周禁用一天                                            |                                                              |
| autoclose            | false          | 当选择一个日期之后是否立即关闭此日期时间选择器。        |                                                              |
| startView            | 2              | 日期时间选择器打开之后首先显示的视图                    | 0 小时  1 天  2 月  3 年  4 十年                             |
| minView              | 0              | 日期时间选择器所能够提供的最精确的时间选择视图          | 0 小时  1 天  2 月  3 年  4 十年                             |
| maxView              | 4              | 日期时间选择器最高能展示的选择范围视图                  | 0 小时  1 天  2 月  3 年  4 十年                             |
| todayBtn             | false          | 是否显示当前日期（今天）按钮                            |                                                              |
| todayHighlight       | false          | 是否高亮当前日期                                        |                                                              |
| keyboardNavigation   | true           | 是否启用键盘方向键选择改变日期                          |                                                              |
| language             | en             | 语言                                                    | zh-cn 中文  en 英文                                          |
| forceParse           | true           | 强制解析                                                | 当选择器关闭的时候，是否强制解析输入框中的值                 |
| minuteStep           | 5              | 分钟选择视图，每5分钟一个间隔选择                       | 只有minView设置 支持分钟，才能看到                           |
| pickerReferer        | default        |                                                         | 没有特殊要求，无序设置                                       |
| pickerPosition       | bottom-right   | 时间选择器窗口的位置                                    | bottom-left左下 bottom-right右下 top-left左上 top-right左下  |
| viewSelect           | 取minView的值  | 视图选择                                                | decade  year  month  day  hour                               |
| showMeridian         | false          | 是否为日视图和小时视图启用子午线视图                    |                                                              |
| initialDate          | new Date()     | 初始日期。                                              | 默认是现在，您可以指定昨天或今天……                           |


## laydate

* 基于`layui`的一款时间插件[laydate](https://www.layui.com/laydate)
 
代码演示参考 若依系统 → 实例演示 → 表单元素 → 日期与时间 `form/datetime.html`  

| 属性                 | 默认值         | 描述                                                    | 备注                                                                                       | 
| -------------------- |--------------- | ------------------------------------------------------- |------------------------------------------------------------------------------------------- | 
| elem                 | 无             | 绑定元素                                                | 必填项，用于绑定执行日期渲染的元素，值一般为选择器，或DOM对象                              |
| type                 | date           | 控件选择类型                                            | 用于单独提供不同的选择器类型 year年 month年月 date年月日 time时分秒 datetime年月日时分秒   |
| range                | false          | 开启左右面板范围选择                                    | 如果设置 true，将默认采用 “ - ” 分割。 你也可以直接设置 分割字符 range: '~'                |
| format               | yyyy-MM-dd     | 自定义格式                                              | 通过日期时间各自的格式符和长度，来设定一个你所需要的日期格式                               |
| value                | new Date()     | 初始值                                                  | 支持传入符合format参数设定的日期格式字符，或者 new Date()                                  |
| isInitValue          | true           | 初始值填充                                              | 用于控制是否自动向元素填充初始值（需配合 value 参数使用）                                  |
| min                  | 1900-1-1       | 最小范围内的日期时间值                                  | 设定最小日期或时间值，不在范围内的将不可选中                                               |
| max                  | 2099-12-31     | 最大范围内的日期时间值                                  | 设定最大日期或时间值，不在范围内的将不可选中                                               |
| trigger              | focus          | 自定义弹出控件的事件                                    | 如果绑定的元素非输入框，则默认事件为：click                                                |
| show                 | false          | 默认显示                                                | 则控件默认显示在绑定元素的区域。通常用于外部事件调用控件                                   |
| position             | absolute       | 定位方式                                                | 用于设定控件的定位方式，有以下三种可选值 abolute绝对定位 fixed固定定位 static静态定位      |
| zIndex               | 66666666       | 层叠顺序                                                | 一般用于解决与其它元素的互相被遮掩的问题。如果 position 参数设为 static 时，该参数无效     |
| showBottom           | true           | 是否显示底部栏                                          | 如果设置 false，将不会显示控件的底部栏区域                                                 |
| btns                 | ['clear', 'now', 'confirm'] | 工具按钮                                   | 右下角显示的按钮，会按照数组顺序排列，内置可识别的值有：clear、now、confirm                |
| lang                 | cn             | 语言                                                    | 两种语言版本：cn（中文版）、en（国际版，即英文版）                                         |
| theme                | default        | 主题                                                    | 内置了多种主题，theme的可选值有：default（默认简约）、molv（墨绿背景）、#颜色值（自定义颜色背景）、grid（格子主题）  |
| calendar             | false          | 是否显示公历节日                                        | 内置了一些我国通用的公历重要节日，通过设置 true 来开启。国际版不会显示。                                             |
| mark                 | 无             | 标注重要日子                                            | calendar 参数所代表的公历节日更多情况下是一个摆设。因此，我们还需要自定义标注重要日子，比如结婚纪念日 日程等         |


## layer

[layer](https://layer.layui.com)是一款web弹层组
 
代码演示参考 若依系统 → 实例演示 → 表单元素 → 日期与时间 `modal/layer.html`   

| 属性                 | 默认值         | 描述                          | 备注                                                                                                                                                                                                                                           | 
| -------------------- |--------------- | ----------------------------- |----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | 
| type                 | 0              | 基本层类型                    | layer提供了5种层类型。可传入的值有：0（信息框，默认）1（页面层）2（iframe层）3（加载层）4（tips层）。 若你采用layer.open({type: 1})方式调用，则type为必填项（信息框除外）                                                                      |
| title                | '信息'         | 标题                          | title支持三种类型的值，若你传入的是普通的字符串，那么只会改变标题文本；若你还需要自定义标题区域样式，那么你可以title: ['文本', 'font-size:18px;']，如果你不想显示标题栏，你可以title: false                                                    |
| content              | ''             | 内容                          | content可传入的值是灵活多变的，不仅可以传入普通的html内容，还可以指定DOM，更可以随着type的不同而不同。                                                                                                                                         |
| skin                 | ''             | 样式类名                      | skin不仅允许你传入layer内置的样式class名，还可以传入您自定义的class名。意味着你可以借助skin轻松完成不同的风格定制。目前layer内置的skin有：layui-layer-lan layui-layer-molv                                                                     |
| area                 | 'auto'         | 宽高                          | 在默认状态下，layer是宽高都自适应的，但当你只想定义宽度时，你可以area: '500px'，高度仍然是自适应的。当你宽高都要定义时，你可以area: ['500px', '300px']                                                                                         |
| offset               | 垂直水平居中   | 坐标                          | offset默认情况下不用设置。但如果你不想垂直水平居中 offset: ['100px', '50px']同时定义top、left坐标                                                                                                                                              |
| icon                 | -1（信息框）   | 图标                          | 息框默认不显示图标。当你想显示图标时，默认皮肤可以传入0-6如果是加载层，可以传入0-2                                                                                                                                                             |
| btn                  | '确认'         | 按钮                          | 信息框模式时，btn默认是一个确认按钮，其它层类型则默认不显示，加载层和tips层则无效。当您只想自定义一个按钮时，你可以btn: '我知道了'，当你要定义两个按钮时，你可以btn: ['yes', 'no']。                                                           |
| btnAlign             | r              | 按钮排列                      | 你可以快捷定义按钮的排列位置，btnAlign的默认值为r，即右对齐。btnAlign: 'l'	按钮左对齐 btnAlign: 'c'	按钮居中对齐 btnAlign: 'r'	按钮右对齐。默认值，不用设置                                                                             |
| closeBtn             | 1              | 关闭按钮                      | layer提供了两种风格的关闭按钮，可通过配置1和2来展示，如果不显示，则closeBtn: 0                                                                                                                                                                 |
| shade                | 0.3            | 遮罩                          | 即弹层外区域。默认是0.3透明度的黑色背景（'#000'）。如果你想定义别的颜色，可以shade: [0.8, '#393D49']；如果你不想显示遮罩，可以shade: 0                                                                                                         |
| shadeClose           | false          | 是否点击遮罩关闭              | 如果你的shade是存在的，那么你可以设定shadeClose来控制点击弹层外区域关闭。                                                                                                                                                                      |
| time                 | 0              | 自动关闭所需毫秒              | 默认不会自动关闭。当你想自动关闭时，可以time: 5000，即代表5秒后自动关闭，注意单位是毫秒（1秒=1000毫秒）                                                                                                                                        |
| id                   | ''             | 用于控制弹层唯一标识          | 设置该值后，不管是什么类型的层，都只允许同时弹出一个。一般用于页面层和iframe层模式                                                                                                                                                             |
| anim                 | 0              | 弹出动画                      | 目前anim可支持的动画类型有0-6 如果不想显示动画，设置 anim: -1 即可。（0平滑放大）（1从上掉落） （2从最底部往上滑入）（3从左滑入）（4从左翻滚） （5渐显）（6抖动）                                                                              |
| isOutAnim            | true           | 关闭动画                      | 默认情况下，关闭层时会有一个过度动画。如果你不想开启，设置 isOutAnim: false 即可                                                                                                                                                               |
| maxmin               | false          | 最大最小化                    | 该参数值对type:1和type:2有效。默认不显示最大小化按钮。需要显示配置maxmin: true即可                                                                                                                                                             |
| fixed                | true           | 固定                          | 即鼠标滚动时，层是否固定在可视区域。如果不想，设置fixed: false即可                                                                                                                                                                             |
| resize               | true           | 是否允许拉伸                  | 默认情况下，你可以在弹层右下角拖动来拉伸尺寸。如果对指定的弹层屏蔽该功能，设置 false即可。该参数对loading、tips层无效                                                                                                                          |
| resizing             | null           | 监听窗口拉伸动作              | 当你拖拽弹层右下角对窗体进行尺寸调整时，如果你设定了该回调，则会执行。回调返回一个参数：当前层的DOM对象                                                                                                                                        |
| scrollbar            | true           | 是否允许浏览器出现滚动条      | 默认允许浏览器滚动，如果设定scrollbar: false，则屏蔽                                                                                                                                                                                           |
| maxWidth             | 360            | 最大宽度                      | 请注意：只有当area: 'auto'时，maxWidth的设定才有效。                                                                                                                                                                                           |
| maxHeight            | 无             | 最大高度                      | 请注意：只有当高度自适应时，maxHeight的设定才有效。                                                                                                                                                                                            |
| zIndex               | 19891014       | 层叠顺序                      | 一般用于解决和其它组件的层叠冲突。                                                                                                                                                                                                             |
| move                 | '.layui-layer-title' | 触发拖动的元素          | 默认是触发标题区域拖拽。如果你想单独定义，指向元素的选择器或者DOM即可。如move: '.mine-move'。你还配置设定move: false来禁止拖拽                                                                                                                 |
| moveOut              | false          | 是否允许拖拽到窗口外          | 默认只能在窗口内拖拽，如果你想让拖到窗外，那么设定moveOut: true即可                                                                                                                                                                            |
| moveEnd              | null           | 拖动完毕后的回调方法          | 默认不会触发moveEnd，如果你需要，设定moveEnd: function(layero){}即可。其中layero为当前层的DOM对象                                                                                                                                              |
| tips                 | 2              | 方向和颜色                    | tips层的私有参数。支持上右下左四个方向，通过1-4进行方向设定。如tips: 3则表示在元素的下面出现。有时你还可能会定义一些颜色，可以设定tips: [1, '#c00']                                                                                            |
| tipsMore             | false          | 是否允许多个tips              | 允许多个意味着不会销毁之前的tips层。通过tipsMore: true开启                                                                                                                                                                                     |
| success              | null           | 层弹出后的成功回调方法        | 当你需要在层创建完毕时即执行一些语句，可以通过该回调。success会携带两个参数，分别是当前层DOM当前层索引。                                                                                                                                       |
| yes                  | null           | 确定按钮回调方法              | 该回调携带两个参数，分别为当前层索引、当前层DOM对象。                                                                                                                                                                                          |
| cancel               | null           | 右上角关闭按钮触发的回调      | 该回调携带两个参数，分别为：当前层索引参数（index）、当前层的DOM对象（layero），默认会自动触发关闭。如果不想关闭，return false即可                                                                                                             |
| end                  | null           | 层销毁后触发的回调            | 无论是确认还是取消，只要层被销毁了，end都会执行，不携带任何参数。                                                                                                                                                                              |
| full                 | null           | 最大化                        | 最大化触发的回调                                                                                                                                                                                                                               |
| min                  | null           | 最小化                        | 最小化触发的回调                                                                                                                                                                                                                               |
| restore              | null           | 还原后                        | 还原后触发的回调                                                                                                                                                                                                                               |

内置方法。

| 名称                                         | 描述                    | 备注                                                                                                                                                                                                            |
| -------------------------------------------- |------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| layer.ready(callback)                        | 初始化就绪              | 由于我们的layer内置了轻量级加载器，所以你根本不需要单独引入css等文件。但是加载总是需要过程的。当你在页面一打开就要执行弹层时，你最好是将弹层放入ready方法中                                                     |
| layer.open(options)                          | 原始核心方法            | 基本上是露脸率最高的方法，不管是使用哪种方式创建层，都是走layer.open()，创建任何类型的弹层都会返回一个当前层索引，上述的options即是基础参数                                                                     |
| layer.alert(content, options, yes)           | 普通信息框              | 它的弹出似乎显得有些高调，一般用于对用户造成比较强烈的关注，类似系统alert，但却比alert更灵便。它的参数是自动向左补齐的。通过第二个参数，可以设定各种你所需要的基础参数，但如果你不需要的话，直接写回调即可。    |
| layer.confirm(content, options, yes, cancel) | 询问框                  | 请求远程校验。url 类似系统confirm，但却远胜confirm，另外它不是和系统的confirm一样阻塞你需要把交互的语句放在回调体中。同样的，它的参数也是自动补齐的。                                                           |
| layer.msg(content, options, end)             | 提示框                  | 消息提示                                                                                                                                                                                                        |
| layer.load(icon, options)                    | 加载层                  | type:3的深度定制。load并不需要你传太多的参数，但如果你不喜欢默认的加载风格，你还有选择空间。icon支持传入0-2如果是0，无需传。另外特别注意一点：load默认是不会自动关闭的，因为你一般会在ajax回调体中关闭它。      |
| layer.tips(content, follow, options)         | tips层                  | type:4的深度定制。也是我本人比较喜欢的一个层类型，因为它拥有和msg一样的低调和自觉，而且会智能定位，即灵活地判断它应该出现在哪边。默认是在元素右边弹出                                                           |
| layer.close(index)                           | 关闭特定层              | 关于它似乎没有太多介绍的必要，唯一让你疑惑的，可能就是这个index了吧。事实上它非常容易得到。                                                                                                                     |
| layer.closeAll(type)                         | 关闭所有层              | 如果你很懒，你不想去获取index你只想关闭。那么closeAll真的可以帮上你。如果你不指向层类型的话，它会销毁掉当前页所有的layer层。                                                                                    |
| layer.style(index, cssStyle)                 | 重新定义层的样式        | 该方法对loading层和tips层无效。参数index为层的索引，cssStyle允许你传入任意的css属性                                                                                                                             |
| layer.title(title, index)                    | 改变层的标题            | 使用方式：layer.title('标题变了', index)                                                                                                                                                                        |
| layer.getChildFrame(selector, index)         | 获取iframe页的DOM       | 当你试图在当前页获取iframe页的DOM元素时，你可以用此方法。selector即iframe页的选择器                                                                                                                             |
| layer.getFrameIndex(windowName)              | 获取特定iframe层的索引  | 此方法一般用于在iframe页关闭自身时用到。                                                                                                                                                                        |
| layer.iframeAuto(index)                      | 指定iframe层自适应      | 调用该方法时，iframe层的高度会重新进行适应                                                                                                                                                                      |
| layer.iframeSrc(index, url)                  | 重置特定iframe url      | 似乎不怎么常用的样子。使用方式：layer.iframeSrc(index, 'http://ruoyi.vip')                                                                                                                                    |
| layer.setTop(layero)                         | 置顶当前窗口            | 非常强大的一个方法，虽然一般很少用。但是当你的页面有很多很多layer窗口，你需要像Window窗体那样，点击某个窗口，该窗体就置顶在上面，那么setTop可以来轻松实现。它采用巧妙的逻辑，以使这种置顶的性能达到最优         |
| layer.full()                                 | 最大化                  | 一般用于在自定义元素上触发最大化。                                                                                                                                                                              |
| layer.min()                                  | 最小化                  | 一般用于在自定义元素上触发最大小。                                                                                                                                                                              |
| layer.restore()                              | 还原后                  | 一般用于在自定义元素上触发还原后。                                                                                                                                                                              |
| layer.prompt(options, yes)                   | 输入层                  | prompt的参数也是向前补齐的。options不仅可支持传入基础参数，还可以传入prompt专用的属性。当然，也可以不传。yes携带value 表单值index 索引elem 表单元素                                                             |
| layer.tab(options)                           | tab层                   | tab层只单独定制了一个成员，即tab: []，                                                                                                                                                                          |
| layer.photos(options)                        | 相册层                  | 相册层，也可以称之为图片查看器。它的出场动画从layer内置的动画类型中随机展现。photos支持传入json和直接读取页面图片两种方式。                                                                                     |


## bootstrap-select

* 基于`bootstrap`的一款下拉框插件[bootstrap-select](https://github.com/snapappointments/bootstrap-select)

代码演示参考 若依系统 → 实例演示 → 表单元素 → 下拉框 `form/select.html`（项目使用需要引入css和js）  

1、<th:block th:include="include :: bootstrap-select-css" />  
2、<th:block th:include="include :: bootstrap-select-js" />  

| 属性                  | 类型           | 默认值                | 描述                                                           | 
| --------------------- |--------------- | --------------------- |--------------------------------------------------------------- | 
| actionsBox            | bool           | false                 | 当设置为true，增加了两个按钮，下拉菜单的顶部（全选和取消全选） |
| container             | string         | false                 | 当设置为一个字符string，追加选择一个特定的元素或选择器，例如 container: 'body' | '.main-body' |
| countSelectedText     | string         | function              | 设置当selectedTextFormat是显示文本的格式count或count > #。{0} 是所选择的量。{1}是用于选择的总可用。当设定为一个函数，第一个参数是所选择的选项的数目，并且第二个是选项的总数。该函数必须返回一个字符string |
| deselectAllText       | string         | 'Deselect All'        | 当取消选择所有选项按钮上的文本actionsBox被启用                 |
| dropdownAlignRight    | bool 'auto'    | false                 | 对齐菜单，而不是左右。如果设置为'auto'，如果在左对齐没有余地菜单的全宽度的菜单会自动右对齐 |
| dropupAuto            | bool           | true                  | 进行检查以查看其具有更多的空间，上方或下方。如果dropup有足够的空间完全打开正常，但上面有更大的空间，在dropup仍能正常打开。否则，就变成了dropup。如果dropupAuto设置为false，dropups必须手动调用 |
| header                | string         | false                 | 增加了菜单的顶部的头部; 默认包含关闭按钮                       |
| hideDisabled          | bool           | false                 | 从菜单中删除禁用的选项和optgroups data-hide-disabled: true     |
| iconBase              | string         | 'glyphicon'           | 将基地使用不同的图标字体代替Glyphicons。如果改变iconBase，你也可能要更改tickIcon，以防新的图标字体使用了不同的命名方案 |
| liveSearch            | bool           | false                 | 当设置为true，增加了一个搜索框的下拉selectpicker的顶部         |
| liveSearchNormalize   | bool           | false                 | 设置liveSearchNormalize以true允许不区分重音的搜索              |
| liveSearchPlaceholder | string         | null                  | 当设置为一个字符string，一个占位符属性等于该字符string将被添加到实况搜索输入 |
| liveSearchStyle       | string         | 'contains'            | 当设置为'contains'，搜索将显示包含搜索到的文本选项。例如，搜索，返回鸭都为PL PL E，PL嗯，和PL antain。当设置为'startsWith'，寻找PL只会返回PL UM和PL antain |
| maxOptions            | integer        | false                 | 当设置为一个integer ，并在多选择，所选选项的数量不能超过给定值。该选项还可以存在作为数据属性为optgroup，在这种情况下，它仅适用于optgroup |
| maxOptionsText        | string         | function              | 启用maxOptions时所显示的文本，并为给定的方案选项的最大数量已被选定。如果使用的功能，它必须返回一个数组。阵列[0]是当maxOptions被施加到整个选择元件使用的文本。阵列[1]是当maxOptions上的OPTGROUP用于使用的文本。如果使用字符string，相同的文字用于元素和OPTGROUP两者 |
| mobile                | bool           |  false                | 当设置为true，使能选择菜单中的设备的本机菜单                   |
| multipleSeparator     | string         | ', '                  | 坐落在分隔所选选项的按钮显示的字符                             |
| noneSelectedText      | string         | 'Nothing selected'    | 当多个选择时所显示的文本没有选择的选择                         |
| selectAllText         | string         | 'Select All'          | 当选择了所有选项，按钮上的文本actionsBox被启用                 |
| selectedTextFormat    | 'values' 'static' 'count'  | 'values'  | 指定选择如何显示有多个选择。'values'显示所选择的选项（由分隔的列表multipleSeparator。'static'简单地显示所述选择元件的标题。'count'显示所选选项的总数量。'count > x'行为类似于'values'直到所选选项的数目大于x;在此之后，它的行为象'count' |
| selectOnTab           | bool           | false                 | 当设置为true，对待像selectpicker下拉列表中输入或空格字符制表符 |
| showContent           | bool           | true                  | 当设置为true，显示与该按钮选择的选项（一个或多个）相关联的自定义的HTML。当设置为false，期权价值将被显示 |
| showIcon              | bool           | true                  | 当设置为true，与在按钮选择的选项（一个或多个）相关联的显示的图标（一个或多个） |
| showSubtext           | bool           | false                 | 当设置为true与所述按钮选择的选项相关联，显示潜台词             |
| showTick              | bool           | false                 | show（没有的项目上选择的选项勾选multiple属性）                 |
| size                  | 'auto' integer false | 'auto'          | 当设置为'auto'，菜单始终打开，以显示尽可能多的项目窗口将允许在没有被切断。当设置为integer 时，菜单将显示项目的给定数量，即使下拉被切断。当设置为false，菜单会一直显示所有项目 |
| style                 | string null    | null                  | 当设置为一个字符string，添加值到该按钮的风格                   |
| tickIcon              | string null    | 'glyphicon-ok'        | 设置要使用的图标旁边显示的“滴答”来选择的选项                   |
| title                 | string| null   | null                  | 对于selectpicker的默认标题                                     |
| width                 | 'auto' 'fit' css-width false | false   | 当设置为auto，所述selectpicker的宽度被自动调节，以适应最宽的选项。当设置为一个css-宽度，所述selectpicker的宽度内联强制为给定值。当设置为false，所有宽度信息被删除 |
| windowPadding         | integer array  | 0                     | 这是在该窗口中有一个下拉菜单中不应该涉及的领域情况下非常有用-例如一个固定的头。当设置为一个integer ，同样填充将被添加到四面八方。可替代地，一个integer 数组可以在格式来使用[top, right, bottom, left] |

```javascript
// selectpicker 常用方法
$('#id').selectpicker('val');                      // 取值
$('#id').selectpicker('val', 'RuoYi');             // 单个赋值
$('#id').selectpicker('val', ['Admin','RuoYi']);   // 多选赋值
$('#id').selectpicker('selectAll');                // 全选
$('#id').selectpicker('deselectAll');              // 反选
$('#id').selectpicker('render');                   // 渲染
$('#id').selectpicker('refresh');                  // 刷新
$('#id').prop('disabled', true);                   // 禁用
$('#id').prop('disabled', false);                  // 启用
$('#id').selectpicker('toggle');                   // 切换
$('#id').selectpicker('hide');                     // 隐藏
$('#id').selectpicker('show');                     // 显示
$('#id').selectpicker('destroy');                  // 销毁
$('#id').selectpicker('mobile');                   // 适应手机模式
<!--  事件监听
show.bs.select
shown.bs.select
hide.bs.select
hidden.bs.select
loaded.bs.select
rendered.bs.select
refreshed.bs.select
changed.bs.select
-->
$('#id').on('changed.bs.select', function (e, clickedIndex, isSelected, previousValue) {
  // 处理自己的业务
});
```


## select2

* 基于`jquery`的一款下拉框插件[select2](https://github.com/select2/select2)
  
代码演示参考 若依系统 → 实例演示 → 表单元素 → 下拉框 `form/select.html`（项目使用需要引入css和js）  

1、<th:block th:include="include :: select2-css" />  
2、<th:block th:include="include :: select2-js" />  

| 属性                    | 类型           | 默认值          | 描述                                                                   | 
| ----------------------- |--------------- | --------------- |----------------------------------------------------------------------- | 
| data                    | Array          | Null            | 数据集合，基础数据格式{id:"", text:"", selected: true, disabled: true} |
| width                   | string         | 空              | 宽度                                                                   |
| style                   | string         | 空              | 样式                                                                   |
| ajax                    | object         | null            | Ajax请求数据                                                           |
| minimumResultsForSearch | Integer        | null            | 设置支持搜索的最小集合，设置为负数，隐藏搜索框                         |
| minimumInputLength      | Integer        | 空              | 输入指定长度字符后开始搜索                                             |
| multiple                | boolean        | false           | 是否多选，默认单选                                                     |
| maximumSelectionLength  | Integer        | 空              | 支持最大的选择数量，int/function                                       |
| maximumInputLength      | Integer        | 空              | 支持搜索的最大字符数                                                   |
| placeholder             | String         | 空              | 选择提示                                                               |
| allowClear              | Boolean        | false           | 是否显示清除按钮，只有设置了placeholder才有效                          |
| closeOnSelect           | Boolean        | true            | 是否选中后关闭选择框，默认true                                         |
| templateSelection       | callback       | 空              | 选中项样式                                                             |
| templateResult          | callback       | 空              | 选项样式                                                               |
| matcher                 | callback       | 空              | 过滤选项集合                                                           |
| sorter                  | callback       | 空              | 选项结果集排序                                                         |
| theme                   | String         | 空              | 主题，可以设置bootstrap主题                                            |
| tags                    | Boolean        | 空              | 是否可动态创建选项                                                     |
| tokenSeparators         | Array          | 空              | 输入时使用分隔符创建新选项                                             |
| createTag               | callback       | 空              | 创建新标签                                                             |
| insertTag               | callback       | 空              | 在选项集合后插入标签                                                   |
| disabled                | boolean        | false           | 是否失效                                                               |
| debug                   | boolean        | false           | 是否开启debug                                                          |

```javascript
// select2 常用方法
$('#id').select2('val');                            // 取值
$("#id").select2("val", ["RuoYi"]);                 // 单个赋值
$("#id").val(["RuoYi"]).trigger("change");          // 单个赋值
$('#id').val(['Admin', 'RuoYi']).trigger("change"); // 多个赋值
$("#id").select2("open");                           // 打开下拉框
$("#id").select2("close");                          // 关闭下拉框
$('#id').prop('disabled', true);                    // 禁用
$('#id').prop('disabled', false);                   // 启用
$('#id').select2('destroy');                        // 销毁
<!--  事件监听
change 
change.select2
select2:closing 
select2:close 
select2:opening 
select2:open
select2:selecting 
select2:select 
select2:unselecting 
select2:unselect
-->
$('#id').on('select2:select', function (e) {
  // 处理自己的业务
});
```


## icheck

* 基于`jquery`的一款表单复选框、单选框美化插件[icheck](https://github.com/dargullin/icheck)，要重新定义触发事件

| 事件名称      | 使用时机                                      |
| ------------- | --------------------------------------------- |
| ifClicked     | 用户点击了自定义的输入框或与其相关联的        |
| ifChanged     | 输入框的 checked 或 disabled 状态改变了       |
| ifChecked     | 输入框的状态变为 checked                      |
| ifUnchecked   | checked 状态被移除                            |
| ifDisabled    | 输入框状态变为 disabled                       |
| ifEnabled     | disabled 状态被移除                           |
| ifCreated     | 输入框被应用了 iCheck 样式                    |
| ifDestroyed   | iCheck 样式被移除                             |

常用方法
```javascript
$('input').iCheck('check');    // 将选框选中
$('input').iCheck('uncheck');  // 将选框取消选中
$('input').iCheck('toggle');   // 将选框的状态反向切换
$('input').iCheck('disable');  // 将选框禁用
$('input').iCheck('enable');   // 将选框取消禁用
$('input').iCheck('update');   // apply input changes, which were done outside the plugin
$('input').iCheck('destroy');  // 移除iCheck样式
```

使用案例
```javascript
// ifChanged 触发时机：选框状态改变时触发
$('input').on('ifChanged', function(obj){
    console.log($(this).val());              // 获取该复选框的value值
    console.log(obj.currentTarget.checked)   // 获取该复选框当前状态是否选中
    console.log('您更改了复选框的状态');
})

// ifChecked 触发时机：选框选中时触发
$('input').on('ifChecked', function(obj){
    console.log($(this).val());              // 获取该复选框的value值
    console.log('您选中了复选框');
})


// ifUnchecked触发时机：选框取消选中时触发
$('input').on('ifUnchecked', function(obj){
    console.log($(this).val());              // 获取该复选框的value值
    console.log('您取消选中了复选框');
})

// 提交时获取选中选框的值
var roleIds = $.form.selectCheckeds("role");
var postIds = $.form.selectSelects("post");
```


## jasny-bootstrap

* 基于`bootstrap`的功能扩展插件（含文件上传）[jasny](https://github.com/jasny/bootstrap)
  
代码演示参考 若依系统 → 实例演示 → 表单元素 → 功能扩展 `form/jasny.html`（项目使用需要引入css和js）  

1、<th:block th:include="include :: jasny-bootstrap-css" />  
2、<th:block th:include="include :: jasny-bootstrap-js" />  

| 属性                    | 类型           | 默认值          | 描述                    | 
| ----------------------- |--------------- | --------------- |------------------------ | 
| name                    | string         | 当前元素        | 使用指定元素设置        |

```javascript
$('#id').fileinput(options)     // 初始
$('#id').fileinput('clear')     // 清除
$('#id').fileinput('reset')     // 重置

<!--  事件监听
change.bs.fileinput 
clear.bs.fileinput
reset.bs.fileinput 
-->
$('#id').on('change.bs.fileinput ', function (e) {
  // 处理自己的业务
});
```


## bootstrap-fileinput

* 基于`bootstrap`的文件上传插件[bootstrap-fileinput](https://github.com/kartik-v/bootstrap-fileinput)
  
代码演示参考 若依系统 → 实例演示 → 表单元素 → 文件上传 `form/upload.html`（项目使用需要引入css和js）  

1、<th:block th:include="include :: bootstrap-fileinput-css" />  
2、<th:block th:include="include :: bootstrap-fileinput-js" />  



| 属性                      | 类型           | 默认值              | 描述                                                                                                      | 
| ------------------------- |--------------- | ------------------- |---------------------------------------------------------------------------------------------------------- | 
| language                  | String         | 'en'                | 多语言设置，使用时需提前引入locales文件夹下对应的语言文件，中文zh，引入语言文件必须放在fileinput.js之后   |
| showCaption               | Boolean        | true                | 是否显示被选文件的简介                                                                                    |
| showBrowse                | Boolean        | true                | 是否显示浏览按钮                                                                                          |
| showPreview               | Boolean        | true                | 是否显示预览区域                                                                                          |
| showRemove                | Boolean        | true                | 是否显示移除按钮                                                                                          |
| showUpload                | Boolean        | true                | 是否显示上传按钮                                                                                          |
| showCancel                | Boolean        | true                | 是否显示取消按钮                                                                                          |
| showClose                 | Boolean        | true                | 是否显示关闭按钮                                                                                          |
| showUploadedThumbs        | Boolean        | true                | 这个属性是基于这样一个使用方法的：选择若干个文件后点击右下角上传按钮批量上传，待全部完成后再选择一批文件，此时之前上传成功的文件是否要保存。就是这个属性控制的。注意，点击文件缩略图下面的上传按钮不会导致之前的成功上传的文件消失，即使这里设置了true   |
| browseOnZoneClick         | Boolean        | false               |                                                                                                           |
| autoReplace               | Boolean        | false               | 是否自动替换当前图片，设置为true时，再次选择文件， 会将当前的文件替换掉。                                 |
| generateFileId            | Object         | null                |                                                                                                           |
| previewClass              | String         | 空                  | 添加预览按钮的类属性                                                                                      |
| captionClass              | String         | 空                  | 添加标题类属性                                                                                            |
| frameClass                | String         | 'krajee-default'    | 针对每个缩略图的框架                                                                                      |
| mainClass                 | String         | 'file-caption-main' | 针对元素类属性                                                                                            |
| mainTemplate              | Object         | null                |                                                                                                           |
| purifyHtml                | Boolean        | true                |                                                                                                           |
| fileSizeGetter            | Object         | null                |                                                                                                           |
| initialCaption            | String         | 空                  |                                                                                                           |
| initialPreview            | Array/Object   | []                  | 通过这个参数，我们可以为文件区设置一些默认的缩略图                                                        |
| initialPreviewDelimiter   | String         | '$$'                |                                                                                                           |
| initialPreviewAsData      | Boolean        | false               |                                                                                                           |
| initialPreviewFileType    | String         | 'image'             |                                                                                                           |
| initialPreviewConfig      | Array/Object   | []                  |                                                                                                           |
| initialPreviewThumbTags   | Array/Object   | []                  |                                                                                                           |
| previewThumbTags          | Object         | {}                  |                                                                                                           |
| initialPreviewShowDelete  | Boolean        | true                |                                                                                                           |
| removeFromPreviewOnError  | Boolean        | false               |                                                                                                           |
| deleteUrl                 | String         | 空                  | 删除图片时的请求路径                                                                                      |
| deleteExtraData           | Object         | {}                  | 删除图片时额外传入的参数                                                                                  |
| overwriteInitial          | Boolean        | true                |                                                                                                           |
| previewZoomButtonIcons    | Object         | {prev: '',next: '',toggleheader: '',fullscreen: '',borderless: '',close: ''}, |                                                 |
| previewZoomButtonClasses  | Object         | {prev: 'btn btn-navigate',next: 'btn btn-navigate',toggleheader: 'btn btn-default btn-header-toggle',fullscreen: 'btn btn-default',borderless: 'btn btn-default',close: 'btn btn-default'}, |  |
| preferIconicPreview       | Boolean        | false               |                                                                                                           |
| preferIconicZoomPreview   | Boolean        | false               |                                                                                                           |
| allowedPreviewTypes       | undefined      | undefined           |                                                                                                           |
| allowedPreviewMimeTypes   | Object         | null                |                                                                                                           |
| allowedFileTypes          | Object         | null                | 接收的文件后缀，如['jpg', 'gif', 'png'],不填将不限制上传文件后缀类型                                      |
| allowedFileExtensions     | Object         | null                | 指出带有哪些后缀名的文件才是被接受上传的，设置msgInvalidFileExtension可以个性化出现此错误时的错误信息     |
| defaultPreviewContent     | Object         | null                |                                                                                                           |
| customLayoutTags          | Object         | {}                  |                                                                                                           |
| customPreviewTags         | Object         | {}                  |                                                                                                           |
| layoutTemplates           | Object         | {actionUpload: '',actionZoom: '',actionDownload: '',actionDelete: ''}         | 渲染布局的每个部分的模板配置                    |
| previewFileIcon           | String         | 空                  | 当文件无法被预览时出现在缩略图中的图标，默认是<i class="glyphicon glyphicon-file"></i>                    |
| previewFileIconClass      | String         | 'file-other-icon'   |                                                                                                           |
| previewFileIconSettings   | Object         | {}                  | 可以将不同的后缀的文件有不同的缩略图图标                                                                  |
| previewFileExtSettings    | Object         | {}                  |                                                                                                           |
| buttonLabelClass          | String         | 'hidden-xs'         |                                                                                                           |
| browseIcon                | String         | 空                  |                                                                                                           |
| browseClass               | String         | 'btn btn-primary'   | 指出了右下角选择按钮的样式。一般尽量不要用btn-sm和btn-lg，会和左边的输入框不协调                          |
| removeIcon                | String         | 空                  | 删除按钮相关的属性                                                                                        |
| removeClass               | String         | 'btn btn-default'   |                                                                                                           |
| cancelIcon                | String         | 空                  |                                                                                                           |
| cancelClass               | String         | 'btn btn-default'   |                                                                                                           |
| uploadIcon                | String         | 空                  | 上传按钮相关的属性                                                                                        |
| uploadClass               | String         | 'btn btn-default'   |                                                                                                           |
| uploadUrl                 | String         | null                | 上传文件路径                                                                                              |
| uploadAsync               | boolean        | true                | 是否为异步上传                                                                                            |
| uploadExtraData           | Object         | {}                  | 上传文件时额外传递的参数设置                                                                              |
| zoomModalHeight           | number         | 480                 |                                                                                                           |
| minImageWidth             | String         | null                | 图片的最小宽度                                                                                            |
| minImageHeight            | String         | null                | 图片的最小高度                                                                                            |
| maxImageWidth             | String         | null                | 图片的最大宽度                                                                                            |
| maxImageHeight            | String         | null                | 图片的最大高度                                                                                            |
| resizeImage               | Boolean        | false               |                                                                                                           |
| resizePreference          | String         | 'width'             |                                                                                                           |
| resizeQuality             | number         | 0.92                |                                                                                                           |
| resizeDefaultImageType    | String         | 'image/jpeg'        |                                                                                                           |
| minFileSize               | number         | 0                   | 单位为kb，上传文件的最小大小值                                                                            |
| maxFileSize               | number         | 0                   | 单位为kb，如果为0表示不限制文件大小                                                                       |
| resizeDefaultImageType    | number         | 25600(25MB)         |                                                                                                           |
| minFileCount              | number         | 0                   | 表示同时最小上传的文件个数                                                                                |
| maxFileCount              | number         | 0                   | 表示允许同时上传的最大文件个数                                                                            |
| validateInitialCount      | Boolean        | false               |                                                                                                           |
| msgValidationErrorClass   | String         | 'text-danger'       |                                                                                                           |
| msgValidationErrorIcon    | String         | 空                  |                                                                                                           |
| msgErrorClass             | String         | 'file-error-message'  |                                                                                                         |
| progressThumbClass        | String         | "progress-bar progress-bar-success progress-bar-striped active"   |                                                             |
| rogressClass              | String         | "progress-bar progress-bar-success progress-bar-striped active"   |                                                             |
| progressCompleteClass     | String         | "progress-bar progress-bar-success"      |                                                                                      |
| progressErrorClass        | String         | "progress-bar progress-bar-danger"       |                                                                                      |
| progressUploadThreshold   | number         | 99                 |                                                                                                            |
| previewFileType           | String         | 'image'            | 预览文件类型,内置['image', 'html', 'text', 'video', 'audio', 'flash', 'object',‘other‘]等格式              |
| elCaptionContainer        | String         | null               |                                                                                                            |
| elCaptionText             | String         | null               | 	设置标题栏提示信息                                                                                     |
| elPreviewContainer        | String         | null               |                                                                                                            |
| elPreviewImage            | String         | null               |                                                                                                            |
| elPreviewStatus           | String         | null               |                                                                                                            |
| elErrorContainer          | String         | null               |                                                                                                            |
| errorCloseButton          | String         | <span class="close kv-error-close">×</span>'   |                                                                                |
| slugCallback              | function       | null               | 选择后未上传前 回调方法                                                                                    |
| dropZoneEnabled           | Boolean        | true               | 是否显示拖拽区域                                                                                           |
| dropZoneTitleClass        | String         | 'file-drop-zone-title'  | 	拖拽区域类属性设置                                                                                 |
| fileActionSettings        | Object         | {}                 | 设置预览图片的显示样式                                                                                     |
| otherActionButtons        | String         | 空                 |    编码设置                                                                                                |
| textEncoding              | String         | 'UTF-8'            |                                                                                                            |
| ajaxSettings              | Object         | {}                 |                                                                                                            |
| ajaxDeleteSettings        | Object         | {}                 |                                                                                                            |
| showAjaxErrorDetails      | Boolean        | true               |                                                                                                            |

Method说明。

| 方法名                 | 描述                                                                                                   |
| ---------------------- | ------------------------------------------------------------------------------------------------------ |
| fileerror              | 异步上传错误结果处理$('#uploadfile').on('fileerror', function(event, data, msg) {});                   |
| fileuploaded           | 异步上传成功结果处理$("#uploadfile").on("fileuploaded", function (event, data, previewId, index) {})   |
| filebatchuploaderror   | 批量上传错误结果处理$('#uploadfile').on('filebatchuploaderror', function(event, data, msg) {});        |
| filebatchuploadsuccess | 批量上传成功结果处理$('#uploadfile').on('filepreupload', function(event, data, previewId, index) {});  |
| filebatchselected      | 选择文件后处理事件$("#fileinput").on("filebatchselected", function(event, files) {});                  |
| upload                 | 文件上传方法$("#fileinput").fileinput("upload");                                                       |
| fileuploaded           | 上传成功后处理方法$("#fileinput").on("fileuploaded", function(event, data, previewId, index) {});      |
| filereset              | Possible values: http, https, ws, wss.                                                                 |
| fileclear              | 点击浏览框右上角X 清空文件前响应事件$("#fileinput").on("fileclear",function(event, data, msg){});      |
| filecleared            | 点击浏览框右上角X 清空文件后响应事件$("#fileinput").on("filecleared",function(event, data, msg){});    |
| fileimageuploaded      | 在预览框中图片已经完全加载完毕后回调的事件                                                             |


## bootstrap-duallistbox

* 基于`bootstrap`的双重列表框插件[bootstrap-duallistbox](https://github.com/istvan-ujjmeszaros/bootstrap-duallistbox)

代码演示参考 若依系统 → 实例演示 → 表单元素 → 左右互选组件 `form/duallistbox.html`（项目使用需要引入css和js）  

1、<th:block th:include="include :: bootstrap-duallistbox-css" />  
2、<th:block th:include="include :: bootstrap-duallistbox-js" />  

| 属性                    | 默认值                  | 描述                                                    |
| ----------------------- | ----------------------- | ------------------------------------------------------- |
| bootstrap2Compatible    | false                   | 兼容bootstrap2                                          |
| filterTextClear         | 'show all'              | 清空过滤条件按钮的文本                                  |
| filterPlaceHolder       | 'Filter'                | 过滤条件的input框的placeholder                          |
| moveSelectedLabel       | 'Move selected'         | 添加选中option按钮的label                               |
| moveAllLabel            | 'Move all'              | 添加全部option按钮的label                               |
| removeSelectedLabel     | 'Remove selected'       | 移除选中option按钮的label                               |
| removeAllLabel          | 'Remove all'            | 移除全部option按钮的label                               |
| moveOnSelect            | true                    | 是否移动选中的option:为false时,moveSelected和removeSelected的按钮显示生效:默认为true;为true只能光标连续选取,松开鼠标,选中的项会移动;为false则可配合键盘的Ctrl和Shift使用,点击moveSelectedLabel和removeSelectedLabel的按钮, option才会移动 |
| preserveSelectionOnMove | false                   | 'moved'或'all'时，展示移动到target列表中的元素（背景色显示）。配合moveOnSelect为false使用 |
| selectedListLabel       | false                   | 已选中list的label                                       |
| nonSelectedListLabel    | false                   | 未选中list的label                                       |
| helperSelectNamePostfix | '_helper'               | 为selector的name的后缀为_helper,朱选中的list后面拼接1,已选中的拼接2:也可通过 setHelperSelectNamePostfix(value, refresh)方法修改  |
| selectorMinimalHeight   | 100                     | selector的最小高度,小于元素的height()则高度的值为height()  |
| showFilterInputs        | true                    | 是否显示过滤的nput输入框,默认tue显示;为fase则过滤相关的内容不起作用、不显示 |
| nonSelectedFilter       | ''                      | 未选中option的过滤条件,默认为空字符串,也可用正则方式,例如:ion([7-9][1]0-2)过滤7、8、9、10、11、12 |
| selectedFilter          | ''                      | 已选中option的过滤条件,默认为空字符串;参考:nonSelectedFilter;-般不设置已选中的过滤条件,会导致某些选中的项不在已选中option的过滤条件范围内,无法显示 |
| infoText                | 'Showing all {0}'       | 未输入过滤条件时,选中/未选中option共几项                                    |
| infoTextFiltered        | '<span class="label label-warning">Filtered</span> {0} from {1}' | 过滤信息,默认< span class="label label-Warning">Filtered</span>{0} from {1}。从m项中筛选n项                                                |
| infoTextEmpty           | 'Empty list'            | 当筛选条件为'',且选中/未选中列表无option时显示的内容    |
| filterOnValues          | false                   | 过滤选项的值                                            |
| eventMoveoverride       | false                   | 设置为true,可自定义moveSelected的事件                   |
| eventMoveAlloverride    | false                   | 设置为true,可自定义moveAll的事件                        |
| eventRemoveOverride     | false                   | 设置为true,可自定义removeSelectecd的事件                |
| eventRemoveAlloverride  | false                   | 设置为true,可自定义removeAll的事件                      |
 
 
Method说明。

| 方法名                                                | 描述                                  |
| ----------------------------------------------------- | ------------------------------------- |
| refresh()                                             | 更新UI插件元素                        |
| destroy()                                             | 恢复原始元素                          |
| getContainer()                                        | 获取容器元素                          |
| setBootstrap2Compatible(value, refresh)               | 更改 bootstrap2Compatible 参数        |
| setFilterTextClear(value, refresh)                    | 更改 filterTextClear 参数             |
| setFilterPlaceHolder(value, refresh)                  | 更改 filterPlaceHolder 参数           |
| setMoveSelectedLabel(value, refresh)                  | 更改 moveSelectedLabel 参数           |
| setMoveAllLabel(value, refresh)                       | 更改 moveAllLabel 参数                |
| setRemoveSelectedLabel(value, refresh)                | 更改 removeSelectedLabel 参数         |
| setRemoveAllLabel(value, refresh)                     | 更改 removeAllLabel 参数              |
| setMoveOnSelect(value, refresh)                       | 更改 moveOnSelect 参数                |
| setPreserveSelectionOnMove(value, refresh)            | 更改 preserveSelectionOnMove 参数     |
| setSelectedListLabel(value, refresh)                  | 更改 selectedListLabel 参数           |
| setNonSelectedListLabel(value, refresh)               | 更改 nonSelectedListLabel 参数        |
| setHelperSelectNamePostfix(value, refresh)            | 更改 helperSelectNamePostfix 参数     |
| setSelectOrMinimalHeight(value, refresh)              | 更改 selectorMinimalHeight 参数       |
| setShowFilterInputs(value, refresh)                   | 更改 showFilterInputs 参数            |
| setNonSelectedFilter(value, refresh)                  | 更改 nonSelectedFilter 参数           |
| setSelectedFilter(value, refresh)                     | 更改 selectedFilter 参数              |
| setInfoText(value, refresh)                           | 更改 infoText 参数                    |
| setInfoTextFiltered(value, refresh)                   | 更改 infoTextFiltered 参数            |
| setInfoTextEmpty(value, refresh)                      | 更改 infoTextEmpty 参数               |
| setFilterOnValues(value, refresh)                     | 更改 filterOnValues 参数              |


## jquery-validate

* 基于`jquery`的一款表单验证插件[jquery-validate](https://github.com/jquery-validation/jquery-validation)

`jquery-validate`插件为表单提供了强大的验证功能，让客户端表单验证变得更简单，同时提供了大量的定制选项，满足应用程序各种需求。
该插件捆绑了一套有用的验证方法，包括 URL 和电子邮件验证，同时提供了一个用来编写用户自定义方法的 API。

代码演示参考 若依系统 → 实例演示 → 表单元素 → 表单验证 `form/validate.html`  

默认校验规则。

| 属性                    | 描述                                                                                   |
| ----------------------- | -------------------------------------------------------------------------------------- |
| required:true           | 必须输入的字段                                                                         |
| remote:"/action"        | 使用ajax方法调用action验证输入值                                                       |
| email:true              | 必须输入正确格式的电子邮件                                                             |
| url:true                | 必须输入正确格式的网址                                                                 |
| date:true               | 必须输入正确格式的日期。日期校验 ie6 出错，慎用                                        |
| dateISO:true            | 必须输入正确格式的日期（ISO），例如：2009-06-23，1998/01/22。只验证格式，不验证有效性  |
| number:true             | 必须输入合法的数字（负数，小数）                                                       |
| digits:true             | 必须输入整数                                                                           |
| creditcard:             | 必须输入合法的信用卡号                                                                 |
| equalTo:"#field"        | 输入值必须和 #field 相同                                                               |
| accept:                 | 输入拥有合法后缀名的字符串（上传文件的后缀）                                           |
| maxlength:5             | 输入长度最多是 5 的字符串（汉字算一个字符）                                            |
| minlength:10            | 输入长度最小是 10 的字符串（汉字算一个字符）                                           |
| rangelength:[5,10]      | 输入长度必须介于 5 和 10 之间的字符串（汉字算一个字符）                                |
| range:[5,10]            | 输入值必须介于 5 和 10 之间                                                            |
| max:5                   | 输入值不能大于 5                                                                       |
| min:10                  | 输入值不能小于 10                                                                      |
| isIp:true               | IP地址验证                                                                             |
| isPhone:true            | 手机号码验证                                                                           |
| isTel:true              | 电话号码验证                                                                           |
| isName:true             | 姓名验证                                                                               |
| isUserName:true         | 用户名验证                                                                             |
| isIdentity:true         | 身份证验证                                                                             |
| isBirth:true            | 出生日期验证                                                                           |


内置验证方式。

| 名称                             | 类型           | 描述                                                                    |
| -------------------------------- |--------------- | ----------------------------------------------------------------------- |
| required()                       | Boolean        | 必填验证元素                                                            |
| required(dependency-expression)  | Boolean        | 必填元素依赖于表达式的结果                                              |
| required(dependency-callback)    | Boolean        | 必填元素依赖于回调函数的结果                                            |
| remote(url)                      | Boolean        | 请求远程校验。url 通常是一个远程调用方法                                |
| minlength(length)                | Boolean        | 设置最小长度                                                            |
| maxlength(length)                | Boolean        | 设置最大长度                                                            |
| rangelength(range)               | Boolean        | 设置一个长度范围 [min,max]                                              |
| min(value)                       | Boolean        | 设置最小值                                                              |
| max(value)                       | Boolean        | 设置最大值                                                              |
| email()                          | Boolean        | 验证电子邮箱格式                                                        |
| range(range)                     | Boolean        | 设置值的范围                                                            |
| url()                            | Boolean        | 验证 URL 格式                                                           |
| date()                           | Boolean        | 验证日期格式（类似 30/30/2008 的格式，不验证日期准确性只验证格式）      |
| dateISO()                        | Boolean        | 验证 ISO 类型的日期格式                                                 |
| dateDE()                         | Boolean        | 验证德式的日期格式（29.04.1994 或 1.1.2006）                            |
| number()                         | Boolean        | 验证十进制数字（包括小数的）                                            |
| digits()                         | Boolean        | 验证整数                                                                |
| creditcard()                     | Boolean        | 验证信用卡号                                                            |
| accept(extension)                | Boolean        | 验证相同后缀名的字符串                                                  |
| equalTo(other)                   | Boolean        | 验证两个输入框的内容是否相同                                            |
| phoneUS()                        | Boolean        | 验证美式的电话号码                                                      |

验证的触发方式修改。  

| 触发方式                | 类型           | 默认值          | 描述                                                                   | 
| ----------------------- |--------------- | --------------- |----------------------------------------------------------------------- | 
| onsubmit                | Boolean        | true            | 提交时验证。设置为 false 就用其他方法去验证                            |
| onfocusout              | Boolean        | true            | 失去焦点时验证（不包括复选框/单选按钮）                                |
| onkeyup                 | Boolean        | true            | 在 keyup 时验证                                                        |
| onclick                 | Boolean        | true            | 在点击复选框和单选按钮时验证                                           |
| focusInvalid            | Boolean        | true            | 提交表单后，未通过验证的表单（第一个或提交之前获得焦点的未通过验证的表单）会获得焦点   |
| focusCleanup            | Boolean        | false           | 如果是 true 那么当未通过验证的元素获得焦点时，移除错误提示。避免和 focusInvalid 一起用 |


## bootstrap-suggest

* 基于`bootstrap`的按钮式下拉菜单组件的搜索建议插件[bootstrap-suggest](https://github.com/lzwme/bootstrap-suggest-plugin)

代码演示参考 若依系统 → 实例演示 → 表单元素 → 搜索自动补全 `form/autocomplete.html`（项目使用需要引入js）  

<th:block th:include="include :: bootstrap-suggest-js" />  

| 属性                    | 默认值                  | 描述                                                                                  |
| ----------------------- | ----------------------- | ------------------------------------------------------------------------------------- |
| url                     | null                    | 请求数据的 URL 地址                                                                   |
| jsonp                   | null                    | 设置此参数名，将开启jsonp功能，否则使用json数据结构                                   |
| data                    | []                      | 提示所用的数据，注意格式                                                              |
| indexId                 | 0                       | 每组数据的第几个数据，作为input输入框的 data-id，设为 -1 且 idField 为空则不设置此值  |
| indexKey                | 0                       | 每组数据的第几个数据，作为input输入框的内容                                           |
| idField                 | ''                      | 每组数据的哪个字段作为 data-id，优先级高于 indexId 设置（推荐）                       |
| keyField                | ''                      | 每组数据的哪个字段作为输入框内容，优先级高于 indexKey 设置（推荐）                    |
| autoSelect              | true                    | 键盘向上/下方向键时，是否自动选择值                                                   |
| allowNoKeyword          | TRUE                    | 是否允许无关键字时请求数据                                                            |
| getDataMethod           | 'firstByUrl'            | 获取数据的方式，url：一直从url请求；data：从 options.data 获取；firstByUrl：第一次从Url获取全部数据，之后从options.data获取 |
| delayUntilKeyup         | false                   | 获取数据的方式 为 firstByUrl 时，是否延迟到有输入时才请求数据                         |
| ignorecase              | false                   | 前端搜索匹配时，是否忽略大小写                                                        |
| effectiveFields         | []                      | 有效显示于列表中的字段，非有效字段都会过滤，默认全部有效                              |
| effectiveFieldsAlias    | {}                      | 有效字段的别名对象，用于 header 的显示                                                |
| searchFields            | []                      | 有效搜索字段，从前端搜索过滤数据时使用，但不一定显示在列表中。effectiveFields 配置字段也会用于搜索过滤 |
| twoWayMatch             | true                    | 是否双向匹配搜索。为 true 即输入关键字包含或包含于匹配字段均认为匹配成功，为 false 则输入关键字包含于匹配字段认为匹配成功 |
| multiWord               | false                   | 以分隔符号分割的多关键字支持                                                          |
| separator               | ','                     | 多关键字支持时的分隔符，默认为半角逗号                                                |
| delay                   | 300                     | 搜索触发的延时时间间隔，单位毫秒                                                      |
| emptyTip                | ''                      | 查询为空时显示的内容，可为 html                                                       |
| searchingTip            | '搜索中...'             | ajax 搜索时显示的提示内容，当搜索时间较长时给出正在搜索的提示                         |
| hideOnSelect            | false                   | 鼠标从列表单击选择了值时，是否隐藏选择列表                                            |
| autoDropup              | false                   | 选择菜单是否自动判断向上展开。设为 true，则当下拉菜单高度超过窗体，且向上方向不会被窗体覆盖，则选择菜单向上弹出 |
| autoMinWidth            | false                   | 是否自动最小宽度，设为 false 则最小宽度不小于输入框宽度                               |
| showHeader              | false                   | 是否显示选择列表的 header。为 true 时，有效字段大于一列则显示表头                     |
| showBtn                 | true                    | 是否显示下拉按钮                                                                      |
| inputBgColor            | ''                      | 输入框背景色，当与容器背景色不同时，可能需要该项的配置                                |
| inputWarnColor          | 'rgba(255,0,0,.1)'      | 输入框内容不是下拉列表选择时的警告色                                                  |
| listStyle               | 默认参考描述            | 列表的样式控制 { 'padding-top': 0, 'max-height': '375px', 'max-width': '800px', 'overflow': 'auto', 'width': 'auto', 'transition': '0.3s', '-webkit-transition': '0.3s', '-moz-transition': '0.3s', '-o-transition': '0.3s' }  |
| listAlign               | 'left'                  | 提示列表对齐位置，left/right/auto                                                     |
| listHoverStyle          | 'background: #07d; color:#fff'                    | 提示框列表鼠标悬浮的样式                                    |
| listHoverCSS            | 'jhover'                | 提示框列表鼠标悬浮的样式名称                                                          |
| clearable               | false                   | 是否可清除已输入的内容                                                                |
| keyLeft                 | 37                      | 向左方向键，不同的操作系统可能会有差别，则自行定义                                    |
| keyUp                   | 38                      | 向上方向键                                                                            |
| keyRight                | 39                      | 向右方向键                                                                            |
| keyDown                 | 40                      | 向下方向键                                                                            |
| keyEnter                | 13                      | 回车键                                                                                |
| fnProcessData           | processData             | 格式化数据的方法，返回数据格式参考 data 参数                                          |
| fnGetData               | getData                 | 获取数据的方法，无特殊需求一般不作设置                                                |
| fnAdjustAjaxParam       | null                    | 调整 ajax 请求参数方法，用于更多的请求配置需求。如对请求关键字作进一步处理、修改超时时间等 |
| fnPreprocessKeyword     | null                    | 搜索过滤数据前，对输入关键字作进一步处理方法。注意，应返回字符串                      |

```javascript
// suggest 常用方法
$("input#test").bsSuggest("disable");    // 禁用提示
$("input#test").bsSuggest("enable");     // 启用提示
$("input#test").bsSuggest("destroy");    // 销毁插件
$("input#test").bsSuggest("version");    // 查看版本

<!--  事件监听
onDataRequestSuccess  // 当 AJAX 请求数据成功时触发，并传回结果到第二个参数
onSetSelectValue      // 当从下拉菜单选取值时触发，并传回设置的数据到第二个参数
onUnsetSelectValue    // 当设置了 idField，且自由输入内容时触发（与背景警告色显示同步）
onShowDropdown        // 下拉菜单显示时触发
onHideDropdown        // 拉菜单隐藏式触发
-->
$("#test").bsSuggest('init', {
    url: "/rest/sys/getuserlist?keyword=",
    effectiveFields: ["userName", "email"],
    searchFields: [ "shortAccount"],
    effectiveFieldsAlias:{userName: "姓名"},
    clearable: true,
    idField: "userId",
    keyField: "userName"
}).on('onDataRequestSuccess', function (e, result) {
    console.log('onDataRequestSuccess: ', result);
}).on('onSetSelectValue', function (e, selectedData, selectedRawData) {
    console.log('onSetSelectValue: ', e.target.value, selectedData, selectedRawData);
}).on('onUnsetSelectValue', function () {
    console.log('onUnsetSelectValue');
}).on('onShowDropdown', function (e, data) {
    console.log('onShowDropdown', e.target.value, data);
}).on('onHideDropdown', function (e, data) {
    console.log('onHideDropdown', e.target.value, data);
});
```


## bootstrap-typeahead

* 基于`bootstrap`的一款搜索自动补全插件[bootstrap-typeahead](https://github.com/bassjobsen/Bootstrap-3-Typeahead)

代码演示参考 若依系统 → 实例演示 → 表单元素 → 搜索自动补全 `form/autocomplete.html`（项目使用需要引入js）  

<th:block th:include="include :: bootstrap-typeahead-js" />  

| 属性                      | 类型             | 默认值              | 描述                                                                                                      | 
| ------------------------- |----------------- | ------------------- |---------------------------------------------------------------------------------------------------------- | 
| source                    | array, function  | [ ]                 | 要查询的数据源。可能是一个字符串数组，一个具有name属性或函数的JSON对象数组。该函数接受两个参数， query 即输入字段中的值和 process 回调。该函数可以通过 process 回调的单个参数直接或异步返回数据源来同步使用。  |
| items                     | number           | 8                   | 在下拉列表中显示的最大项目数。也可以设置为“全部”                                                          |
| minLength                 | number           | 1                   | 触发自动填充建议之前所需的最小字符长度。您可以将其设置为0，因此即使在调用查找功能时没有文本时也会显示建议。|
| showHintOnFocus           | boolean          | false               | 一旦输入得到焦点，就可以在适用时显示提示。                                                                |
| scrollHeight              | number, function | 0                   | 可滚动父容器向下滚动的像素数（滚出视口）。                                                                |
| matcher                   | function         | case insensitive    | 用于确定查询是否匹配项的方法。接受单个参数， item 用于测试查询。访问当前查询 this.query。true如果查询是匹配，则返回一个布尔值。  |
| sorter                    | function         | exact match,case sensitive,case insensitive  | 用于对自动完成结果进行排序的方法。接受单个参数， items 并具有类型头实例的范围。引用当前查询 this.query. |
| updater                   | function         | returns selected item | 用于返回所选项目的方法。接受单个参数， item 并具有类型头实例的范围。                                                           |
| highlighter               | function         | highlights all default matches | 用于突出显示自动完成结果的方法。接受单个参数， item 并具有类型头实例的范围。应该返回html       |
| displayText               | function         | item.name   item    | 用于获取源的项目的文本表示的方法。接受单个参数， item 并具有类型头实例的范围。应该返回一个String。        |
| autoSelect                | boolean          | true                | 允许您指定是否自动选择第一个建议。关闭自动选择也意味着如果没有选择 enter 或被 tab 击中，输入将不会被清除。|
| afterSelect               | function         | $.noop()            | 调用功能在选择一个项目后执行。它将当前活动项目置于参数中（如果有）。                                      |
| delay                     | integer          | 0                   | 在查找之间增加延迟。                                                                                      |
| addItem                   | JSONobject       | false               | 将项目添加到列表的末尾，例如“新建条目”。例如，当在数据列表中找不到某个项目时，可以使用该对话框。          |


## jquery-cxselect

* 基于`jquery`的一款联动下拉菜单插件[jquery-cxselect](https://github.com/ciaoca/cxSelect)

代码演示参考 若依系统 → 实例演示 → 表单元素 → 多级联动下拉 `form/cxselect.html`（项目使用需要引入js）  

<th:block th:include="include :: jquery-cxselect-js" />

| 属性                       | 默认值              | 描述                                                                                                      | 
| ------------------------- | -------------------- |---------------------------------------------------------------------------------------------------------- | 
| selects                   | [ ]                  | 下拉选框组。输入 select 的 className                                                                      |
| url                       | null                 | 整合列表数据接口地址（URL）每个选框的内容使用各自的接口地址，                                             |
| data                      | null                 | 自定义数据，类型为数组，数据使用 JSON 格式。                                                              |
| emptyStyle                | null                 | 子集无数据时 select 的状态。可设置为："none"(display:none), "hidden"(visibility:hidden)                   |
| required                  | false                | 是否为必选。设为 false 时，会在列表头部添加 <option value="firstValue">firstTitle</option> 选项。         |
| firstTitle                | '请选择'             | 选框第一个项目的标题（仅在 required 为 false 时有效）                                                     |
| firstValue                | ''                   | 选框第一个项目的值（仅在 required 为 false 时有效）                                                       |
| jsonSpace                 | ''                   | 数据命名空间                                                                                              |
| jsonName                  | 'n'                  | 数据标题字段名称（用于 option 的标题）                                                                    |
| jsonValue                 | ''                   | 数据值字段名称（用于 option 的 value，没有值字段时使用标题作为 value）                                    |
| jsonSub                   | 's'                  | 子集数据字段名称                                                                                          |

在父元素上的 `data-` 属性。
```html
<div id="element_id" data-url="cityData.min.json" data-selects="province,city,area" data-required="true"></div>
```

| 名称                    | 说明                                                                                   |
| ----------------------- | -------------------------------------------------------------------------------------- |
| data-selects            | 下拉选框组。输入 select 的 className，使用英文逗号分隔的字符串                         |
| data-url                | 列表数据接口地址（此处只能设置 URL，自定义需要在参数中设置）                           |
| data-empty-style        | 子集无数据时 select 的状态                                                             |
| data-required           | 是否为必选                                                                             |
| data-first-title        | 选框第一个项目的标题                                                                   |
| data-first-value        | 选框第一个项目的值                                                                     |
| data-json-space         | 数据命名空间                                                                           |
| data-json-name          | 数据标题字段名称                                                                       |
| data-json-value         | 数据值字段名称                                                                         |
| data-json-sub           | 子集数据字段名称                                                                       |

在 `<select>` 元素上的 `data-` 属性
```html
<select class="province" data-value="浙江省" data-required="false" data-first-title="选择省"></select>
```

| 名称                    | 说明                                                                                   |
| ----------------------- | -------------------------------------------------------------------------------------- |
| data-value              | 默认选中值                                                                             |
| data-url                | 列表数据接口地址                                                                       |
| data-required           | 是否为必选                                                                             |
| data-query-name         | 传递上一个选框值的参数名称（默认使用上一个选框的 name 属性值）                         |
| data-first-title        | 选框第一个项目的标题                                                                   |
| data-first-value        | 选框第一个项目的值                                                                     |
| data-json-space         | 数据命名空间                                                                           |
| data-json-name          | 数据标题字段名称                                                                       |
| data-json-value         | 数据值字段名称                                                                         |

`API` 接口
```javascript
var cxSelectApi;
// 方法一：
cxSelectApi = $.cxSelect($('#element_id'), {
  selects: ['province', 'city', 'area']
});

// 方法二：
$('#element_id').cxSelect({
  selects: ['province', 'city', 'area']
}, function(api) {
  cxSelectApi = api;
});
```

| 名称                    | 说明                                                                                           |
| ----------------------- | ---------------------------------------------------------------------------------------------- |
| attach()                | 绑定，调用时会自动进行绑定，用于使用detach解除绑定后，进行重新绑定。                           |
| detach()                | 解除绑定，解除绑定后，不再具有联动效果。                                                       |
| clear(index)            | 清空选项，清空第 index 个 select 自身及之后的 select 的选项。index: select 的序号，从 0 开始。 |
| setOptions(settings)    | 重新设置参数，settings: 与调用时参数一致。                                                     |


## summernote

* [summernote](https://github.com/summernote/summernote)是一款富文本编辑器

1、<th:block th:include="include :: summernote-css" />
2、<th:block th:include="include :: summernote-js" />

* 自定义样式，您可以使用`styleTags`选项设置自己的样式选择。
```js
$('#summernote').summernote({
    styleTags: ['p', {
        title: 'Blockquote',
        tag: 'blockquote',
        className: 'blockquote',
        value: 'blockquote'
    },
    'pre', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6'],
});
```

* 自定义`fontNames`，您可以使用`fontNames`选项定义字体。
```js
$('#summernote').summernote({
  fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New']
});
```

* 自定义字体大小单位，您可以使用`fontSizeUnits`选项设置可用的字体大小单位。
```js
$('#summernote').summernote({
  fontSizeUnits: ['px', 'pt']
});
```

* 自定义自定义行高，您可以覆盖默认列表并指定一个自定义列表。
```js
$('#summernote').summernote({
  lineHeights: ['0.2', '0.3', '0.4', '0.5', '0.6', '0.8', '1.0', '1.2', '1.4', '1.5', '2.0', '3.0']
});
```

* 自定义占位符，您可以定义占位符`placeholder`选择。
```js
$('#summernote').summernote({
  placeholder: 'write here...'
});
```

* 禁用拖拽，你可以禁用拖拽`disableDragAndDrop`选择。
```js
$('#summernote').summernote({
  disableDragAndDrop: true
});
```

* 禁用快捷键，你可以禁用自定义快捷键`shortcuts`选择
```js
$('#summernote').summernote({
  shortcuts: false
});
```

* 禁用TAB，您可以使用`tabDisable`选项禁用
```js
$('#summernote').summernote({
  tabDisable: false
});
```

* 对`CodeView`的`XSS`保护
`Summernote`为`CodeView`提供了`XSS`保护。它由`iframe`的过滤标签和白名单组成。  
白名单过滤器默认情况下处于启用状态，但过滤标签未启用。 您可以通过以下选项打开和关闭它们。
```js
$('#summernote').summernote({
  codeviewFilter: false,
  codeviewIframeFilter: true
});
```

`API` 接口
```javascript
// 示例代码插入文本“hello world”
$('#summernote').summernote('editor.insertText', 'hello world'));

// 您可以通过API切换editable/codable视图。
$('#summernote').summernote('codeview.toggle');

// 为当前用户创建一个范围对象的选择。
var range = $('#summernote').summernote('createRange');

// 您可以通过API禁用/恢复编辑器。
$('#summernote').summernote('disable');
$('#summernote').summernote('enable');

// 禁用拼写检查
$('#summernote').summernote({ spellCheck: true });

// 禁用语法浏览器插件
$('#summernote').summernote({ disableGrammar: false });

// 在当前summernote设定一个焦点
$('#summernote').summernote('focus');

// 您可以通过API切换全屏视图。
$('#summernote').summernote('fullscreen.toggle');

// 您可以使用isFullscreen来以编程方式确定Summernote是否处于全屏模式，这将返回true或false。
$('#summernote').summernote('fullscreen.isFullscreen');

// 编辑区域的需求 <p><br></p>焦点,即使内容是空的。所以summernote支持这个方法帮助检查内容是空的。
if ($('#summernote').summernote('isEmpty')) {
  alert('editor content is empty');
}

// 清除编辑器内容并删除所有存储的历史记录。
$('#summernote').summernote('reset');

// saveRange在内部保存当前用户选择。
$('#summernote').summernote('saveRange');

// restoreRange恢复当前保存的范围
$('#summernote').summernote('restoreRange');

// 撤销和重做最后一个命令
$('#summernote').summernote('undo');
$('#summernote').summernote('redo');

// 字体风格的API backColor, foreColor
$('#summernote').summernote('backColor', 'red');
$('#summernote').summernote('foreColor', 'blue');

// bold, italic, underline, strikethrough 粗体、斜体、下划线、删除线设置字体样式。
$('#summernote').summernote('bold');
$('#summernote').summernote('italic');
$('#summernote').summernote('underline');
$('#summernote').summernote('strikethrough');

// 设置字体大小
$('#summernote').summernote('fontSize', 20);

// 设置字体大小单位。
$('#summernote').summernote('fontSizeUnit', 'pt');

// 清除一个样式
$('#summernote').summernote('removeFormat');

// 设置上标或下标
$('#summernote').summernote('superscript');
$('#summernote').summernote('subscript');

// 将当前段落更改为<h1>〜<h6>。
$('#summernote').summernote('formatH2');
$('#summernote').summernote('formatH6');

// 在当前段落上缩进或减少缩进。
$('#summernote').summernote('indent');
$('#summernote').summernote('outdent');

// 切换有序列表和无序列表
$('#summernote').summernote('insertOrderedList');
$('#summernote').summernote('insertUnorderedList');

// 插入一段
$('#summernote').summernote('insertParagraph');

// 设置段落的对齐方式。
$('#summernote').summernote('justifyLeft');
$('#summernote').summernote('justifyRight');
$('#summernote').summernote('justifyCenter');
$('#summernote').summernote('justifyFull');

// 设置行高。
$('#summernote').summernote('lineHeight', 20);

// 创建链接并取消链接
$('#summernote').summernote('createLink', {
  text: "This is the Summernote's Official Site",
  url: 'http://summernote.org',
  isNewWindow: true
});

$('#summernote').summernote('unlink');

// 插入图像。
$('#summernote').summernote('insertImage', url, filename);

// 插入一个元素或textnode。
var node = document.createElement('div');
$('#summernote').summernote('insertNode', node);

// 插入文字。
$('#summernote').summernote('insertText', 'Hello, world');

// 粘贴HTML字符串。
$('#summernote').summernote('pasteHTML', HTMLstring);
```