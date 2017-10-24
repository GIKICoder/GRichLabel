//
//  GTagFlowContainer.m
//  GBigbangExample
//
//  Created by GIKI on 2017/10/20.
//  Copyright © 2017年 GIKI. All rights reserved.
//
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#import "GTagFlowContainer.h"
@interface GTagFlowContainer ()
@property (nonatomic, strong) UIView *menuBackgroundView;
@property (nonatomic, strong,readwrite) GTagFlowView * flowView;
@property (nonatomic, strong) UIView * topContentView;
@property (nonatomic, strong) UIButton * closeBtn;
@property (nonatomic, assign) CGFloat  maxFlowViewHeight;
@end

@implementation GTagFlowContainer

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:kGPopContainerHiddenKey object:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)relodLayoutWithCollectionHeight:(CGFloat)height
{
    if (height < self.maxFlowViewHeight) {
        self.flowView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height - height)/2 , self.frame.size.width, height);
    } else {
        self.flowView.frame = CGRectMake(0,75 , self.frame.size.width, self.maxFlowViewHeight);
    }
    self.closeBtn.frame = CGRectMake((self.frame.size.width - 50)/2, CGRectGetMaxY(self.flowView.frame) + 20, 50, 25);
    self.topContentView.frame = CGRectMake(0, CGRectGetMinY(self.flowView.frame)-50, self.frame.size.width, 40);
}

- (void)loadUI
{
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.maxFlowViewHeight = [UIScreen mainScreen].bounds.size.height - 70 - 90;
    
    self.flowView = [[GTagFlowView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.flowView.heightChangedBlock = ^(CGFloat original, CGFloat newHeight) {
        [weakSelf relodLayoutWithCollectionHeight:newHeight];
    };
    self.flowView.selectedChangedBlock = ^(BOOL hasSelected) {
        weakSelf.topContentView.hidden = !hasSelected;
    };
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *close = [self drawCloseImageSize:CGSizeMake(10, 10) lineWidth:1 tintColor:nil];
    [self.closeBtn setImage:close forState:UIControlStateNormal];
    self.closeBtn.layer.cornerRadius = 4;
    self.closeBtn.layer.masksToBounds = YES;
    self.closeBtn.backgroundColor = [UIColor blackColor];
    [self.closeBtn addTarget:self action:@selector(closeContanier:) forControlEvents:UIControlEventTouchUpInside];
    
    self.topContentView = [UIView new];
    self.topContentView.hidden = YES;
    
    [self addSubview:self.menuBackgroundView];
    [self addSubview:self.flowView];
    [self addSubview:self.closeBtn];
    [self addSubview:self.topContentView];
    self.flowView.frame = CGRectMake(0,75 , self.frame.size.width, self.maxFlowViewHeight);
    self.closeBtn.frame = CGRectMake((self.frame.size.width - 50)/2, CGRectGetMaxY(self.flowView.frame) + 20, 50, 25);
    self.topContentView.frame = CGRectMake(0, CGRectGetMinY(self.flowView.frame)-50, self.frame.size.width, 40);
    
    self.actionBtnItems = @[@"复制",@"",@"翻译",@"搜索",@"分享"];
    
}


- (void)createTopButton:(NSString*)title frame:(CGRect)rect
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.frame = rect;
    [btn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor blackColor];
    [self.topContentView addSubview:btn];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public method

- (void)setActionBtnItems:(NSArray<NSString *> *)actionBtnItems
{
    _actionBtnItems = actionBtnItems;

    if (actionBtnItems.count > 0) {
        
        CGFloat width = (self.frame.size.width-20-40)/5;
        CGFloat height = 30;
        CGFloat padding = 10;
        CGFloat leftMargin = 10;
        [self.topContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [actionBtnItems enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = CGRectMake(leftMargin + idx*(padding+width), 10, width, height);
            if (obj.length > 0) {
                [self createTopButton:obj frame:rect];
            }
        }];
    }
}

- (void)configDatas:(NSArray*)flowDatas
{
    self.flowView.flowDatas = flowDatas;
    [self relodLayoutWithCollectionHeight:self.maxFlowViewHeight];
    [self.flowView reloadDatas];
    
    [self setNeedsLayout];
}

- (void)show
{
    [self addToKeyWindow];
    [self.flowView reloadDatas];
    self.topContentView.hidden = YES;
    
    [self showAnimationWithCompletion:^(BOOL finished) {
    
    }];;
}

- (void)hide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self hideAnimationWithCompletion:^(BOOL finished) {
        [self removeFromKeyWindow];
    }];
}

#pragma mark - private method

- (void)closeContanier:(UIButton*)btn
{
    NSArray * array = [self.flowView filterAllSelectTitles];
    if (array.count>0) {
        [self.flowView.flowDatas makeObjectsPerformSelector:@selector(setIsSelected:) withObject:@(NO)];
        [self.flowView reloadDatas];
    } else {
        [self hide];
    }
}

- (void)actionBtnClick:(UIButton*)btn
{
    [self hide];
    NSString * text = [self.flowView getNewTextstring];
    NSLog(@"%@",text);
    if ([btn.titleLabel.text isEqualToString:@"复制"]) {
        [self copyText:text];
    } else if ([btn.titleLabel.text isEqualToString:@"翻译"]) {
        
    } else if ([btn.titleLabel.text isEqualToString:@"搜索"]) {
        
    } else if ([btn.titleLabel.text isEqualToString:@"分享"]) {
        
    }
    if (self.actionBlock) {
        self.actionBlock(btn.titleLabel.text, text);
    }
}

- (void)copyText:(NSString*)text
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:text];
}

- (void)addToKeyWindow
{
    if (!self.superview) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
}

- (void)removeFromKeyWindow
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)showAnimationWithCompletion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.25 animations:^{
        
        if ([UIDevice currentDevice].systemVersion.floatValue > 7.99f) {
            self.menuBackgroundView.alpha = 1;
        } else {
            self.menuBackgroundView.alpha = 0.5;
        }
        self.flowView.alpha = 1;
        
    } completion:completion];
    
}

- (void)hideAnimationWithCompletion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.025 animations:^{
        self.menuBackgroundView.alpha = 0;
        self.flowView.alpha = 0;
    } completion:completion];
}

- (UIView *)menuBackgroundView
{
    if (!_menuBackgroundView) {
        _menuBackgroundView = [[UIView alloc] init];
        _menuBackgroundView.frame = CGRectMake(0, 0, ScreenWidth , ScreenHeight);
        
        if ([UIDevice currentDevice].systemVersion.floatValue > 7.99f) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *effectV = [[UIVisualEffectView alloc] initWithEffect:effect];
            [_menuBackgroundView addSubview:effectV];
            effectV.frame = _menuBackgroundView.frame;
        } else {
            _menuBackgroundView.backgroundColor = [UIColor blackColor];
        }
        _menuBackgroundView.alpha = 0;
    }
    return _menuBackgroundView;
}

- (UIImage*)drawCloseImageSize:(CGSize)size lineWidth:(CGFloat)lineWidth tintColor:(UIColor *)tintColor
{
    UIImage *resultImage = nil;
    tintColor = tintColor ? tintColor : [UIColor whiteColor];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    [path closePath];
    [path moveToPoint:CGPointMake(size.width, 0)];
    [path addLineToPoint:CGPointMake(0, size.height)];
    [path closePath];
    path.lineWidth = lineWidth;
    path.lineCapStyle = kCGLineCapRound;
    CGContextSetStrokeColorWithColor(context, tintColor.CGColor);
    [path stroke];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
