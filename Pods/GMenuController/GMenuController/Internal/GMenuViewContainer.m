//
//  GMenuViewContainer.m
//  GMenuController
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GMenuViewContainer.h"
#import "GMenuEffectsWindow.h"
#import "GMenuController.h"
#define GMenuStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height
#define GMenuScreenHeight [UIScreen mainScreen].bounds.size.height
#define GMenuScreenWidth [UIScreen mainScreen].bounds.size.width
static inline CGPoint GMenuGetXCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), rect.origin.y);
}


@interface GMenuViewContainer()
{
    CGFloat _arrowMidx;
}
@property (nonatomic, strong) CAShapeLayer    *contentLayer;
@property (nonatomic, assign) CGPoint  AnchorPoint;  ///锚点
@property (nonatomic, assign) CGRect  targetRect;
@property (nonatomic, weak  ) UIView  *targetView;
@property (nonatomic, assign) GMenuControllerArrowDirection  CorrectDirection;
@end

@implementation GMenuViewContainer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.contentLayer];
        [self initConfigs];
    }
    return self;
}

- (void)dealloc
{
    //NSLog(@"GMenuController Dealloc~");
}

- (void)initConfigs
{
    self.hasAutoHide = YES;
    self.cornerRadius = 6;
    self.arrowDirection = GMenuControllerArrowDefault;
    self.arrowSize = CGSizeMake(17, 9.7);
    self.menuItemFont = [UIFont systemFontOfSize:14];
    self.imagePosition = GAdjustButtonIMGPositionLeft;
    self.arrowMargin = 5.5;
    self.menuEdgeInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.menuViewHeight = 45.34;
    self.maxMenuViewWidth = GMenuScreenWidth;
    self.menuItemTintColor = [UIColor whiteColor];
    self.menuItemHighlightColor = [UIColor lightGrayColor];
    self.contentLayer.fillColor = [UIColor colorWithRed:26/255 green:26/288 blue:27/255 alpha:1].CGColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize arrowSize = self.arrowSize;
    CGRect roundedRect = CGRectMake(0, (self.CorrectDirection == GMenuControllerArrowUp ? 0 : arrowSize.height), CGRectGetWidth(self.bounds) , CGRectGetHeight(self.bounds) - arrowSize.height);
    CGRect menuRect = self.menuView.frame;
    menuRect.origin.y = (self.CorrectDirection == GMenuControllerArrowUp ? 0 : arrowSize.height);
    //    self.menuView.frame = menuRect;
    
    CGFloat arrowMidx = self.AnchorPoint.x - self.frame.origin.x;
    if ((self.AnchorPoint.x-arrowSize.width/2)<(self.frame.origin.x+self.cornerRadius+3)) {
        arrowMidx = self.cornerRadius+3+arrowSize.width/2;
    }
    if ((self.AnchorPoint.x+arrowSize.width/2)>CGRectGetMaxX(self.frame)) {
        arrowMidx = roundedRect.size.width - self.cornerRadius-arrowSize.width/2-3;
    }
    _arrowMidx = arrowMidx;
    CGFloat cornerRadius = self.cornerRadius;
    
    [self.menuView processLineWithMidX:arrowMidx direction:_CorrectDirection];
    
    
    CGPoint leftTopArcCenter = CGPointMake(CGRectGetMinX(roundedRect) + cornerRadius, CGRectGetMinY(roundedRect) + cornerRadius);
    CGPoint leftBottomArcCenter = CGPointMake(leftTopArcCenter.x, CGRectGetMaxY(roundedRect) - cornerRadius);
    CGPoint rightTopArcCenter = CGPointMake(CGRectGetMaxX(roundedRect) - cornerRadius, leftTopArcCenter.y);
    CGPoint rightBottomArcCenter = CGPointMake(rightTopArcCenter.x, leftBottomArcCenter.y);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(leftTopArcCenter.x, CGRectGetMinY(roundedRect))];
    [path addArcWithCenter:leftTopArcCenter radius:cornerRadius startAngle:M_PI * 1.5 endAngle:M_PI clockwise:NO];
    [path addLineToPoint:CGPointMake(CGRectGetMinX(roundedRect), leftBottomArcCenter.y)];
    [path addArcWithCenter:leftBottomArcCenter radius:cornerRadius startAngle:M_PI endAngle:M_PI * 0.5 clockwise:NO];
    
    if (self.CorrectDirection == GMenuControllerArrowUp) {
        //始画三角形，箭头向下
        [path addLineToPoint:CGPointMake(arrowMidx-arrowSize.width / 2, CGRectGetMaxY(roundedRect))];
        [path addLineToPoint:CGPointMake(arrowMidx , CGRectGetMaxY(roundedRect) + arrowSize.height)];
        [path addLineToPoint:CGPointMake(arrowMidx + arrowSize.width / 2, CGRectGetMaxY(roundedRect))];
    }
    
    [path addLineToPoint:CGPointMake(rightBottomArcCenter.x, CGRectGetMaxY(roundedRect))];
    [path addArcWithCenter:rightBottomArcCenter radius:cornerRadius startAngle:M_PI * 0.5 endAngle:0.0 clockwise:NO];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(roundedRect), rightTopArcCenter.y)];
    [path addArcWithCenter:rightTopArcCenter radius:cornerRadius startAngle:0.0 endAngle:M_PI * 1.5 clockwise:NO];
    
    if (self.CorrectDirection == GMenuControllerArrowDown) {
        // 箭头向上
        [path addLineToPoint:CGPointMake(arrowMidx + arrowSize.width/ 2, CGRectGetMinY(roundedRect))];
        [path addLineToPoint:CGPointMake(arrowMidx, CGRectGetMinY(roundedRect) - arrowSize.height)];
        [path addLineToPoint:CGPointMake(arrowMidx- arrowSize.width / 2, CGRectGetMinY(roundedRect))];
    }
    [path closePath];
    
    self.contentLayer.path = path.CGPath;
    self.contentLayer.frame = self.bounds;
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    if (fillColor) {
        self.contentLayer.fillColor = fillColor.CGColor;
    }
}

