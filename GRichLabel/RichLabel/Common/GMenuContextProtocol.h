
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
- (void)ShowRichLabelTextMenuWithTargetRect:(CGRect)targetRect;
- (void)HideRichLabelTextMenu;

@optional
- (void)ConfigMenuWithRichLabel:(GRichLabel*)richLabel;
@end
