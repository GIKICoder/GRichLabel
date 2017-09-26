//
//  GAttributedStringFactory.h
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/4.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
