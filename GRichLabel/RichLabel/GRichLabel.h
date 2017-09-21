//
//  GRichLabel.h
//  GRichText
//
//  Created by GIKI on 2017/8/30.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GAttributedStringLayout.h"
#import "GDrawTextBuilder.h"

@interface GRichLabel : UIView

@property (nonatomic, strong) NSString * text;

@property (nonatomic, strong) NSAttributedString *attributedString;

@property (nonatomic, strong) GAttributedStringLayout * attributedLayout;
@property (nonatomic, strong) GDrawTextBuilder  *textBuilder;
/**
 是否开启异步绘制
 
 @brief: 内部使用YYAsyncLayer提供异步绘制任务
 @default: NO
 */
@property (nonatomic, assign) BOOL  displaysAsynchronously;

/**
 是否可拷贝
 
 @default: NO
 */
@property (nonatomic, assign) BOOL  canCopy;

/**
 最小的选择范围
 
 @brief: 开启canCopy 生效
 @default: 1
 */
@property (nonatomic, assign) CGFloat  minSelectRange;

/**
 richlabel的容器view
 如果开启canCopy,并且richLabel在scrollview等具有滚动功能的view上.
 滚动会和select文字选择冲突.
 需要把scrollview 传入来处理滚动事件
 */
@property (nonatomic, weak  ) __kindof UIScrollView   *contentScrollView;

/**
 选择框颜色
 @defalut: 219,226,250
 */
@property (nonatomic, strong) UIColor * selectionColor;

/**
 光标颜色
 @defalut: blueColor
 */
@property (nonatomic, strong) UIColor * cursorColor;


@end
