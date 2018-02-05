//
//  UIView+GText.h
//  GRichLabel
//
//  Created by GIKI on 2017/9/2.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GText)

- (CGPoint)convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view;
- (CGPoint)convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view ;
@end
