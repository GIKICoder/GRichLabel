
//
//  GMenuContextProtocol.h
//  GRichLabel
//
//  Created by GIKI on 2017/11/7.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GRichLabel;
@protocol GMenuContextProtocol <NSObject>

@required
- (void)configMenuWithRichLabel:(GRichLabel*)richLabel;
- (void)showMenuWithTargetRect:(CGRect)targetRect selectRange:(NSRange)selectRange;
- (void)hideTextMenu;

@end
