//
//  GAttributedToken.h
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/12.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GTokenAppearance.h"

UIKIT_EXTERN NSString *const kGAttributeTokenHighlightName;

UIKIT_EXTERN NSString *const kGAttributeTokenUnderlineName;

UIKIT_EXTERN NSString *const kGAttributeTokenAttachmentName;

UIKIT_EXTERN NSString *const kGAttributeTokenTruncationName;
/// 表情.link等被替换的字符串
UIKIT_EXTERN NSString *const kGAttributeTokenReplaceStringName;

@class GAttributedToken;
typedef void(^GAttributedTokenClick)(GAttributedToken *token);


@interface GAttributedToken : NSObject
///文本token
@property (nonatomic, strong) NSString * textToken;

///正则token 与textToken同时存在时不生效.
@property (nonatomic, strong) NSString * regexToken;

///tokenColor 不传默认使用GAttributedConfiguration中的tokenTextColor
@property (nonatomic, strong) UIColor * tokenColor;

///tokenFont 不传默认使用GAttributedConfiguration中的font
@property (nonatomic, strong) UIFont  *tokenFont;

/// token Range
@property (nonatomic, assign,readonly) NSRange  tokenRange;

/// 用于存储tokenInfo信息.
@property (nonatomic, strong) id tokenInfo;

/// token 点击
@property (nonatomic, copy) GAttributedTokenClick  tokenClickBlock;

/**
 token 点击样式
 default: appearance.cornerRadius = 4;
          appearance.fillColor = [UIColor colorWithRed:69/255.0 green:111/255.0 blue:238/255.0 alpha:0.6];
 */
@property (nonatomic, strong) GTokenAppearance * tokenAppearance;

+ (instancetype)attributedTextToken:(NSString*)textToken;
+ (instancetype)attributedTextToken:(NSString*)textToken color:(UIColor*)color;
+ (instancetype)attributedTextToken:(NSString*)textToken color:(UIColor*)color font:(UIFont*)font;

+ (instancetype)attributedRegexToken:(NSString*)textToken;
+ (instancetype)attributedRegexToken:(NSString*)textToken color:(UIColor*)color;
+ (instancetype)attributedRegexToken:(NSString*)textToken color:(UIColor*)color font:(UIFont*)font;
@end
