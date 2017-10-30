//
//  NSMutableAttributedString+GRichLabel.h
//  GRichLabelExample
//
//  Created by GIKI on 2017/10/30.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
/**
 Set pre-defined attributes to attributed string.
 All properties defined in UIKit, CoreText
 */
@interface NSMutableAttributedString (GRichLabel)

#pragma mark - Set character attribute

/**
 Sets the attributes to the entire text string.
 
 @discussion The old attributes will be removed.
 
 @param attributes  A dictionary containing the attributes to set, or nil to remove all attributes.
 */
- (void)g_setAttributes:(NSDictionary *)attributes;
- (void)setG_attributes:(NSDictionary *)attributes;

/**
 Sets an attribute with the given name and value to the entire text string.
 
 @param name   A string specifying the attribute name.
 @param value  The attribute value associated with name. Pass `nil` or `NSNull` to
 remove the attribute.
 */
- (void)g_setAttribute:(NSString *)name value:(id)value;

/**
 Sets an attribute with the given name and value to the characters in the specified range.
 
 @param name   A string specifying the attribute name.
 @param value  The attribute value associated with name. Pass `nil` or `NSNull` to
 remove the attribute.
 @param range  The range of characters to which the specified attribute/value pair applies.
 */
- (void)g_setAttribute:(NSString *)name value:(id)value range:(NSRange)range;

/**
 Removes all attributes in the specified range.
 
 @param range  The range of characters.
 */
- (void)g_removeAttributesInRange:(NSRange)range;


#pragma mark - Set character attribute as property
///=============================================================================
/// @name Set character attribute as property
///=============================================================================

/**
 The font of the text.
 
 @discussion Default is Helvetica (Neue) 12.
 */
@property (nonatomic, strong, readwrite) UIFont *g_font;
- (void)g_setFont:(UIFont *)font range:(NSRange)range;

/**
 A kerning adjustment.
 */
@property (nonatomic, strong, readwrite) NSNumber *g_kern;
- (void)g_setKern:(NSNumber *)kern range:(NSRange)range;

/**
 The foreground color.
 
 @discussion Default is Black.
 */
@property (nonatomic, strong, readwrite) UIColor *g_color;
- (void)g_setColor:(UIColor *)color range:(NSRange)range;

/**
 The background color.
 
 @discussion Default is nil (or no background).
 */
@property (nonatomic, strong, readwrite) UIColor *g_backgroundColor;
- (void)g_setBackgroundColor:(UIColor *)backgroundColor range:(NSRange)range;

/**
 The stroke width.
 
 @discussion Default value is 0.0 (no stroke).
 */
@property (nonatomic, strong, readwrite) NSNumber *g_strokeWidth;
- (void)g_setStrokeWidth:(NSNumber *)strokeWidth range:(NSRange)range;

/**
 The stroke color.
 
 @discussion Default value is nil (same as foreground color).
 */
@property (nonatomic, strong, readwrite) UIColor *g_strokeColor;
- (void)g_setStrokeColor:(UIColor *)strokeColor range:(NSRange)range;

/**
 The text shadow.
 
 @discussion Default value is nil (no shadow).
 */
@property (nonatomic, strong, readwrite) NSShadow *g_shadow;
- (void)g_setShadow:(NSShadow *)shadow range:(NSRange)range;

/**
 The strikethrough style.
 
 @discussion Default value is NSUnderlineStyleNone (no strikethrough).
 */
@property (nonatomic, assign, readwrite) NSUnderlineStyle g_strikethroughStyle;
- (void)g_setStrikethroughStyle:(NSUnderlineStyle)strikethroughStyle range:(NSRange)range;

/**
 The strikethrough color.
 
 @discussion Default value is nil (same as foreground color)
 */
@property (nonatomic, strong, readwrite) UIColor *g_strikethroughColor;
- (void)g_setStrikethroughColor:(UIColor *)strikethroughColor range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 The underline style.
 
 @discussion Default value is NSUnderlineStyleNone (no underline).
 */
@property (nonatomic, assign, readwrite) NSUnderlineStyle g_underlineStyle;
- (void)g_setUnderlineStyle:(NSUnderlineStyle)underlineStyle range:(NSRange)range;

