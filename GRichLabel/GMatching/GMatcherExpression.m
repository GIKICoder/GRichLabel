//
//  GMatcherExpression.m
//  GMatchingKit
//
//  Created by GIKI on 2018/4/18.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GMatcherExpression.h"
#import "IMatcherProcessor.h"
#import "GKMPMatcherProcessor.h"
#import "GACMatcherProcessor.h"
#import "GRegexMatcherProcessor.h"
@interface GMatcherExpression()
@property (nonatomic, assign) GMatchingOption matchingOption;
@property (nonatomic, strong) NSArray * pattens;
@property (nonatomic, strong) id<IMatcherProcessor> matcherProcessor;
@end

@implementation GMatcherExpression

+ (GMatcherExpression *)matcherExpressionWithPattern:(NSString*)pattern
{
    NSParameterAssert(pattern);
    if (!pattern)  return nil;
    return  [[GMatcherExpression alloc] initWithPatterns:@[pattern] option:GMatchingOption_Auto];
}

+ (GMatcherExpression *)matcherExpressionWithPatterns:(NSArray*)patterns
{
    NSParameterAssert(patterns);
    if (!patterns)  return nil;
    return  [[GMatcherExpression alloc] initWithPatterns:patterns option:GMatchingOption_Auto];
}

+ (GMatcherExpression *)matcherExpressionWithPattern:(NSString*)pattern option:(GMatchingOption)option
{
    NSParameterAssert(pattern);
    if (!pattern)  return nil;
    return  [[GMatcherExpression alloc] initWithPatterns:@[pattern] option:option];
}
+ (GMatcherExpression *)matcherExpressionWithPatterns:(NSArray*)patterns option:(GMatchingOption)option
{
    NSParameterAssert(patterns);
    if (!patterns)  return nil;
    return  [[GMatcherExpression alloc] initWithPatterns:patterns option:option];
}

+ (GMatcherExpression *)matcherExpressionWithObjectPatterns:(NSArray<id<IMatcherObject>>*)patterns
{
    NSParameterAssert(patterns);
    if (!patterns)  return nil;
    return  [[GMatcherExpression alloc] initWithPatterns:patterns option:GMatchingOption_Auto];
}

+ (GMatcherExpression *)matcherExpressionWithObjectPatterns:(NSArray<id<IMatcherObject>>*)patterns option:(GMatchingOption)option
{
    NSParameterAssert(patterns);
    if (!patterns)  return nil;
    return  [[GMatcherExpression alloc] initWithPatterns:patterns option:option];
}

- (instancetype)initWithPatterns:(NSArray *)patterns option:(GMatchingOption)option
{
    self = [super init];
    if (self) {
        self.matchingOption = option;
        self.pattens = patterns;
        
        self.matcherProcessor = [self createMatcherProcessor];
        [self.matcherProcessor matcherExpressionWithPatterns:patterns];
    }
    return self;
}

- (id<IMatcherProcessor>)createMatcherProcessor
{
    switch (self.matchingOption) {
        case GMatchingOption_Auto:
           return [self createAutoMatcherProcessor];
            break;
        case GMatchingOption_KMP:
            return   [self createKMPMatcherProcessor];
            break;
        case GMatchingOption_AC:
            return   [self createACMatcherProcessor];
            break;
        case GMatchingOption_Regex:
            return  [self createRegularMatcherProcessor];
            break;
        default:
            break;
    }
    return nil;
}

- (id<IMatcherProcessor>)createAutoMatcherProcessor
{
    if (self.pattens.count > 10) {
        return [self createACMatcherProcessor];
    } else {
        return [self createKMPMatcherProcessor];
    }
}

- (id<IMatcherProcessor>)createKMPMatcherProcessor
{
      return [[GKMPMatcherProcessor alloc] init];
}

- (id<IMatcherProcessor>)createACMatcherProcessor
{
    return [[GACMatcherProcessor alloc] init];
}

- (id<IMatcherProcessor>)createRegularMatcherProcessor
{
    return [[GRegexMatcherProcessor alloc] init];
}

#pragma mark - Public Method

- (void)enumerateMatchesInString:(NSString *)string usingBlock:(void (NS_NOESCAPE ^)(GMatcherResult * result, BOOL *stop))block
{
    [self.matcherProcessor enumerateMatchesInString:string usingBlock:block];
}

- (NSArray<GMatcherResult *> *)matchesInString:(NSString *)string
{
    return [self.matcherProcessor matchesInString:string];
}

- (NSUInteger)numberOfMatchesInString:(NSString *)string
{
    NSArray * array = [self.matcherProcessor matchesInString:string];
    return array.count;
}

- (GMatcherResult *)firstMatchInString:(NSString *)string
{
    __block GMatcherResult *matcher = nil;
    [self enumerateMatchesInString:string usingBlock:^(GMatcherResult *result, BOOL *stop) {
        matcher = result;
        *stop = YES;
    }];
    return matcher;
}

- (NSRange)rangeOfFirstMatchInString:(NSString *)string
{
    __block GMatcherResult *matcher = nil;
    [self enumerateMatchesInString:string usingBlock:^(GMatcherResult *result, BOOL *stop) {
        matcher = result;
        *stop = YES;
    }];
    return matcher.range;
}
@end
