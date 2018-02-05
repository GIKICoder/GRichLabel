//
//  GEmojiRunDelegate.h
//  GRichLabel
//
//  Created by GIKI on 2017/9/6.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface GEmojiRunDelegate : NSObject

@property(nonatomic,strong) UIFont *textFont;
@property(nonatomic,strong) NSString *emojiImageName;

@property (nonatomic, assign,readonly) CGRect bounds;

- (CTRunDelegateRef)GetCTRunDelegate;

@end