/**
 The underline color.
 
 @discussion Default value is nil (same as foreground color).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:7.0
 */
@property (nonatomic, strong, readwrite) UIColor *g_underlineColor;
- (void)g_setUnderlineColor:(UIColor *)underlineColor range:(NSRange)range;

/**
 Ligature formation control.
 
 @discussion Default is int value 1. The ligature attribute determines what kinds
 of ligatures should be used when displaying the string. A value of 0 indicates
 that only ligatures essential for proper rendering of text should be used,
 1 indicates that standard ligatures should be used, and 2 indicates that all
 available ligatures should be used. Which ligatures are standard depends on the
 script and possibly the font.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:3.2  UIKit:6.0       6.0
 */
@property (nonatomic, strong, readwrite) NSNumber *g_ligature;
- (void)g_setLigature:(NSNumber *)ligature range:(NSRange)range;

/**
 The text effect.
 
 @discussion Default is nil (no effect). The only currently supported value
 is NSTextEffectLetterpressStyle.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nonatomic, strong, readwrite) NSString *g_textEffect;
- (void)g_setTextEffect:(NSString *)textEffect range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 The skew to be applied to glyphs.
 
 @discussion Default is 0 (no skew).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nonatomic, strong, readwrite) NSNumber *g_obliqueness;
- (void)g_setObliqueness:(NSNumber *)obliqueness range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 The log of the expansion factor to be applied to glyphs.
 
 @discussion Default is 0 (no expansion).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nonatomic, strong, readwrite) NSNumber *g_expansion;
- (void)g_setExpansion:(NSNumber *)expansion range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 The character's offset from the baseline, in points.
 
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:7.0
 */
@property (nonatomic, strong, readwrite) NSNumber *g_baselineOffset;
- (void)g_setBaselineOffset:(NSNumber *)baselineOffset range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 Glyph orientation control.
 
 @discussion Default is NO. A value of NO indicates that horizontal glyph forms
 are to be used, YES indicates that vertical glyph forms are to be used.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:4.3       6.0
 */
@property (nonatomic, assign, readwrite) BOOL g_verticalGlyphForm;
- (void)g_setVerticalGlyphForm:(BOOL)verticalGlyphForm range:(NSRange)range;

/**
 Specifies text language.
 
 @discussion Value must be a NSString containing a locale identifier. Default is
 unset. When this attribute is set to a valid identifier, it will be used to select
 localized glyphs (if supported by the font) and locale-specific line breaking rules.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:7.0       7.0
 */
@property (nonatomic, strong, readwrite) NSString *g_language;
- (void)g_setLanguage:(NSString *)language range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 Specifies a bidirectional override or embedding.
 
 @discussion See alse NSWritingDirection and NSWritingDirectionAttributeName.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:7.0       6.0
 */
@property (nonatomic, strong, readwrite) NSArray *g_writingDirection;
- (void)g_setWritingDirection:(NSArray *)writingDirection range:(NSRange)range;

