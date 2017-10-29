//
//  GRichLabel.h
//  GRichLabel
//
//  Created by GIKI on 2017/8/30.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAttributedConfiguration.h"
#import "GDrawTextBuilder.h"
#import "NSAttributedString+GText.h"
@class GTextMenuConfiguration;
@interface GRichLabel : UIView

@property (nonatomic, strong) NSString * text;

@property (nonatomic, strong) NSAttributedString *attributedString;

/// A quick attribute configuration class
/// Don't need to deal with complex NSAttributedString
@property (nonatomic, strong) GAttributedConfiguration * attributedConfig;

///GDrawTextBuilder class is a readonly class stores text layout result.
@property (nonatomic, strong) GDrawTextBuilder  *textBuilder;

@property (nonatomic, strong,readonly) GTextMenuConfiguration * menuConfiguration;

/**
 是否开启异步绘制
 
 @brief: 内部使用YYAsyncLayer提供异步绘制任务
 @default: NO
 */
@property (nonatomic, assign) BOOL  displaysAsynchronously;

/**
 是否开启文本选择操作
 
 @default: NO
 */
@property (nonatomic, assign) BOOL  canSelect;

/**
 最小的选择范围
 
 @brief: 开启canSelect 生效
 @default: 1
 */
@property (nonatomic, assign) CGFloat  minSelectRange;

/**
 richlabel的容器view
 如果开启canSelect,并且richLabel在scrollview等具有滚动功能的view上.
 滚动会和select文字选择冲突.
 需要把scrollview 传入来处理滚动事件
 */
@property (nonatomic, weak  ) __kindof UIScrollView   *contentScrollView;

/**
 选择框颜色
 @default: 219,226,250
 */
@property (nonatomic, strong) UIColor * selectionColor;

/**
 光标颜色
 @default: blueColor
 */
@property (nonatomic, strong) UIColor * cursorColor;

/**
 rich label 最大行数
 
 @Default value is 1.
 0 means no limit.
 */
//@property (nonatomic, assign) NSUInteger numberOfLines;  //// 暂未实现
#pragma mark - public Method

/**
 选中全部文本区域
 */
- (void)setSelectAllRange;

/**
 重置文本选择区域
 */
- (void)resetSelection;

/**
 展示SelectionView
 */
- (void)showSelectionView;

/**
 展示menu
 */
- (void)showTextMenu;

/**
 获取当前选中文本
 
 @return NSString
 */
- (NSString*)getSelectText;

/**
 获取当前richLabel所在的控制器

 @return UIViewController
 */
- (UIViewController*)getCurrentViewController;
@end
