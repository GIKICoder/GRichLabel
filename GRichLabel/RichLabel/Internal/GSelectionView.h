//
//  GSelectionView.h
//  GRichLabel
//
//  Created by GIKI on 2017/9/1.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCursor.h"
#import "GTokenAppearance.h"
@interface GSelectionView : UIView

@property (nonatomic, strong) GCursor  *  leftCursor;
@property (nonatomic, strong) GCursor  *  rightCursor;

@property (nonatomic, copy) NSArray *selectionRects;
@property (nonatomic, copy) NSArray *highlightRects;

@property (nonatomic, strong) UIColor * selectionColor;
@property (nonatomic, strong) UIColor * highlightColor;

@property (nonatomic, assign) CGFloat  linespace;
- (void)showSelectionView:(NSArray*)selectionRects showCursor:(BOOL)isShowCursor;

- (void)hideSelectionView;

- (void)showHighlightViewWithRects:(NSArray*)hightLightRects withAppearance:(GTokenAppearance*)appearance;

- (void)hideHighlightView;

- (BOOL)isCursorContainsPoint:(CGPoint)point;
- (BOOL)isLeftCursorContainsPoint:(CGPoint)point;
- (BOOL)isRightCursorContainsPoint:(CGPoint)point;


@end
