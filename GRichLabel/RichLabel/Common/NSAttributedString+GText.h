//
//  NSAttributedString+GText.h
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/11.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GAttributedToken.h"
#import "GAttributedStringLayout.h"
@interface NSAttributedString (GText)

@property (nonatomic, assign) BOOL  hasEmojiImage;

@property (nonatomic, strong) NSAttributedString * truncationToken;

@property (nonatomic, strong) NSDictionary<NSString*,GAttributedToken*> * tokenRangesDictionary;

+ (NSMutableAttributedString *)setAttachmentStringWithEmojiImageName:(NSString *)imageName
                                                        font:(UIFont*)font;

+ (NSMutableAttributedString*)setTokenStringWithAttributedToken:(GAttributedToken*)token attributedLayout:(GAttributedStringLayout*)layout;

@end



@interface NSMutableAttributedString (GText)

- (void)setAttribute:(NSString *)name value:(id)value range:(NSRange)range;
- (id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index;

@end