/**
 An NSParagraphStyle object which is used to specify things like
 line alignment, tab rulers, writing direction, etc.
 
 @discussion Default is nil ([NSParagraphStyle defaultParagraphStyle]).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, strong, readwrite) NSParagraphStyle *g_paragraphStyle;
- (void)g_setParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range;


#pragma mark - Set paragraph attribute as property
///=============================================================================
/// @name Set paragraph attribute as property
///=============================================================================

/**
 The text alignment (A wrapper for NSParagraphStyle).
 
 @discussion Natural text alignment is realized as left or right alignment
 depending on the line sweep direction of the first script contained in the paragraph.
 @discussion Default is NSTextAlignmentNatural.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, assign, readwrite) NSTextAlignment g_alignment;
- (void)g_setAlignment:(NSTextAlignment)alignment range:(NSRange)range;

/**
 The mode that should be used to break lines (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the line break mode to be used laying out the paragraph's text.
 @discussion Default is NSLineBreakByWordWrapping.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, assign, readwrite) NSLineBreakMode g_lineBreakMode;
- (void)g_setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range;

/**
 The distance in points between the bottom of one line fragment and the top of the next.
 (A wrapper for NSParagraphStyle)
 
 @discussion This value is always nonnegative. This value is included in the line
 fragment heights in the layout manager.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, assign, readwrite) CGFloat g_lineSpacing;
- (void)g_setLineSpacing:(CGFloat)lineSpacing range:(NSRange)range;

/**
 The space after the end of the paragraph (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the space (measured in points) added at the
 end of the paragraph to separate it from the following paragraph. This value must
 be nonnegative. The space between paragraphs is determined by adding the previous
 paragraph's paragraphSpacing and the current paragraph's paragraphSpacingBefore.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, assign, readwrite) CGFloat g_paragraphSpacing;
- (void)g_setParagraphSpacing:(CGFloat)paragraphSpacing range:(NSRange)range;

/**
 The distance between the paragraph's top and the beginning of its text content.
 (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the space (measured in points) between the
 paragraph's top and the beginning of its text content.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, assign, readwrite) CGFloat g_paragraphSpacingBefore;
- (void)g_setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore range:(NSRange)range;

/**
 The indentation of the first line (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the distance (in points) from the leading margin
 of a text container to the beginning of the paragraph's first line. This value
 is always nonnegative.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, assign, readwrite) CGFloat g_firstLineHeadIndent;
- (void)g_setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent range:(NSRange)range;

/**
 The indentation of the receiver's lines other than the first. (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the distance (in points) from the leading margin
 of a text container to the beginning of lines other than the first. This value is
 always nonnegative.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, assign, readwrite) CGFloat g_headIndent;
- (void)g_setHeadIndent:(CGFloat)headIndent range:(NSRange)range;

/**
 The trailing indentation (A wrapper for NSParagraphStyle).
 
 @discussion If positive, this value is the distance from the leading margin
 (for example, the left margin in left-to-right text). If 0 or negative, it's the
 distance from the trailing margin.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, assign, readwrite) CGFloat g_tailIndent;
- (void)g_setTailIndent:(CGFloat)tailIndent range:(NSRange)range;

/**
 The receiver's minimum height (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the minimum height in points that any line in
 the receiver will occupy, regardless of the font size or size of any attached graphic.
 This value must be nonnegative.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, assign, readwrite) CGFloat g_minimumLineHeight;
- (void)g_setMinimumLineHeight:(CGFloat)minimumLineHeight range:(NSRange)range;

/**
 The receiver's maximum line height (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the maximum height in points that any line in
 the receiver will occupy, regardless of the font size or size of any attached graphic.
 This value is always nonnegative. Glyphs and graphics exceeding this height will
 overlap neighboring lines; however, a maximum height of 0 implies no line height limit.
 Although this limit applies to the line itself, line spacing adds extra space between adjacent lines.
 @discussion Default is 0 (no limit).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, assign, readwrite) CGFloat g_maximumLineHeight;
- (void)g_setMaximumLineHeight:(CGFloat)maximumLineHeight range:(NSRange)range;

/**
 The line height multiple (A wrapper for NSParagraphStyle).
 
 @discussion This property contains the line break mode to be used laying out the paragraph's text.
 @discussion Default is 0 (no multiple).
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, assign, readwrite) CGFloat g_lineHeightMultiple;
- (void)g_setLineHeightMultiple:(CGFloat)lineHeightMultiple range:(NSRange)range;

/**
 The base writing direction (A wrapper for NSParagraphStyle).
 
 @discussion If you specify NSWritingDirectionNaturalDirection, the receiver resolves
 the writing direction to either NSWritingDirectionLeftToRight or NSWritingDirectionRightToLeft,
 depending on the direction for the user's `language` preference setting.
 @discussion Default is NSWritingDirectionNatural.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:6.0  UIKit:6.0       6.0
 */
@property (nonatomic, assign, readwrite) NSWritingDirection g_baseWritingDirection;
- (void)g_setBaseWritingDirection:(NSWritingDirection)baseWritingDirection range:(NSRange)range;

/**
 The paragraph's threshold for hyphenation. (A wrapper for NSParagraphStyle).
 
 @discussion Valid values lie between 0.0 and 1.0 inclusive. Hyphenation is attempted
 when the ratio of the text width (as broken without hyphenation) to the width of the
 line fragment is less than the hyphenation factor. When the paragraph's hyphenation
 factor is 0.0, the layout manager's hyphenation factor is used instead. When both
 are 0.0, hyphenation is disabled.
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since UIKit:6.0
 */
