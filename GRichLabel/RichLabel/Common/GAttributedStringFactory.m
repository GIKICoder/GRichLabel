//
//  GAttributedStringFactory.m
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/4.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GAttributedStringFactory.h"
#import <CoreText/CoreText.h>
#import "GAttributedConfiguration.h"
#import "GACAutomaton.h"
#import "GEmojiConfigManager.h"
#import "GEmojiRunDelegate.h"
#import "NSAttributedString+GText.h"
#import "GDrawTextBuilder.h"

@implementation GAttributedStringFactory

+ (GDrawTextBuilder*)createDrawTextBuilderWithAttributedConfig:(GAttributedConfiguration*)config boundSize:(CGSize)size
{
    NSAttributedString * string = [GAttributedStringFactory createAttributedStringWithAttributedConfig:config];
    GDrawTextBuilder *textBuilder = [GDrawTextBuilder buildDrawTextSize:size attributedString:string];

    return textBuilder;
}

+ (NSMutableAttributedString*)createAttributedStringWithAttributedConfig:(GAttributedConfiguration*)config
{
    __block NSMutableAttributedString * attributed = [GAttributedStringFactory createBaseAttributedStringWithAttributedConfig:config];
    if (attributed.string.length  <= 0) return nil;
        
    __block NSMutableDictionary *tokenRangesDictM = [NSMutableDictionary dictionary];
    //替换表情
    {
        // 匹配 [表情]
        NSArray<NSTextCheckingResult *> *emoticonResults = [[GAttributedStringFactory regexEmoticon] matchesInString:attributed.string options:kNilOptions range:NSMakeRange(0, attributed.string.length)];
        NSUInteger clipLength = 0;
    
        for (NSTextCheckingResult *emo in emoticonResults) {
            if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
            NSRange range = emo.range;
            range.location -= clipLength;
            
            if ([attributed attribute:(id)kCTRunDelegateAttributeName atIndex:range.location]) continue;
            NSString *emoString = [attributed.string substringWithRange:range];
            NSString* emojiName = [[GEmojiConfigManager sharedInstance] getEmojiImageName:emoString];
            if (!emojiName) continue;
            attributed.hasEmojiImage = YES;
            NSMutableAttributedString * attr = [NSAttributedString setAttachmentStringWithEmojiImageName:emojiName font:config.font];
            [attributed replaceCharactersInRange:range withAttributedString:attr];
            clipLength += range.length - 1;
        }
    }
    
    /// 字符串匹配
    {
        NSArray * tokens = config.tokenPatternConfigs;
        if (tokens.count > 0) {
            GACAutomaton *automaton = [[GACAutomaton alloc] init];
            
            [automaton insertObjects:tokens];
            [automaton build];
            
            NSArray * result = [automaton searchString:attributed.string];
            
            [result enumerateObjectsUsingBlock:^(GACResult* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (obj.range.location == NSNotFound && obj.range.length <= 1) *stop = NO;
                if ([attributed attribute:(NSString*)kCTForegroundColorAttributeName atIndex:obj.range.location]) *stop = NO;
                
                // 替换的内容
                NSMutableAttributedString *replace = [NSMutableAttributedString setTokenStringWithAttributedToken:obj.info attributedConfig:config];
                if (!replace) *stop = NO;
                
                // 替换
                [attributed replaceCharactersInRange:obj.range withAttributedString:replace];
                [tokenRangesDictM setObject:obj.info forKey:NSStringFromRange(obj.range)];
            }];
        }
    }
    
    /// 正则匹配
    {
        NSArray * regexs = config.regexPatternConifgs;
        if (regexs.count > 0) {
            NSRange regexRange = NSMakeRange(0,attributed.string.length);
            [regexs enumerateObjectsUsingBlock:^(GAttributedToken* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.regexToken && obj.regexToken.length>0) {
                    NSArray* matches = [[NSRegularExpression regularExpressionWithPattern:obj.regexToken
                                                                                  options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:attributed.string options:0 range:regexRange];
                    for(NSTextCheckingResult* match in matches.reverseObjectEnumerator) {
                        
                        NSString *matchString = [attributed.string substringWithRange:match.range];
                        if (!matchString || matchString.length == 0) continue;
                        if ([attributed attribute:(NSString*)kCTForegroundColorAttributeName atIndex:match.range.location]) *stop = NO;
                        
                        obj.textToken = matchString;
                        // 替换的内容
                        NSMutableAttributedString *replace = [NSMutableAttributedString setTokenStringWithAttributedToken:obj attributedConfig:config];
                        if (!replace) continue;
                        
                        // 替换
                        [attributed replaceCharactersInRange:match.range withAttributedString:replace];
                        [tokenRangesDictM setObject:obj forKey:NSStringFromRange(match.range)];
                    }
                    
                }
            }];
            
        }
    }
    attributed.truncationToken = config.truncationToken;
    return attributed;
}

