//
//  GRichLabel.m
//  GRichLabel
//
//  Created by GIKI on 2017/8/30.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GRichLabel.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>
#import "YYAsyncLayer.h"
#import "GCursor.h"
#import "GMagnifiter.h"
#import "GSelectionView.h"
#import "GTextUtils.h"
#import "GMagnifiterWindow.h"
#import "GLineLayout.h"
#import "UIView+GText.h"
#import "GEmojiRunDelegate.h"
#import "GEmojiConfigManager.h"
#import "GThrottleInvoke.h"
#import "GRichLabel+TextMenuConfiguration.h"

#define kLeftCursorTag 100
#define kRightCursorTag 200

NSNotificationName  const GRichLabelWillSelectNotification = @"GRichLabelWillSelectNotification";
NSNotificationName  const GRichLabelDidSelectNotification= @"GRichLabelDidSelectNotification";

NSNotificationName  const GRichLabelDidCancelSelectNotification= @"GRichLabelDidCancelSelectNotification";


@interface GRichLabel ()<YYAsyncLayerDelegate>

/// recognizer property
@property (nonatomic, strong) UILongPressGestureRecognizer *longRecognizer;

/// coreText property
@property (nonatomic, assign) NSRange selectedRange;//选择区域

/// select,magnifierView property
@property (strong, nonatomic) GMagnifiter *magnifierCaret;
@property (strong, nonatomic) GMagnifiter *magnifierRanged;
@property (nonatomic, strong) GSelectionView * selectionView;

/// container ViewController
@property (nonatomic, weak  ) UIViewController  * currentController;

/// 是否点击了高亮token文字
@property (nonatomic, assign) BOOL  isHighlightTouch;
/// 是否触发了长按手势
@property (nonatomic, assign) BOOL  isLongPressTouch;
/// richlabel所在控制器是否开启侧滑
@property (nonatomic, assign) BOOL  isPopPanGestureEnabled;
/// richlabel 父view 是否可滑动
@property (nonatomic, assign) BOOL  canScroller;

@property (nonatomic, strong) GAttributedToken * highToken;

@end

@implementation GRichLabel

#pragma mark - override Method

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self doInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self doInit];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.selectionView.frame = self.bounds;
}

+ (Class)layerClass
{
    [YYAsyncLayer defaultValueForKey:@"NODisplayAsyn"];
    return [YYAsyncLayer class];
}

- (void)dealloc
{
    [self releaseSelectionRanges];
}

- (void)doInit
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    if (!_selectionView) {
        _selectionView = [[GSelectionView alloc] initWithFrame:self.bounds];
        [self addSubview:_selectionView];
    }
}

#pragma mark - setter Method

/**
 设置rich label 是否支持copy/select
 
 @param canSelect YES/NO
 */
- (void)setCanSelect:(BOOL)canSelect
{
    if (_canSelect == canSelect) return;
    
    _canSelect = canSelect;
    if (canSelect) {
        self.minSelectRange = 1;
        _longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongRecognizerMethod:)];
        _longRecognizer.enabled = YES;
        [self addGestureRecognizer:_longRecognizer];
        if (!self.menuConfiguration) {
            GRichLabelWeakReference * reference = [GRichLabelWeakReference weakReference:self];
            self.menuConfiguration = reference.weakObj;
            if ([self.menuConfiguration respondsToSelector:@selector(ConfigMenuWithRichLabel:)]) {
                [self.menuConfiguration ConfigMenuWithRichLabel:reference.weakObj];
            }
        }
    } else {
        if (_longRecognizer) {
            _longRecognizer.enabled = NO;
        }
    }
}

/**
 是否开启异步绘制
 
 @param displaysAsynchronously YES/NO
 */
- (void)setDisplaysAsynchronously:(BOOL)displaysAsynchronously
{
    _displaysAsynchronously = displaysAsynchronously;
    ((YYAsyncLayer *)self.layer).displaysAsynchronously = displaysAsynchronously;
}

