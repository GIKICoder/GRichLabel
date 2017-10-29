//
//  GAttributedConfiguration.h
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/4.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GAttributedStringFactory.h"
#import "GAttributedToken.h"
/**
 A quick attribute configuration class
 Don't need to deal with complex NSAttributedString
 */

@interface GAttributedConfiguration : NSObject

@property (nonatomic, strong) NSString * text;

/**
 文本颜色
 @default : [UIColor blackColor]
 */
@property (nonatomic, strong) UIColor * textColor;

/**
 自定义高亮文字颜色
 @brief: 如果在GAttributedToken中设置的tokenColor,此属性不生效.
 
 @default: [UIColor blueColor]
 */
@property (nonatomic, strong) UIColor * tokenTextColor;

/**
 文字Font
 @brief:如果在GAttributedToken中设置的tokenFont,高亮展示文本不跟随此属性..
 
 @default: 14
 */
@property (nonatomic, strong) UIFont  *font;

/**
 行间距
 
 @default:1
 */
@property (nonatomic, assign) CGFloat  linespace;

/**
 换行方式
 
 @default:kCTLineBreakByWordWrapping
 */
@property (nonatomic, assign) CTLineBreakMode  lineBreakMode;

/**
 截断AttributedString
 
 @defalut:nil
 */
@property (nonatomic, copy) NSAttributedString *truncationToken;

/**
 文本对齐方式
 
 @default:kCTLineBreakByWordWrapping,如果想要文本排版左右对齐,请使用kCTTextAlignmentJustified
 */
@property (nonatomic, assign) CTTextAlignment  textAlignment;

/**
 首行缩进
 
 @default : 0
 */
@property (nonatomic, assign) CGFloat  lineIndent;

/**
 自定义文本显示属性数组<GAttributedToken>
 */
@property (nonatomic, strong) NSArray<GAttributedToken*> * tokenPatternConfigs;

/**
 正则属性数组<GAttributedToken>
 */
@property (nonatomic, strong) NSArray<GAttributedToken*> * regexPatternConifgs;

+ (instancetype)attributedConfig:(NSString*)text;
+ (instancetype)attributedConfig:(NSString*)text color:(UIColor*)color font:(UIFont*)font;

@end
