//
//  GCursor.m
//  GRichLabel
//
//  Created by GIKI on 2017/8/29.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GCursor.h"

#define kCursorW 2
#define kGestureW 22
#define kDotGestureW 16

@interface GCursor()
{
    UIImageView *_dotView;
}

@end

@implementation GCursor

+ (instancetype)cursorWithDirection:(GCursorDirection)direction
{
    GCursor *cursor = [[GCursor alloc] init];
    cursor.direction = direction;
    return cursor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dotView = [[UIImageView alloc] init];//WithImage:[UIImage imageNamed:@"r_drag-dot.png"
        
        CGRect dotRect = _dotView.frame;
        dotRect.size = CGSizeMake(12,12);
        _dotView.frame = dotRect;
        _dotView.layer.cornerRadius = 6;
        _dotView.layer.masksToBounds = YES;
        self.color = [UIColor blueColor];
        self.clipsToBounds = NO;
        self.cursorHeight = 26;
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    self.backgroundColor = color;
    _dotView.backgroundColor = color;
}

- (void)setDirection:(GCursorDirection)direction
{
    _direction = direction;
}

- (void)showPoint:(CGPoint)point
{
    if (![self.subviews containsObject:_dotView]) {
        [self addSubview:_dotView];
    }

    CGRect dotRect = _dotView.frame;
    
    if (_direction == GCursorDirectionRight) {
        self.frame = CGRectMake(point.x, point.y - _cursorHeight, kCursorW, _cursorHeight);
        dotRect.origin.x = -(dotRect.size.width - kCursorW)/2;
        dotRect.origin.y =  _cursorHeight - dotRect.size.height*0.3 ;
    } else if (_direction == GCursorDirectionLeft) {
        self.frame = CGRectMake(point.x - kCursorW, point.y - _cursorHeight, kCursorW, _cursorHeight);
        dotRect.origin.x = -(dotRect.size.width - kCursorW)/2;
        dotRect.origin.y = - dotRect.size.height*0.7;
    } else {
        [_dotView removeFromSuperview];
    }
    _dotView.frame = dotRect;
}

- (CGRect)enlargeTouchRect
{
    CGRect rect = CGRectInset(self.frame, -kGestureW, -kGestureW);
    UIEdgeInsets insets = {0};
    if (_direction == GCursorDirectionRight) {
        insets.right = -kDotGestureW;
    } else if (_direction == GCursorDirectionLeft) {
        insets.left = -kDotGestureW;
    }
    rect = UIEdgeInsetsInsetRect(rect, insets);
    return rect;
}

@end