/**
 设置文本选择框颜色
 
 @param selectionColor UIColor
 */
- (void)setSelectionColor:(UIColor *)selectionColor
{
    _selectionColor = selectionColor;
    self.selectionView.selectionColor = selectionColor;
}

/**
 设置光标颜色
 
 @param cursorColor UIColor
 */
- (void)setCursorColor:(UIColor *)cursorColor
{
    _cursorColor = cursorColor;
    self.selectionView.leftCursor.color = cursorColor;
    self.selectionView.rightCursor.color = cursorColor;
}

- (void)setIsFixedLineHeight:(BOOL)isFixedLineHeight
{
    _isFixedLineHeight = isFixedLineHeight;
    if (self.textBuilder) {
        [self.textBuilder setFixedLineHeight:YES];
        [self contentNeedUpdate];
    }
}

- (void)setMenuConfiguration:(id<GMenuContextProtocol>)menuConfiguration
{
    _menuConfiguration = menuConfiguration;
    if ([_menuConfiguration respondsToSelector:@selector(ConfigMenuWithRichLabel:)]) {
        GRichLabelWeakReference * reference = [GRichLabelWeakReference weakReference:self];
        [_menuConfiguration ConfigMenuWithRichLabel:reference.weakObj];
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    GAttributedConfiguration *defaultConfig = [GAttributedConfiguration attributedConfig:text color:[UIColor blackColor] font:[UIFont systemFontOfSize:12]];
    self.attributedConfig = defaultConfig;
}

- (void)setattributedConfig:(GAttributedConfiguration *)attributedConfig
{
    _attributedConfig = attributedConfig;
    GDrawTextBuilder * builder = [GAttributedStringFactory createDrawTextBuilderWithAttributedConfig:attributedConfig boundSize:self.frame.size];
    self.textBuilder = builder;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    _attributedString = attributedString;
    self.textBuilder = [GDrawTextBuilder buildDrawTextSize:self.frame.size attributedString:attributedString];
}

- (void)setTextBuilder:(GDrawTextBuilder *)textBuilder
{
    _textBuilder = textBuilder;
    [textBuilder setFixedLineHeight:_isFixedLineHeight];
    _attributedString = textBuilder.attributedString;
    [self contentNeedUpdate];
    self.selectionView.pathRect = self.textBuilder.pathRect;
}

#pragma mark - update draw layer

- (void)contentNeedUpdate
{
    [self.layer setNeedsDisplay];
}


#pragma mark - YYAsyncLayerDelegate

- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask
{
    YYAsyncLayerDisplayTask * task = [[YYAsyncLayerDisplayTask alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    task.willDisplay = ^(CALayer * _Nonnull layer) {
        /// must be set
        layer.contentsScale =  [UIScreen mainScreen].scale;
    };
    
    task.display = ^(CGContextRef  _Nonnull context, CGSize size, BOOL (^ _Nonnull isCancelled)(void)) {
        
        if (isCancelled()) return;
        if (!weakSelf.textBuilder) return;
        
        [weakSelf.textBuilder drawAttributedText:context cancel:isCancelled];
        
    };
    
    task.didDisplay = ^(CALayer * _Nonnull layer, BOOL finished) {
        
    };
    
    return task;
}

#pragma mark - private Method

/**
 计算光标选择区域
 
 @return 光标选择区域
 */
- (NSArray *)calculateSelectRectPaths
{
    if (_selectedRange.length == 0 || _selectedRange.location == NSNotFound) {
        return nil;
    }
    
    NSMutableArray *pathRects = [[NSMutableArray alloc] init];
    for (GLineLayout *lineLayout in _textBuilder.lineLayouts) {
        CTLineRef line = (__bridge CTLineRef)lineLayout.line;
        CFRange lineRange = CTLineGetStringRange(line);
        NSRange rangeN = NSMakeRange(lineRange.location==kCFNotFound ? NSNotFound : lineRange.location, lineRange.length);
        NSRange intersection =  GetIntersectionToRange(rangeN, _selectedRange);
        if (intersection.length > 0) {
            ///相对line的原点的x值
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);
            
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
            CGFloat ascent, descent,leading;
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect selectionRect = CGRectMake(lineLayout.rect.origin.x + xStart, lineLayout.rect.origin.y-descent , xEnd - xStart, lineLayout.rect.size.height);
            self.selectionView.linespace = lineLayout.linespace;
            [pathRects addObject:NSStringFromCGRect(selectionRect)];
        }
        
    }
    return pathRects;
}

/**
 转换point 为 当前文本中的index
 
 @param point 点击区域
 @return 点击区域文字所在的index
 */
- (CFIndex)convertTouchPointToSelectIndex:(CGPoint)point
{
    CGPoint touchPoint = CGPointMake(point.x, self.textBuilder.pathRect.size.height-point.y);
    CFIndex index = kCFNotFound;
    for (GLineLayout *lineLayout in _textBuilder.lineLayouts) {
        
        if (CGRectContainsPoint(lineLayout.rect, touchPoint)){
            /// line的起始点
            CGPoint point = CGPointMake(touchPoint.x -lineLayout.rect.origin.x,0);
            index = CTLineGetStringIndexForPosition((__bridge CTLineRef)lineLayout.line, point);
            break;
        }
    }
    return index;
}

/**
 手指移动过程中,所在文字的区域
 
 @param point 点击区域
 @param isLeft 是否是左边光标
 @return 文字index
 */
- (CFIndex)moveConvertTouchPointToSelectIndex:(CGPoint)point isLeft:(BOOL)isLeft
{
    CGPoint touchPoint = CGPointMake(point.x, self.textBuilder.pathRect.size.height-point.y);
    CFIndex index = kCFNotFound;
    for (GLineLayout *lineLayout in _textBuilder.lineLayouts) {
        
        if (CGRectContainsPoint(lineLayout.rect, touchPoint)){
            /// line的起始点
            CGPoint point = CGPointMake(touchPoint.x -lineLayout.rect.origin.x,0);
            index = CTLineGetStringIndexForPosition((__bridge CTLineRef)lineLayout.line, point);
        } else {
            if (touchPoint.x>lineLayout.rect.origin.x+lineLayout.rect.size.width && lineLayout.rect.origin.y > touchPoint.y && lineLayout.rect.origin.y - lineLayout.rect.size.height < touchPoint.y) {
                /// line终点
                CGPoint pointOffset = CGPointMake(lineLayout.rect.origin.x+lineLayout.rect.size.width,0);
                index = CTLineGetStringIndexForPosition((__bridge CTLineRef)lineLayout.line, pointOffset);
            } else if (touchPoint.x < lineLayout.rect.origin.x && lineLayout.rect.origin.y > touchPoint.y && lineLayout.rect.origin.y - lineLayout.rect.size.height < touchPoint.y ) {
                /// line 起点
                CGPoint pointOffset = CGPointMake(0,0);
                index = CTLineGetStringIndexForPosition((__bridge CTLineRef)lineLayout.line, pointOffset);
            }
        }
    }
    return index;
}

/**
 长按手势 智能选择
 
 @param point 点击区域
 @return 选择范围
 */
- (NSRange)selectWordsRangeAtpoint:(CGPoint)point
{
    CGPoint touchPoint = CGPointMake(point.x, self.textBuilder.pathRect.size.height-point.y);
    __block CFIndex index;
    __block NSRange returnRange = NSMakeRange(NSNotFound, 0);
    NSInteger linesCount = _textBuilder.lineLayouts.count;
    __block NSRange selectRange = NSMakeRange(0, 0);
    [_textBuilder.lineLayouts enumerateObjectsUsingBlock:^(GLineLayout * _Nonnull lineLayout, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(lineLayout.rect, touchPoint)){
            CTLineRef line = (__bridge CTLineRef)lineLayout.line;
            CFRange currentRange = CTLineGetStringRange(line);
            CFRange nextRange = CFRangeMake(0, 0);
            NSRange range = NSMakeRange(currentRange.location == kCFNotFound ? NSNotFound : currentRange.location, currentRange.length == kCFNotFound ? 0 : currentRange.length);
            /// line的起始点
            CGPoint point = CGPointMake(touchPoint.x -lineLayout.rect.origin.x,0);
            index = CTLineGetStringIndexForPosition((__bridge CTLineRef)lineLayout.line, point);
            if (idx < linesCount - 1) {
                GLineLayout *nextLineLayout = [_textBuilder.lineLayouts objectAtIndex:idx+1];
                __block CTLineRef nextLine = (__bridge CTLineRef)nextLineLayout.line;
                nextRange = CTLineGetStringRange(nextLine);
            
                if (index >= range.location && index <= range.location+range.length && range.length > 1) {
                    range = NSMakeRange(range.location, range.length + nextRange.length);
                }
            }
            selectRange = range;
            *stop = YES;
        }
    }];
    if (selectRange.length <= 0) {
        return returnRange;
    }
    [GTextUtils enumerateSubstringsInRange:selectRange string:self.attributedString.string usingBlock:^(NSString *substring, NSRange subStringRange, BOOL *stop) {
        if (index - subStringRange.location <= subStringRange.length&&index - subStringRange.location!=0) {
            returnRange = subStringRange;
            /// 选择范围大于最小选择范围
            if (returnRange.length <= self.minSelectRange && self.attributedString.length > self.minSelectRange) {
                returnRange.length = self.minSelectRange;
            }
            *stop = YES;
        }
    }];
    
    return returnRange;
}

/**
 隐藏放大镜
 */
- (void)hideMaginfierView
{
    if (!_canSelect) return;
    
    [GMagnifiterINST hideMagnifier:self.magnifierCaret];
    [GMagnifiterINST hideMagnifier:self.magnifierRanged];
}

/**
 隐藏选择区域
 */
- (void)hideSelectionView
{
    [self.selectionView hideSelectionView];
}

/**
 隐藏点击高亮
 */
- (void)hideHighlightView
{
    [self.selectionView hideHighlightView];
}

/**
 隐藏menu
 */
- (void)hideMenu
{
    if (!_canSelect) return;
    if ([self.menuConfiguration respondsToSelector:@selector(HideRichLabelTextMenu)]) {
        [self.menuConfiguration HideRichLabelTextMenu];
    }
}

/**
 显示选择区域
 
 @param isShowCursor 是否显示光标
 */
- (void)showSelectionViewWithCursor:(BOOL)isShowCursor
{
    [GThrottleInvoke throttle:0.0005 block:^{
        [self throttleShowSelectionViewWithCursor:isShowCursor];
    }];
}

- (void)throttleShowSelectionViewWithCursor:(BOOL)isShowCursor
{
    if (_selectedRange.length == 0 || _selectedRange.location == NSNotFound ) {
        return;
    }
    
    [self hideSelectionView];
    
    NSArray * array = [self calculateSelectRectPaths];
    if (array) {
        [self.selectionView showSelectionView:array showCursor:isShowCursor];
    }
}

/**
 显示menu
 */
- (void)showMenu
{
    if (!_canSelect) return;
    
    _longRecognizer.enabled = NO;
    CGRect selectedRect =CGRectFromString([self.selectionView.selectionRects firstObject]);
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.textBuilder.pathRect.size.height);
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    selectedRect = CGRectApplyAffineTransform(selectedRect, transform);
    CGRect rect = [self convertRect:selectedRect toView:[UIApplication sharedApplication].keyWindow];
    if (rect.origin.x <0 || rect.origin.y < 0) {
        CGRect selectedRect =CGRectFromString([self.selectionView.selectionRects lastObject]);
        CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.textBuilder.pathRect.size.height);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        selectedRect = CGRectApplyAffineTransform(selectedRect, transform);
        if ([self.menuConfiguration respondsToSelector:@selector(ShowRichLabelTextMenuWithTargetRect:)]) {
             [self.menuConfiguration ShowRichLabelTextMenuWithTargetRect:selectedRect];
        }
    } else {
        if ([self.menuConfiguration respondsToSelector:@selector(ShowRichLabelTextMenuWithTargetRect:)]) {
            [self.menuConfiguration ShowRichLabelTextMenuWithTargetRect:selectedRect];
        }
    }
    
}

