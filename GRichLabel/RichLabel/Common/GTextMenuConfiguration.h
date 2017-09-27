//
//  GTextMenuConfiguration.h
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class GRichLabel;
@interface GTextMenuConfiguration : NSObject

+ (instancetype)textMenuConfig:(GRichLabel*)richLabel;
- (void)showMenuWithTargetRect:(CGRect)targetRect selectRange:(NSRange)selectRange;
- (void)hideTextMenu;
@end
