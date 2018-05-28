GMenuController
==============
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/GIKICoder/GMenuController/blob/master/LICENSE)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS7+-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/GMenuController.svg?style=flat)](http://cocoapods.org/pods/GMenuController)&nbsp;

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

### other
```objc
///menuView弹出状态下.点击空白区域默认自动隐藏.如何不需要自动隐藏设置:
[GMenuController sharedMenuController].menuViewContainer.hasAutoHide = NO;
```

```objc
///更多menuView属性设置

/**
menuView 填充颜色 Defulat:[UIColor colorWithRed:26/255 green:26/288 blue:27/255 alpha:1]
*/
@property (nonatomic, strong) UIColor  *fillColor;

/**
menuView 圆角
*/
@property(nonatomic, assign) CGFloat cornerRadius;

/**
三角箭头的大小，defulat:CGSizeMake(17, 9.7) 系统menu箭头size
*/
@property(nonatomic, assign) CGSize arrowSize ;

/**
箭头指向
GMenuControllerArrow Default: 会自动计算合适的箭头方向
*/
@property(nonatomic, assign) GMenuControllerArrowDirection arrowDirection ;

/**
如果menuItem 有图片. 指定图片与文字的排列. Default:GAdjustButtonIMGPositionLeft
*/
@property (nonatomic, assign) GAdjustButtonIMGPosition  imagePosition;

/**
menuItemFont Default:14
*/
@property (nonatomic, strong) UIFont * menuItemFont;

/**
menuItemColor Default:whiteColor
*/
@property (nonatomic, strong) UIColor * menuItemTintColor;

/**
menuItemHighlightColor Default:lightGaryColor
*/
@property (nonatomic, strong) UIColor * menuItemHighlightColor;
/**
menu高度 Default:45.34f
*/
@property (nonatomic, assign) CGFloat  menuViewHeight;

/**
menu最大宽度
默认screenWidth
真实宽度需要减去menuEdgeInset
*/
@property (nonatomic, assign) CGFloat  maxMenuViewWidth;

/**
箭头与目标view的间隙
*/
@property(nonatomic, assign) CGFloat arrowMargin;

/**
menuView 与屏幕边缘的间隙
*/
@property(nonatomic, assign) UIEdgeInsets menuEdgeInset;
```
安装
==============

### CocoaPods

1. Update cocoapods to the latest version.
2. Add `pod 'GMenuController'` to your Podfile.
3. Run `pod install` or `pod update`.
4. Import "GMenuController.h"

### 手动添加
1. ` git clone  https://github.com/GIKICoder/GMenuController.git `
2. 选择`GMenuController`文件夹.拖入项目中即可.


Demo
==============
### Demo

<img src="https://github.com/GIKICoder/GMenuController/blob/master/snapshot/demo4.gif" width="320">
<img src="https://github.com/GIKICoder/GMenuController/blob/master/snapshot/demo5.png" width="320">
<img src="https://github.com/GIKICoder/GMenuController/blob/master/snapshot/demo6.png" width="320">
<img src="https://github.com/GIKICoder/GRichLabel/blob/master/screenshot/selectCopy.png" width="400">
<img src="https://github.com/GIKICoder/GRichLabel/blob/master/screenshot/novelReader.png" width="400">



