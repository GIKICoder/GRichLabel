//
//  GMatcherResult.m
//  GMatchingKit
//
//  Created by GIKI on 2018/4/18.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GMatcherResult.h"

@implementation GMatcherResult

+ (instancetype)result:(NSString*)string location:(long)location userInfo:(id)info
{
    GMatcherResult * result = [[GMatcherResult alloc] init];
    result.range = NSMakeRange(location, [string length]);
    result.string = string;
    result.info = info;
    return result;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@,%@", NSStringFromRange(_range), _string];
}

@end