- (void)selectAllRange
{
    if (!_textBuilder.lineLayouts || _textBuilder.lineLayouts.count == 0) return;
    
    GLineLayout *lineLayout = [_textBuilder.lineLayouts lastObject];
    CFRange lastLineRange = CTLineGetStringRange((__bridge CTLineRef)lineLayout.line);
    _selectedRange = NSMakeRange(0, lastLineRange.location + lastLineRange.length);
}

/**
 重置文本选择区域
 */
- (void)releaseSelectionRanges
{
    _selectedRange.location = 0;
    _selectedRange.length = 0;
    self.selectionView.tag = 0;
    [self hideSelectionView];
    [self hideMenu];
    self.isLongPressTouch = NO;
    _longRecognizer.enabled = YES;
}

/**
 文本选择状态下.释放页面滚动
 */
- (void)scrollerEnable
{
    if (_canScroller == YES) {
        _canScroller = NO;
        self.contentScrollView.scrollEnabled = YES;
    }
}

/**
 文本选择状态下.禁止页面滚动
 */
- (void)scrollerDisable
{
    if (self.contentScrollView.scrollEnabled == YES) {
        _canScroller = YES;
        self.contentScrollView.scrollEnabled = NO;
    }
}

#pragma mark - 长按手势

- (void)LongRecognizerMethod:(UILongPressGestureRecognizer *)Recognizer
{
    CGPoint point = [Recognizer locationInView:self];
    if (Recognizer.state == UIGestureRecognizerStateBegan ||
        Recognizer.state == UIGestureRecognizerStateChanged){
        
        CFIndex index = [self convertTouchPointToSelectIndex:point];
        if (index != kCFNotFound && index <= self.attributedString.length) {
            /// 智能选择
            NSRange range = [self selectWordsRangeAtpoint:point];
            _selectedRange = NSMakeRange(range.location, range.length);
            
            [self showSelectionViewWithCursor:NO];
            
            if (!self.magnifierCaret) {
                self.magnifierCaret = [GMagnifiter magnifierWithType:GTextMagnifierTypeCaret];
                self.magnifierCaret.hostView = self;
            }
            self.magnifierCaret.hostView = self;
            self.magnifierCaret.hostPopoverCenter = point;
            self.magnifierCaret.hostCaptureCenter = point;
            
            if (self.magnifierCaret.superview) {
                [GMagnifiterINST moveMagnifier:self.magnifierCaret];
            } else {
                [GMagnifiterINST showMagnifier:self.magnifierCaret];
            }
        }
    }else{
        [self hideMaginfierView];
        [self showSelectionViewWithCursor:YES];
        if (_selectedRange.length == 0) {
            _isLongPressTouch = NO;
        }else{
            _isLongPressTouch = YES;
            [self showMenu];
        }
    }
    
}

