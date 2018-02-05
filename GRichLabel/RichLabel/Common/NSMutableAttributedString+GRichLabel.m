//
//  NSMutableAttributedString+GRichLabel.m
//  GRichLabel
//
//  Created by GIKI on 2017/10/30.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "NSMutableAttributedString+GRichLabel.h"
#import "NSParagraphStyle+GRichLabel.h"
#import "GTextUtils.h"

@implementation NSMutableAttributedString (GRichLabel)

- (void)g_setAttributes:(NSDictionary *)attributes {
    [self setG_attributes:attributes];
}

- (void)setG_attributes:(NSDictionary *)attributes {
    if (attributes == (id)[NSNull null]) attributes = nil;
    [self setAttributes:@{} range:NSMakeRange(0, self.length)];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self g_setAttribute:key value:obj];
    }];
}

- (void)g_setAttribute:(NSString *)name value:(id)value {
    [self g_setAttribute:name value:value range:NSMakeRange(0, self.length)];
}

- (void)g_setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

- (void)g_removeAttributesInRange:(NSRange)range {
    [self setAttributes:nil range:range];
}

#pragma mark - Property Setter

- (void)setG_font:(UIFont *)font {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    [self g_setFont:font range:NSMakeRange(0, self.length)];
}

- (void)setG_kern:(NSNumber *)kern {
    [self g_setKern:kern range:NSMakeRange(0, self.length)];
}

- (void)setG_color:(UIColor *)color {
    [self g_setColor:color range:NSMakeRange(0, self.length)];
}

- (void)setG_backgroundColor:(UIColor *)backgroundColor {
    [self g_setBackgroundColor:backgroundColor range:NSMakeRange(0, self.length)];
}

- (void)setG_strokeWidth:(NSNumber *)strokeWidth {
    [self g_setStrokeWidth:strokeWidth range:NSMakeRange(0, self.length)];
}

- (void)setG_strokeColor:(UIColor *)strokeColor {
    [self g_setStrokeColor:strokeColor range:NSMakeRange(0, self.length)];
}

- (void)setG_shadow:(NSShadow *)shadow {
    [self g_setShadow:shadow range:NSMakeRange(0, self.length)];
}

- (void)setG_strikethroughStyle:(NSUnderlineStyle)strikethroughStyle {
    [self g_setStrikethroughStyle:strikethroughStyle range:NSMakeRange(0, self.length)];
}

- (void)setG_strikethroughColor:(UIColor *)strikethroughColor {
    [self g_setStrokeColor:strikethroughColor range:NSMakeRange(0, self.length)];
}

- (void)setG_underlineStyle:(NSUnderlineStyle)underlineStyle {
    [self g_setUnderlineStyle:underlineStyle range:NSMakeRange(0, self.length)];
}

- (void)setG_underlineColor:(UIColor *)underlineColor {
    [self g_setUnderlineColor:underlineColor range:NSMakeRange(0, self.length)];
}

- (void)setG_ligature:(NSNumber *)ligature {
    [self g_setLigature:ligature range:NSMakeRange(0, self.length)];
}

- (void)setG_textEffect:(NSString *)textEffect {
    [self g_setTextEffect:textEffect range:NSMakeRange(0, self.length)];
}

- (void)setG_obliqueness:(NSNumber *)obliqueness {
    [self g_setObliqueness:obliqueness range:NSMakeRange(0, self.length)];
}

- (void)setG_expansion:(NSNumber *)expansion {
    [self g_setExpansion:expansion range:NSMakeRange(0, self.length)];
}

- (void)setG_baselineOffset:(NSNumber *)baselineOffset {
    [self g_setBaselineOffset:baselineOffset range:NSMakeRange(0, self.length)];
}

- (void)setG_verticalGlyphForm:(BOOL)verticalGlyphForm {
    [self g_setVerticalGlyphForm:verticalGlyphForm range:NSMakeRange(0, self.length)];
}

- (void)setG_language:(NSString *)language {
    [self g_setLanguage:language range:NSMakeRange(0, self.length)];
}

- (void)setG_writingDirection:(NSArray *)writingDirection {
    [self g_setWritingDirection:writingDirection range:NSMakeRange(0, self.length)];
}

- (void)setG_paragraphStyle:(NSParagraphStyle *)paragraphStyle {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    [self g_setParagraphStyle:paragraphStyle range:NSMakeRange(0, self.length)];
}

- (void)setG_alignment:(NSTextAlignment)alignment {
    [self g_setAlignment:alignment range:NSMakeRange(0, self.length)];
}

- (void)setG_baseWritingDirection:(NSWritingDirection)baseWritingDirection {
    [self g_setBaseWritingDirection:baseWritingDirection range:NSMakeRange(0, self.length)];
}

