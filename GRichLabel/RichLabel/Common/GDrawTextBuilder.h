//
//  GDrawTextBuilder.h
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/17.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "GLineLayout.h"
@class GAttributedStringLayout,GAttributedToken;
@interface GDrawTextBuilder : NSObject

@property (nonatomic, strong,readonly) NSAttributedString  *attributedString;
@property (nonatomic, assign,readonly) CGSize  boundSize;
@property (nonatomic, strong,readonly) NSArray<GLineLayout*>  *lineLayouts;
@property (nonatomic, assign,readonly) CTFramesetterRef frameSetter;
@property (nonatomic, assign,readonly) CTFrameRef ctFrame;
@property (nonatomic, assign,readonly) BOOL  hasEmojiImage;
@property (nonatomic, strong,readonly) NSAttributedString *truncationToken;
@property (nonatomic, strong) NSDictionary<NSString*,GAttributedToken*> * tokenRangesDictionary;
@property (nonatomic, strong) GAttributedStringLayout * layout;

+ (instancetype)buildDrawTextSize:(CGSize)size attributedString:(NSAttributedString*)string;

- (void)drawAttributedText:(CGContextRef)context cancel:(BOOL (^)(void))cancel;

@end

