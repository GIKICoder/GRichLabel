# GBigbang
大爆炸/分词/tagFlowView
==============

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/GIKICoder/GBigbang/blob/master/LICENSE)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS7+-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;


介绍
==============
这是一个分词组件.用与文本分词,列表展示.参考Pin的分词界面.和UC的bigbang界面.
(该项目是 [GRichLabel](https://github.com/GIKICoder/GRichLabel) 文本选择复制功能的组件之一)


特性
==============
- 可区分标点符号与表情.
- 可自定义分词展现列表.
- 分词列表支持滑动/点击选择.
- 提供默认分词展现Container.
-

用法
==============

### 基本用法
```objc

NSString* selection = [self stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
NSArray * array = [GBigbangBox bigBang:selection];
__block NSMutableArray *flows = [NSMutableArray array];
[array enumerateObjectsUsingBlock:^(GBigbangItem  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
GTagFlowLayout *layout = [GTagFlowLayout tagFlowLayoutWithText:obj.text];
[flows addObject:layout];
if (obj.isSymbolOrEmoji) {
    layout.appearance.backgroundColor = [UIColor grayColor];
    layout.appearance.textColor = [UIColor blackColor];
}
}];
[self.container configDatas:flows.copy];
[self.container show];

```

```objc
NSArray *items = [GBigbangBox bigBang:self.string];

NSArray * layouts = [GTagFlowLayout factoryFolwLayoutWithItems:items withAppearance:self.appearance];
self.flowView.flowDatas = layouts;
[self.flowView reloadDatas];
```
安装
==============

### 手动添加
1. ` git clone  https://github.com/GIKICoder/GBigbang.git `
2. 选择`GBigbang`文件夹.拖入项目中即可.


Demo
==============
### Demo

<img src="https://github.com/GIKICoder/GBigbang/blob/master/snapshot/bigbangDemo1.gif" width="320">
<img src="https://github.com/GIKICoder/GBigbang/blob/master/snapshot/bigbangDemo2.gif" width="320">
<img src="https://github.com/GIKICoder/GBigbang/blob/master/snapshot/demo3.png" width="320">
<img src="https://github.com/GIKICoder/GBigbang/blob/master/snapshot/demo4.png" width="320">
