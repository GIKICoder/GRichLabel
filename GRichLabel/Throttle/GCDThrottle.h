//
//  GCDThrottle.h
//  GCDThrottle
//
//  Created by cyan on 16/5/24.
//  Copyright © 2016年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define THROTTLE_MAIN_QUEUE             (dispatch_get_main_queue())
#define THROTTLE_GLOBAL_QUEUE           (dispatch_get_global_queue(0, 0))

typedef void (^GCDThrottleBlock) ();


/** Throttle type */
typedef NS_ENUM(NSInteger, GCDThrottleType) {
    GCDThrottleTypeDelayAndInvoke,/**< Throttle will wait for [threshold] seconds to invoke the block, when new block comes, it cancels the previous block and restart waiting for [threshold] seconds to invoke the new one. */
    GCDThrottleTypeInvokeAndIgnore,/**< Throttle invokes the block at once and then wait for [threshold] seconds before it can invoke another new block, all block invocations during waiting time will be ignored. */
};


#pragma mark -
@interface GCDThrottle : NSObject

void dispatch_throttle(NSTimeInterval threshold, GCDThrottleBlock block);
void dispatch_throttle_on_queue(NSTimeInterval threshold, dispatch_queue_t queue, GCDThrottleBlock block);
void dispatch_throttle_by_type(NSTimeInterval threshold, GCDThrottleType type, GCDThrottleBlock block);
void dispatch_throttle_by_type_on_queue(NSTimeInterval threshold, GCDThrottleType type, dispatch_queue_t queue, GCDThrottleBlock block);

+ (void)throttle:(NSTimeInterval)threshold block:(GCDThrottleBlock)block;
+ (void)throttle:(NSTimeInterval)threshold queue:(dispatch_queue_t)queue block:(GCDThrottleBlock)block;
+ (void)throttle:(NSTimeInterval)threshold type:(GCDThrottleType)type block:(GCDThrottleBlock)block;
+ (void)throttle:(NSTimeInterval)threshold type:(GCDThrottleType)type queue:(dispatch_queue_t)queue block:(GCDThrottleBlock)block;

@end
