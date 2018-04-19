//
//  GMatcherExpression.h
//  GMatchingKit
//
//  Created by GIKI on 2018/4/18.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMatcherResult.h"
#import "IMatcherObject.h"
typedef NS_ENUM(NSUInteger, GMatchingOption) {
    GMatchingOption_Auto,
    GMatchingOption_KMP,
    GMatchingOption_AC,
    GMatchingOption_Regex,
};

@interface GMatcherExpression : NSObject

+ (GMatcherExpression *)matcherExpressionWithPattern:(NSString*)pattern;
+ (GMatcherExpression *)matcherExpressionWithPatterns:(NSArray*)patterns;
+ (GMatcherExpression *)matcherExpressionWithPattern:(NSString*)pattern option:(GMatchingOption)option;
+ (GMatcherExpression *)matcherExpressionWithPatterns:(NSArray*)patterns option:(GMatchingOption)option;

+ (GMatcherExpression *)matcherExpressionWithObjectPatterns:(NSArray<id<IMatcherObject>>*)patterns;
+ (GMatcherExpression *)matcherExpressionWithObjectPatterns:(NSArray<id<IMatcherObject>>*)patterns option:(GMatchingOption)option;

- (void)enumerateMatchesInString:(NSString *)string usingBlock:(void (NS_NOESCAPE ^)(GMatcherResult * result, BOOL *stop))block;

- (NSArray<GMatcherResult *> *)matchesInString:(NSString *)string;

- (NSUInteger)numberOfMatchesInString:(NSString *)string ;

- (NSTextCheckingResult *)firstMatchInString:(NSString *)string;

- (NSRange)rangeOfFirstMatchInString:(NSString *)string;

@end