- (void)setG_lineSpacing:(CGFloat)lineSpacing {
    [self g_setLineSpacing:lineSpacing range:NSMakeRange(0, self.length)];
}

- (void)setG_paragraphSpacing:(CGFloat)paragraphSpacing {
    [self g_setParagraphSpacing:paragraphSpacing range:NSMakeRange(0, self.length)];
}

- (void)setG_paragraphSpacingBefore:(CGFloat)paragraphSpacingBefore {
    [self g_setParagraphSpacing:paragraphSpacingBefore range:NSMakeRange(0, self.length)];
}

- (void)setG_firstLineHeadIndent:(CGFloat)firstLineHeadIndent {
    [self g_setFirstLineHeadIndent:firstLineHeadIndent range:NSMakeRange(0, self.length)];
}

- (void)setG_headIndent:(CGFloat)headIndent {
    [self g_setHeadIndent:headIndent range:NSMakeRange(0, self.length)];
}

- (void)setG_tailIndent:(CGFloat)tailIndent {
    [self g_setTailIndent:tailIndent range:NSMakeRange(0, self.length)];
}

- (void)setG_lineBreakMode:(NSLineBreakMode)lineBreakMode {
    [self g_setLineBreakMode:lineBreakMode range:NSMakeRange(0, self.length)];
}

- (void)setG_minimumLineHeight:(CGFloat)minimumLineHeight {
    [self g_setMinimumLineHeight:minimumLineHeight range:NSMakeRange(0, self.length)];
}

- (void)setG_maximumLineHeight:(CGFloat)maximumLineHeight {
    [self g_setMaximumLineHeight:maximumLineHeight range:NSMakeRange(0, self.length)];
}

- (void)setG_lineHeightMultiple:(CGFloat)lineHeightMultiple {
    [self g_setLineHeightMultiple:lineHeightMultiple range:NSMakeRange(0, self.length)];
}

- (void)setG_hyphenationFactor:(float)hyphenationFactor {
    [self g_setHyphenationFactor:hyphenationFactor range:NSMakeRange(0, self.length)];
}

- (void)setG_defaultTabInterval:(CGFloat)defaultTabInterval {
    [self g_setDefaultTabInterval:defaultTabInterval range:NSMakeRange(0, self.length)];
}

- (void)setG_tabStops:(NSArray *)tabStops {
    [self g_setTabStops:tabStops range:NSMakeRange(0, self.length)];
}

#pragma mark - Range Setter

- (void)g_setFont:(UIFont *)font range:(NSRange)range {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    [self g_setAttribute:NSFontAttributeName value:font range:range];
}

- (void)g_setKern:(NSNumber *)kern range:(NSRange)range {
    [self g_setAttribute:NSKernAttributeName value:kern range:range];
}

- (void)g_setColor:(UIColor *)color range:(NSRange)range {
    [self g_setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
    [self g_setAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)g_setBackgroundColor:(UIColor *)backgroundColor range:(NSRange)range {
    [self g_setAttribute:NSBackgroundColorAttributeName value:backgroundColor range:range];
}

- (void)g_setStrokeWidth:(NSNumber *)strokeWidth range:(NSRange)range {
    [self g_setAttribute:NSStrokeWidthAttributeName value:strokeWidth range:range];
}

- (void)g_setStrokeColor:(UIColor *)strokeColor range:(NSRange)range {
    [self g_setAttribute:(id)kCTStrokeColorAttributeName value:(id)strokeColor.CGColor range:range];
    [self g_setAttribute:NSStrokeColorAttributeName value:strokeColor range:range];
}

- (void)g_setShadow:(NSShadow *)shadow range:(NSRange)range {
    [self g_setAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)g_setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle range:(NSRange)range {
    NSNumber *style = strikethroughStyle == 0 ? nil : @(strikethroughStyle);
    [self g_setAttribute:NSStrikethroughStyleAttributeName value:style range:range];
}

- (void)g_setStrikethroughColor:(UIColor *)strikethroughColor range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self g_setAttribute:NSStrikethroughColorAttributeName value:strikethroughColor range:range];
    }
}

- (void)g_setUnderlineStyle:(NSUnderlineStyle)underlineStyle range:(NSRange)range {
    NSNumber *style = underlineStyle == 0 ? nil : @(underlineStyle);
    [self g_setAttribute:NSUnderlineStyleAttributeName value:style range:range];
}

- (void)g_setUnderlineColor:(UIColor *)underlineColor range:(NSRange)range {
    [self g_setAttribute:(id)kCTUnderlineColorAttributeName value:(id)underlineColor.CGColor range:range];
    if (kSystemVersion >= 7) {
        [self g_setAttribute:NSUnderlineColorAttributeName value:underlineColor range:range];
    }
}

- (void)g_setLigature:(NSNumber *)ligature range:(NSRange)range {
    [self g_setAttribute:NSLigatureAttributeName value:ligature range:range];
}

