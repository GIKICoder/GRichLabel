//
//  GMenuContainer.h
//  GMenuController
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMenuController.h"
#import "GMenuDefaultView.h"
@interface GMenuViewContainer : UIView

/**
 menuView
 */
@property(nonatomic, strong) GMenuDefaultView *menuView;

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
 GMenuControllerArrowDefault: 会自动计算合适的箭头方向
 */
@property(nonatomic, assign) GMenuControllerArrowDirection arrowDirection ;

/**
 menu高度
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

@property (nonatomic, strong) NSArray<GMenuItem*> * menuItems;

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView;

- (void)processMenuFrame;

@end
