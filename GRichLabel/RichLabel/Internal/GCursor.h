//
//  GCursor.h
//  GRichText
//
//  Created by GIKI on 2017/8/29.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, GCursorDirection) {
    GCursorDirectionLeft,
    GCursorDirectionRight,
};

@interface GCursor : UIView

@property (nonatomic,assign) GCursorDirection direction;
@property (nonatomic,assign) CGFloat cursorHeight;
@property (nonatomic,strong) UIColor *color;

+ (instancetype)cursorWithDirection:(GCursorDirection)direction;

- (CGRect)enlargeTouchRect;
- (void)showPoint:(CGPoint)point;

@end
