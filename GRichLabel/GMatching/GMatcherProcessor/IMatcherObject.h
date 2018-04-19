//
//  IMatcherObject.h
//  GMatchingKit
//
//  Created by GIKI on 2018/4/19.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMatcherObject <NSObject>

@required
- (NSString *)getPatternString;

@end
