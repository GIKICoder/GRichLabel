//
//  GTextMenuConfiguration.h
//  GRichLabel
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GMenuContextProtocol.h"
@class GRichLabel;
@interface GTextMenuConfiguration : NSObject<GMenuContextProtocol>

@property (nonatomic, strong) NSArray * menuItems;

@end
