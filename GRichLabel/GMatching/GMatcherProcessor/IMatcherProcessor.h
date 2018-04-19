//
//  IMatcherProcessor.h
//  GMatchingKit
//
//  Created by GIKI on 2018/4/18.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMatcherResult.h"
@protocol IMatcherProcessor <NSObject>

- (void)matcherExpressionWithPatterns:(NSArray*)patterns;
- (NSArray<GMatcherResult *> *)matchesInString:(NSString *)string;
- (void)enumerateMatchesInString:(NSString *)string usingBlock:(void (NS_NOESCAPE ^)(GMatcherResult * result, BOOL *stop))block;

@end


