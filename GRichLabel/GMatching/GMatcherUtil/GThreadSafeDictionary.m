//
//  GThreadSafeDictionary.m
//  GMatchingKit
//
//  Created by GIKI on 2018/4/18.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GThreadSafeDictionary.h"
@interface GThreadSafeDictionary ()

@property(nonatomic, strong) NSMutableDictionary * dict;
@property (nonatomic, strong) NSLock * lock;

@end

@implementation GThreadSafeDictionary

+ (instancetype)dictionary
{
    GThreadSafeDictionary * dict = [[GThreadSafeDictionary alloc] init];
    return dict;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.dict = [NSMutableDictionary dictionary];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

-(void)dealloc
{
    _dict = nil;
    _lock  = nil;
}

- (NSUInteger)count
{
    while (![_lock tryLock]) {
        usleep(10*1000);
    }
    
    NSUInteger num = [self.dict count];
    
    [_lock unlock];
    
    return num;
}

- (NSArray*)allKeys
{
    while (![_lock tryLock]) {
        usleep(10*1000);
    }
    
    NSArray * allkeys = [self.dict allKeys];
    
    [_lock unlock];
    
    return allkeys;
}

- (__kindof id)objectForKey:(NSString*)key
{
    if (key.length <= 0) {
        return nil;
    }
    
    while (![_lock tryLock]) {
        usleep(10*1000);
    }
    
    id object = [self.dict objectForKey:key];
    
    [_lock unlock];
    
    return object;
}

- (void)setObject:(id)value forKey:(NSString *)key
{
    if (!value || key.length <= 0) {
        return;
    }
    
    while (![_lock tryLock]) {
        usleep(10*1000);
    }
    [self.dict setObject:value forKey:key];
    
    [_lock unlock];
    
}

- (void)removeObjectForKey:(id)key
{
    if (key == nil) {
        return;
    }
    
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    
    [self.dict removeObjectForKey:key];
    
    [_lock unlock];
    
}

- (void)removeAllObjects
{
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    
    [self.dict removeAllObjects];
   
    
    [_lock unlock];
}

- (void)iterateWitHandler:(BOOL(^)(id key, id obj))handler
{
    if (!handler) {
        return;
    }
    
    while (![_lock tryLock]) {
        usleep(10 * 1000);
    }
    [self.dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (!handler) {
            *stop = YES;
        }
        BOOL result = handler(key,obj);
        if (result) {
            *stop = YES;
        }
    }];
    handler = nil;
    
    [_lock unlock];
}
@end
