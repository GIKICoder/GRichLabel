//
//  GMenuContainer.h
//  GMenuController
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMenuDefaultView.h"
#import "GAdjustButton.h"

@interface GMenuViewContainer : UIView

/**
 点击非menuViewContainer 区域.自动隐藏. Defulat:YES
 */
@property (nonatomic, assign) BOOL  hasAutoHide;

/**
 menuView
 */
@property(nonatomic, strong) GMenuDefaultView *menuView;

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

@property (nonatomic, strong) NSArray<GMenuItem*> * menuItems;

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView;

- (void)processMenuFrame;

- (void)initConfigs;
@end