@property (nonatomic, assign, readwrite) float g_hyphenationFactor;
- (void)g_setHyphenationFactor:(float)hyphenationFactor range:(NSRange)range;

/**
 The document-wide default tab interval (A wrapper for NSParagraphStyle).
 
 @discussion This property represents the default tab interval in points. Tabs after the
 last specified in tabStops are placed at integer multiples of this distance (if positive).
 @discussion Default is 0.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:7.0  UIKit:7.0       7.0
 */
@property (nonatomic, assign, readwrite) CGFloat g_defaultTabInterval;
- (void)g_setDefaultTabInterval:(CGFloat)defaultTabInterval range:(NSRange)range NS_AVAILABLE_IOS(7_0);

/**
 An array of NSTextTab objects representing the receiver's tab stops.
 (A wrapper for NSParagraphStyle).
 
 @discussion The NSTextTab objects, sorted by location, define the tab stops for
 the paragraph style.
 @discussion Default is 12 TabStops with 28.0 tab interval.
 @discussion Set this property applies to the entire text string.
 Get this property returns the first character's attribute.
 @since CoreText:7.0  UIKit:7.0       7.0
 */
@property (nonatomic, copy, readwrite) NSArray *g_tabStops;
- (void)g_setTabStops:(NSArray *)tabStops range:(NSRange)range NS_AVAILABLE_IOS(7_0);


#pragma mark - Set discontinuous attribute for range
///=============================================================================
/// @name Set discontinuous attribute for range
///=============================================================================

- (void)g_setSuperscript:(NSNumber *)superscript range:(NSRange)range;
- (void)g_setGlyphInfo:(CTGlyphInfoRef)glyphInfo range:(NSRange)range;
- (void)g_setCharacterShape:(NSNumber *)characterShape range:(NSRange)range;
- (void)g_setRunDelegate:(CTRunDelegateRef)runDelegate range:(NSRange)range;
- (void)g_setBaselineClass:(CFStringRef)baselineClass range:(NSRange)range;
- (void)g_setBaselineInfo:(CFDictionaryRef)baselineInfo range:(NSRange)range;
- (void)g_setBaselineReferenceInfo:(CFDictionaryRef)referenceInfo range:(NSRange)range;
- (void)g_setRubyAnnotation:(CTRubyAnnotationRef)ruby range:(NSRange)range NS_AVAILABLE_IOS(8_0);
- (void)g_setAttachment:(NSTextAttachment *)attachment range:(NSRange)range NS_AVAILABLE_IOS(7_0);
- (void)g_setLink:(id)link range:(NSRange)range NS_AVAILABLE_IOS(7_0);


#pragma mark - Utilities
///=============================================================================
/// @name Utilities
///=============================================================================

/**
 Inserts into the receiver the characters of a given string at a given location.
 The new string inherit the attributes of the first replaced character from location.
 
 @param string  The string to insert into the receiver, must not be nil.
 @param location The location at which string is inserted. The location must not
 exceed the bounds of the receiver.
 @throw Raises an NSRangeException if the location out of bounds.
 */
- (void)g_insertString:(NSString *)string atIndex:(NSUInteger)location;

/**
 Adds to the end of the receiver the characters of a given string.
 The new string inherit the attributes of the receiver's tail.
 
 @param string  The string to append to the receiver, must not be nil.
 */
- (void)g_appendString:(NSString *)string;

/**
 Set foreground color with [UIColor clearColor] in joined-emoji range.
 Emoji drawing will not be affected by the foreground color.
 
 @discussion In iOS 8.3, Apple releases some new diversified emojis.
 There's some single emoji which can be assembled to a new 'joined-emoji'.
 The joiner is unicode character 'ZERO WIDTH JOINER' (U+200D).
 For example: 👨👩👧👧 -> 👨‍👩‍👧‍👧.
 
 When there are more than 5 'joined-emoji' in a same CTLine, CoreText may render some
 extra glyphs above the emoji. It's a bug in CoreText, try this method to avoid.
 This bug is fixed in iOS 9.
 */
- (void)g_setClearColorToJoinedEmoji;




@end