- (void)g_setTextEffect:(NSString *)textEffect range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self g_setAttribute:NSTextEffectAttributeName value:textEffect range:range];
    }
}

- (void)g_setObliqueness:(NSNumber *)obliqueness range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self g_setAttribute:NSObliquenessAttributeName value:obliqueness range:range];
    }
}

- (void)g_setExpansion:(NSNumber *)expansion range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self g_setAttribute:NSExpansionAttributeName value:expansion range:range];
    }
}

- (void)g_setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self g_setAttribute:NSBaselineOffsetAttributeName value:baselineOffset range:range];
    }
}

- (void)g_setVerticalGlyphForm:(BOOL)verticalGlyphForm range:(NSRange)range {
    NSNumber *v = verticalGlyphForm ? @(YES) : nil;
    [self g_setAttribute:NSVerticalGlyphFormAttributeName value:v range:range];
}

- (void)g_setLanguage:(NSString *)language range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self g_setAttribute:(id)kCTLanguageAttributeName value:language range:range];
    }
}

- (void)g_setWritingDirection:(NSArray *)writingDirection range:(NSRange)range {
    [self g_setAttribute:(id)kCTWritingDirectionAttributeName value:writingDirection range:range];
}

- (void)g_setParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    [self g_setAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

#define ParagraphStyleSet(_attr_) \
[self enumerateAttribute:NSParagraphStyleAttributeName \
inRange:range \
options:kNilOptions \
usingBlock: ^(NSParagraphStyle *value, NSRange subRange, BOOL *stop) { \
NSMutableParagraphStyle *style = nil; \
if (value) { \
if (CFGetTypeID((__bridge CFTypeRef)(value)) == CTParagraphStyleGetTypeID()) { \
value = [NSParagraphStyle g_styleWithCTStyle:(__bridge CTParagraphStyleRef)(value)]; \
} \
if (value. _attr_ == _attr_) return; \
if ([value isKindOfClass:[NSMutableParagraphStyle class]]) { \
style = (id)value; \
} else { \
style = value.mutableCopy; \
} \
} else { \
if ([NSParagraphStyle defaultParagraphStyle]. _attr_ == _attr_) return; \
style = [NSParagraphStyle defaultParagraphStyle].mutableCopy; \
} \
style. _attr_ = _attr_; \
[self g_setParagraphStyle:style range:subRange]; \
}];

- (void)g_setAlignment:(NSTextAlignment)alignment range:(NSRange)range {
    ParagraphStyleSet(alignment);
}

- (void)g_setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range {
    ParagraphStyleSet(baseWritingDirection);
}

- (void)g_setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range {
    ParagraphStyleSet(lineSpacing);
}

- (void)g_setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range {
    ParagraphStyleSet(paragraphSpacing);
}

- (void)g_setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range {
    ParagraphStyleSet(paragraphSpacingBefore);
}

- (void)g_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range {
    ParagraphStyleSet(firstLineHeadIndent);
}

- (void)g_setHeadIndent:(CGFloat)headIndent range:(NSRange)range {
    ParagraphStyleSet(headIndent);
}

- (void)g_setTailIndent:(CGFloat)tailIndent range:(NSRange)range {
    ParagraphStyleSet(tailIndent);
}

- (void)g_setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range {
    ParagraphStyleSet(lineBreakMode);
}

- (void)g_setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range {
    ParagraphStyleSet(minimumLineHeight);
}

- (void)g_setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range {
    ParagraphStyleSet(maximumLineHeight);
}

- (void)g_setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range {
    ParagraphStyleSet(lineHeightMultiple);
}

- (void)g_setHyphenationFactor:(float)hyphenationFactor range:(NSRange)range {
    ParagraphStyleSet(hyphenationFactor);
}

- (void)g_setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range {
    if (!kiOS7Later) return;
    ParagraphStyleSet(defaultTabInterval);
}

- (void)g_setTabStops:(NSArray *)tabStops range:(NSRange)range {
    if (!kiOS7Later) return;
    ParagraphStyleSet(tabStops);
}

#undef ParagraphStyleSet

- (void)g_setSuperscript:(NSNumber *)superscript range:(NSRange)range {
    if ([superscript isEqualToNumber:@(0)]) {
        superscript = nil;
    }
    [self g_setAttribute:(id)kCTSuperscriptAttributeName value:superscript range:range];
}

- (void)g_setGlyphInfo:(CTGlyphInfoRef)glyphInfo range:(NSRange)range {
    [self g_setAttribute:(id)kCTGlyphInfoAttributeName value:(__bridge id)glyphInfo range:range];
}

- (void)g_setCharacterShape:(NSNumber *)characterShape range:(NSRange)range {
    [self g_setAttribute:(id)kCTCharacterShapeAttributeName value:characterShape range:range];
}

- (void)g_setRunDelegate:(CTRunDelegateRef)runDelegate range:(NSRange)range {
    [self g_setAttribute:(id)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:range];
}

- (void)g_setBaselineClass:(CFStringRef)baselineClass range:(NSRange)range {
    [self g_setAttribute:(id)kCTBaselineClassAttributeName value:(__bridge id)baselineClass range:range];
}

- (void)g_setBaselineInfo:(CFDictionaryRef)baselineInfo range:(NSRange)range {
    [self g_setAttribute:(id)kCTBaselineInfoAttributeName value:(__bridge id)baselineInfo range:range];
}

- (void)g_setBaselineReferenceInfo:(CFDictionaryRef)referenceInfo range:(NSRange)range {
    [self g_setAttribute:(id)kCTBaselineReferenceInfoAttributeName value:(__bridge id)referenceInfo range:range];
}

- (void)g_setRubyAnnotation:(CTRubyAnnotationRef)ruby range:(NSRange)range {
    if (kSystemVersion >= 8) {
        [self g_setAttribute:(id)kCTRubyAnnotationAttributeName value:(__bridge id)ruby range:range];
    }
}

- (void)g_setAttachment:(NSTextAttachment *)attachment range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self g_setAttribute:NSAttachmentAttributeName value:attachment range:range];
    }
}

