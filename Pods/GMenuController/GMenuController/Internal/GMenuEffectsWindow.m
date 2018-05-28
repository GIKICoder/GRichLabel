//
//  GMenuEffectsWindow.m
//  GMenuController
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GMenuEffectsWindow.h"
#import "GMenuViewContainer.h"

@interface GMenuEffectsWindow ()
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;
@property (nonatomic, weak) GMenuViewContainer * currentMenu;
@end

@implementation GMenuEffectsWindow

+ (instancetype)sharedWindow
{
    static GMenuEffectsWindow *inst = nil;
    if (inst == nil) {
        // iOS 9 compatible
        NSString *mode = [NSRunLoop currentRunLoop].currentMode;
        if (mode.length == 27 &&
            [mode hasPrefix:@"UI"] &&
            [mode hasSuffix:@"InitializationRunLoopMode"]) {
            return nil;
        }
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            inst = [self new];
            inst.frame = (CGRect){.size = GMenuScreenSize()};
            inst.userInteractionEnabled = NO;
            inst.windowLevel = UIWindowLevelStatusBar + 1;
            inst.hidden = NO;
            
            // for iOS 9:
            inst.opaque = NO;
            inst.backgroundColor = [UIColor clearColor];
            inst.layer.backgroundColor = [UIColor clearColor].CGColor;
    });
    return inst;
}

- (void)showMenu:(GMenuViewContainer *)menu animation:(BOOL)animation
{
    if(!menu) return;
    menu.alpha = 0;
    if(menu.superview != self) [self addSubview:menu];
    self.currentMenu = menu;
    [self updateWindowLevel];
    
    if (animation) {
        NSTimeInterval time =  0.16;
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            if (menu) {
                menu.alpha = 1;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:GMenuControllerDidShowMenuNotification object:nil];
        } completion:^(BOOL finished) {
            
        }];
    } else {
        menu.alpha = 1;
        [[NSNotificationCenter defaultCenter] postNotificationName:GMenuControllerDidShowMenuNotification object:nil];
    }
  
}

- (void)hideMenu:(GMenuViewContainer *)menu
{
    if (!menu) return;
    if (menu.superview != self) return;
    [menu initConfigs];
    [menu removeFromSuperview];
    menu = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:GMenuControllerDidHideMenuNotification object:nil];
}

- (void)updateWindowLevel
{
    UIApplication *app =  [UIApplication sharedApplication];
    if (!app) return;
    
    UIWindow *top = app.windows.lastObject;
    UIWindow *key = app.keyWindow;
    if (key && key.windowLevel > top.windowLevel) top = key;
    if (top == self) return;
    self.windowLevel = top.windowLevel + 1;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event] == NO) return nil;
    
    NSInteger count = self.subviews.count;
    UIView *fitView = nil;
    for (NSInteger i = count - 1; i >= 0; i--) {
        UIView *childView = self.subviews[i];
        CGPoint childP = [self convertPoint:point toView:childView];
        fitView = [childView hitTest:childP withEvent:event];
        if (fitView) {
            break;
        }
    }
    if (fitView) {
        return fitView;
    }
    if (self.currentMenu && self.currentMenu.superview && self.currentMenu.hasAutoHide) {
        [self hideMenu:self.currentMenu];
    }
    return nil;
}

CGSize GMenuScreenSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}

@end
