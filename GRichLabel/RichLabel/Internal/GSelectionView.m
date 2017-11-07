//
//  GSelectionView.m
//  GRichLabel
//
//  Created by GIKI on 2017/9/1.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GSelectionView.h"
#import "GTextUtils.h"

@interface GSelectionView ()

@property (nonatomic, strong) NSMutableArray * markViews;

@property (nonatomic, strong) NSMutableArray  *highlightViews;

@property (nonatomic, assign) BOOL  isShowCursor;

@property (nonatomic, assign) CGFloat  alphaValue;

@end


@implementation GSelectionView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = NO;
        self.clipsToBounds = NO;
        
        _isShowCursor = YES;
        
        _markViews = [NSMutableArray array];
        _highlightViews = [NSMutableArray array];
        
        self.alphaValue = 0.2;
        self.selectionColor = [UIColor colorWithRed:69/255.0 green:111/255.0 blue:238/255.0 alpha:1];
        self.highlightColor = [UIColor colorWithRed:69/255.0 green:111/255.0 blue:238/255.0 alpha:1];
        
        _leftCursor = [GCursor cursorWithDirection:GCursorDirectionLeft];
        _rightCursor = [GCursor cursorWithDirection:GCursorDirectionRight]; //self.font
        _leftCursor.hidden = YES;
        _rightCursor.hidden = YES;
        
        [self addSubview:_leftCursor];
        [self addSubview:_rightCursor];
        
    }
    return self;
}


- (void)setSelectionRects:(NSArray *)selectionRects
{
    _selectionRects = selectionRects;
    
    [self.markViews enumerateObjectsUsingBlock:^(UIView *markView, NSUInteger idx, BOOL * _Nonnull stop) {
        [markView removeFromSuperview];
    }];
    
    [self.markViews removeAllObjects];
    
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.pathRect.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    __block BOOL isFirst = YES;
    __block CGFloat lastPointY = 0;
    [selectionRects enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect rect =  CGRectFromString(obj);
        rect = CGRectStandardize(rect);
    
        if (isFirst) {
            _leftCursor.cursorHeight = rect.size.height;
            _rightCursor.cursorHeight = rect.size.height;
        }
        CGPoint cgPoint = CGPointApplyAffineTransform(rect.origin, transform);
        CGPoint point = CGPointMake(cgPoint.x, cgPoint.y-rect.size.height);
        if (lastPointY != 0) {
            if (point.y - lastPointY < 0) {
                point.y = lastPointY;
            }
        }
        rect.origin = point;
        if (self.linespace < 1) {
             rect.size.height += self.linespace;
        }

    
        lastPointY = rect.origin.y+rect.size.height;
        if (rect.size.width > 0 && rect.size.height > 0) {
            	
            UIView *mark = [[UIView alloc] initWithFrame:rect];
            //
            mark.backgroundColor = self.selectionColor;;
            mark.alpha = self.alphaValue;
            [self insertSubview:mark atIndex:0];
            [self.markViews addObject:mark];
        }
        
    }];
    
    if (_isShowCursor) {
        _isShowCursor = NO;
        _leftCursor.hidden = NO;
        _rightCursor.hidden = NO;
        CGRect leftCursorRect =  CGRectFromString([selectionRects objectAtIndex:0]);
        CGPoint leftCursorPoint = leftCursorRect.origin;
        leftCursorPoint = CGPointApplyAffineTransform(leftCursorPoint, transform);
        [_leftCursor showPoint:leftCursorPoint];
       
        
        CGRect rightCursorRect =  CGRectFromString([selectionRects lastObject]);
        CGPoint rightCursorPoint = rightCursorRect.origin;
        rightCursorPoint.x = rightCursorPoint.x + CGRectFromString([selectionRects lastObject]).size.width;
        rightCursorPoint = CGPointApplyAffineTransform(rightCursorPoint, transform);
        [_rightCursor showPoint:rightCursorPoint];
        
    }
}


- (void)showSelectionView:(NSArray*)selectionRects showCursor:(BOOL)isShowCursor
{
    _isShowCursor = isShowCursor;
    self.selectionRects = selectionRects;
}

- (void)hideSelectionView
{
    _isShowCursor = YES;
    _leftCursor.hidden = YES;
    _rightCursor.hidden = YES;
    [self.markViews enumerateObjectsUsingBlock:^(UIView *markView, NSUInteger idx, BOOL * _Nonnull stop) {
        [markView removeFromSuperview];
    }];
    
    [self.markViews removeAllObjects];
}

- (void)showHighlightViewWithRects:(NSArray*)hightLightRects withAppearance:(GTokenAppearance*)appearance;
{
    if (!hightLightRects) return;
    if (!appearance) return;
    
    _highlightRects = hightLightRects;
    [self.highlightViews enumerateObjectsUsingBlock:^(UIView *highView, NSUInteger idx, BOOL * _Nonnull stop) {
        [highView removeFromSuperview];
    }];
    
    [self.highlightViews removeAllObjects];
    
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    [hightLightRects enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect rect =  CGRectFromString(obj);
        rect = CGRectStandardize(rect);
  
        CGPoint po = CGPointApplyAffineTransform(rect.origin, transform);
        CGPoint poY = CGPointMake(po.x, po.y-rect.size.height);
        rect.origin = poY;
        
        if (rect.size.width > 0 && rect.size.height > 0) {
            
            UIView *high = [[UIView alloc] initWithFrame:rect];
            high.backgroundColor = appearance.fillColor;
            high.layer.cornerRadius = appearance.cornerRadius;
            high.layer.masksToBounds = YES;
            if (appearance.strokeColor && appearance.strokeWidth) {
                high.layer.borderWidth = appearance.strokeWidth;
                high.layer.borderColor = appearance.strokeColor.CGColor;
            }
            [self insertSubview:high atIndex:0];
            [self.highlightViews addObject:high];
        }
        
    }];
}

- (void)hideHighlightView
{
    [self.highlightViews enumerateObjectsUsingBlock:^(UIView *markView, NSUInteger idx, BOOL * _Nonnull stop) {
        [markView removeFromSuperview];
    }];
    
    [self.highlightViews removeAllObjects];
}

- (BOOL)isCursorContainsPoint:(CGPoint)point
{
    return [self isLeftCursorContainsPoint:point] || [self isRightCursorContainsPoint:point];
}

- (BOOL)isLeftCursorContainsPoint:(CGPoint)point
{
    if (_leftCursor.hidden == YES) {
        return NO;
    }
    
    CGRect startRect = [_leftCursor enlargeTouchRect];
    CGRect endRect = [_rightCursor enlargeTouchRect];
    if (CGRectIntersectsRect(startRect, endRect)) {
        CGFloat distStart = GetDistanceToPoint(point, CGRectGetCenter(startRect));
        CGFloat distEnd = GetDistanceToPoint(point, CGRectGetCenter(endRect));
        if (distEnd <= distStart) return NO;
    }
    return CGRectContainsPoint(startRect, point);
    
}

- (BOOL)isRightCursorContainsPoint:(CGPoint)point
{
    if (_rightCursor.hidden == YES) {
        return NO;
    }
    CGRect startRect = [_leftCursor enlargeTouchRect];
    CGRect endRect = [_rightCursor enlargeTouchRect];
    if (CGRectIntersectsRect(startRect, endRect)) {
        CGFloat distStart = GetDistanceToPoint(point, CGRectGetCenter(startRect));
        CGFloat distEnd = GetDistanceToPoint(point, CGRectGetCenter(endRect));
        if (distEnd > distStart) return NO;
    }
    return CGRectContainsPoint(endRect, point);
}


@end
