//
//  GACQueue.m
//  GRichText
//
//  Created by GIKI on 2017/8/28.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GACQueue.h"
@interface GACQueue()
{
    NSMutableArray * _queue;
}
@end

@implementation GACQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addQueue:(id)object
{
    [_queue addObject:object];
}

- (id)getQueue
{
    if ([self isEmpty]) {
        return nil;
    }
    
    id value = _queue.firstObject;
    [_queue removeObjectAtIndex:0];
    return value;
}

- (BOOL)isEmpty
{
    return _queue.count == 0;
}

- (void)clean
{
    [_queue removeAllObjects];
}

@end
