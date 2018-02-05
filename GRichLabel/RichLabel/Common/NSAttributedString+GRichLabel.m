//
//  NSAttributedString+GRichLabel.m
//  GRichLabel
//
//  Created by GIKI on 2017/10/29.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "NSAttributedString+GRichLabel.h"
#import <CoreFoundation/CoreFoundation.h>
#import "NSParagraphStyle+GRichLabel.h"
#import "GTextUtils.h"


@implementation NSAttributedString (GRichLabel)
- (NSDictionary *)g_attributesAtIndex:(NSUInteger)index {
    if (self.length > 0 && index == self.length) index--;
    return [self attributesAtIndex:index effectiveRange:NULL];
}

- (id)g_attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) return nil;
    if (self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

- (NSDictionary *)g_attributes {
    return [self g_attributesAtIndex:0];
}

- (UIFont *)g_font {
    return [self g_fontAtIndex:0];
}

- (UIFont *)g_fontAtIndex:(NSUInteger)index {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    UIFont *font = [self g_attribute:NSFontAttributeName atIndex:index];
    if (kSystemVersion <= 6) {
        if (font) {
            if (CFGetTypeID((__bridge CFTypeRef)(font)) == CTFontGetTypeID()) {
                CTFontRef CTFont = (__bridge CTFontRef)(font);
                CFStringRef name = CTFontCopyPostScriptName(CTFont);
                CGFloat size = CTFontGetSize(CTFont);
                if (!name) {
                    font = nil;
                } else {
                    font = [UIFont fontWithName:(__bridge NSString *)(name) size:size];
                    CFRelease(name);
                }
            }
        }
    }
    return font;
}

- (NSNumber *)g_kern {
    return [self g_kernAtIndex:0];
}

- (NSNumber *)g_kernAtIndex:(NSUInteger)index {
    return [self g_attribute:NSKernAttributeName atIndex:index];
}

- (UIColor *)g_color {
    return [self g_colorAtIndex:0];
}

- (UIColor *)g_colorAtIndex:(NSUInteger)index {
    UIColor *color = [self g_attribute:NSForegroundColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self g_attribute:(NSString *)kCTForegroundColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    if (color && ![color isKindOfClass:[UIColor class]]) {
        if (CFGetTypeID((__bridge CFTypeRef)(color)) == CGColorGetTypeID()) {
            color = [UIColor colorWithCGColor:(__bridge CGColorRef)(color)];
        } else {
            color = nil;
        }
    }
    return color;
}

- (UIColor *)g_backgroundColor {
    return [self g_backgroundColorAtIndex:0];
}

- (UIColor *)g_backgroundColorAtIndex:(NSUInteger)index {
    return [self g_attribute:NSBackgroundColorAttributeName atIndex:index];
}

- (NSNumber *)g_strokeWidth {
    return [self g_strokeWidthAtIndex:0];
}

- (NSNumber *)g_strokeWidthAtIndex:(NSUInteger)index {
    return [self g_attribute:NSStrokeWidthAttributeName atIndex:index];
}

- (UIColor *)g_strokeColor {
    return [self g_strokeColorAtIndex:0];
}

- (UIColor *)g_strokeColorAtIndex:(NSUInteger)index {
    UIColor *color = [self g_attribute:NSStrokeColorAttributeName atIndex:index];
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self g_attribute:(NSString *)kCTStrokeColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    return color;
}

- (NSShadow *)g_shadow {
    return [self g_shadowAtIndex:0];
}

- (NSShadow *)g_shadowAtIndex:(NSUInteger)index {
    return [self g_attribute:NSShadowAttributeName atIndex:index];
}

- (NSUnderlineStyle)g_strikethroughStyle {
    return [self g_strikethroughStyleAtIndex:0];
}

- (NSUnderlineStyle)g_strikethroughStyleAtIndex:(NSUInteger)index {
    NSNumber *style = [self g_attribute:NSStrikethroughStyleAttributeName atIndex:index];
    return style.integerValue;
}

- (UIColor *)g_strikethroughColor {
    return [self g_strikethroughColorAtIndex:0];
}

- (UIColor *)g_strikethroughColorAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self g_attribute:NSStrikethroughColorAttributeName atIndex:index];
    }
    return nil;
}

