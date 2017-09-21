//
//  GMagnifiterWindow.m
//  GRichTextExample
//
//  Created by GIKI on 2017/9/2.
//  Copyright © 2017年 GIKI. All rights reserved.
//


#import "GMagnifiterWindow.h"
#import "GTextUtils.h"
#import "GMagnifiter.h"
#import "UIView+GText.h"

@implementation GMagnifiterWindow

+ (instancetype)sharedWindow
{
    static GMagnifiterWindow *one = nil;
    if (one == nil) {
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
        if (!GTextIsAppExtension()) {
            one = [self new];
            one.frame = (CGRect){.size = GTextScreenSize()};
            one.userInteractionEnabled = NO;
            one.windowLevel = UIWindowLevelStatusBar + 1;
            one.hidden = NO;
            
            // for iOS 9:
            one.opaque = NO;
            one.backgroundColor = [UIColor clearColor];
            one.layer.backgroundColor = [UIColor clearColor].CGColor;
        }
    });
    return one;
}

- (void)showMagnifier:(GMagnifiter *)magnifiter
{
    if (!magnifiter) return;
    if (magnifiter.superview != self) [self addSubview:magnifiter];
    [self updateWindowLevel];
    CGFloat rotation = [self updateMagnifier:magnifiter];
    CGPoint center = [self convertPoint:magnifiter.hostPopoverCenter fromViewOrWindow:magnifiter.hostView];
    CGAffineTransform trans = CGAffineTransformMakeRotation(rotation);
    trans = CGAffineTransformScale(trans, 0.3, 0.3);
    magnifiter.transform = trans;
    magnifiter.center = center;
    if (magnifiter.type == GTextMagnifierTypeRanged) {
        magnifiter.alpha = 0;
    }
    NSTimeInterval time = magnifiter.type == GTextMagnifierTypeCaret ? 0.06 : 0.1;
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (magnifiter.type == GTextMagnifierTypeCaret) {
            CGPoint newCenter = CGPointMake(0, -magnifiter.fitSize.height / 2);
            newCenter = CGPointApplyAffineTransform(newCenter, CGAffineTransformMakeRotation(rotation));
            newCenter.x += center.x;
            newCenter.y += center.y;
            magnifiter.center = [self correctedCenter:newCenter forMagnifier:magnifiter rotation:rotation];
        } else {
            magnifiter.center = [self correctedCenter:center forMagnifier:magnifiter rotation:rotation];
        }
        magnifiter.transform = CGAffineTransformMakeRotation(rotation);
        magnifiter.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)moveMagnifier:(GMagnifiter *)magnifiter
{
    if (!magnifiter) return;
    [self updateWindowLevel];
    CGFloat rotation = [self updateMagnifier:magnifiter];
    CGPoint center = [self convertPoint:magnifiter.hostPopoverCenter fromViewOrWindow:magnifiter.hostView];
    if (magnifiter.type == GTextMagnifierTypeCaret) {
        CGPoint newCenter = CGPointMake(0, -magnifiter.fitSize.height / 2);
        newCenter = CGPointApplyAffineTransform(newCenter, CGAffineTransformMakeRotation(rotation));
        newCenter.x += center.x;
        newCenter.y += center.y;
        magnifiter.center = [self correctedCenter:newCenter forMagnifier:magnifiter rotation:rotation];
    } else {
        magnifiter.center = [self correctedCenter:center forMagnifier:magnifiter rotation:rotation];
    }
    magnifiter.transform = CGAffineTransformMakeRotation(rotation);
}

- (void)hideMagnifier:(GMagnifiter *)magnifiter
{
    if (!magnifiter) return;
    if (magnifiter.superview != self) return;
    CGFloat rotation = [self updateMagnifier:magnifiter];
    CGPoint center = [self convertPoint:magnifiter.hostPopoverCenter fromViewOrWindow:magnifiter.hostView];
    NSTimeInterval time = magnifiter.type == GTextMagnifierTypeCaret ? 0.20 : 0.15;
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        CGAffineTransform trans = CGAffineTransformMakeRotation(rotation);
        trans = CGAffineTransformScale(trans, 0.01, 0.01);
        magnifiter.transform = trans;
        
        if (magnifiter.type == GTextMagnifierTypeCaret) {
            CGPoint newCenter = CGPointMake(0, -magnifiter.fitSize.height / 2);
            newCenter = CGPointApplyAffineTransform(newCenter, CGAffineTransformMakeRotation(rotation));
            newCenter.x += center.x;
            newCenter.y += center.y;
            magnifiter.center = [self correctedCenter:newCenter forMagnifier:magnifiter rotation:rotation];
        } else {
            magnifiter.center = [self correctedCenter:center forMagnifier:magnifiter rotation:rotation];
            magnifiter.alpha = 0;
        }
        
    } completion:^(BOOL finished) {
        if (finished) {
            [magnifiter removeFromSuperview];
            magnifiter.transform = CGAffineTransformIdentity;
            magnifiter.alpha = 1;
        }
    }];

}

#pragma mark -- Private Method

// Bring self to front
- (void)updateWindowLevel
{
    UIApplication *app =  GTextSharedApplication();
    if (!app) return;
    
    UIWindow *top = app.windows.lastObject;
    UIWindow *key = app.keyWindow;
    if (key && key.windowLevel > top.windowLevel) top = key;
    if (top == self) return;
    self.windowLevel = top.windowLevel + 1;
}

