//
//  GThreadSafeDictionary.h
//  GMatchingKit
//
//  Created by GIKI on 2018/4/18.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GThreadSafeDictionary : NSObject

+ (instancetype)dictionary;

- (NSUInteger)count;

- (NSArray*)allKeys;

- (__kindof id)objectForKey:(NSString*)key;

- (void)setObject:(id)value forKey:(NSString *)key;

- (void)removeObjectForKey:(id)key;

- (void)removeAllObjects;

- (void)iterateWitHandler:(BOOL(^)(id key, id obj))handler;

@end
