//
//  NSParagraphStyle+GRichLabel.h
//  GRichLabelExample
//
//  Created by GIKI on 2017/10/29.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 Provides extensions for `NSParagraphStyle` to work with CoreText.
 */
@interface NSParagraphStyle (GRichLabel)
/**
 Creates a new NSParagraphStyle object from the CoreText Style.
 
 @param CTStyle CoreText Paragraph Style.
 
 @return a new NSParagraphStyle
 */
+ (NSParagraphStyle *)g_styleWithCTStyle:(CTParagraphStyleRef)CTStyle;

/**
 Creates and returns a CoreText Paragraph Style. (need call CFRelease() after used)
 */
- (CTParagraphStyleRef)g_CTStyle CF_RETURNS_RETAINED;
@end
