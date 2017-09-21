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

@class GAttributedToken;
typedef void(^GAttributedTokenClick)(GAttributedToken *token);

@interface GAttributedToken : NSObject
///文本token
@property (nonatomic, strong) NSString * textToken;

///正则token 与textToken同时存在时不生效.
@property (nonatomic, strong) NSString * regexToken;

///tokenColor 不传默认使用GAttributedStringLayout中的tokenTextColor
@property (nonatomic, strong) UIColor * tokenColor;

///tokenFont 不传默认使用GAttributedStringLayout中的font
@property (nonatomic, strong) UIFont  *tokenFont;

/// token Range
@property (nonatomic, assign,readonly) NSRange  tokenRange;

/// 用于存储tokenInfo信息.
@property (nonatomic, strong) id tokenInfo;

/// token 点击
@property (nonatomic, copy) GAttributedTokenClick  tokenClickBlock;

/// token 点击样式
@property (nonatomic, strong) GTokenAppearance * tokenAppearance;


@end
