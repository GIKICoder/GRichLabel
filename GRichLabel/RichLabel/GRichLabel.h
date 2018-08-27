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
#import "NSAttributedString+GRichLabel.h"
#import "GMenuContextProtocol.h"

/**
 文本选择
 richLabel在scrollview等具有滚动功能的视图上。开启可以滚动选择文字。
 - GRichLabelScrollerAutoSelectNone: 不开启滚动选择
 - GRichLabelScrollerAutoSelectLine: 开启滚动选择，默认向下滚动一行
 - GRichLabelScrollerAutoSelectAll: 开启滚动选择，默认滚动到控件顶部或者底部
 */
typedef NS_ENUM(NSUInteger, GRichLabelScrollerAutoSelect) {
    GRichLabelScrollerAutoSelectNone,
    GRichLabelScrollerAutoSelectLine,
    GRichLabelScrollerAutoSelectAll,
};
@interface GRichLabel : UIView

@property (nonatomic, strong) NSString * text;

@property (nonatomic, strong) NSAttributedString *attributedString;

/// A quick attribute configuration class
/// Don't need to deal with complex NSAttributedString
@property (nonatomic, strong) GAttributedConfiguration * attributedConfig;

///GDrawTextBuilder class is a readonly class stores text layout result.
@property (nonatomic, strong) GDrawTextBuilder  *textBuilder;

@property (nonatomic, strong) id<GMenuContextProtocol> menuConfiguration;

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
 @default: 1 如果想要微信聊天那种效果，可设置为MAXFLOAT,会自动选择全部文本
 */
@property (nonatomic, assign) CGFloat  minSelectRange;

/**
 是否开启固定行高
 default:NO
 */
@property (nonatomic, assign) BOOL isFixedLineHeight;

/**
 richlabel的容器view
 如果开启canSelect,并且richLabel在scrollview等具有滚动功能的view上.
 滚动会和select文字选择冲突.
 需要把scrollview 传入来处理滚动事件
 */
@property (nonatomic, weak  ) __kindof UIScrollView   *contentScrollView;

/**
 是否可以滚动选择
 richLabel在scrollview等具有滚动功能的视图上。开启可以滚动选择文字。
 default：GRichLabelScrollerAutoSelectNone
 */
@property (nonatomic, assign) GRichLabelScrollerAutoSelect  scrollerAutoSelectType;


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
 隐藏Menu
 */
- (void)hideTextMenu;

/**
 获取当前选中文本
 
 @return NSString
 */
- (NSString*)getSelectText;

/**
 获取当前选中范围

 @return NSRange
 */
- (NSRange)getSelectRange;

/**
 获取当前richLabel所在的控制器

 @return UIViewController
 */
- (UIViewController*)getCurrentViewController;
@end

UIKIT_EXTERN NSNotificationName const GRichLabelWillSelectNotification;
UIKIT_EXTERN NSNotificationName const GRichLabelDidSelectNotification;
UIKIT_EXTERN NSNotificationName const GRichLabelDidCancelSelectNotification;