+ (NSMutableAttributedString*)createBaseAttributedStringWithAttributedConfig:(GAttributedConfiguration*)config
{
    NSMutableString * stringM = config.text.mutableCopy;
    if (!stringM || stringM.length == 0) return nil;
    UIColor *normalColor = config.textColor;
    UIFont *normalFont = config.font;
    
    CTLineBreakMode lineBreakModel = config.lineBreakMode;
    CTTextAlignment textAlignment = config.textAlignment;
    CGFloat linespace = config.linespace;
    
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)normalFont.fontName,
                                             normalFont.pointSize,
                                             NULL);
    CTParagraphStyleSetting AlignmentStyleSetting;
    AlignmentStyleSetting.spec=kCTParagraphStyleSpecifierAlignment;
    AlignmentStyleSetting.valueSize=sizeof(textAlignment);
    AlignmentStyleSetting.value=&textAlignment;
    
    CTParagraphStyleSetting LineSpacingStyleSetting;
    LineSpacingStyleSetting.spec=kCTParagraphStyleSpecifierLineSpacingAdjustment;// kCTParagraphStyleSpecifierLineSpacing;
    LineSpacingStyleSetting.valueSize=sizeof(linespace);
    LineSpacingStyleSetting.value=&linespace;
    
    CTParagraphStyleSetting LineBreakStyleSetting;
    LineBreakStyleSetting.spec=kCTParagraphStyleSpecifierLineBreakMode;
    LineBreakStyleSetting.valueSize=sizeof(lineBreakModel);
    LineBreakStyleSetting.value=&lineBreakModel;
    
    //首行缩进
    CGFloat fristlineindent = config.font.pointSize*config.lineIndent;
    CTParagraphStyleSetting fristline;
    fristline.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    fristline.value = &fristlineindent;
    fristline.valueSize = sizeof(CGFloat);
    
    CTParagraphStyleSetting paragraphs[4] = {AlignmentStyleSetting,LineSpacingStyleSetting,LineBreakStyleSetting,fristline};
    
    CTParagraphStyleRef styleRef = CTParagraphStyleCreate(paragraphs, 4);
    
    NSMutableDictionary * attributedConfig = [NSMutableDictionary dictionary];
    [attributedConfig setObject:(__bridge id)fontRef forKey:(__bridge NSString*)kCTFontAttributeName];
    [attributedConfig setObject:(__bridge id)normalColor.CGColor forKey:(__bridge NSString*)kCTForegroundColorAttributeName];
    [attributedConfig setObject:(__bridge id)styleRef forKey:(__bridge NSString*)kCTParagraphStyleAttributeName];
    
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString:stringM attributes:attributedConfig.copy];
    
    CFRelease(styleRef);
    CFRelease(fontRef);
    
    return attributed;
}

+ (CGFloat)getRichLabelHeightWithAttributedString:(NSAttributedString*)string MaxContianerWidth:(CGFloat)width
{
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(setter, CFRangeMake(0, 0), NULL, CGSizeMake(width, CGFLOAT_MAX), NULL);
    return ceilf(size.height+0.5);
}

+ (NSRegularExpression *)regexEmoticon
{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:kNilOptions error:NULL];
    });
    return regex;
}

@end
