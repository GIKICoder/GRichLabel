//
//  GTokenAppearance.h
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/12.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GTokenAppearance : NSObject

//@property (nonatomic, assign) YYTextLineStyle lineStyle; ///< border line style
@property (nonatomic, assign) CGFloat strokeWidth;       ///< border line width
@property (nonatomic, strong) UIColor *strokeColor;      ///< border line color
@property (nonatomic, assign) CGLineJoin lineJoin;       ///< border line join
@property (nonatomic, assign) UIEdgeInsets insets;       ///< border insets for text bounds
@property (nonatomic, assign) CGFloat cornerRadius;      ///< border corder radius
//@property (nonatomic, strong) YYTextShadow *shadow;      ///< border shadow
@property (nonatomic, strong) UIColor *fillColor;        ///< inner fill color
@end
