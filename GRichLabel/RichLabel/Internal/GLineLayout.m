//
//  GLineLayout.m
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/6.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GLineLayout.h"

@implementation GLineLayout

+ (instancetype)line:(id)line Layout:(CGRect)rect
{
    GLineLayout *layout = [GLineLayout new];
    layout.line = line;
    layout.rect = rect;
    return layout;
}

@end