- (void)setMenuViewHeight:(CGFloat)menuViewHeight
{
    _menuViewHeight = menuViewHeight;
    [self processMenuFrame];
}

- (void)setMaxMenuViewWidth:(CGFloat)maxMenuViewWidth
{
    _maxMenuViewWidth = maxMenuViewWidth;
    [self processMenuFrame];
}

-(void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self processMenuFrame];
}

- (void)setArrowSize:(CGSize)arrowSize
{
    _arrowSize = arrowSize;
    [self processMenuFrame];
}

- (void)setArrowMargin:(CGFloat)arrowMargin
{
    _arrowMargin = arrowMargin;
    [self processMenuFrame];
}

- (void)setMenuEdgeInset:(UIEdgeInsets)menuEdgeInset
{
    _menuEdgeInset = menuEdgeInset;
    [self processMenuFrame];
}

- (void)setArrowDirection:(GMenuControllerArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self processMenuFrame];
}

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView
{
    self.targetRect =targetRect;
    self.targetView = targetView;
    [self processMenuFrame];
}

- (void)setMenuItems:(NSArray<GMenuItem *> *)menuItems
{
    _menuItems = menuItems;
    if (menuItems) {
        [self processMenuFrame];
    }
}

- (void)setImagePosition:(GAdjustButtonIMGPosition)imagePosition
{
    _imagePosition = imagePosition;
    [self processMenuFrame];
}

- (void)setMenuItemFont:(UIFont *)menuItemFont
{
    _menuItemFont = menuItemFont;
    if (menuItemFont) {
        [self processMenuFrame];
    }
}

- (void)setMenuItemTintColor:(UIColor *)menuItemTintColor
{
    _menuItemTintColor = menuItemTintColor;
    if (menuItemTintColor) {
        [self processMenuFrame];
    }
}

