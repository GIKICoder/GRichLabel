//
//  NSAttributedString+GText.m
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/11.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "NSAttributedString+GText.h"
#import "GTextUtils.h"
#import "GEmojiRunDelegate.h"
#import <objc/runtime.h>
static NSString* const propertyKeyhasEmojiImage = @"propertyKeyhasEmojiImage";
static NSString* const propertyKeytruncationToken = @"propertyKeytruncationToken";
static NSString* const propertyKeytokenRanges = @"propertyKeytokenRanges";
@implementation NSAttributedString (GText)


- (BOOL)hasEmojiImage
{
    return [objc_getAssociatedObject(self, &propertyKeyhasEmojiImage) boolValue];
}

- (void)setHasEmojiImage:(BOOL)hasEmojiImage
{
    objc_setAssociatedObject(self, &propertyKeyhasEmojiImage, @(hasEmojiImage), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSAttributedString *)truncationToken
{
    return objc_getAssociatedObject(self, &propertyKeytruncationToken);
}

- (void)setTruncationToken:(NSAttributedString *)truncationToken
{
     objc_setAssociatedObject(self, &propertyKeytruncationToken, truncationToken, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSMutableAttributedString *)setAttachmentStringWithEmojiImageName:(NSString *)imageName
                                                                font:(UIFont*)font
{
    if (!imageName || !font) return nil;
        
    GEmojiRunDelegate *delegate = [[GEmojiRunDelegate alloc] init];

    delegate.textFont = font;
    delegate.emojiImageName = imageName;
    
    // 创建带有图片的占位符
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"\uFFFC"];
    
    CTRunDelegateRef ctDelegate = [delegate GetCTRunDelegate];
    [string setAttribute:(id)kCTRunDelegateAttributeName value:(__bridge id)ctDelegate range:NSMakeRange(0, string.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return string;
}

+ (NSMutableAttributedString*)setTokenStringWithAttributedToken:(GAttributedToken*)token attributedConfig:(GAttributedConfiguration*)config
{
    if (!token || (token.textToken.length == 0)) return nil;
   
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:token.textToken];
    UIColor * tokenColor= config.tokenTextColor;
    if (token.tokenColor) {
        tokenColor = tokenColor;
    }
    if (!tokenColor) {
        tokenColor = config.textColor;
    }
    [string setAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)tokenColor.CGColor range:NSMakeRange(0, string.length)];
    
    UIFont *tokenFont = token.tokenFont;
    if (!tokenFont) {
        tokenFont = config.font;
    }
    [string setAttribute:(NSString*)kCTFontAttributeName value:(id)tokenFont range:NSMakeRange(0, string.length)];
    [string setAttribute:(NSString *)kGAttributeTokenHighlightName value:token range:NSMakeRange(0, string.length)];
    
//    [string setAttribute:(NSString*)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble] range:NSMakeRange(0, string.length)];
    return string;
}

@end

@implementation NSMutableAttributedString (GText)

- (void)setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

- (id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index
{
    if (!attributeName) return nil;
    if (index > self.length || self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

@end