#pragma mark - touche Methods

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    
    if (self.isLongPressTouch) {
        [self scrollerDisable];
        BOOL isSelectCursor = NO;
        /// 计算相应区域 未左还是右
        if ([self.selectionView isLeftCursorContainsPoint:point]) {
            isSelectCursor = YES;
            self.selectionView.tag = kLeftCursorTag;
        } else if ([self.selectionView isRightCursorContainsPoint:point]) {
            isSelectCursor = YES;
            self.selectionView.tag = kRightCursorTag;
        } else { /// 未选中
            [self scrollerEnable];
            isSelectCursor = NO;
            _isLongPressTouch = NO;
            [self releaseSelectionRanges];
        }
        
        if (isSelectCursor) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GRichLabelDidSelectNotification object:nil];
            [self hideMenu];
            if (!self.magnifierRanged) {
                self.magnifierRanged = [GMagnifiter magnifierWithType:GTextMagnifierTypeRanged];
                self.magnifierRanged.hostView = self;
                
            }
            self.magnifierRanged.hostCaptureCenter = point;
            self.magnifierRanged.hostPopoverCenter = point;
            if (self.magnifierRanged.superview) {
                [GMagnifiterINST moveMagnifier:self.magnifierRanged];
            } else {
                [GMagnifiterINST showMagnifier:self.magnifierRanged];
            }
        }
        return;
    }
    
    
    CFIndex index = [self convertTouchPointToSelectIndex:point];
    if (index == kCFNotFound || index == -1) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    NSRange range = {0};
    NSDictionary *dict = [self.attributedString attributesAtIndex:index effectiveRange:&range];
    
    if ([dict objectForKey:kGAttributeTokenHighlightName]) {
        GAttributedToken *token = dict[kGAttributeTokenHighlightName];
        if (token && [token isKindOfClass:[GAttributedToken class]]) {
            _isHighlightTouch = YES;
            self.highToken = token;
            _selectedRange = range;
            NSArray *path = [self calculateSelectRectPaths];
            [self.selectionView showHighlightViewWithRects:path withAppearance:token.tokenAppearance];
        }
    } else {
        [super touchesBegan:touches withEvent:event];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isLongPressTouch) {
        UITouch *touch = touches.anyObject;
        CGPoint point = [touch locationInView:self];
        
        [self hideMenu];
        
        BOOL isLeftCursor = YES;
        BOOL isMoveCursor = NO;
        if (self.selectionView.tag == kLeftCursorTag) {
            isLeftCursor = YES;
            isMoveCursor = YES;
        } else if (self.selectionView.tag == kRightCursorTag) {
            isLeftCursor = NO;
            isMoveCursor = YES;
        } else {
            isMoveCursor = NO;
        }
        
        CFIndex index = [self moveConvertTouchPointToSelectIndex:point isLeft:isLeftCursor];
        if (index == kCFNotFound) {
            return;
        }
        if ( self.selectionView.tag == kLeftCursorTag && index < _selectedRange.length + _selectedRange.location) {
            _selectedRange.length = _selectedRange.location - index + _selectedRange.length;
            _selectedRange.location = index;
        } else if (self.selectionView.tag == kRightCursorTag && index > _selectedRange.location ) {
            _selectedRange.location = _selectedRange.location;
            _selectedRange.length =  index - _selectedRange.location;
            isMoveCursor = YES;
        } else {
            isMoveCursor = NO;
        }
        
        
        if (isMoveCursor) {
            self.magnifierRanged.hostCaptureCenter = point;
            self.magnifierRanged.hostPopoverCenter = point;
            [GMagnifiterINST moveMagnifier:self.magnifierRanged];
            [self showSelectionViewWithCursor:YES];
        }
        
    } else {
        [super touchesMoved:touches withEvent:event];
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isLongPressTouch) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GRichLabelDidCancelSelectNotification object:nil];
        [self hideMaginfierView];
        if (_selectedRange.length > 0) {
            [self showMenu];
        }
        [self showSelectionViewWithCursor:YES];
        [self scrollerEnable];
        
        if (_isPopPanGestureEnabled) {
            _isPopPanGestureEnabled = NO;
            if ([self.currentController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.currentController.navigationController.interactivePopGestureRecognizer.enabled = YES;
            }
        }
    }
    
    if (_isHighlightTouch) {
        
        _isHighlightTouch = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideHighlightView];
        });
        
        if (self.highToken.tokenClickBlock) {
            self.highToken.tokenClickBlock(self.highToken);
        }
        if (self.highToken) {
            self.highToken = nil;
        }
    } else{
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isLongPressTouch) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GRichLabelDidCancelSelectNotification object:nil];
        [self hideMaginfierView];
        if (_selectedRange.length > 0) {
            [self showMenu];
        }
        [self showSelectionViewWithCursor:YES];
        [self scrollerEnable];
        if (_isPopPanGestureEnabled) {
            _isPopPanGestureEnabled = NO;
            if ([self.currentController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.currentController.navigationController.interactivePopGestureRecognizer.enabled = YES;
            }
        }
    }
    if (_isHighlightTouch) {
        _isHighlightTouch = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideHighlightView];
        });
        if (self.highToken) {
            self.highToken = nil;
        }
    } else {
        [super touchesCancelled:touches withEvent:event];
    }
    
}

