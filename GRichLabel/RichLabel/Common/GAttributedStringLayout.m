//
//  GAttributedStringLayout.m
//  GRichTextExample
//
//  Created by GIKI on 2017/9/4.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GAttributedStringLayout.h"



@implementation GAttributedStringLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textColor = [UIColor blackColor];
        self.tokenTextColor = [UIColor blueColor];
        self.font = [UIFont systemFontOfSize:14];
        self.linespace = 0;
        self.lineBreakMode = kCTLineBreakByWordWrapping;
        self.textAlignment = kCTLineBreakByWordWrapping;
        self.numberOfLines = 1;
        self.lineIndent = 0;
    }
    return self;
}

@end