/**
 Capture screen snapshot and set it to magnifier.
 @return Magnifier rotation radius.
 */
- (CGFloat)updateMagnifier:(GMagnifiter *)mag
{
    UIApplication *app = GTextSharedApplication();
    if (!app) return 0;
    
    UIView *hostView = mag.hostView;
    UIWindow *hostWindow = [hostView isKindOfClass:[UIWindow class]] ? (id)hostView : hostView.window;
    if (!hostView || !hostWindow) return 0;
    CGPoint captureCenter = [self convertPoint:mag.hostCaptureCenter fromViewOrWindow:hostView];
    
    CGRect captureRect = {.size = mag.snapshotSize};
    captureRect.origin.x = captureCenter.x - captureRect.size.width / 2;
    captureRect.origin.y = captureCenter.y - captureRect.size.height / 2;
    
    CGAffineTransform trans = GTextCGAffineTransformGetFromViews(hostView, self);
    CGFloat rotation = GTextCGAffineTransformGetRotation(trans);
    
    if (mag.captureDisabled) {
        if (!mag.snapshot || mag.snapshot.size.width > 1) {
            static UIImage *placeholder;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                CGRect rect = mag.bounds;
                rect.origin = CGPointZero;
                UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
                CGContextRef context = UIGraphicsGetCurrentContext();
                [[UIColor colorWithWhite:1 alpha:0.8] set];
                CGContextFillRect(context, rect);
                placeholder = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            });
            mag.captureFadeAnimation = YES;
            mag.snapshot = placeholder;
            mag.captureFadeAnimation = NO;
        }
        return rotation;
    }
    
    UIGraphicsBeginImageContextWithOptions(captureRect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return rotation;
    
    CGPoint tp = CGPointMake(captureRect.size.width / 2, captureRect.size.height / 2);
    tp = CGPointApplyAffineTransform(tp, CGAffineTransformMakeRotation(rotation));
    CGContextRotateCTM(context, -rotation);
    CGContextTranslateCTM(context, tp.x - captureCenter.x, tp.y - captureCenter.y);
    
    NSMutableArray *windows = app.windows.mutableCopy;
    UIWindow *keyWindow = app.keyWindow;
    if (![windows containsObject:keyWindow]) [windows addObject:keyWindow];
    [windows sortUsingComparator:^NSComparisonResult(UIWindow *w1, UIWindow *w2) {
        if (w1.windowLevel < w2.windowLevel) return NSOrderedAscending;
        else if (w1.windowLevel > w2.windowLevel) return NSOrderedDescending;
        return NSOrderedSame;
    }];
    UIScreen *mainScreen = [UIScreen mainScreen];
    for (UIWindow *window in windows) {
        if (window.hidden || window.alpha <= 0.01) continue;
        if (window.screen != mainScreen) continue;
        if ([window isKindOfClass:self.class]) break; //don't capture window above self
        CGContextSaveGState(context);
        CGContextConcatCTM(context, GTextCGAffineTransformGetFromViews(window, self));
        [window.layer renderInContext:context]; //render
        //[window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO]; //slower when capture whole window
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (mag.snapshot.size.width == 1) {
        mag.captureFadeAnimation = YES;
    }
    mag.snapshot = image;
    mag.captureFadeAnimation = NO;
    return rotation;
}

- (CGPoint)correctedCenter:(CGPoint)center forMagnifier:(GMagnifiter *)mag rotation:(CGFloat)rotation {
    CGFloat degree = rotation* 180 / M_PI;
    
    degree /= 45.0;
    if (degree < 0) degree += (int)(-degree/8.0 + 1) * 8;
    if (degree > 8) degree -= (int)(degree/8.0) * 8;
    
    CGFloat caretExt = 10;
    if (degree <= 1 || degree >= 7) { //top
        if (mag.type == GTextMagnifierTypeCaret) {
            if (center.y < caretExt)
                center.y = caretExt;
        } else if (mag.type == GTextMagnifierTypeRanged) {
            if (center.y < mag.bounds.size.height)
                center.y = mag.bounds.size.height;
        }
    } else if (1 < degree && degree < 3) { // right
        if (mag.type == GTextMagnifierTypeCaret) {
            if (center.x > self.bounds.size.width - caretExt)
                center.x = self.bounds.size.width - caretExt;
        } else if (mag.type == GTextMagnifierTypeRanged) {
            if (center.x > self.bounds.size.width - mag.bounds.size.height)
                center.x = self.bounds.size.width - mag.bounds.size.height;
        }
    } else if (3 <= degree && degree <= 5) { // bottom
        if (mag.type == GTextMagnifierTypeCaret) {
            if (center.y > self.bounds.size.height - caretExt)
                center.y = self.bounds.size.height - caretExt;
        } else if (mag.type == GTextMagnifierTypeRanged) {
            if (center.y > mag.bounds.size.height)
                center.y = mag.bounds.size.height;
        }
    } else if (5 < degree && degree < 7) { // left
        if (mag.type == GTextMagnifierTypeCaret) {
            if (center.x < caretExt)
                center.x = caretExt;
        } else if (mag.type == GTextMagnifierTypeRanged) {
            if (center.x < mag.bounds.size.height)
                center.x = mag.bounds.size.height;
        }
    }
    
    return center;
}

#pragma mark - helper Method

@end
