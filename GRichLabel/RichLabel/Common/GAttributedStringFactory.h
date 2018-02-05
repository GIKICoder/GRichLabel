//
//  GAttributedStringFactory.h
//  GRichLabel
//
//  Created by GIKI on 2017/9/4.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 A AttributedString processing factory. Generate 'GAttributedConfiguration' through 'NSMutableAttributedString'.
 */
@class GAttributedConfiguration ,GDrawTextBuilder;

@interface GAttributedStringFactory : NSObject

/**
 create DrawTextBuilder
 DrawTextBuilder  is a used to draw the rich text library class.
 @param config GAttributedConfiguration
 @return DrawTextBuilder
 */
+ (GDrawTextBuilder*)createDrawTextBuilderWithAttributedConfig:(GAttributedConfiguration*)config boundSize:(CGSize)size;

/**
 create AttributedString

 @param config GAttributedConfiguration
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString*)createAttributedStringWithAttributedConfig:(GAttributedConfiguration*)config;

/**
 calculate rich Text Height

 @param string attributedString
 @param width  textContainer Max Width
 @return rich Text height
 */
+ (CGFloat)getRichLabelHeightWithAttributedString:(NSAttributedString*)string MaxContianerWidth:(CGFloat)width;

@end
