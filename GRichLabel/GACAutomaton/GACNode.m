//
//  GACNode.m
//  GRichLabel
//
//  Created by GIKI on 2017/8/28.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GACNode.h"

@implementation GACNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        _next = [[NSMutableDictionary alloc] init];
        _failed = nil;
        _storeString = nil;
    }
    
    return self;
}

@end