- (NSUnderlineStyle)g_underlineStyle {
    return [self g_underlineStyleAtIndex:0];
}

- (NSUnderlineStyle)g_underlineStyleAtIndex:(NSUInteger)index {
    NSNumber *style = [self g_attribute:NSUnderlineStyleAttributeName atIndex:index];
    return style.integerValue;
}

- (UIColor *)g_underlineColor {
    return [self g_underlineColorAtIndex:0];
}

- (UIColor *)g_underlineColorAtIndex:(NSUInteger)index {
    UIColor *color = nil;
    if (kSystemVersion >= 7) {
        [self g_attribute:NSUnderlineColorAttributeName atIndex:index];
    }
    if (!color) {
        CGColorRef ref = (__bridge CGColorRef)([self g_attribute:(NSString *)kCTUnderlineColorAttributeName atIndex:index]);
        color = [UIColor colorWithCGColor:ref];
    }
    return color;
}

- (NSNumber *)g_ligature {
    return [self g_ligatureAtIndex:0];
}

- (NSNumber *)g_ligatureAtIndex:(NSUInteger)index {
    return [self g_attribute:NSLigatureAttributeName atIndex:index];
}

- (NSString *)g_textEffect {
    return [self g_textEffectAtIndex:0];
}

- (NSString *)g_textEffectAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self g_attribute:NSTextEffectAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)g_obliqueness {
    return [self g_obliquenessAtIndex:0];
}

- (NSNumber *)g_obliquenessAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self g_attribute:NSObliquenessAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)g_expansion {
    return [self g_expansionAtIndex:0];
}

- (NSNumber *)g_expansionAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self g_attribute:NSExpansionAttributeName atIndex:index];
    }
    return nil;
}

- (NSNumber *)g_baselineOffset {
    return [self g_baselineOffsetAtIndex:0];
}

- (NSNumber *)g_baselineOffsetAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self g_attribute:NSBaselineOffsetAttributeName atIndex:index];
    }
    return nil;
}

- (BOOL)g_verticalGlyphForm {
    return [self g_verticalGlyphFormAtIndex:0];
}

- (BOOL)g_verticalGlyphFormAtIndex:(NSUInteger)index {
    NSNumber *num = [self g_attribute:NSVerticalGlyphFormAttributeName atIndex:index];
    return num.boolValue;
}

- (NSString *)g_language {
    return [self g_languageAtIndex:0];
}

- (NSString *)g_languageAtIndex:(NSUInteger)index {
    if (kSystemVersion >= 7) {
        return [self g_attribute:(id)kCTLanguageAttributeName atIndex:index];
    }
    return nil;
}

- (NSArray *)g_writingDirection {
    return [self g_writingDirectionAtIndex:0];
}

- (NSArray *)g_writingDirectionAtIndex:(NSUInteger)index {
    return [self g_attribute:(id)kCTWritingDirectionAttributeName atIndex:index];
}

- (NSParagraphStyle *)g_paragraphStyle {
    return [self g_paragraphStyleAtIndex:0];
}

- (NSParagraphStyle *)g_paragraphStyleAtIndex:(NSUInteger)index {
    /*
     NSParagraphStyle is NOT toll-free bridged to CTParagraphStyleRef.
     
     CoreText can use both NSParagraphStyle and CTParagraphStyleRef,
     but UILabel/UITextView can only use NSParagraphStyle.
     
     We use NSParagraphStyle in both CoreText and UIKit.
     */
    NSParagraphStyle *style = [self g_attribute:NSParagraphStyleAttributeName atIndex:index];
    if (style) {
        if (CFGetTypeID((__bridge CFTypeRef)(style)) == CTParagraphStyleGetTypeID()) { \
            style = [NSParagraphStyle g_styleWithCTStyle:(__bridge CTParagraphStyleRef)(style)];
        }
    }
    return style;
}