/**
 hitTest Method
 @breif : 用于在选择文本过程中禁止掉系统侧滑手势. 系统侧滑手势会拦截选择光标.
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (_isLongPressTouch) {
        BOOL isHitCursor = NO;
        
        if ([self.selectionView isLeftCursorContainsPoint:point]) {
            isHitCursor = YES;
        } else if ([self.selectionView isRightCursorContainsPoint:point]) {
            isHitCursor = YES;
        } else {
            isHitCursor = NO;
        }
        if (isHitCursor) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GRichLabelWillSelectNotification object:nil];
            if (point.x > 60) {
                return self;
            }
            if (!self.currentController) {
                self.currentController = [self getViewController];
            }
            if (self.currentController) {
                
                if ([self.currentController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    if (self.currentController.navigationController.interactivePopGestureRecognizer.enabled == YES) {
                        self.currentController.navigationController.interactivePopGestureRecognizer.enabled = NO;
                        _isPopPanGestureEnabled = YES;
                    }
                }
            }
        }
    }
    return self;
}

/**
 获取当前richLabel 所在的控制器
 
 @return currentViewController
 */
- (UIViewController *)getViewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - public Method

/**
 选中全部文本区域
 */
- (void)setSelectAllRange
{
    [self selectAllRange];
}

/**
 重置文本选择区域
 */
