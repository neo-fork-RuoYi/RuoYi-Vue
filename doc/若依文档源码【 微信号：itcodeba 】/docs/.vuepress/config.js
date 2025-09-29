module.exports = {
	title : 'RuoYi',
	description : '使用若依快速构建web应用程序',
	port : 3000,
	dest : "dist",
	head : [
		[
			'link', {
				rel : 'icon',
				href : '/images/favicon.ico'
			}

		],
		[
			'link', {
				rel : 'stylesheet',
				href : '/css/ruoyi.css'
			}
		],
		[
			'script', {
				charset : 'utf-8',
				src : '/js/ruoyi.js'
			}
		]
	],
	base : '',
	markdown : {
		lineNumbers : true // 代码块是否显示行号
	},
	themeConfig : {
		sidebarDepth : 3,
		/*
		algolia : {
			// 使用官方注册key无需appId
			appId: 'YDP9KZMGO2',
			// 官方注册默认 key 017ae7acde5e01882ca2985797787d06
			apiKey : 'cc3949f0409f5b9067b49292194b5bfe',
			indexName : 'ruoyi',
			algoliaOptions : {
				hitsPerPage : 5,
				facetFilters : ""
			}
		},
		*/
		nav : [// 导航栏配置
			{
				text : '文档',
				link : '/ruoyi/'
			}, {
				text : '分离版',
				link : '/ruoyi-vue/'
			}, {
				text : '微服务版',
				link : '/ruoyi-cloud/'
			}, {
				text : '生态系统',
				items : [{
						text : '项目',
						items : [{
								text : 'RuoYi（不分离版本）',
								link : 'https://gitee.com/y_project/RuoYi'
							}, {
								text : 'RuoYi-Vue（分离版本）',
								link : 'https://gitee.com/y_project/RuoYi-Vue'
							}, {
								text : 'RuoYi-Cloud（微服务版本）',
								link : 'https://gitee.com/y_project/RuoYi-Cloud'
							}, {
								text : 'RuoYi-fast（不分离版本单应用）',
								link : 'https://gitee.com/y_project/RuoYi-fast'
							}, {
								text : 'RuoYi-Vue-fast（分离版本单应用）',
								link : 'https://github.com/yangzongzhuan/RuoYi-Vue-fast'
							}
						]
					}, {
						text : '扩展列表',
						items : [{
								text : 'RuoYi 项目扩展（不分离版本）',
								link : '/ruoyi/document/xmkz'
							}, {
								text : 'RuoYi-Vue 项目扩展（分离版本）',
								link : '/ruoyi-vue/document/xmkz'
							}, {
								text : 'RuoYi-Cloud 项目扩展（微服务版本）',
								link : '/ruoyi-cloud/document/xmkz'
							}
						]
					}, {
						text : '帮助',
						items : [{
								text : '我要提问',
								link : 'https://gitee.com/y_project/RuoYi/issues'
							}, {
								text : '常见问题',
								link : '/ruoyi/other/faq'
							}, {
								text : '加入QQ群',
								link : 'https://jq.qq.com/?_wv=1027&k=1sNsfWzD'
							}
						]
					}
				]
			}, {
				text : 'GitHub',
				link : 'https://github.com/yangzongzhuan/RuoYi'
			}, {
				text : 'Gitee',
				link : 'https://gitee.com/y_project/RuoYi'
			}
		],
		sidebar : {
			'/ruoyi/' : [{
					title : '文档',
					collapsable : false,
					children : [
						'',
						'document/kslj',
						'document/hjbs',
						'document/xmjs',
						'document/htsc',
						'document/qdsc',
						'document/gnzj',
						'document/zjwd',
						'document/cjjc',
						'document/xmkz',
						'document/spjc',
						'document/gxrz'
					]
				}, {
					title : '其它',
					collapsable : false,
					children : [
						'other/faq',
						'other/donate'
					]
				}
			],
			'/ruoyi-vue/' : [{
					title : '文档',
					collapsable : false,
					children : [
						'',
						'document/kslj',
						'document/hjbs',
						'document/xmjs',
						'document/htsc',
						'document/qdsc',
						'document/zjwd',
						'document/cjjc',
						'document/xmkz',
						'document/spjc',
						'document/gxrz'
					]
				}, {
					title : '其它',
					collapsable : false,
					children : [
						'other/faq',
						'other/donate'
					]
				}
			],
			'/ruoyi-cloud/' : [{
					title : '文档',
					collapsable : false,
					children : [
						'',
						'document/kslj',
						'document/hjbs',
						'document/xmjs',
						'document/htsc',
						'document/qdsc',
						'document/zjwd',
						'document/xmkz',
						'document/spjc',
						'document/gxrz'
					]
				}, {
					title : '微服务',
					collapsable : false,
					children : [
						'cloud/gateway',
						'cloud/auth',
						'cloud/nacos',
						'cloud/config',
						'cloud/feign',
						'cloud/monitor',
						'cloud/swagger',
						'cloud/skywalking',
						'cloud/sentinel',
						'cloud/file',
						'cloud/seata',
						'cloud/elk',
						'cloud/dokcer'
					]
				}, {
					title : '其它',
					collapsable : false,
					children : [
						'other/faq',
						'other/donate'
					]
				}
			]

		}
	}
};