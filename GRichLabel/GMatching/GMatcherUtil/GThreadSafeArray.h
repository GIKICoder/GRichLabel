//
//  GThreadSafeArray.h
//  GMatchingKit
//
//  Created by GIKI on 2018/4/18.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GThreadSafeArray : NSObject

+ (instancetype)array;

- (NSUInteger)count;

- (id)objectAtIndex:(NSUInteger)index;

- (void)addObject:(id)object;

- (void)removeObject:(id)object;

- (void)removeAllObject;

- (void)iterateWitHandler:(BOOL(^)(id element))handler;

@end


@interface NSArray (Safely)

- (id)objectAtIndexSafely:(NSUInteger)index;

@end

@interface NSMutableArray (Safely)

- (void)addObjectSafely:(id)anObject;
- (void)insertObjectSafely:(id)anObject atIndex:(NSUInteger)index;
- (void)removeObjectAtIndexSafely:(NSUInteger)index;
- (void)replaceObjectAtIndexSafely:(NSUInteger)index withObject:(id)anObject;

@end
