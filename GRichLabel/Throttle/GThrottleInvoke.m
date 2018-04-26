//
//  GThrottleInvoke.m
//  GRichLabelExample
//
//  Created by GIKI on 2018/4/26.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GThrottleInvoke.h"
#define ThreadCallStackSymbol       [NSThread callStackSymbols][1]
@implementation GThrottleInvoke

+ (NSMutableDictionary *)scheduledSources
{
    static NSMutableDictionary *_sources = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _sources = [NSMutableDictionary dictionary];
    });
    return _sources;
}

+ (void)throttle:(NSTimeInterval)threshold block:(dispatch_block_t)block
{
     [self _throttle:threshold queue:dispatch_get_main_queue() key:ThreadCallStackSymbol block:block];
}

+ (void)throttle:(NSTimeInterval)threshold queue:(dispatch_queue_t)queue block:(dispatch_block_t)block
{
    [self _throttle:threshold queue:queue key:ThreadCallStackSymbol block:block];
}

+ (void)_throttle:(NSTimeInterval)threshold queue:(dispatch_queue_t)queue key:(NSString *)key block:(dispatch_block_t)block
{
        NSMutableDictionary *scheduledSources = self.scheduledSources;
        
        dispatch_source_t source = scheduledSources[key];
        
        if (source) {
            dispatch_source_cancel(source);
        }
        
        source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(source, dispatch_time(DISPATCH_TIME_NOW, threshold * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 0);
        dispatch_source_set_event_handler(source, ^{
            block();
            dispatch_source_cancel(source);
            [scheduledSources removeObjectForKey:key];
        });
        dispatch_resume(source);
        
        scheduledSources[key] = source;
}

@end