- (void)g_setLink:(id)link range:(NSRange)range {
    if (kSystemVersion >= 7) {
        [self g_setAttribute:NSLinkAttributeName value:link range:range];
    }
}


- (void)g_insertString:(NSString *)string atIndex:(NSUInteger)location {
    [self replaceCharactersInRange:NSMakeRange(location, 0) withString:string];
    [self g_removeDiscontinuousAttributesInRange:NSMakeRange(location, string.length)];
}

- (void)g_appendString:(NSString *)string {
    NSUInteger length = self.length;
    [self replaceCharactersInRange:NSMakeRange(length, 0) withString:string];
    [self g_removeDiscontinuousAttributesInRange:NSMakeRange(length, string.length)];
}

- (void)g_setClearColorToJoinedEmoji {
    NSString *str = self.string;
    if (str.length < 8) return;
    
    // Most string do not contains the joined-emoji, test the joiner first.
    BOOL containsJoiner = NO;
    {
        CFStringRef cfStr = (__bridge CFStringRef)str;
        BOOL needFree = NO;
        UniChar *chars = NULL;
        chars = (void *)CFStringGetCharactersPtr(cfStr);
        if (!chars) {
            chars = malloc(str.length * sizeof(UniChar));
            if (chars) {
                needFree = YES;
                CFStringGetCharacters(cfStr, CFRangeMake(0, str.length), chars);
            }
        }
        if (!chars) { // fail to get unichar..
            containsJoiner = YES;
        } else {
            for (int i = 0, max = (int)str.length; i < max; i++) {
                if (chars[i] == 0x200D) { // 'ZERO WIDTH JOINER' (U+200D)
                    containsJoiner = YES;
                    break;
                }
            }
            if (needFree) free(chars);
        }
    }
    if (!containsJoiner) return;
    
    // NSRegularExpression is designed to be immutable and thread safe.
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"((👨‍👩‍👧‍👦|👨‍👩‍👦‍👦|👨‍👩‍👧‍👧|👩‍👩‍👧‍👦|👩‍👩‍👦‍👦|👩‍👩‍👧‍👧|👨‍👨‍👧‍👦|👨‍👨‍👦‍👦|👨‍👨‍👧‍👧)+|(👨‍👩‍👧|👩‍👩‍👦|👩‍👩‍👧|👨‍👨‍👦|👨‍👨‍👧))" options:kNilOptions error:nil];
    });
    
    UIColor *clear = [UIColor clearColor];
    [regex enumerateMatchesInString:str options:kNilOptions range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [self g_setColor:clear range:result.range];
    }];
}

- (void)g_removeDiscontinuousAttributesInRange:(NSRange)range {
    NSArray *keys = [NSMutableAttributedString g_allDiscontinuousAttributeKeys];
    for (NSString *key in keys) {
        [self removeAttribute:key range:range];
    }
}

+ (NSArray *)g_allDiscontinuousAttributeKeys {
    static NSMutableArray *keys;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keys = @[(id)kCTSuperscriptAttributeName,
                 (id)kCTRunDelegateAttributeName,].mutableCopy;
        ///          YYTextBackedStringAttributeName,
        //        YYTextBindingAttributeName,
        //        YYTextAttachmentAttributeName
        if (kiOS8Later) {
            [keys addObject:(id)kCTRubyAnnotationAttributeName];
        }
        if (kiOS7Later) {
            [keys addObject:NSAttachmentAttributeName];
        }
    });
    return keys;
}


@end

