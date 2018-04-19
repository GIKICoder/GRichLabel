//
//  GThreadSafeArray.m
//  GMatchingKit
//
//  Created by GIKI on 2018/4/18.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GThreadSafeArray.h"

@interface GThreadSafeArray()
@property (nonatomic, strong) NSLock* lock;
@property (nonatomic, strong) NSMutableArray* array;
@end

@implementation GThreadSafeArray

+ (instancetype)array
{
    GThreadSafeArray * array = [[GThreadSafeArray alloc] init];
    return array;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.array = [NSMutableArray array];
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

- (NSUInteger)count
{
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    
    NSUInteger num = self.array.count;
    
    [self.lock unlock];
    
    return num;
}


- (id)objectAtIndex:(NSUInteger)index;
{
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    
    if (self.array.count <= index) {
        [_lock unlock];
        return nil;
    }
    id object = [self.array objectAtIndex:index];
    
    [_lock unlock];
    
    return object;
}


- (void)addObject:(id)object
{
    if (!object) return;
    
    while (![self.lock tryLock]) {
        usleep(10*1000);
    }
    [self.array addObject:object];
    
    [self.lock unlock];
}


- (void)removeObject:(id)object
{
    if (!object) {
        return;
    }
    
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    
    [self.array removeObject:object];
    
    [self.lock unlock];
}


- (void)removeAllObject
{
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    
    [self.array removeAllObjects];
    
    [self.lock unlock];
}

- (void)iterateWitHandler:(BOOL(^)(id element))handler
{
    if (!handler) {
        return;
    }
    
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    
    for (id element in self.array) {
        BOOL result = handler(element);
        
        if (result) {
            break;
        }
    }
    
    handler = nil;
    
    [_lock unlock];
}

@end

@implementation NSArray (Safely)

- (id)objectAtIndexSafely:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end


@implementation NSMutableArray (Safely)

- (void)addObjectSafely:(id)anObject {
    if (anObject != nil) {
        [self addObject:anObject];
    }
}

- (void)insertObjectSafely:(id)anObject atIndex:(NSUInteger)index {
    if (anObject != nil ) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)removeObjectAtIndexSafely:(NSUInteger)index {
    if (index < [self count]) {
        [self removeObjectAtIndex:index];
    }
}

- (void)replaceObjectAtIndexSafely:(NSUInteger)index withObject:(id)anObject {
    if (anObject != nil && index < [self count]) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}


@end
