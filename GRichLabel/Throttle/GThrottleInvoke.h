//
//  GThrottleInvoke.h
//  GRichLabelExample
//
//  Created by GIKI on 2018/4/26.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GThrottleInvoke : NSObject

+ (void)throttle:(NSTimeInterval)threshold block:(dispatch_block_t)block;
+ (void)throttle:(NSTimeInterval)threshold queue:(dispatch_queue_t)queue block:(dispatch_block_t)block;

@end
