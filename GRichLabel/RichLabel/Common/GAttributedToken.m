//
//  GAttributedToken.m
//  GRichLabel
//
//  Created by GIKI on 2017/9/12.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GAttributedToken.h"

NSString *const kGAttributeTokenHighlightName = @"kGAttributeTokenHighlightName";
NSString *const kGAttributeTokenUnderlineName = @"kGAttributeTokenUnderlineName";
NSString *const kGAttributeTokenAttachmentName = @"\uFFFC";
NSString *const kGAttributeTokenTruncationName = @"\u2026";
NSString *const kGAttributeTokenReplaceStringName =  @"kGAttributeTokenReplaceStringName";

@implementation GAttributedToken

+ (instancetype)attributedTextToken:(NSString*)textToken
{
    return [GAttributedToken attributedTextToken:textToken color:nil font:nil];
}

+ (instancetype)attributedTextToken:(NSString*)textToken color:(UIColor*)color
{
    return [GAttributedToken attributedTextToken:textToken color:color font:nil];
}

+ (instancetype)attributedTextToken:(NSString*)textToken color:(UIColor*)color font:(UIFont*)font
{
    GAttributedToken * token = [GAttributedToken new];
    token.textToken = textToken;
    token.tokenColor = color;
    token.tokenFont = font;
    GTokenAppearance * appearance = [GTokenAppearance new];
    appearance.cornerRadius = 4;
    appearance.fillColor = [UIColor colorWithRed:69/255.0 green:111/255.0 blue:238/255.0 alpha:0.6];
    token.tokenAppearance =  appearance;
    return token;
}

+ (instancetype)attributedRegexToken:(NSString*)regexToken
{
    return [GAttributedToken attributedRegexToken:regexToken color:nil font:nil];
}

+ (instancetype)attributedRegexToken:(NSString*)regexToken color:(UIColor*)color
{
    return [GAttributedToken attributedRegexToken:regexToken color:color font:nil];
}

+ (instancetype)attributedRegexToken:(NSString*)regexToken color:(UIColor*)color font:(UIFont*)font
{
    GAttributedToken * token = [GAttributedToken new];
    token.regexToken = regexToken;
    token.tokenColor = color;
    token.tokenFont = font;
    GTokenAppearance * appearance = [GTokenAppearance new];
    appearance.cornerRadius = 4;
    appearance.fillColor = [UIColor colorWithRed:58/255 green:59/255 blue:205/255 alpha:0.6];
    token.tokenAppearance =  appearance;
    return token;
}

#pragma mark - protocol Method
- (NSString *)getPatternString
{
    return self.textToken;
}
@end
