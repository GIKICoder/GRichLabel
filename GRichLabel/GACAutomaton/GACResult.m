//
//  GACResult.m
//  GRichText
//
//  Created by GIKI on 2017/8/28.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GACResult.h"

@implementation GACResult


+ (instancetype)result:(NSString*)string location:(long)location userInfo:(id)info
{
    GACResult * result = [[GACResult alloc] init];
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