- (void)setMenuItemHighlightColor:(UIColor *)menuItemHighlightColor
{
    _menuItemHighlightColor = menuItemHighlightColor;
    if (menuItemHighlightColor) {
        [self processMenuFrame];
    }
}
- (void)processMenuFrame
{
    if (!self.targetView) return;
    if (CGRectEqualToRect(self.targetRect, CGRectZero)) return;
    if (_menuItems.count == 0 ) return;
    
    
    CGRect rect = [self.targetView convertRect:self.targetRect toView:[GMenuEffectsWindow sharedWindow]];
   
    if (self.menuView.superview) {
        [self.menuView removeFromSuperview];
    }
    self.menuView = [GMenuDefaultView defaultView:self WithMenuItems:_menuItems MaxSize:CGSizeMake(_maxMenuViewWidth-_menuEdgeInset.left-_menuEdgeInset.right, _menuViewHeight) arrowSize:_arrowSize AnchorPoint:CGPointZero];
    [self addSubview:self.menuView];
    CGRect menuRect = self.menuView.frame;
    //    menuRect.size.height += _arrowSize.height;
    self.AnchorPoint = [self calculateAnchorPoint:rect menuViewSize:menuRect.size];
    [self.menuView setCorrectDirection:self.CorrectDirection];
    
    if (self.AnchorPoint.x < GMenuScreenWidth/2) {
        if ((self.AnchorPoint.x-menuRect.size.width/2)>self.menuEdgeInset.left) {
            menuRect.origin.x = (self.AnchorPoint.x-menuRect.size.width/2);
        } else {
            menuRect.origin.x = self.menuEdgeInset.left;
        }
    } else {
        if ((self.AnchorPoint.x + menuRect.size.width/2)>(GMenuScreenWidth-self.menuEdgeInset.right)) {
            menuRect.origin.x = (GMenuScreenWidth - self.menuEdgeInset.right-menuRect.size.width);
        } else {
            menuRect.origin.x =(self.AnchorPoint.x - menuRect.size.width/2);
        }
    }
    
    switch (self.CorrectDirection) {
        case GMenuControllerArrowUp:
        {
            menuRect.origin.y = self.AnchorPoint.y-menuRect.size.height;
        }
            break;
        case GMenuControllerArrowDown:
        {
            menuRect.origin.y = self.AnchorPoint.y;
            
        }
            break;
        default:
            break;
    }
    
    if (!CGRectEqualToRect(self.frame, menuRect)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GMenuControllerMenuFrameDidChangeNotification object:nil];
    }
    self.frame = menuRect;
    
    [self setNeedsLayout];
}

- (CGPoint)calculateAnchorPoint:(CGRect)targetRect menuViewSize:(CGSize)size
{
    CGPoint centerPoint = GMenuGetXCenter(targetRect);
    if (centerPoint.x < 0 || centerPoint.x > GMenuScreenWidth) {
        centerPoint.x = GMenuScreenWidth/2;
    }
    if (centerPoint.y < 0 || centerPoint.y > GMenuScreenHeight) {
        centerPoint.y = GMenuScreenHeight/2;
    }
    CGPoint targetPoint = CGPointMake(centerPoint.x, centerPoint.y);

    CGSize tempSize = size;
    switch (self.arrowDirection) {
        case GMenuControllerArrowDefault:
            if ((targetPoint.y - self.arrowMargin - tempSize.height) > GMenuStatusBarHeight) {
                self.CorrectDirection = GMenuControllerArrowUp;
                targetPoint.y -= self.arrowMargin;
            } else {
                self.CorrectDirection = GMenuControllerArrowDown;
                targetPoint.y += (targetRect.size.height + self.arrowMargin);
            }
            break;
        case GMenuControllerArrowUp:
            self.CorrectDirection = GMenuControllerArrowUp;
            if ((targetPoint.y - self.arrowMargin - tempSize.height) < GMenuStatusBarHeight) {
                targetPoint.y += (GMenuStatusBarHeight - (targetPoint.y - self.arrowMargin - tempSize.height));
            } else {
                targetPoint.y  -= self.arrowMargin;
            }
            break;
        case GMenuControllerArrowDown:
            self.CorrectDirection = GMenuControllerArrowDown;
            if ((targetPoint.y+targetRect.size.height+tempSize.height+self.arrowMargin) >([UIScreen mainScreen].bounds.size.height-self.menuEdgeInset.bottom)) {
                targetPoint.y += (targetRect.size.height+self.arrowMargin);
                targetPoint.y -= ((targetPoint.y+tempSize.height+self.arrowMargin)-([UIScreen mainScreen].bounds.size.height-self.menuEdgeInset.bottom));
            } else {
                targetPoint.y += (targetRect.size.height+self.arrowMargin);
            }
            break;
        default:
            break;
    }
    
    return targetPoint;
}


@end
