//
//  GAttributedStringFactory.h
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/4.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define Phone @"(([0-9]{11})|((400|800)([0-9\\-]{7,10})|(([0-9]{4}|[0-9]{3})(-| )?)?([0-9]{7,8})((-| |转)*([0-9]{1,4}))?)|(110|120|119|114))"

@class GAttributedStringLayout ,GDrawTextBuilder;

@interface GAttributedStringFactory : NSObject

/**
 create DrawTextBuilder
 DrawTextBuilder  is a used to draw the rich text library class.
 @param layout GAttributedStringLayout
 @return DrawTextBuilder
 */
+ (GDrawTextBuilder*)createDrawTextBuilderWithLayout:(GAttributedStringLayout*)layout boundSize:(CGSize)size;

/**
 create AttributedString

 @param layout GAttributedStringLayout
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString*)createAttributedStringWithLayout:(GAttributedStringLayout*)layout;

/**
 calculate rich Text Height

 @param string attributedString
 @param width  textContainer Max Width
 @return rich Text height
 */
+ (CGFloat)getRichLabelHeightWithAttributedString:(NSAttributedString*)string MaxContianerWidth:(CGFloat)width;

@end