#define ParagraphAttribute(_attr_) \
NSParagraphStyle *style = self.g_paragraphStyle; \
if (!style) style = [NSParagraphStyle defaultParagraphStyle]; \
return style. _attr_;

#define ParagraphAttributeAtIndex(_attr_) \
NSParagraphStyle *style = [self g_paragraphStyleAtIndex:index]; \
if (!style) style = [NSParagraphStyle defaultParagraphStyle]; \
return style. _attr_;

- (NSTextAlignment)g_alignment {
    ParagraphAttribute(alignment);
}

- (NSLineBreakMode)g_lineBreakMode {
    ParagraphAttribute(lineBreakMode);
}

- (CGFloat)g_lineSpacing {
    ParagraphAttribute(lineSpacing);
}

- (CGFloat)g_paragraphSpacing {
    ParagraphAttribute(paragraphSpacing);
}

- (CGFloat)g_paragraphSpacingBefore {
    ParagraphAttribute(paragraphSpacingBefore);
}

- (CGFloat)g_firstLineHeadIndent {
    ParagraphAttribute(firstLineHeadIndent);
}

- (CGFloat)g_headIndent {
    ParagraphAttribute(headIndent);
}

- (CGFloat)g_tailIndent {
    ParagraphAttribute(tailIndent);
}

- (CGFloat)g_minimumLineHeight {
    ParagraphAttribute(minimumLineHeight);
}

- (CGFloat)g_maximumLineHeight {
    ParagraphAttribute(maximumLineHeight);
}

- (CGFloat)g_lineHeightMultiple {
    ParagraphAttribute(lineHeightMultiple);
}

- (NSWritingDirection)g_baseWritingDirection {
    ParagraphAttribute(baseWritingDirection);
}

- (float)g_hyphenationFactor {
    ParagraphAttribute(hyphenationFactor);
}

- (CGFloat)g_defaultTabInterval {
    if (!kiOS7Later) return 0;
    ParagraphAttribute(defaultTabInterval);
}

- (NSArray *)g_tabStops {
    if (!kiOS7Later) return nil;
    ParagraphAttribute(tabStops);
}

- (NSTextAlignment)g_alignmentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(alignment);
}

- (NSLineBreakMode)g_lineBreakModeAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(lineBreakMode);
}

- (CGFloat)g_lineSpacingAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(lineSpacing);
}

- (CGFloat)g_paragraphSpacingAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(paragraphSpacing);
}

- (CGFloat)g_paragraphSpacingBeforeAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(paragraphSpacingBefore);
}

- (CGFloat)g_firstLineHeadIndentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(firstLineHeadIndent);
}

- (CGFloat)g_headIndentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(headIndent);
}

- (CGFloat)g_tailIndentAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(tailIndent);
}

- (CGFloat)g_minimumLineHeightAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(minimumLineHeight);
}

- (CGFloat)g_maximumLineHeightAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(maximumLineHeight);
}

- (CGFloat)g_lineHeightMultipleAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(lineHeightMultiple);
}

- (NSWritingDirection)g_baseWritingDirectionAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(baseWritingDirection);
}

- (float)g_hyphenationFactorAtIndex:(NSUInteger)index {
    ParagraphAttributeAtIndex(hyphenationFactor);
}

- (CGFloat)g_defaultTabIntervalAtIndex:(NSUInteger)index {
    if (!kiOS7Later) return 0;
    ParagraphAttributeAtIndex(defaultTabInterval);
}

- (NSArray *)g_tabStopsAtIndex:(NSUInteger)index {
    if (!kiOS7Later) return nil;
    ParagraphAttributeAtIndex(tabStops);
}

#undef ParagraphAttribute
#undef ParagraphAttributeAtIndex


@end

