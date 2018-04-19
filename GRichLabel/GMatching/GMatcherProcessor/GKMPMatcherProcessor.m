//
//  GKMPMatcherProcessor.m
//  GMatchingKit
//
//  Created by GIKI on 2018/4/19.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GKMPMatcherProcessor.h"
#import "GMatcherResult.h"
#import "GThreadSafeArray.h"
#import "GThreadSafeDictionary.h"

@interface GKMPMatcherProcessor()
@property (nonatomic, strong) GThreadSafeDictionary * nextsMap;
@property (nonatomic, strong) GThreadSafeDictionary * userInfoMap;
@property (nonatomic, strong) NSMutableArray * nexts;
@property (nonatomic, copy  ) NSString * aString;
@end
@implementation GKMPMatcherProcessor

- (void)insertString:(NSString*)aString
{
    self.aString = aString;
    int t = 0;
    [self.nexts removeAllObjects];
    self.nexts[0] = @(-1);
    unsigned long length = [aString length];
    for (int i =1; i<length; i++) {
        t = [self.nexts[i-1] intValue];
        while ([aString characterAtIndex:t+1] != [aString characterAtIndex:i] && t >0) {
            t = [self.nexts[t] intValue];
        }
        if ([aString characterAtIndex:t+1] == [aString characterAtIndex:i]) {
            self.nexts[i] = @(t+1);
        } else {
            self.nexts[i] = @(-1);
        }
    }
}

- (NSArray*)searchString:(NSString*)searchStr
{
    NSMutableArray *result = [NSMutableArray array];
    unsigned long searchLength = [searchStr length];
    unsigned long aLength = [self.aString length];
    int i = 0 ,j = 0;
    while (i<searchLength ) {
        
        if ([[searchStr substringWithRange:NSMakeRange(i,1)] isEqualToString:[self.aString substringWithRange:NSMakeRange(j,1)]]) {
            ++i;
            ++j;
            if (j==aLength) {
                GMatcherResult *matcher = [GMatcherResult result:self.aString location:(i-aLength) userInfo:nil];
                [result addObject:matcher];
                j = [self.nexts[j-1] intValue] + 1;
            }
        }  else {
            if (j == 0) {
                i++;
            } else {
                j = [self.nexts[j-1] intValue]+1;
            }
        }
    }
    
    return result;
}

- (NSMutableArray *)nexts
{
    if (!_nexts) {
        _nexts = [NSMutableArray array];
    }
    return _nexts;
}

- (GThreadSafeDictionary *)nextsMap
{
    if (!_nextsMap) {
        _nextsMap = [GThreadSafeDictionary dictionary];
    }
    return _nextsMap;
}

- (GThreadSafeDictionary *)userInfoMap
{
    if (!_userInfoMap) {
        _userInfoMap = [GThreadSafeDictionary dictionary];
    }
    return _userInfoMap;
}

- (void)matcherExpressionWithPatterns:(NSArray*)patterns
{
    [patterns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[NSString class]]) {
            [self processKMPNexts:obj info:nil];
        } else if ([obj respondsToSelector:NSSelectorFromString(@"getPatternString")]) {
            NSString * pattern = [obj performSelector:NSSelectorFromString(@"getPatternString")];
            [self processKMPNexts:obj info:pattern];
        }
    }];
}

- (void)processKMPNexts:(NSString*)pattern info:(id)info
{
    if (info) {
        NSArray * hasNexts = [self.nextsMap objectForKey:pattern];
        if (hasNexts) return;
    }
   
    NSUInteger length = [pattern length];
    NSMutableArray * nexts = [NSMutableArray arrayWithCapacity:length];
    int t = 0;
    [nexts insertObjectSafely:@(-1) atIndex:0];
    for (int i =1; i<length; i++) {
        NSNumber* next = [nexts objectAtIndexSafely:i-1];
        t = [next intValue];
        if (length > t+1) {
            while ([pattern characterAtIndex:t+1] != [pattern characterAtIndex:i] && t >0) {
                NSNumber* next2 = [nexts objectAtIndexSafely:t];
                t = [next2 intValue];
            }
            if ([pattern characterAtIndex:t+1] == [pattern characterAtIndex:i]) {
                [nexts insertObjectSafely:@(t+1) atIndex:i];
            } else {
                [nexts insertObjectSafely:@(-1) atIndex:i];
            }
        }
    }
    if (nexts.count > 0) {
        [self.nextsMap setObject:nexts.copy forKey:pattern];
        if (info) {
            [self.userInfoMap setObject:info forKey:pattern];
        }
    }
}

- (NSArray<GMatcherResult *> *)matchesInString:(NSString *)string
{
    __weak typeof(self) weakSelf = self;
    __block NSMutableArray * results = [NSMutableArray array];
    [self.nextsMap iterateWitHandler:^BOOL(NSString* key, id obj) {
        NSArray * array = [weakSelf searchString:string pattern:key nexts:obj];
        [results addObjectsFromArray:array];
        return NO;
    }];
    return results.copy;
}

- (NSArray*)searchString:(NSString*)searchStr pattern:(NSString*)pattern nexts:(NSArray*)nexts
{
    id userInfo = nil;
    if (_userInfoMap) {
        userInfo = [self.userInfoMap objectForKey:pattern];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    unsigned long searchLength = [searchStr length];
    unsigned long aLength = [pattern length];
    int i = 0 ,j = 0;
    while (i<searchLength ) {
        if ([[searchStr substringWithRange:NSMakeRange(i,1)] isEqualToString:[pattern substringWithRange:NSMakeRange(j,1)]]) {
            ++i;
            ++j;
            if (j==aLength) {
                
                GMatcherResult *matcher = [GMatcherResult result:pattern location:(i-aLength) userInfo:userInfo];
                [result addObject:matcher];
                j = [[nexts objectAtIndexSafely:j-1] intValue] + 1;
            }
        }  else {
            if (j == 0) {
                i++;
            } else {
                j = [[nexts objectAtIndexSafely:j-1] intValue]+1;
            }
        }
    }
    return result.copy;
}

- (void)enumerateMatchesInString:(NSString *)string usingBlock:(void (^)(GMatcherResult *, BOOL *))block
{
    
    [self.nextsMap iterateWitHandler:^BOOL(NSString* pattern, NSArray* nexts) {
        
        id userInfo = [self.userInfoMap objectForKey:pattern];
        unsigned long searchLength = [string length];
        unsigned long aLength = [pattern length];
        int i = 0 ,j = 0;
        while (i<searchLength ) {
            if ([[string substringWithRange:NSMakeRange(i,1)] isEqualToString:[pattern substringWithRange:NSMakeRange(j,1)]]) {
                ++i;
                ++j;
                if (j==aLength) {
                    GMatcherResult *matcher = [GMatcherResult result:pattern location:(i-aLength) userInfo:userInfo];
                    if (block) {
                        BOOL hasBreak = NO;
                        block(matcher,&hasBreak);
                        if (hasBreak) {
                            break;
                        }
                    }
                    j = [[nexts objectAtIndexSafely:j-1] intValue] + 1;
                }
            }  else {
                if (j == 0) {
                    i++;
                } else {
                    j = [[nexts objectAtIndexSafely:j-1] intValue]+1;
                }
            }
        }
        return NO;
    }];
    
}
@end
