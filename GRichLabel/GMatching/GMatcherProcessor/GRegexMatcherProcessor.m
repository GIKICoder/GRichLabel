//
//  GRegexMatcherProcessor.m
//  GMatchingKit
//
//  Created by GIKI on 2018/4/18.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GRegexMatcherProcessor.h"
#import "GThreadSafeArray.h"
#import "GThreadSafeDictionary.h"
#import "IMatcherObject.h"
@interface GRegexMatcherProcessor()
@property (nonatomic, strong) GThreadSafeArray * safeArray;
@property (nonatomic, strong) GThreadSafeDictionary * safeMap;
@property (nonatomic, strong) GThreadSafeDictionary * userInfoMap;
@end

@implementation GRegexMatcherProcessor

- (GThreadSafeDictionary *)userInfoMap
{
    if (!_userInfoMap) {
        _userInfoMap = [GThreadSafeDictionary dictionary];
    }
    return _userInfoMap;
}

- (GThreadSafeArray *)safeArray
{
    if (!_safeArray) {
        _safeArray = [GThreadSafeArray array];
    }
    return _safeArray;
}

- (GThreadSafeDictionary*)safeMap
{
    if (!_safeMap) {
        _safeMap = [GThreadSafeDictionary dictionary];
    }
    return _safeMap;
}

- (void)processRegularExpression:(NSString*)pattern userInfo:(id)userinfo
{
    NSRegularExpression * regular = [self.safeMap objectForKey:pattern];
    if (regular) {
        return;
    }
    NSError *error;
    NSRegularExpression * regularNew = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionIgnoreMetacharacters error:&error];
    if (!error) {
        [self.safeMap setObject:regularNew forKey:pattern];
        [self.userInfoMap setObject:userinfo forKey:pattern];
    }
}

- (void)matcherExpressionWithPatterns:(NSArray*)patterns
{
    [patterns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [self processRegularExpression:obj userInfo:nil];
        } else if ([obj respondsToSelector:NSSelectorFromString(@"getPatternString")]) {
            NSString * pattern = [obj performSelector:NSSelectorFromString(@"getPatternString")];
            [self processRegularExpression:pattern userInfo:obj];
        }
    }];
}

- (NSArray<GMatcherResult *> *)matchesInString:(NSString *)string
{
    __block NSMutableArray * array = [NSMutableArray array];
    [self.safeMap iterateWitHandler:^BOOL(id key, NSRegularExpression* obj) {
        if ([obj isKindOfClass:[NSRegularExpression class]]) {
            NSArray * result = [obj matchesInString:string options:0 range:NSMakeRange(0, string.length)];
            [array addObjectsFromArray:result];
        }
        return NO;
    }];
    return array.copy;
}

- (void)enumerateMatchesInString:(NSString *)string usingBlock:(void (NS_NOESCAPE ^)(GMatcherResult * result, BOOL *stop))block
{
    [self.safeMap iterateWitHandler:^BOOL(id key, NSRegularExpression* obj) {
        id userinfo = [self.userInfoMap objectForKey:key];
        if ([obj isKindOfClass:[NSRegularExpression class]]) {
            [obj enumerateMatchesInString:string options:0 range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                if (block) {
                    BOOL st = NO;
                    GMatcherResult * matcher = [GMatcherResult result:key location:result.range.location userInfo:userinfo];
                    block(matcher,&st);
                    if (st) {
                        *stop = YES;
                    }
                }
            }];
        }
        return NO;
    }];
}

@end
