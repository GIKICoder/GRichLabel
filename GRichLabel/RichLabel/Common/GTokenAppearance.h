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

@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *fillColor;

@end
