GMenuController
==============
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/GIKICoder/GMenuController/blob/master/LICENSE)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS7+-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;

介绍
==============
具有和系统UIMenuController行为,交互一致的UI控件.相比UIMenuController.具有更加友好的使用方式.
(该项目是 [GRichLabel](https://github.com/GIKICoder/GRichLabel) 文本选择复制功能的组件之一)


特性
==============
- API与UIMenuController一致.
- 支持MenuItem指定target.使用更加灵活
- 支持显示图标加文字menu.图标可自定义位置
- 支持更改menuview 外观设置
- 无需对添加MenuController的控件 添加canBecomeFirstResponder等行为.
- 相比UIMenuController. GMenuController具有更加简单,友好的使用方式.

用法
==============

### 基本用法
```objc 
// GMenuController (和 UIMenuController 用法一致)
GMenuItem *item1 = [[GMenuItem alloc] initWithTitle:@"选择" target:self action:@selector(test)];
GMenuItem *item2 = [[GMenuItem alloc] initWithTitle:@"复制" target:self action:@selector(test)];
GMenuItem *item3 = [[GMenuItem alloc] initWithTitle:@"全选" target:self action:@selector(test)];
GMenuItem *item4= [[GMenuItem alloc] initWithTitle:@"收藏" target:self action:@selector(test)];
GMenuItem *item5 = [[GMenuItem alloc] initWithTitle:@"更多" target:self action:@selector(test)];
self.arr = @[item1,item2,item3,item4,item5];

[[GMenuController sharedMenuController] setMenuItems:self.arr];
[[GMenuController sharedMenuController] setTargetRect:sender.frame inView:self.view];
[[GMenuController sharedMenuController] setMenuVisible:YES];

```

```objc 
///带有图片的menuView. 可指定图片位置
GMenuItem *item1 = [[GMenuItem alloc] initWithTitle:@"选择" image:[UIImage imageNamed:@"star"] target:self action:@selector(test)];
GMenuItem *item2 = [[GMenuItem alloc] initWithTitle:@"复制" image:[UIImage imageNamed:@"star"] target:self action:@selector(test)];
GMenuItem *item3 = [[GMenuItem alloc] initWithTitle:@"全选" image:[UIImage imageNamed:@"star"] target:self action:@selector(test)];
GMenuItem *item4= [[GMenuItem alloc] initWithTitle:@"收藏" image:[UIImage imageNamed:@"star"] target:self action:@selector(test)];
GMenuItem *item5 = [[GMenuItem alloc] initWithTitle:@"更多" image:[UIImage imageNamed:@"star"] target:self action:@selector(test)];
GMenuItem *item6 = [[GMenuItem alloc] initWithTitle:@"可以有多个文字,行为与系统menuview完全一致" image:[UIImage imageNamed:@"star"] target:self action:@selector(test)];
NSArray* arr1 = @[item1,item2,item3,item4,item5,item6];
    
GMenuController.sharedMenuController.menuViewContainer.imagePosition = GAdjustButtonIMGPositionBottom;
GMenuController.sharedMenuController.menuViewContainer.menuViewHeight = 65;
[[GMenuController sharedMenuController] setMenuItems:arr1];
[[GMenuController sharedMenuController] setTargetRect:sender.frame inView:self.view];
[[GMenuController sharedMenuController] setMenuVisible:YES];
```

### Demo

<img src="https://github.com/GIKICoder/GMenuController/blob/master/snapshot/demo4.gif" width="320">
<img src="https://github.com/GIKICoder/GMenuController/blob/master/snapshot/demo5.png" width="320">
<img src="https://github.com/GIKICoder/GMenuController/blob/master/snapshot/demo6.png" width="320">
<img src="https://github.com/GIKICoder/GRichLabel/blob/master/screenshot/selectCopy.png" width="400">
<img src="https://github.com/GIKICoder/GRichLabel/blob/master/screenshot/novelReader.png" width="400">