- (void)resetSelection
{
    [self releaseSelectionRanges];
}

/**
 展示SelectionView
 */
- (void)showSelectionView
{
    [self showSelectionViewWithCursor:YES];
}

/**
 展示menu
 */
- (void)showTextMenu
{
    [self showMenu];
}

- (void)hideTextMenu
{
    [self hideMenu];
}

- (NSString *)getSelectText
{
    NSRange range = NSMakeRange(_selectedRange.location, _selectedRange.length);
    NSString *select = [self.attributedString.string substringWithRange:range];
    
    NSAttributedString *innerAttri = [self.attributedString attributedSubstringFromRange:range];
    NSMutableString *result = [NSMutableString string];
    if (range.length == 0) return result;
    NSString *string = select;
    [innerAttri enumerateAttribute:kGAttributeTokenReplaceStringName inRange:NSMakeRange(0, innerAttri.length) options:kNilOptions usingBlock:^(id value, NSRange range, BOOL *stop) {
        NSString *backed = value;
        if (backed) {
            [result appendString:backed];
        } else {
            [result appendString:[string substringWithRange:range]];
        }
    }];
    return result.copy;
}

- (NSRange)getSelectRange
{
    return self.selectedRange;
}

- (UIViewController*)getCurrentViewController
{
    if (!self.currentController) {
        self.currentController = [self getViewController];
    }
    return self.currentController;
}


@end
