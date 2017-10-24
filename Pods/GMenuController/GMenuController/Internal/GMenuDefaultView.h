//
//  GMenuDefaultView.h
//  GMenuController
//
//  Created by GIKI on 2017/9/29.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMenuControllerHeader.h"
@class GMenuItem,GMenuViewContainer;
@interface GMenuDefaultView : UIView
@property (nonatomic, strong) NSArray<GMenuItem*>* menuItems;
@property (nonatomic, assign) CGSize  maxSize;
@property (nonatomic, assign) CGSize  arrowSize;
@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic, strong) UIColor  *menuTintColor;
@property (nonatomic, assign) GMenuControllerArrowDirection  CorrectDirection;
+(instancetype)defaultView:(GMenuViewContainer*)container WithMenuItems:(NSArray<GMenuItem*>*)menuItems MaxSize:(CGSize)maxSize arrowSize:(CGSize)arrowSize AnchorPoint:(CGPoint)anchorPoint;
- (void)processLineWithMidX:(CGFloat)midX direction:(GMenuControllerArrowDirection)direction;
@end
