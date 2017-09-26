//
//  GAttributedStringLayout.m
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/4.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GAttributedStringLayout.h"

@implementation GAttributedStringLayout

+ (instancetype)attributedLayout:(NSString*)text
{
    return [GAttributedStringLayout attributedLayout:text color:nil font:nil];
}

+ (instancetype)attributedLayout:(NSString*)text color:(UIColor*)color font:(UIFont*)font
{
    GAttributedStringLayout *defalut = [[GAttributedStringLayout alloc] init];
    if (text) defalut.text = text;
    if (color) defalut.textColor = color;
    if (font)  defalut.font = font;
    return defalut;
}

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
